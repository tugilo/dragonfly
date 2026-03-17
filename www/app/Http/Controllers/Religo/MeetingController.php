<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\BreakoutRoom;
use App\Models\ContactMemo;
use App\Models\Member;
use App\Models\Meeting;
use App\Services\Religo\CandidateMemberMatchService;
use App\Services\Religo\MeetingBreakoutService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * GET /api/meetings — 一覧（Religo BO ビルダー用）. SSOT: DATA_MODEL §4.3.
 * Phase M1: breakout_count, has_memo を追加（FIT_AND_GAP_MEETINGS）。
 * GET /api/meetings/stats — 統計（Phase M6）. total_meetings, total_breakouts, meetings_with_memo, next_meeting.
 * GET /api/meetings/{meetingId} — 詳細（Phase M3: Drawer 用）. meeting・memo_body・rooms（メンバー名付き）を返す。
 */
class MeetingController extends Controller
{
    public function __construct(
        private MeetingBreakoutService $breakoutService,
        private CandidateMemberMatchService $candidateMemberMatch
    ) {}

    /**
     * GET /api/meetings — 一覧. Phase M5: q（番号/日付検索）, has_memo でフィルタ可能.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Meeting::query()
            ->withCount('breakoutRooms')
            ->addSelect([
                DB::raw("exists(select 1 from contact_memos where contact_memos.meeting_id = meetings.id and contact_memos.memo_type = 'meeting') as has_memo"),
                DB::raw("exists(select 1 from meeting_participant_imports where meeting_participant_imports.meeting_id = meetings.id) as has_participant_pdf"),
            ]);

        $q = $request->input('q');
        if (is_string($q) && trim($q) !== '') {
            $q = trim($q);
            $query->where(function ($qb) use ($q) {
                $qb->where('meetings.number', 'like', '%' . $q . '%')
                    ->orWhereRaw('DATE(meetings.held_on) LIKE ?', [$q . '%']);
            });
        }

        $hasMemo = $request->input('has_memo');
        if ($hasMemo === '1' || $hasMemo === true) {
            $query->whereRaw(
                "EXISTS (SELECT 1 FROM contact_memos WHERE contact_memos.meeting_id = meetings.id AND contact_memos.memo_type = 'meeting')"
            );
        } elseif ($hasMemo === '0' || $hasMemo === false) {
            $query->whereRaw(
                "NOT EXISTS (SELECT 1 FROM contact_memos WHERE contact_memos.meeting_id = meetings.id AND contact_memos.memo_type = 'meeting')"
            );
        }

        $hasParticipantPdf = $request->input('has_participant_pdf');
        if ($hasParticipantPdf === '1' || $hasParticipantPdf === true) {
            $query->whereRaw(
                "EXISTS (SELECT 1 FROM meeting_participant_imports WHERE meeting_participant_imports.meeting_id = meetings.id)"
            );
        } elseif ($hasParticipantPdf === '0' || $hasParticipantPdf === false) {
            $query->whereRaw(
                "NOT EXISTS (SELECT 1 FROM meeting_participant_imports WHERE meeting_participant_imports.meeting_id = meetings.id)"
            );
        }

        $meetings = $query
            ->orderByDesc('held_on')
            ->orderByDesc('id')
            ->get()
            ->map(fn (Meeting $m) => [
                'id' => $m->id,
                'number' => $m->number,
                'held_on' => $m->held_on?->format('Y-m-d'),
                'breakout_count' => (int) $m->breakout_rooms_count,
                'has_memo' => (bool) $m->has_memo,
                'has_participant_pdf' => (bool) $m->has_participant_pdf,
            ]);
        return response()->json($meetings->values()->all());
    }

    /**
     * GET /api/meetings/stats — 統計カード用. Phase M6.
     */
    public function stats(): JsonResponse
    {
        $totalMeetings = Meeting::query()->count();
        $totalBreakouts = BreakoutRoom::query()->count();
        $meetingsWithMemo = (int) DB::table('contact_memos')
            ->where('memo_type', 'meeting')
            ->whereNotNull('meeting_id')
            ->count(DB::raw('DISTINCT meeting_id'));
        $nextMeeting = Meeting::query()
            ->where('held_on', '>=', now()->toDateString())
            ->orderBy('held_on')
            ->orderBy('id')
            ->first();
        $nextMeetingPayload = $nextMeeting ? [
            'id' => $nextMeeting->id,
            'number' => $nextMeeting->number,
            'held_on' => $nextMeeting->held_on?->format('Y-m-d'),
        ] : null;

        return response()->json([
            'total_meetings' => $totalMeetings,
            'total_breakouts' => $totalBreakouts,
            'meetings_with_memo' => $meetingsWithMemo,
            'next_meeting' => $nextMeetingPayload,
        ]);
    }

    public function show(int $meetingId): JsonResponse
    {
        $meeting = Meeting::query()
            ->with('participantImport')
            ->withCount('breakoutRooms')
            ->addSelect([
                DB::raw("exists(select 1 from contact_memos where contact_memos.meeting_id = meetings.id and contact_memos.memo_type = 'meeting') as has_memo"),
            ])
            ->find($meetingId);

        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $memoBody = ContactMemo::query()
            ->where('meeting_id', $meeting->id)
            ->where('memo_type', 'meeting')
            ->orderByDesc('created_at')
            ->value('body');

        $participantImport = $meeting->participantImport;
        $candidates = null;
        $candidateCount = null;
        $matchedCount = null;
        $newCount = null;
        $totalCount = null;
        if ($participantImport && $participantImport->parse_status === 'success' && is_array($participantImport->extracted_result['candidates'] ?? null)) {
            $rawCandidates = $participantImport->extracted_result['candidates'];
            $enriched = $this->candidateMemberMatch->enrichCandidates($rawCandidates);
            $candidates = $enriched['candidates'];
            $candidateCount = count($rawCandidates);
            $matchedCount = $enriched['matched_count'];
            $newCount = $enriched['new_count'];
            $totalCount = $enriched['total_count'];
        }
        $participant_import = $participantImport ? [
            'has_pdf' => true,
            'original_filename' => $participantImport->original_filename,
            'parse_status' => $participantImport->parse_status ?? 'pending',
            'parsed_at' => $participantImport->parsed_at?->toIso8601String(),
            'candidate_count' => $candidateCount,
            'candidates' => $candidates,
            'matched_count' => $matchedCount,
            'new_count' => $newCount,
            'total_count' => $totalCount,
            'imported_at' => $participantImport->imported_at?->toIso8601String(),
            'applied_count' => $participantImport->applied_count,
        ] : ['has_pdf' => false, 'original_filename' => null, 'parse_status' => null, 'parsed_at' => null, 'candidate_count' => null, 'candidates' => null, 'matched_count' => null, 'new_count' => null, 'total_count' => null, 'imported_at' => null, 'applied_count' => null];

        $breakouts = $this->breakoutService->getBreakouts($meeting);
        $allMemberIds = [];
        foreach ($breakouts['rooms'] as $room) {
            $allMemberIds = array_merge($allMemberIds, $room['member_ids']);
        }
        $allMemberIds = array_values(array_unique($allMemberIds));
        $members = $allMemberIds === []
            ? []
            : Member::query()->whereIn('id', $allMemberIds)->get()->keyBy('id');

        $roomsWithNames = array_map(function (array $room) use ($members) {
            $memberNames = array_map(
                fn ($id) => $members->get($id)?->name ?? (string) $id,
                $room['member_ids']
            );
            return [
                'id' => $room['id'],
                'room_label' => $room['room_label'],
                'notes' => $room['notes'],
                'member_ids' => $room['member_ids'],
                'member_names' => array_values($memberNames),
            ];
        }, $breakouts['rooms']);

        return response()->json([
            'meeting' => [
                'id' => $meeting->id,
                'number' => $meeting->number,
                'held_on' => $meeting->held_on?->format('Y-m-d'),
                'breakout_count' => (int) $meeting->breakout_rooms_count,
                'has_memo' => (bool) $meeting->has_memo,
            ],
            'memo_body' => $memoBody,
            'participant_import' => $participant_import,
            'rooms' => $roomsWithNames,
        ]);
    }
}
