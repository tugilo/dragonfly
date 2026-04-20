<?php

namespace App\Services\Religo;

use App\Models\BreakoutRoom;
use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Religo: Meeting の BO1/BO2 割当取得・保存（Phase10 互換）.
 * breakout_rounds テーブルが無い環境でも動作するよう meeting_id + room_label で breakout_rooms を扱う. SSOT: DATA_MODEL §4.5, §4.6.
 */
class MeetingBreakoutService
{
    private const ROOM_LABELS = ['BO1', 'BO2'];

    /**
     * GET 用: meeting と rooms（BO1/BO2）.
     */
    public function getBreakouts(Meeting $meeting): array
    {
        $rooms = BreakoutRoom::where('meeting_id', $meeting->id)
            ->whereIn('room_label', self::ROOM_LABELS)
            ->orderBy('room_label')
            ->get();

        $result = [];
        foreach (self::ROOM_LABELS as $label) {
            $room = $rooms->firstWhere('room_label', $label);
            if ($room) {
                $memberIds = $room->participants()
                    ->whereNotIn('type', ['absent', 'proxy'])
                    ->pluck('member_id')
                    ->values()
                    ->all();
                $result[] = [
                    'id' => $room->id,
                    'room_label' => $room->room_label,
                    'notes' => $room->notes,
                    'member_ids' => array_map('intval', $memberIds),
                ];
            } else {
                $result[] = [
                    'id' => null,
                    'room_label' => $label,
                    'notes' => null,
                    'member_ids' => [],
                ];
            }
        }

        return [
            'meeting' => [
                'id' => $meeting->id,
                'number' => $meeting->number,
                'held_on' => $meeting->held_on?->format('Y-m-d'),
            ],
            'rooms' => $result,
        ];
    }

    /**
     * PUT 用: BO1/BO2 の rooms を保存.
     *
     * 各 member_id には当該例会の participants 行が必須。無い場合は自動作成せず ValidationException。
     * SPEC-007 / CONN-BO-PARTICIPANT-REQUIRED-P1.
     *
     * @throws ValidationException
     */
    public function updateBreakouts(Meeting $meeting, array $rooms): void
    {
        // G11: 同一 member を BO1/BO2 の両方に入れてよい。同一 BO 内のみ重複を防ぐ。
        DB::transaction(function () use ($meeting, $rooms) {
            $roomLabels = array_column($rooms, 'room_label');
            $roomMap = [];
            foreach (self::ROOM_LABELS as $label) {
                $idx = array_search($label, $roomLabels, true);
                $payload = $idx !== false ? $rooms[$idx] : ['room_label' => $label, 'notes' => null, 'member_ids' => []];
                $memberIds = array_values(array_unique(array_map('intval', $payload['member_ids'] ?? [])));
                $room = BreakoutRoom::firstOrCreate(
                    ['meeting_id' => $meeting->id, 'room_label' => $label],
                    ['sort_order' => 1]
                );
                $room->update(['notes' => $payload['notes'] ?? null]);
                $roomMap[$label] = ['room' => $room, 'member_ids' => $memberIds];
            }

            $allMemberIds = [];
            foreach ($roomMap as $data) {
                foreach ($data['member_ids'] as $memberId) {
                    $allMemberIds[] = $memberId;
                }
            }
            $uniqueMemberIds = array_values(array_unique($allMemberIds));

            $participantsByMemberId = null;
            if ($uniqueMemberIds !== []) {
                $participantsByMemberId = Participant::query()
                    ->where('meeting_id', $meeting->id)
                    ->whereIn('member_id', $uniqueMemberIds)
                    ->get()
                    ->keyBy('member_id');

                $missing = [];
                $ineligible = [];
                foreach ($uniqueMemberIds as $memberId) {
                    $p = $participantsByMemberId->get($memberId);
                    if ($p === null) {
                        $missing[] = $memberId;
                    } elseif (in_array($p->type, ['absent', 'proxy'], true)) {
                        $ineligible[] = $memberId;
                    }
                }
                if ($missing !== []) {
                    sort($missing);
                    throw ValidationException::withMessages([
                        'rooms' => [
                            sprintf(
                                '当該例会の参加者に存在しない member_id です: %s。CSVまたは参加者登録で登録してからBOに割り当ててください。',
                                implode(', ', $missing)
                            ),
                        ],
                    ]);
                }
                if ($ineligible !== []) {
                    sort($ineligible);
                    throw ValidationException::withMessages([
                        'rooms' => [
                            sprintf(
                                '欠席または代理出席のためBOに含められない member_id です: %s。',
                                implode(', ', $ineligible)
                            ),
                        ],
                    ]);
                }
            }

            $participantIdsByRoom = [];
            foreach ($roomMap as $label => $data) {
                $participantIds = [];
                foreach ($data['member_ids'] as $memberId) {
                    $participantIds[] = $participantsByMemberId->get($memberId)->id;
                }
                $participantIdsByRoom[$label] = $participantIds;
            }

            $breakoutRoomIds = collect($roomMap)->pluck('room.id')->all();
            DB::table('participant_breakout')
                ->whereIn('breakout_room_id', $breakoutRoomIds)
                ->delete();

            foreach ($roomMap as $label => $data) {
                $roomId = $data['room']->id;
                foreach ($participantIdsByRoom[$label] as $participantId) {
                    DB::table('participant_breakout')->insert([
                        'participant_id' => $participantId,
                        'breakout_room_id' => $roomId,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }
        });
    }
}
