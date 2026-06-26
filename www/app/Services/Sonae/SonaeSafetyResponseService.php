<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeNotificationTarget;
use App\Models\Sonae\SonaeSafetyResponse;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;

/**
 * SPEC-017 §7: メンバー安否回答。
 */
class SonaeSafetyResponseService
{
    /**
     * @param  array<string, mixed>  $input
     */
    public function submit(SonaeNotificationTarget $target, array $input): SonaeSafetyResponse
    {
        $validated = $this->validateInput($input);

        return DB::transaction(function () use ($target, $validated) {
            $response = SonaeSafetyResponse::query()->updateOrCreate(
                ['notification_target_id' => $target->id],
                [
                    'member_id' => $target->member_id,
                    'safety_status' => $validated['safety_status'],
                    'activity_status' => $validated['activity_status'],
                    'meeting_attendance_status' => $validated['meeting_attendance_status'],
                    'comment' => $validated['comment'] ?? null,
                    'submitted_at' => now(),
                ]
            );

            $target->responded_at = now();
            $target->save();

            return $response->fresh();
        });
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array{safety_status: string, activity_status: string, meeting_attendance_status: string, comment?: string|null}
     */
    private function validateInput(array $input): array
    {
        $safety = (string) ($input['safety_status'] ?? '');
        $activity = (string) ($input['activity_status'] ?? '');
        $attendance = (string) ($input['meeting_attendance_status'] ?? '');

        $allowedSafety = [
            SonaeConstants::SAFETY_SAFE,
            SonaeConstants::SAFETY_MINOR_INJURY,
            SonaeConstants::SAFETY_SERIOUS_INJURY,
            SonaeConstants::SAFETY_EVACUATING,
            SonaeConstants::SAFETY_HARD_TO_ANSWER,
        ];
        $allowedActivity = [
            SonaeConstants::ACTIVITY_NORMAL,
            SonaeConstants::ACTIVITY_PARTIALLY_AFFECTED,
            SonaeConstants::ACTIVITY_DIFFICULT,
        ];
        $allowedAttendance = [
            SonaeConstants::ATTENDANCE_CAN,
            SonaeConstants::ATTENDANCE_CANNOT,
            SonaeConstants::ATTENDANCE_UNDECIDED,
        ];

        if (! in_array($safety, $allowedSafety, true)) {
            throw new InvalidArgumentException('Invalid safety_status.');
        }
        if (! in_array($activity, $allowedActivity, true)) {
            throw new InvalidArgumentException('Invalid activity_status.');
        }
        if (! in_array($attendance, $allowedAttendance, true)) {
            throw new InvalidArgumentException('Invalid meeting_attendance_status.');
        }

        $comment = isset($input['comment']) ? (string) $input['comment'] : null;
        if ($comment !== null && mb_strlen($comment) > 1000) {
            throw new InvalidArgumentException('Comment exceeds 1000 characters.');
        }

        return [
            'safety_status' => $safety,
            'activity_status' => $activity,
            'meeting_attendance_status' => $attendance,
            'comment' => $comment,
        ];
    }
}
