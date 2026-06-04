<?php

namespace App\Services\Zoom;

use App\Models\User;
use App\Models\ZoomAccount;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Http;
use RuntimeException;

/**
 * Zoom OAuth トークンの取得・更新（SPEC-012 Phase A）。
 *
 * - 認可コード → アクセストークン交換（OAuth）
 * - リフレッシュトークンによる更新
 * - 期限切れトークンの自動更新（ensureFreshAccessToken）
 *
 * アプリ資格情報は ZoomCredentialResolver（ユーザー DB → .env フォールバック）。
 * トークンは zoom_accounts に暗号化保存。
 */
class ZoomTokenService
{
    public function __construct(private ZoomCredentialResolver $credentials) {}

    /**
     * 認可コードをトークンに交換し、ユーザーの ZoomAccount を作成/更新する。
     */
    public function exchangeCodeForToken(User $user, string $code): ZoomAccount
    {
        $config = $this->requireCredentials($user);

        $response = Http::asForm()
            ->withBasicAuth($config['client_id'], $config['client_secret'])
            ->post($this->oauthTokenUrl(), [
                'grant_type' => 'authorization_code',
                'code' => $code,
                'redirect_uri' => $config['redirect'],
            ]);

        if (! $response->successful()) {
            throw new RuntimeException('Zoom token exchange failed: '.$response->status().' '.$response->body());
        }

        $data = $response->json();
        $account = $this->persistToken($user, $data);
        $this->fillAccountIdentity($account);

        return $account;
    }

    /**
     * リフレッシュトークンでアクセストークンを更新する。
     */
    public function refresh(ZoomAccount $account): ZoomAccount
    {
        if (empty($account->refresh_token)) {
            throw new RuntimeException('Zoom account has no refresh token; re-connect required.');
        }

        $user = $account->user;
        if ($user === null) {
            throw new RuntimeException('Zoom account has no associated user.');
        }

        $config = $this->requireCredentials($user);

        $response = Http::asForm()
            ->withBasicAuth($config['client_id'], $config['client_secret'])
            ->post($this->oauthTokenUrl(), [
                'grant_type' => 'refresh_token',
                'refresh_token' => $account->refresh_token,
            ]);

        if (! $response->successful()) {
            throw new RuntimeException('Zoom token refresh failed: '.$response->status().' '.$response->body());
        }

        return $this->persistToken($user, $response->json());
    }

    /**
     * 期限切れなら更新したうえで有効なアクセストークンを返す。
     */
    public function ensureFreshAccessToken(ZoomAccount $account): string
    {
        if ($account->isExpired()) {
            $account = $this->refresh($account);
        }

        $token = (string) $account->access_token;
        if ($token === '') {
            throw new RuntimeException('Zoom access token unavailable.');
        }

        return $token;
    }

    /**
     * @param  array<string, mixed>  $data
     */
    private function persistToken(User $user, array $data): ZoomAccount
    {
        $expiresIn = (int) ($data['expires_in'] ?? 3600);

        $account = ZoomAccount::firstOrNew(['user_id' => $user->id]);
        $account->access_token = $data['access_token'] ?? $account->access_token;
        if (! empty($data['refresh_token'])) {
            $account->refresh_token = $data['refresh_token'];
        }
        $account->token_expires_at = Carbon::now()->addSeconds($expiresIn);
        if (! empty($data['scope'])) {
            $account->scopes = is_array($data['scope']) ? implode(' ', $data['scope']) : (string) $data['scope'];
        }
        $account->save();

        return $account->refresh();
    }

    /**
     * /users/me から zoom_user_id / account_id / email を補完する。失敗しても致命的ではない。
     */
    private function fillAccountIdentity(ZoomAccount $account): void
    {
        try {
            $response = Http::withToken((string) $account->access_token)
                ->acceptJson()
                ->get($this->apiBaseUrl().'/users/me');
            if ($response->successful()) {
                $me = $response->json();
                $account->zoom_user_id = $me['id'] ?? $account->zoom_user_id;
                $account->zoom_account_id = $me['account_id'] ?? $account->zoom_account_id;
                $account->zoom_email = $me['email'] ?? $account->zoom_email;
                $account->save();
            }
        } catch (\Throwable) {
            // identity 補完失敗はトークン保存を妨げない。
        }
    }

    private function oauthTokenUrl(): string
    {
        return rtrim((string) config('services.zoom.oauth_base_url'), '/').'/oauth/token';
    }

    private function apiBaseUrl(): string
    {
        return rtrim((string) config('services.zoom.base_url'), '/');
    }

    /**
     * SPA が開く認可 URL を組み立てる（state は呼び出し側で付与）。
     */
    public function authorizeUrl(User $user, string $state): string
    {
        $config = $this->requireCredentials($user);

        $query = http_build_query([
            'response_type' => 'code',
            'client_id' => $config['client_id'],
            'redirect_uri' => $config['redirect'],
            'state' => $state,
        ]);

        return rtrim((string) config('services.zoom.oauth_base_url'), '/').'/oauth/authorize?'.$query;
    }

    /**
     * @return array{client_id: string, client_secret: string, redirect: string, webhook_secret_token: string, source: string}
     */
    private function requireCredentials(User $user): array
    {
        $config = $this->credentials->resolveForUser($user);
        if ($config === null) {
            throw new RuntimeException('Zoom credentials not configured for user.');
        }

        return $config;
    }
}
