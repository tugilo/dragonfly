<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeErrorLog;
use App\Models\Sonae\SonaeLineAccount;

/**
 * SPEC-017 §10.3: LINE Webhook イベント処理。
 */
class SonaeLineWebhookService
{
    public function __construct(
        private readonly SonaeLineLinkService $linkService,
    ) {}

    /**
     * @param  array<string, mixed>  $payload
     */
    public function handle(SonaeChapter $chapter, SonaeLineAccount $lineAccount, array $payload): void
    {
        $events = $payload['events'] ?? [];
        if (! is_array($events)) {
            return;
        }

        foreach ($events as $event) {
            if (! is_array($event)) {
                continue;
            }
            $this->handleEvent($chapter, $lineAccount, $event);
        }
    }

    /**
     * @param  array<string, mixed>  $event
     */
    private function handleEvent(SonaeChapter $chapter, SonaeLineAccount $lineAccount, array $event): void
    {
        $type = (string) ($event['type'] ?? '');
        $source = (array) ($event['source'] ?? []);
        $lineUserId = (string) ($source['userId'] ?? '');

        $this->logWebhook($chapter, 'info', "LINE webhook event: {$type}", [
            'line_user_id' => $lineUserId,
            'event_type' => $type,
        ]);

        if ($lineUserId === '') {
            return;
        }

        match ($type) {
            'follow' => null,
            'unfollow' => $this->linkService->unlinkLineUser($lineAccount, $lineUserId),
            'message' => $this->handleMessage($chapter, $lineAccount, $lineUserId, $event),
            default => null,
        };
    }

    /**
     * @param  array<string, mixed>  $event
     */
    private function handleMessage(
        SonaeChapter $chapter,
        SonaeLineAccount $lineAccount,
        string $lineUserId,
        array $event
    ): void {
        $message = (array) ($event['message'] ?? []);
        if (($message['type'] ?? '') !== 'text') {
            return;
        }

        $text = (string) ($message['text'] ?? '');
        $this->linkService->linkByInviteMessage($chapter, $lineAccount, $lineUserId, $text);
    }

    /**
     * @param  array<string, mixed>  $context
     */
    private function logWebhook(SonaeChapter $chapter, string $severity, string $message, array $context = []): void
    {
        SonaeErrorLog::query()->create([
            'chapter_id' => $chapter->id,
            'category' => 'line_webhook',
            'severity' => $severity,
            'message' => $message,
            'context' => $context,
            'occurred_at' => now(),
        ]);
    }
}
