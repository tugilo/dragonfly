<?php

namespace App\Http\Controllers\Zoom;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\ZoomAccount;
use App\Services\Religo\ReligoActorContext;
use App\Services\Zoom\ZoomCredentialResolver;
use App\Services\Zoom\ZoomTokenService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Log;

/**
 * Zoom OAuth 連携（SPEC-012 Phase A）。
 *
 * - connect/status/disconnect は認証済みユーザー単位。
 * - callback は Zoom からのブラウザリダイレクト（Bearer 無し）。署名付き state で user を解決する。
 */
class ZoomOAuthController extends Controller
{
    public function __construct(
        private ZoomTokenService $tokenService,
        private ZoomCredentialResolver $credentials,
    ) {}

    /**
     * GET /api/zoom/connect — SPA が開く Zoom 認可 URL を返す。
     */
    public function connect(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }
        if (! $this->credentials->isConfiguredForUser($user)) {
            return response()->json([
                'message' => 'Zoom 連携が未設定です。設定画面で Client ID / Client Secret を登録するか、管理者に ZOOM_REDIRECT_URI の設定を確認してください。',
            ], 422);
        }

        $state = Crypt::encryptString(json_encode([
            'user_id' => $user->id,
            'exp' => Carbon::now()->addMinutes(10)->getTimestamp(),
        ]));

        return response()->json([
            'authorize_url' => $this->tokenService->authorizeUrl($user, $state),
        ]);
    }

    /**
     * GET /api/zoom/callback — Zoom からのリダイレクト。code を交換し SPA に戻す。
     */
    public function callback(Request $request): RedirectResponse
    {
        $code = (string) $request->query('code', '');
        $state = (string) $request->query('state', '');

        if ($code === '' || $state === '') {
            return redirect($this->spaReturnUrl('error', 'missing_code'));
        }

        $user = $this->resolveUserFromState($state);
        if ($user === null) {
            return redirect($this->spaReturnUrl('error', 'invalid_state'));
        }

        try {
            $this->tokenService->exchangeCodeForToken($user, $code);
        } catch (\Throwable $e) {
            Log::warning('Zoom OAuth callback failed', ['error' => $e->getMessage()]);

            return redirect($this->spaReturnUrl('error', 'token_exchange_failed'));
        }

        return redirect($this->spaReturnUrl('connected'));
    }

    /**
     * GET /api/zoom/status — 連携状態。
     */
    public function status(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        $account = $user ? ZoomAccount::where('user_id', $user->id)->first() : null;
        $resolved = $this->credentials->resolveForUser($user);

        return response()->json([
            'configured' => $resolved !== null,
            'credential_source' => $resolved['source'] ?? null,
            'redirect_uri' => $resolved['redirect'] ?? trim((string) config('services.zoom.redirect')) ?: null,
            'connected' => $account !== null,
            'zoom_email' => $account?->zoom_email,
            'scopes' => $account?->scopes,
            'token_expires_at' => $account?->token_expires_at?->toIso8601String(),
        ]);
    }

    /**
     * DELETE /api/zoom/connect — 連携解除。
     */
    public function disconnect(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user !== null) {
            ZoomAccount::where('user_id', $user->id)->delete();
        }

        return response()->json(['message' => 'disconnected']);
    }

    private function resolveUserFromState(string $state): ?User
    {
        try {
            $payload = json_decode(Crypt::decryptString($state), true);
        } catch (\Throwable) {
            return null;
        }
        if (! is_array($payload) || empty($payload['user_id'])) {
            return null;
        }
        if (($payload['exp'] ?? 0) < Carbon::now()->getTimestamp()) {
            return null;
        }

        return User::find((int) $payload['user_id']);
    }

    private function spaReturnUrl(string $status, ?string $reason = null): string
    {
        $url = url('/admin').'#/zoom-import?zoom_'.$status.'=1';
        if ($reason !== null) {
            $url .= '&reason='.$reason;
        }

        return $url;
    }
}
