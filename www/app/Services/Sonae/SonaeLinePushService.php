<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeErrorLog;
use App\Models\Sonae\SonaeLineAccount;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * SPEC-017 §10: LINE Push Message 送信。
 */
class SonaeLinePushService
{
    private const PUSH_ENDPOINT = 'https://api.line.me/v2/bot/message/push';

    public function pushText(SonaeLineAccount $account, string $lineUserId, string $text): bool
    {
        $token = $account->readEncryptedAttribute('messaging_api_access_token_encrypted');
        if ($token === null || $token === '') {
            $this->logError($account, 'LINE access token is not configured.', [
                'line_user_id' => $lineUserId,
            ]);

            return false;
        }

        try {
            $response = Http::withToken($token)
                ->acceptJson()
                ->post(self::PUSH_ENDPOINT, [
                    'to' => $lineUserId,
                    'messages' => [
                        ['type' => 'text', 'text' => $text],
                    ],
                ]);

            if (! $response->successful()) {
                $this->logError($account, 'LINE push failed.', [
                    'line_user_id' => $lineUserId,
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);

                return false;
            }

            return true;
        } catch (\Throwable $e) {
            Log::warning('SONAE LINE push exception', ['message' => $e->getMessage()]);
            $this->logError($account, $e->getMessage(), ['line_user_id' => $lineUserId]);

            return false;
        }
    }

    /**
     * @param  array<string, mixed>  $context
     */
    private function logError(SonaeLineAccount $account, string $message, array $context = []): void
    {
        SonaeErrorLog::query()->create([
            'chapter_id' => $account->chapter_id,
            'category' => 'line_send',
            'severity' => 'error',
            'message' => $message,
            'context' => $context,
            'occurred_at' => now(),
        ]);
    }
}
