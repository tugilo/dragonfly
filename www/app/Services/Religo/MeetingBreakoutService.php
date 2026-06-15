<?php

namespace App\Services\Religo;

use App\Models\BreakoutRoom;
use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Religo: Meeting の BO（同室枠 BO1..BOn）割当取得・保存.
 * breakout_rounds テーブルが無い環境でも動作するよう meeting_id + room_label で breakout_rooms を扱う. SSOT: DATA_MODEL §4.5, §4.6.
 */
class MeetingBreakoutService
{
    /** UI/API で扱う room_label の最大数（BO1..BO20） */
    public const MAX_BO_ROOMS = 20;

    /**
     * Connections のグローバル Owner がどの BO にも含まれないとき、BO1 に追加する（同一保存ペイロード内で完結）。
     * G11 で同一 member を複数 BO に入れてよいため、「いずれかのルームにいれば」追加しない。
     *
     * @param  array<int, array{room_label: string, notes?: string|null, member_ids?: array<int>}>  $rooms
     * @return array<int, array{room_label: string, notes?: string|null, member_ids?: array<int>}>
     */
    public function mergeEnsureMemberInBo1IfAbsent(array $rooms, ?int $memberId): array
    {
        if ($memberId === null || $memberId <= 0) {
            return $rooms;
        }
        foreach ($rooms as $room) {
            foreach ($room['member_ids'] ?? [] as $mid) {
                if ((int) $mid === $memberId) {
                    return $rooms;
                }
            }
        }

        $out = [];
        foreach ($rooms as $room) {
            $label = $room['room_label'] ?? '';
            if ($label === 'BO1') {
                $ids = array_values(array_unique(array_map('intval', $room['member_ids'] ?? [])));
                $ids[] = $memberId;
                $room['member_ids'] = array_values(array_unique($ids));
            }
            $out[] = $room;
        }

        return $out;
    }

    /**
     * GET 用: meeting と rooms（BO1..BOn、DB に存在する分）.
     */
    public function getBreakouts(Meeting $meeting): array
    {
        $rooms = BreakoutRoom::where('meeting_id', $meeting->id)
            ->get()
            ->filter(fn (BreakoutRoom $room) => self::isManagedBoLabel($room->room_label))
            ->sortBy(fn (BreakoutRoom $room) => self::boNumberFromLabel($room->room_label))
            ->values();

        $result = [];
        foreach ($rooms as $room) {
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
     * PUT 用: BO1..BOn の rooms を保存（payload が正）。
     * payload に無い BO* ルームは削除する（BO 以外の room_label は触らない）。
     *
     * 各 member_id には当該例会の participants 行が必須。無い場合は自動作成せず ValidationException。
     * SPEC-007 / CONN-BO-PARTICIPANT-REQUIRED-P1.
     *
     * @throws ValidationException
     */
    public function updateBreakouts(Meeting $meeting, array $rooms): void
    {
        // G11: 同一 member を複数 BO に入れてよい。同一 BO 内のみ重複を防ぐ。
        DB::transaction(function () use ($meeting, $rooms) {
            $payloadByLabel = [];
            foreach ($rooms as $payload) {
                $label = (string) ($payload['room_label'] ?? '');
                $payloadByLabel[$label] = $payload;
            }

            $roomMap = [];
            foreach ($payloadByLabel as $label => $payload) {
                $memberIds = array_values(array_unique(array_map('intval', $payload['member_ids'] ?? [])));
                $sortOrder = self::boNumberFromLabel($label);
                $room = BreakoutRoom::firstOrCreate(
                    ['meeting_id' => $meeting->id, 'room_label' => $label],
                    ['sort_order' => $sortOrder]
                );
                $room->update([
                    'notes' => $payload['notes'] ?? null,
                    'sort_order' => $sortOrder,
                ]);
                $roomMap[$label] = ['room' => $room, 'member_ids' => $memberIds];
            }

            $labelsInPayload = array_keys($payloadByLabel);
            BreakoutRoom::where('meeting_id', $meeting->id)
                ->get()
                ->filter(function (BreakoutRoom $room) use ($labelsInPayload) {
                    return self::isManagedBoLabel($room->room_label)
                        && ! in_array($room->room_label, $labelsInPayload, true);
                })
                ->each(fn (BreakoutRoom $room) => $room->delete());

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
            if ($breakoutRoomIds !== []) {
                DB::table('participant_breakout')
                    ->whereIn('breakout_room_id', $breakoutRoomIds)
                    ->delete();
            }

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

    public static function isManagedBoLabel(string $label): bool
    {
        return (bool) preg_match('/^BO\d+$/', $label);
    }

    public static function boNumberFromLabel(string $label): int
    {
        if (preg_match('/^BO(\d+)$/', $label, $m)) {
            return (int) $m[1];
        }

        return PHP_INT_MAX;
    }
}
