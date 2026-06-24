<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeAlertNotification;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeNotificationTarget;
use App\Models\Sonae\SonaeTrainingEvent;
use Illuminate\Support\Facades\DB;

/**
 * SPEC-017 §6.4: 回答集計。
 */
class SonaeAggregationService
{
    /** @var list<string> */
    private const HARMFUL_SAFETY_STATUSES = [
        SonaeConstants::SAFETY_MINOR_INJURY,
        SonaeConstants::SAFETY_SERIOUS_INJURY,
        SonaeConstants::SAFETY_EVACUATING,
        SonaeConstants::SAFETY_HARD_TO_ANSWER,
    ];

    /**
     * @return array<string, mixed>
     */
    public function summarizeNotification(SonaeAlertNotification $notification): array
    {
        $targets = SonaeNotificationTarget::query()
            ->where('alert_notification_id', $notification->id)
            ->with(['safetyResponse', 'member'])
            ->get();

        $targetCount = $targets->count();
        $respondedCount = $targets->filter(fn ($t) => $t->responded_at !== null)->count();
        $unansweredCount = $targetCount - $respondedCount;

        $harmfulCount = 0;
        $activityDifficultCount = 0;
        $meetingCannotCount = 0;

        foreach ($targets as $target) {
            $response = $target->safetyResponse;
            if ($response === null) {
                continue;
            }
            if (in_array($response->safety_status, self::HARMFUL_SAFETY_STATUSES, true)) {
                $harmfulCount++;
            }
            if ($response->activity_status === SonaeConstants::ACTIVITY_DIFFICULT) {
                $activityDifficultCount++;
            }
            if ($response->meeting_attendance_status === SonaeConstants::ATTENDANCE_CANNOT) {
                $meetingCannotCount++;
            }
        }

        return [
            'notification_id' => $notification->id,
            'notification_type' => $notification->notification_type,
            'title' => $notification->title,
            'sent_at' => $notification->sent_at?->toIso8601String(),
            'target_count' => $targetCount,
            'responded_count' => $respondedCount,
            'unanswered_count' => $unansweredCount,
            'response_rate' => $targetCount > 0 ? (float) round($respondedCount / $targetCount, 4) : null,
            'harmful_count' => $harmfulCount,
            'activity_difficult_count' => $activityDifficultCount,
            'meeting_cannot_attend_count' => $meetingCannotCount,
        ];
    }

    /**
     * @return list<array<string, mixed>>
     */
    public function listUnanswered(SonaeAlertNotification $notification): array
    {
        return SonaeNotificationTarget::query()
            ->where('alert_notification_id', $notification->id)
            ->whereNull('responded_at')
            ->with(['member'])
            ->orderBy('id')
            ->get()
            ->map(fn (SonaeNotificationTarget $target) => [
                'member_id' => $target->member_id,
                'member_name' => $target->member?->name,
                'send_status' => $target->send_status,
            ])
            ->values()
            ->all();
    }

    public function responseRateForTraining(SonaeTrainingEvent $training): ?float
    {
        $notification = SonaeAlertNotification::query()
            ->where('training_event_id', $training->id)
            ->where('notification_type', SonaeConstants::NOTIFICATION_TRAINING)
            ->latest('id')
            ->first();

        if ($notification === null) {
            return null;
        }

        $summary = $this->summarizeNotification($notification);

        return $summary['response_rate'];
    }

    /**
     * @return array<string, mixed>|null
     */
    public function previousTrainingComparison(SonaeChapter $chapter, SonaeTrainingEvent $current): ?array
    {
        $previous = SonaeTrainingEvent::query()
            ->where('chapter_id', $chapter->id)
            ->where('id', '<', $current->id)
            ->whereNotNull('executed_at')
            ->orderByDesc('id')
            ->first();

        if ($previous === null) {
            return null;
        }

        $currentRate = $this->responseRateForTraining($current);
        $previousRate = $this->responseRateForTraining($previous);

        if ($currentRate === null || $previousRate === null) {
            return null;
        }

        return [
            'previous_training_event_id' => $previous->id,
            'previous_training_name' => $previous->name,
            'previous_response_rate' => $previousRate,
            'current_response_rate' => $currentRate,
            'delta' => round($currentRate - $previousRate, 4),
        ];
    }
}
