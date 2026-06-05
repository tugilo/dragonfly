<?php

namespace App\Services\Zoom;

use App\Models\User;
use App\Models\UserZoomCredential;

/**
 * Zoom OAuth アプリ資格情報の解決（ユーザー DB → .env フォールバック）。
 */
class ZoomCredentialResolver
{
    public const SOURCE_USER = 'user';

    public const SOURCE_ENV = 'env';

    /**
     * @return array{client_id: string, client_secret: string, redirect: string, webhook_secret_token: string, source: string}|null
     */
    public function resolveForUser(?User $user): ?array
    {
        $redirect = trim((string) config('services.zoom.redirect'));
        if ($redirect === '') {
            return null;
        }

        if ($user !== null) {
            $cred = UserZoomCredential::where('user_id', $user->id)->first();
            if ($cred !== null && $cred->hasUsableOAuthCredentials()) {
                $clientSecret = $cred->readEncryptedAttribute('client_secret');
                if ($clientSecret === null) {
                    return null;
                }

                return [
                    'client_id' => (string) $cred->client_id,
                    'client_secret' => $clientSecret,
                    'redirect' => $redirect,
                    'webhook_secret_token' => (string) ($cred->readEncryptedAttribute('webhook_secret_token') ?? ''),
                    'source' => self::SOURCE_USER,
                ];
            }
        }

        $clientId = trim((string) config('services.zoom.client_id'));
        $clientSecret = trim((string) config('services.zoom.client_secret'));
        if ($clientId === '' || $clientSecret === '') {
            return null;
        }

        return [
            'client_id' => $clientId,
            'client_secret' => $clientSecret,
            'redirect' => $redirect,
            'webhook_secret_token' => trim((string) config('services.zoom.webhook_secret_token')),
            'source' => self::SOURCE_ENV,
        ];
    }

    public function isConfiguredForUser(?User $user): bool
    {
        return $this->resolveForUser($user) !== null;
    }

    /**
     * @return list<string>
     */
    public function allWebhookSecrets(): array
    {
        $secrets = [];
        $envSecret = trim((string) config('services.zoom.webhook_secret_token'));
        if ($envSecret !== '') {
            $secrets[] = $envSecret;
        }

        UserZoomCredential::query()
            ->where('is_active', true)
            ->get()
            ->each(function (UserZoomCredential $cred) use (&$secrets): void {
                $token = $cred->readEncryptedAttribute('webhook_secret_token');
                if ($cred->is_active && $token !== null) {
                    $secrets[] = $token;
                }
            });

        return array_values(array_unique($secrets));
    }
}
