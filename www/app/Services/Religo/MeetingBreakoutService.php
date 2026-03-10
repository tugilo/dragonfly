<?php

namespace App\Services\Religo;

use App\Models\BreakoutRoom;
use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Support\Facades\DB;

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

            $participantIdsByRoom = [];
            foreach ($roomMap as $label => $data) {
                $participantIds = [];
                foreach ($data['member_ids'] as $memberId) {
                    $participant = Participant::firstWhere([
                        'meeting_id' => $meeting->id,
                        'member_id' => $memberId,
                    ]);
                    if ($participant) {
                        if (in_array($participant->type, ['absent', 'proxy'], true)) {
                            throw \Illuminate\Validation\ValidationException::withMessages([
                                'rooms' => ["member_id {$memberId} は欠席/代理のため割当に含められません。"],
                            ]);
                        }
                    } else {
                        $participant = Participant::create([
                            'meeting_id' => $meeting->id,
                            'member_id' => $memberId,
                            'type' => 'regular',
                        ]);
                    }
                    $participantIds[] = $participant->id;
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
