<?php

namespace App\Services\DragonFly;

use App\Models\DragonflyContactEvent;
use App\Models\DragonflyContactFlag;
use App\Models\Meeting;
use Illuminate\Validation\ValidationException;

class ContactFlagService
{
    /**
     * フラグを upsert し、interested / want_1on1 の変更時は contact_events に 1 件ずつ追加する.
     * meeting_id が渡されていればそれを優先、無ければ meeting_number から meetings.id を解決する.
     *
     * @param  array<string, mixed>|null  $extraStatus
     */
    public function upsertFlag(
        int $ownerMemberId,
        int $targetMemberId,
        ?bool $interested = null,
        ?bool $want1on1 = null,
        ?array $extraStatus = null,
        ?string $reason = null,
        ?int $meetingId = null,
        ?int $meetingNumber = null
    ): DragonflyContactFlag {
        $resolvedMeetingId = null;
        if ($meetingId !== null) {
            $resolvedMeetingId = $meetingId;
        } elseif ($meetingNumber !== null) {
            $meeting = Meeting::where('number', $meetingNumber)->first();
            if (! $meeting) {
                throw ValidationException::withMessages([
                    'meeting_number' => '指定された meeting_number は存在しません。',
                ]);
            }
            $resolvedMeetingId = $meeting->id;
        }

        $flag = DragonflyContactFlag::firstOrNew([
            'owner_member_id' => $ownerMemberId,
            'target_member_id' => $targetMemberId,
        ]);

        $beforeInterested = $flag->interested;
        $beforeWant1on1 = $flag->want_1on1;

        if ($interested !== null) {
            $flag->interested = $interested;
        }
        if ($want1on1 !== null) {
            $flag->want_1on1 = $want1on1;
        }
        if ($extraStatus !== null) {
            $merged = is_array($flag->extra_status) ? $flag->extra_status : [];
            foreach ($extraStatus as $key => $value) {
                $merged[$key] = $value;
            }
            $flag->extra_status = $merged;
        }

        $flag->save();

        if ($beforeInterested !== $flag->interested) {
            $this->appendEvent(
                $ownerMemberId,
                $targetMemberId,
                $flag->interested ? 'interested_on' : 'interested_off',
                $reason,
                $resolvedMeetingId
            );
        }
        if ($beforeWant1on1 !== $flag->want_1on1) {
            $this->appendEvent(
                $ownerMemberId,
                $targetMemberId,
                $flag->want_1on1 ? 'want_1on1_on' : 'want_1on1_off',
                $reason,
                $resolvedMeetingId
            );
        }

        return $flag;
    }

    /**
     * contact_events に 1 件追加（event 追加ロジックの集約）.
     */
    private function appendEvent(
        int $ownerMemberId,
        int $targetMemberId,
        string $eventType,
        ?string $reason = null,
        ?int $meetingId = null
    ): DragonflyContactEvent {
        $event = new DragonflyContactEvent([
            'owner_member_id' => $ownerMemberId,
            'target_member_id' => $targetMemberId,
            'meeting_id' => $meetingId,
            'event_type' => $eventType,
            'reason' => $reason !== null && $reason !== '' ? $reason : null,
        ]);
        $event->created_at = now();
        $event->save();

        return $event;
    }
}
