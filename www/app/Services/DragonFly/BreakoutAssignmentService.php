<?php

namespace App\Services\DragonFly;

use App\Models\BreakoutRoom;
use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Support\Facades\DB;

class BreakoutAssignmentService
{
    /**
     * 同室割当を保存する（Session ごとに room_label を S{session}-{room_label} で表現）.
     *
     * @param  array<int>  $roommateParticipantIds  自分以外の同室者 participant_id の配列
     * @return array{room: array, members: array}
     */
    public function saveAssignment(
        Meeting $meeting,
        int $session,
        int $participantId,
        string $roomLabel,
        array $roommateParticipantIds
    ): array {
        $effectiveRoomLabel = 'S' . $session . '-' . trim($roomLabel);
        $participantIds = array_unique(array_merge([$participantId], $roommateParticipantIds));

        $room = BreakoutRoom::updateOrCreate(
            [
                'meeting_id' => $meeting->id,
                'room_label' => $effectiveRoomLabel,
            ],
            ['sort_order' => $session]
        );

        $sessionPrefix = 'S' . $session . '-';
        $sessionRoomIds = BreakoutRoom::where('meeting_id', $meeting->id)
            ->where('room_label', 'like', $sessionPrefix . '%')
            ->pluck('id')
            ->all();

        if (! empty($sessionRoomIds)) {
            DB::table('participant_breakout')
                ->whereIn('participant_id', $participantIds)
                ->whereIn('breakout_room_id', $sessionRoomIds)
                ->delete();
        }

        foreach ($participantIds as $pid) {
            $participant = Participant::find($pid);
            if ($participant) {
                $participant->breakoutRooms()->syncWithoutDetaching([$room->id]);
            }
        }

        $room->load('participants.member');
        $members = $room->participants->map(fn (Participant $p) => [
            'participant_id' => $p->id,
            'member' => $p->member ? [
                'id' => $p->member->id,
                'display_no' => $p->member->display_no,
                'name' => $p->member->name,
                'name_kana' => $p->member->name_kana,
                'category' => $p->member->category,
            ] : null,
        ])->values()->all();

        return [
            'room' => [
                'id' => $room->id,
                'meeting_id' => $room->meeting_id,
                'room_label' => $room->room_label,
                'session' => $session,
            ],
            'members' => $members,
        ];
    }
}
