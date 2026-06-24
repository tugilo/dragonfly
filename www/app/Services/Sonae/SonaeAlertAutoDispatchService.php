<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeAlertEvent;
use App\Models\Sonae\SonaeAlertNotification;
use App\Models\Sonae\SonaeChapterAlertSetting;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeLineAccount;
use App\Models\Sonae\SonaeMember;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\DB;

class SonaeAlertAutoDispatchService
{
    public function __construct(
        private readonly SonaeAlertMatchService $matcher,
        private readonly SonaeNotificationTargetResolver $targetResolver,
        private readonly SonaeResponseTokenService $tokenService,
        private readonly SonaeLinePushService $linePush,
    ) {}

    /**
     * @param  list<SonaeAlertEvent>  $events
     * @return array{created_notification_count: int, skipped_notification_count: int}
     */
    public function dispatchEvents(array $events): array
    {
        $createdNotificationCount = 0;
        $skippedNotificationCount = 0;

        foreach ($events as $event) {
            $result = $this->dispatchForEvent($event);
            $createdNotificationCount += $result['created_notification_count'];
            $skippedNotificationCount += $result['skipped_notification_count'];
        }

        return [
            'created_notification_count' => $createdNotificationCount,
            'skipped_notification_count' => $skippedNotificationCount,
        ];
    }

    /**
     * @return array{created_notification_count: int, skipped_notification_count: int}
     */
    public function dispatchForEvent(SonaeAlertEvent $event): array
    {
        $created = 0;
        $skipped = 0;

        foreach ($this->matcher->matchEnabledSettings($event) as $setting) {
            $result = $this->dispatchToChapter($event, $setting);
            $created += $result['created'] ? 1 : 0;
            $skipped += $result['created'] ? 0 : 1;
        }

        return [
            'created_notification_count' => $created,
            'skipped_notification_count' => $skipped,
        ];
    }

    /**
     * @return array{created: bool}
     */
    private function dispatchToChapter(SonaeAlertEvent $event, SonaeChapterAlertSetting $setting): array
    {
        $chapter = $setting->chapter;
        if ($chapter === null) {
            return ['created' => false];
        }

        if (SonaeAlertNotification::query()
            ->where('chapter_id', $chapter->id)
            ->where('alert_event_id', $event->id)
            ->exists()) {
            return ['created' => false];
        }

        $chapter->load('lineAccount');
        $lineAccount = $chapter->lineAccount;
        $members = $this->targetResolver->resolveLinkedActiveMembers($chapter);

        try {
            DB::transaction(function () use ($chapter, $event, $lineAccount, $members) {
                $notification = SonaeAlertNotification::query()->create([
                    'chapter_id' => $chapter->id,
                    'alert_event_id' => $event->id,
                    'notification_type' => SonaeConstants::NOTIFICATION_ALERT,
                    'title' => $this->titleForEvent($event),
                    'body' => $this->bodyForEvent($event),
                    'status' => 'sending',
                ]);

                if ($lineAccount === null || ! $lineAccount->hasUsableCredentials()) {
                    $notification->status = 'failed';
                    $notification->save();

                    return;
                }

                $sent = 0;
                $failed = 0;
                foreach ($members as $member) {
                    $result = $this->dispatchToMember($notification, $member, $lineAccount, $chapter->name, $event->title);
                    $sent += $result['sent'];
                    $failed += $result['failed'];
                }

                $notification->status = $failed > 0 && $sent === 0 ? 'failed' : 'sent';
                $notification->sent_at = now();
                $notification->save();
            });
        } catch (QueryException $e) {
            // unique(chapter_id, alert_event_id) が衝突した場合は既存通知ありとしてスキップ。
            $sqlState = $e->errorInfo[0] ?? null;
            if ($sqlState === '23000') {
                return ['created' => false];
            }
            throw $e;
        }

        return ['created' => true];
    }

    /**
     * @return array{sent: int, failed: int}
     */
    private function dispatchToMember(
        SonaeAlertNotification $notification,
        SonaeMember $member,
        SonaeLineAccount $lineAccount,
        string $chapterName,
        string $eventTitle
    ): array {
        $token = $this->tokenService->generate();
        $respondUrl = $this->tokenService->respondUrl($token['plain']);

        $link = $member->activeLineUserLink ?? $member->lineUserLinks()
            ->where('status', SonaeConstants::LINE_LINK_ACTIVE)
            ->first();

        $target = $notification->targets()->create([
            'member_id' => $member->id,
            'line_user_link_id' => $link?->id,
            'response_token_hash' => $token['hash'],
            'send_status' => 'pending',
        ]);

        $message = "【SONAE 災害通知】\n{$eventTitle}\n{$chapterName}\n{$respondUrl}";
        $ok = $link !== null && $this->linePush->pushText($lineAccount, $link->line_user_id, $message);

        $target->send_status = $ok ? 'sent' : 'failed';
        $target->sent_at = $ok ? now() : null;
        if (! $ok) {
            $target->error_message = 'LINE push failed';
        }
        $target->save();

        return ['sent' => $ok ? 1 : 0, 'failed' => $ok ? 0 : 1];
    }

    private function titleForEvent(SonaeAlertEvent $event): string
    {
        return '【SONAE 災害】'.$event->title;
    }

    private function bodyForEvent(SonaeAlertEvent $event): string
    {
        $pieces = ['災害通知', $event->title];
        if (is_string($event->severity) && $event->severity !== '') {
            $pieces[] = '深刻度: '.$event->severity;
        }
        if ($event->occurred_at !== null) {
            $pieces[] = '発生: '.$event->occurred_at->toIso8601String();
        }

        return implode("\n", $pieces);
    }
}
