<?php

namespace App\Services\Religo;

use App\Models\BreakoutRoom;
use App\Models\BreakoutRound;
use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Phase10R: Meeting の複数 Round 割当取得・保存. SSOT: PHASE10R PLAN.
 */
class MeetingBreakoutRoundsService
{
    private const ROOM_LABELS = ['BO1', 'BO2'];

    /**
     * GET 用: meeting + rounds[]（各 round に rooms[]）.
     *
     * @return array{meeting: array, rounds: array<int, array{round_no: int, label: string|null, rooms: array}>}
     */
    public function getBreakoutRounds(Meeting $meeting): array
    {
        $rounds = BreakoutRound::where('meeting_id', $meeting->id)
            ->orderBy('round_no')
            ->get();

        $result = [];
        foreach ($rounds as $round) {
            $rooms = BreakoutRoom::where('breakout_round_id', $round->id)
                ->whereIn('room_label', self::ROOM_LABELS)
                ->orderBy('room_label')
                ->get();
            $roomList = [];
            foreach (self::ROOM_LABELS as $label) {
                $room = $rooms->firstWhere('room_label', $label);
                if ($room) {
                    $memberIds = $room->participants()
                        ->whereNotIn('type', ['absent', 'proxy'])
                        ->pluck('member_id')
                        ->values()
                        ->all();
                    $roomList[] = [
                        'room_id' => $room->id,
                        'room_label' => $room->room_label,
                        'notes' => $room->notes,
                        'member_ids' => array_map('intval', $memberIds),
                    ];
                } else {
                    $roomList[] = [
                        'room_id' => null,
                        'room_label' => $label,
                        'notes' => null,
                        'member_ids' => [],
                    ];
                }
            }
            $result[] = [
                'round_no' => $round->round_no,
                'label' => $round->label,
                'rooms' => $roomList,
            ];
        }

        return [
            'meeting' => [
                'id' => $meeting->id,
                'number' => $meeting->number,
                'held_on' => $meeting->held_on?->format('Y-m-d'),
            ],
            'rounds' => $result,
        ];
    }

    /**
     * PUT 用: rounds[] を upsert. 同一 round 内重複 member・absent/proxy・participant 未登録は 422.
     *
     * participant 不在時の自動作成はしない（SPEC-007 / CONN-BO-PARTICIPANT-REQUIRED-P1）。
     *
     * @param  array<int, array{round_no: int, label: string|null, rooms: array}>  $rounds
     *
     * @throws ValidationException
     */
    public function updateBreakoutRounds(Meeting $meeting, array $rounds): void
    {
        DB::transaction(function () use ($meeting, $rounds) {
            foreach ($rounds as $roundPayload) {
                $roundNo = (int) ($roundPayload['round_no'] ?? 0);
                $label = $roundPayload['label'] ?? null;
                $roomsPayload = $roundPayload['rooms'] ?? [];
                if ($roundNo < 1) {
                    throw \Illuminate\Validation\ValidationException::withMessages([
                        'rounds' => ['round_no は 1 以上である必要があります。'],
                    ]);
                }
                $round = BreakoutRound::firstOrCreate(
                    ['meeting_id' => $meeting->id, 'round_no' => $roundNo],
                    ['label' => $label ?? "Round {$roundNo}"]
                );
                $round->update(['label' => $label ?? $round->label]);

                $allMemberIdsInRound = [];
                foreach ($roomsPayload as $r) {
                    foreach ($r['member_ids'] ?? [] as $mid) {
                        $allMemberIdsInRound[] = (int) $mid;
                    }
                }
                if (count($allMemberIdsInRound) !== count(array_unique($allMemberIdsInRound))) {
                    throw \Illuminate\Validation\ValidationException::withMessages([
                        'rounds' => ["Round {$roundNo} 内で同一メンバーを複数ルームに割り当てることはできません。"],
                    ]);
                }

                $roomMap = [];
                foreach (self::ROOM_LABELS as $labelKey) {
                    $idx = array_search($labelKey, array_column($roomsPayload, 'room_label'), true);
                    $payload = $idx !== false ? $roomsPayload[$idx] : ['room_label' => $labelKey, 'notes' => null, 'member_ids' => []];
                    $room = BreakoutRoom::firstOrCreate(
                        ['breakout_round_id' => $round->id, 'room_label' => $labelKey],
                        ['meeting_id' => $meeting->id, 'sort_order' => $roundNo]
                    );
                    $room->update(['notes' => $payload['notes'] ?? null]);
                    $roomMap[$labelKey] = ['room' => $room, 'member_ids' => array_map('intval', $payload['member_ids'] ?? [])];
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
                            'rounds' => [
                                sprintf(
                                    'Round %d: 当該例会の参加者に存在しない member_id です: %s。CSVまたは参加者登録で登録してからBOに割り当ててください。',
                                    $roundNo,
                                    implode(', ', $missing)
                                ),
                            ],
                        ]);
                    }
                    if ($ineligible !== []) {
                        sort($ineligible);
                        throw ValidationException::withMessages([
                            'rounds' => [
                                sprintf(
                                    'Round %d: 欠席または代理出席のためBOに含められない member_id です: %s。',
                                    $roundNo,
                                    implode(', ', $ineligible)
                                ),
                            ],
                        ]);
                    }
                }

                $participantIdsByRoom = [];
                foreach ($roomMap as $labelKey => $data) {
                    $participantIds = [];
                    foreach ($data['member_ids'] as $memberId) {
                        $participantIds[] = $participantsByMemberId->get($memberId)->id;
                    }
                    $participantIdsByRoom[$labelKey] = $participantIds;
                }

                $breakoutRoomIds = collect($roomMap)->pluck('room.id')->all();
                DB::table('participant_breakout')
                    ->whereIn('breakout_room_id', $breakoutRoomIds)
                    ->delete();

                foreach ($roomMap as $labelKey => $data) {
                    $roomId = $data['room']->id;
                    foreach ($participantIdsByRoom[$labelKey] as $participantId) {
                        DB::table('participant_breakout')->insert([
                            'participant_id' => $participantId,
                            'breakout_room_id' => $roomId,
                            'created_at' => now(),
                            'updated_at' => now(),
                        ]);
                    }
                }
            }
        });
    }
}
