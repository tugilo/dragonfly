<?php

namespace App\Services\DragonFly;

use App\Models\Meeting;
use Illuminate\Support\Collection;

class MeetingAttendeesService
{
    /**
     * 指定回の定例会の参加者一覧を区分別に返す.
     *
     * @return array{meeting: array, attendees: array{member: array, visitor: array, guest: array}}
     */
    public function getAttendeesByMeetingNumber(int $number): array
    {
        $meeting = Meeting::where('number', $number)
            ->with([
                'participants.member.category',
                'participants.member.memberRoles.role',
                'participants.introducer:id,name',
                'participants.attendant:id,name',
                'participants.breakoutRooms',
            ])
            ->first();

        if (! $meeting) {
            return [
                'meeting' => null,
                'attendees' => ['member' => [], 'visitor' => [], 'guest' => []],
            ];
        }

        $participants = $meeting->participants;
        $byType = [
            'member' => $participants->where('type', 'member')->values(),
            'visitor' => $participants->where('type', 'visitor')->values(),
            'guest' => $participants->where('type', 'guest')->values(),
        ];

        foreach (['member', 'visitor', 'guest'] as $type) {
            $byType[$type] = $this->sortParticipants($byType[$type], $type);
        }

        return [
            'meeting' => [
                'number' => $meeting->number,
                'held_on' => $meeting->held_on->format('Y-m-d'),
                'name' => $meeting->name,
            ],
            'attendees' => [
                'member' => $byType['member']->map(fn ($p) => $this->formatAttendee($p))->values()->all(),
                'visitor' => $byType['visitor']->map(fn ($p) => $this->formatAttendee($p))->values()->all(),
                'guest' => $byType['guest']->map(fn ($p) => $this->formatAttendee($p))->values()->all(),
            ],
        ];
    }

    private function sortParticipants(Collection $participants, string $type): Collection
    {
        if ($type === 'member') {
            return $participants->sortBy(fn ($p) => (int) ($p->member->display_no ?? 0))->values();
        }
        return $participants->sortBy(fn ($p) => $p->member->display_no ?? '')->values();
    }

    private function formatAttendee($participant): array
    {
        $member = $participant->member;
        $breakoutRoomLabels = $participant->breakoutRooms->pluck('room_label')->values()->all();

        return [
            'participant_id' => $participant->id,
            'type' => $participant->type,
            'member' => [
                'id' => $member->id,
                'display_no' => $member->display_no,
                'name' => $member->name,
                'name_kana' => $member->name_kana,
                'category' => $member->category ? ($member->category->group_name . ($member->category->name !== $member->category->group_name ? ' / ' . $member->category->name : '')) : null,
                'role_notes' => $member->currentRole()?->name,
            ],
            'introducer' => $participant->introducer ? [
                'id' => $participant->introducer->id,
                'name' => $participant->introducer->name,
            ] : null,
            'attendant' => $participant->attendant ? [
                'id' => $participant->attendant->id,
                'name' => $participant->attendant->name,
            ] : null,
            'breakout_room_labels' => $breakoutRoomLabels,
        ];
    }
}
