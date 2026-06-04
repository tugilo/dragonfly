<?php

namespace App\Services\Zoom;

/**
 * Zoom Webhook 署名検証用 secret の解決（env + 全ユーザー secret を試行）。
 */
class ZoomWebhookSecretResolver
{
    public function __construct(private ZoomCredentialResolver $credentials) {}

    /**
     * リクエスト body と署名ヘッダから一致する secret を返す。
     */
    public function matchSecret(string $timestamp, string $signature, string $rawBody): ?string
    {
        if ($timestamp === '' || $signature === '') {
            return null;
        }

        $message = 'v0:'.$timestamp.':'.$rawBody;
        foreach ($this->credentials->allWebhookSecrets() as $secret) {
            $expected = 'v0='.hash_hmac('sha256', $message, $secret);
            if (hash_equals($expected, $signature)) {
                return $secret;
            }
        }

        return null;
    }

    public function hasAnySecret(): bool
    {
        return $this->credentials->allWebhookSecrets() !== [];
    }
}
