<?php

namespace Database\Seeders;

use App\Models\BreakoutRoom;
use App\Models\Meeting;
use App\Models\Member;
use App\Models\Participant;
use Illuminate\Database\Seeder;

/**
 * 第199回の breakout_rooms と participant_breakout を投入する Seeder.
 *
 * データソース: docs/networking/bni/dragonfly/participants/BNI_DragonFly_Breakout_20260303.md
 * 元資料にはルーム割り当てが無いため、display_no 順に A,B,C,D へ均等割り当てする。
 *
 * 実行手順:
 *   php artisan db:seed --class=DragonFlyMeeting199BreakoutSeeder
 *
 * 期待:
 *   - breakout_rooms: 4件（A,B,C,D）
 *   - participant_breakout: 63件（参加者全員が1ルームに紐付く）
 */
class DragonFlyMeeting199BreakoutSeeder extends Seeder
{
    /** Breakout 資料の display_no 順（メンバー1-54, V1-V5, G1-G4） */
    private function displayNoOrder(): array
    {
        $nos = [];
        for ($i = 1; $i <= 54; $i++) {
            $nos[] = (string) $i;
        }
        foreach (['V1', 'V2', 'V3', 'V4', 'V5'] as $v) {
            $nos[] = $v;
        }
        foreach (['G1', 'G2', 'G3', 'G4'] as $g) {
            $nos[] = $g;
        }
        return $nos;
    }

    public function run(): void
    {
        $meeting = Meeting::where('number', 199)->first();
        if (! $meeting) {
            $this->command?->warn('Meeting 199 not found. Run DragonFlyMeeting199Seeder first.');
            return;
        }

        $participants = Participant::where('meeting_id', $meeting->id)
            ->with('member')
            ->get()
            ->keyBy(fn (Participant $p) => $p->member->display_no ?? 'unknown');

        $displayNos = $this->displayNoOrder();
        $rooms = ['A', 'B', 'C', 'D'];
        $roomCount = count($rooms);
        $perRoom = (int) ceil(63 / $roomCount);

        foreach ($rooms as $index => $label) {
            BreakoutRoom::updateOrCreate(
                [
                    'meeting_id' => $meeting->id,
                    'room_label' => $label,
                ],
                [
                    'sort_order' => $index + 1,
                ]
            );
        }

        $roomLabels = collect($rooms);
        foreach ($displayNos as $i => $displayNo) {
            $participant = $participants->get($displayNo);
            if (! $participant) {
                continue;
            }
            $roomIndex = min((int) floor($i / $perRoom), $roomCount - 1);
            $roomLabel = $roomLabels->get($roomIndex, 'A');
            $room = BreakoutRoom::where('meeting_id', $meeting->id)->where('room_label', $roomLabel)->first();
            if (! $room) {
                continue;
            }
            $participant->breakoutRooms()->sync([$room->id]);
        }
    }
}
