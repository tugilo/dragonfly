<?php

namespace App\Http\Controllers\Zoom;

use App\Http\Controllers\Controller;
use App\Models\UserZoomCredential;
use App\Services\Religo\ReligoActorContext;
use App\Services\Zoom\ZoomCredentialResolver;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

/**
 * SPEC-012 拡張: ユーザーごとの Zoom OAuth アプリ資格情報（BYO app credentials）。
 * Secret は API レスポンスに平文を返さない。
 */
class UserZoomCredentialController extends Controller
{
    public function __construct(private ZoomCredentialResolver $resolver) {}

    public function show(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $cred = UserZoomCredential::where('user_id', $user->id)->first();

        return response()->json($this->payload($cred, $user->id));
    }

    public function update(Request $request): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $validated = $request->validate([
            'client_id' => ['nullable', 'string', 'max:255'],
            'client_secret' => ['nullable', 'string', 'max:500'],
            'webhook_secret_token' => ['nullable', 'string', 'max:500'],
            'is_active' => ['nullable', 'boolean'],
        ]);

        $cred = UserZoomCredential::firstOrNew(['user_id' => $user->id]);
        if (array_key_exists('client_id', $validated)) {
            $cred->client_id = $validated['client_id'];
        }
        if (array_key_exists('is_active', $validated)) {
            $cred->is_active = (bool) $validated['is_active'];
        }
        if (! empty($validated['client_secret'])) {
            $cred->client_secret = $validated['client_secret'];
        }
        if (! empty($validated['webhook_secret_token'])) {
            $cred->webhook_secret_token = $validated['webhook_secret_token'];
        }
        $cred->save();

        return response()->json($this->payload($cred->refresh(), $user->id));
    }

    /**
     * POST /api/zoom/credentials/test — 保存済み Client ID/Secret で OAuth エンドポイント疎通確認。
     */
    public function test(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $cred = UserZoomCredential::where('user_id', $user->id)->first();
        if ($cred !== null && $cred->clientSecretDecryptFailed()) {
            return response()->json([
                'ok' => false,
                'credential_decrypt_error' => true,
                'message' => '保存済みの Client Secret を復号できません（別環境の APP_KEY で暗号化されたデータの可能性があります）。Client Secret を再入力して保存してください。',
            ], 422);
        }
        if ($cred === null || ! $cred->hasUsableOAuthCredentials()) {
            return response()->json([
                'ok' => false,
                'message' => 'Zoom 資格情報が未登録です。Client ID / Client Secret を保存してください。',
            ], 422);
        }

        $resolved = $this->resolver->resolveForUser($user);
        if ($resolved === null) {
            return response()->json(['ok' => false, 'message' => 'ZOOM_REDIRECT_URI が未設定です。管理者に連絡してください。'], 422);
        }

        $oauthBase = rtrim((string) config('services.zoom.oauth_base_url'), '/');
        $response = Http::asForm()
            ->withBasicAuth($resolved['client_id'], $resolved['client_secret'])
            ->post($oauthBase.'/oauth/token', [
                'grant_type' => 'authorization_code',
                'code' => 'invalid-connectivity-test',
                'redirect_uri' => $resolved['redirect'],
            ]);

        // 401 = 資格情報不正。400 invalid_grant = Client ID/Secret は有効。
        if ($response->status() === 401) {
            return response()->json([
                'ok' => false,
                'message' => 'Client ID / Client Secret が Zoom に拒否されました。Marketplace の値を確認してください。',
            ], 422);
        }

        return response()->json([
            'ok' => true,
            'message' => 'Zoom OAuth 資格情報の疎通に成功しました（Client ID/Secret は有効）。',
            'source' => $resolved['source'],
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    private function payload(?UserZoomCredential $cred, int $userId): array
    {
        $user = ReligoActorContext::actingUser();
        $resolved = $this->resolver->resolveForUser($user);

        return [
            'client_id' => $cred?->client_id,
            'has_client_secret' => $cred !== null && $cred->readEncryptedAttribute('client_secret') !== null,
            'has_webhook_secret' => $cred !== null && $cred->readEncryptedAttribute('webhook_secret_token') !== null,
            'credential_decrypt_error' => (bool) ($cred?->clientSecretDecryptFailed() || $cred?->webhookSecretDecryptFailed()),
            'is_active' => (bool) ($cred?->is_active ?? true),
            'has_user_credentials' => $cred !== null && $cred->hasUsableOAuthCredentials(),
            'configured' => $resolved !== null,
            'credential_source' => $resolved['source'] ?? null,
            'redirect_uri' => trim((string) config('services.zoom.redirect')) ?: null,
        ];
    }
}
