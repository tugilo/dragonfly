<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeAlertNotification;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeMember;
use App\Models\Sonae\SonaeNotificationTarget;
use App\Models\Sonae\SonaeTrainingEvent;
use Illuminate\Support\Facades\DB;

/**
 * SPEC-017 §8.2: 手動訓練発報。
 */
class SonaeTrainingDispatchService
{
    public function __construct(
        private readonly SonaeNotificationTargetResolver $targetResolver,
        private readonly SonaeResponseTokenService $tokenService,
        private readonly SonaeLinePushService $linePush,
    ) {}

    /**
     * @param  array{name: string, title?: string|null, body?: string|null}  $input
     * @return array{training_event: SonaeTrainingEvent, notification: SonaeAlertNotification, sent: int, failed: int}
     */
    public function dispatch(SonaeChapter $chapter, array $input, ?int $createdByUserId = null): array
    {
        $members = $this->targetResolver->resolveLinkedActiveMembers($chapter);
        $chapter->load('lineAccount');
        $lineAccount = $chapter->lineAccount;

        if ($lineAccount === null || ! $lineAccount->hasUsableCredentials()) {
            throw new \RuntimeException('LINE account is not configured for push.');
        }

        $title = $input['title'] ?? '【SONAE 訓練】安否確認';
        $bodyTemplate = $input['body'] ?? 'これは {chapter} の安否確認訓練です。以下から回答してください。';

        return DB::transaction(function () use ($chapter, $input, $createdByUserId, $members, $lineAccount, $title, $bodyTemplate) {
            $training = SonaeTrainingEvent::query()->create([
                'chapter_id' => $chapter->id,
                'name' => $input['name'],
                'executed_at' => now(),
                'created_by_user_id' => $createdByUserId,
            ]);

            $notification = SonaeAlertNotification::query()->create([
                'chapter_id' => $chapter->id,
                'training_event_id' => $training->id,
                'notification_type' => SonaeConstants::NOTIFICATION_TRAINING,
                'title' => $title,
                'body' => str_replace('{chapter}', $chapter->name, $bodyTemplate),
                'status' => 'sending',
                'created_by_user_id' => $createdByUserId,
            ]);

            $sent = 0;
            $failed = 0;

            foreach ($members as $member) {
                $result = $this->dispatchToMember($notification, $member, $lineAccount, $chapter, $title);
                $sent += $result['sent'];
                $failed += $result['failed'];
            }

            $notification->status = $failed > 0 && $sent === 0 ? 'failed' : 'sent';
            $notification->sent_at = now();
            $notification->save();

            return [
                'training_event' => $training->fresh(),
                'notification' => $notification->fresh(),
                'sent' => $sent,
                'failed' => $failed,
            ];
        });
    }

    /**
     * @return array{sent: int, failed: int}
     */
    private function dispatchToMember(
        SonaeAlertNotification $notification,
        SonaeMember $member,
        $lineAccount,
        SonaeChapter $chapter,
        string $title
    ): array {
        $token = $this->tokenService->generate();
        $respondUrl = $this->tokenService->respondUrl($token['plain']);

        $link = $member->activeLineUserLink ?? $member->lineUserLinks()
            ->where('status', SonaeConstants::LINE_LINK_ACTIVE)
            ->first();

        $target = SonaeNotificationTarget::query()->create([
            'alert_notification_id' => $notification->id,
            'member_id' => $member->id,
            'line_user_link_id' => $link?->id,
            'response_token_hash' => $token['hash'],
            'send_status' => 'pending',
        ]);

        $message = $title."\n".$chapter->name."\n".$respondUrl;

        $ok = $link !== null && $this->linePush->pushText($lineAccount, $link->line_user_id, $message);

        $target->send_status = $ok ? 'sent' : 'failed';
        $target->sent_at = $ok ? now() : null;
        if (! $ok) {
            $target->error_message = 'LINE push failed';
        }
        $target->save();

        return ['sent' => $ok ? 1 : 0, 'failed' => $ok ? 0 : 1];
    }
}
