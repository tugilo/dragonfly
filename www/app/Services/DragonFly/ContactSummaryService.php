<?php

namespace App\Services\DragonFly;

use App\Models\BreakoutMemo;
use App\Models\DragonflyContactEvent;
use App\Models\DragonflyContactFlag;
use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class ContactSummaryService
{
    /**
     * 人物カード用サマリを取得する.
     *
     * @return array<string, mixed>
     */
    public function getSummary(
        int $ownerMemberId,
        int $targetMemberId,
        int $limitMemos = 3,
        ?int $meetingNumber = null
    ): array {
        $flags = $this->getFlags($ownerMemberId, $targetMemberId);
        $sameRoom = $this->getSameRoomSummary($ownerMemberId, $targetMemberId, $meetingNumber);
        $latestMemos = $this->getLatestMemos($ownerMemberId, $targetMemberId, $limitMemos);
        $latestInterestedReason = $this->getLatestReason($ownerMemberId, $targetMemberId, 'interested_on');
        $latest1on1Reason = $this->getLatestReason($ownerMemberId, $targetMemberId, 'want_1on1_on');
        $oneOnOne = $this->getOneOnOneSummary($ownerMemberId, $targetMemberId);

        return [
            'owner_member_id' => $ownerMemberId,
            'target_member_id' => $targetMemberId,
            'flags' => $flags,
            'same_room_count' => $sameRoom['count'],
            'last_same_room_meeting' => $sameRoom['last_meeting'],
            'latest_memos' => $latestMemos,
            'latest_interested_reason' => $latestInterestedReason,
            'latest_1on1_reason' => $latest1on1Reason,
            'one_on_one_count' => $oneOnOne['count'],
            'last_one_on_one_at' => $oneOnOne['last_at'],
            'next_one_on_one_at' => $oneOnOne['next_at'],
        ];
    }

    /**
     * contact_flags を取得。無ければデフォルト.
     *
     * @return array{interested: bool, want_1on1: bool, extra_status: array|null}
     */
    private function getFlags(int $ownerMemberId, int $targetMemberId): array
    {
        $flag = DragonflyContactFlag::where('owner_member_id', $ownerMemberId)
            ->where('target_member_id', $targetMemberId)
            ->first();

        return [
            'interested' => $flag ? $flag->interested : false,
            'want_1on1' => $flag ? $flag->want_1on1 : false,
            'extra_status' => $flag?->extra_status,
        ];
    }

    /**
     * 同室回数と最終同室 meeting.
     *
     * @return array{count: int, last_meeting: array|null}
     */
    private function getSameRoomSummary(int $ownerMemberId, int $targetMemberId, ?int $meetingNumber): array
    {
        $query = DB::table('participant_breakout as pbo')
            ->join('participants as po', 'po.id', '=', 'pbo.participant_id')
            ->join('breakout_rooms as br', 'br.id', '=', 'pbo.breakout_room_id')
            ->join('participant_breakout as pbt', 'pbt.breakout_room_id', '=', 'br.id')
            ->join('participants as pt', 'pt.id', '=', 'pbt.participant_id')
            ->where('po.member_id', $ownerMemberId)
            ->where('pt.member_id', $targetMemberId)
            ->whereColumn('pbo.participant_id', '!=', 'pbt.participant_id')
            ->select('br.meeting_id');

        if ($meetingNumber !== null) {
            $query->join('meetings as m', 'm.id', '=', 'br.meeting_id')
                ->where('m.number', '<=', $meetingNumber);
        }

        $meetingIds = $query->distinct()->pluck('meeting_id');

        if ($meetingIds->isEmpty()) {
            return ['count' => 0, 'last_meeting' => null];
        }

        $lastMeeting = Meeting::whereIn('id', $meetingIds)->orderByDesc('held_on')->first();
        $lastMeetingArray = $lastMeeting ? [
            'id' => $lastMeeting->id,
            'number' => $lastMeeting->number,
            'held_on' => $lastMeeting->held_on->format('Y-m-d'),
            'name' => $lastMeeting->name,
        ] : null;

        return [
            'count' => $meetingIds->count(),
            'last_meeting' => $lastMeetingArray,
        ];
    }

    /**
     * owner が target に書いたメモの直近 N 件（meeting 跨ぎ）.
     *
     * @return array<int, array{id: int, meeting_id: int, meeting_number: int, body: string|null, updated_at: string, breakout_room_label: string|null}>
     */
    private function getLatestMemos(int $ownerMemberId, int $targetMemberId, int $limit): array
    {
        $ownerParticipantIds = Participant::where('member_id', $ownerMemberId)->pluck('id');
        $targetParticipantIds = Participant::where('member_id', $targetMemberId)->pluck('id');

        if ($ownerParticipantIds->isEmpty() || $targetParticipantIds->isEmpty()) {
            return [];
        }

        $memos = BreakoutMemo::query()
            ->whereIn('participant_id', $ownerParticipantIds)
            ->whereIn('target_participant_id', $targetParticipantIds)
            ->with(['meeting', 'breakoutRoom'])
            ->orderByDesc('updated_at')
            ->limit($limit)
            ->get();

        return $memos->map(function (BreakoutMemo $m) {
            return [
                'id' => $m->id,
                'meeting_id' => $m->meeting_id,
                'meeting_number' => $m->meeting?->number ?? 0,
                'body' => $m->body,
                'updated_at' => $m->updated_at?->toIso8601String() ?? '',
                'breakout_room_label' => $m->breakoutRoom?->room_label,
            ];
        })->values()->all();
    }

    /**
     * contact_events の最新理由 1 件（event_type 指定）.
     *
     * @return array{reason: string|null, meeting_id: int|null, meeting_number: int|null, created_at: string}|null
     */
    private function getLatestReason(int $ownerMemberId, int $targetMemberId, string $eventType): ?array
    {
        $event = DragonflyContactEvent::where('owner_member_id', $ownerMemberId)
            ->where('target_member_id', $targetMemberId)
            ->where('event_type', $eventType)
            ->orderByDesc('created_at')
            ->first();

        if (! $event) {
            return null;
        }

        $meeting = $event->meeting_id ? Meeting::find($event->meeting_id) : null;

        return [
            'reason' => $event->reason,
            'meeting_id' => $event->meeting_id,
            'meeting_number' => $meeting?->number,
            'created_at' => $event->created_at ? \Carbon\Carbon::parse($event->created_at)->format('c') : '',
        ];
    }

    /**
     * one_on_one_sessions が存在すれば集計、無ければ 0 / null.
     *
     * @return array{count: int, last_at: string|null, next_at: string|null}
     */
    private function getOneOnOneSummary(int $ownerMemberId, int $targetMemberId): array
    {
        if (! Schema::hasTable('dragonfly_one_on_one_sessions')) {
            return [
                'count' => 0,
                'last_at' => null,
                'next_at' => null,
            ];
        }

        $base = DB::table('dragonfly_one_on_one_sessions')
            ->where('owner_member_id', $ownerMemberId)
            ->where('target_member_id', $targetMemberId);

        $count = (clone $base)->where('status', 'done')->count();

        $lastDone = (clone $base)->where('status', 'done')->orderByDesc('held_at')->first();
        $lastAt = $lastDone && $lastDone->held_at
            ? (new \DateTime($lastDone->held_at))->format('c')
            : null;

        $nextPlanned = (clone $base)->where('status', 'planned')->whereNotNull('held_at')->orderBy('held_at')->first();
        $nextAt = $nextPlanned && $nextPlanned->held_at
            ? (new \DateTime($nextPlanned->held_at))->format('c')
            : null;

        return [
            'count' => $count,
            'last_at' => $lastAt,
            'next_at' => $nextAt,
        ];
    }
}
