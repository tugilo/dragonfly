<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeNotificationTarget;
use Illuminate\Support\Str;

/**
 * SPEC-017 §10.6: 回答 URL トークン。
 */
class SonaeResponseTokenService
{
    /**
     * @return array{plain: string, hash: string}
     */
    public function generate(): array
    {
        $plain = Str::random(48);

        return [
            'plain' => $plain,
            'hash' => $this->hash($plain),
        ];
    }

    public function hash(string $plainToken): string
    {
        return hash('sha256', $plainToken);
    }

    public function findTargetByPlainToken(string $plainToken): ?SonaeNotificationTarget
    {
        return SonaeNotificationTarget::query()
            ->where('response_token_hash', $this->hash($plainToken))
            ->with(['member', 'notification.chapter', 'safetyResponse'])
            ->first();
    }

    public function respondUrl(string $plainToken): string
    {
        return url('/sonae/respond/'.$plainToken);
    }
}
