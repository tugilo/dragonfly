<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\DragonFly\UpsertBreakoutMemoRequest;
use App\Models\BreakoutMemo;
use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DragonFlyBreakoutMemoController extends Controller
{
    /**
     * 指定 meeting で指定 participant が書いたメモ一覧.
     * GET /api/dragonfly/meetings/{number}/breakout-memos?participant_id={id}
     */
    public function index(Request $request, int $number): JsonResponse
    {
        $meeting = Meeting::where('number', $number)->first();
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }
        $participantId = $request->query('participant_id');
        if ($participantId === null || $participantId === '') {
            return response()->json(['message' => 'participant_id is required.'], 422);
        }
        $participantId = (int) $participantId;
        $memos = BreakoutMemo::where('meeting_id', $meeting->id)
            ->where('participant_id', $participantId)
            ->with(['targetParticipant.member', 'breakoutRoom'])
            ->orderBy('id')
            ->get()
            ->map(fn (BreakoutMemo $m) => [
                'id' => $m->id,
                'participant_id' => $m->participant_id,
                'target_participant_id' => $m->target_participant_id,
                'target_member' => $m->targetParticipant?->member ? [
                    'id' => $m->targetParticipant->member->id,
                    'display_no' => $m->targetParticipant->member->display_no,
                    'name' => $m->targetParticipant->member->name,
                ] : null,
                'breakout_room_id' => $m->breakout_room_id,
                'body' => $m->body,
                'created_at' => $m->created_at?->toIso8601String(),
                'updated_at' => $m->updated_at?->toIso8601String(),
            ]);
        return response()->json(['data' => $memos]);
    }

    /**
     * メモの upsert.
     * PUT /api/dragonfly/meetings/{number}/breakout-memos
     */
    public function upsert(UpsertBreakoutMemoRequest $request, int $number): JsonResponse
    {
        $meeting = Meeting::where('number', $number)->first();
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }
        $participantId = (int) $request->input('participant_id');
        $targetParticipantId = (int) $request->input('target_participant_id');
        $body = $request->input('body');
        $breakoutRoomId = $request->input('breakout_room_id');

        if ($breakoutRoomId === null && $participantId) {
            $participant = Participant::where('meeting_id', $meeting->id)
                ->where('id', $participantId)
                ->with('breakoutRooms')
                ->first();
            if ($participant && $participant->breakoutRooms->isNotEmpty()) {
                $breakoutRoomId = $participant->breakoutRooms->first()?->id;
            }
        }

        $memo = BreakoutMemo::updateOrCreate(
            [
                'meeting_id' => $meeting->id,
                'participant_id' => $participantId,
                'target_participant_id' => $targetParticipantId,
            ],
            [
                'breakout_room_id' => $breakoutRoomId,
                'body' => $body,
            ]
        );

        return response()->json([
            'data' => [
                'id' => $memo->id,
                'meeting_id' => $memo->meeting_id,
                'participant_id' => $memo->participant_id,
                'target_participant_id' => $memo->target_participant_id,
                'breakout_room_id' => $memo->breakout_room_id,
                'body' => $memo->body,
                'created_at' => $memo->created_at?->toIso8601String(),
                'updated_at' => $memo->updated_at?->toIso8601String(),
            ],
        ]);
    }

    /**
     * 指定 participant の同室者一覧（自分以外）.
     * GET /api/dragonfly/meetings/{number}/breakout-roommates/{participant_id}
     */
    public function roommates(Request $request, int $number, int $participantId): JsonResponse
    {
        $meeting = Meeting::where('number', $number)->first();
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }
        $participant = Participant::where('meeting_id', $meeting->id)
            ->where('id', $participantId)
            ->with('breakoutRooms.participants.member')
            ->first();
        if (! $participant) {
            return response()->json(['message' => 'Participant not found.'], 404);
        }
        $roommateParticipantIds = collect();
        foreach ($participant->breakoutRooms as $room) {
            foreach ($room->participants as $p) {
                if ((int) $p->id !== (int) $participantId) {
                    $roommateParticipantIds->push($p);
                }
            }
        }
        $roommateParticipantIds = $roommateParticipantIds->unique('id')->values();
        $data = $roommateParticipantIds->map(fn (Participant $p) => [
            'participant_id' => $p->id,
            'member' => $p->member ? [
                'id' => $p->member->id,
                'display_no' => $p->member->display_no,
                'name' => $p->member->name,
                'name_kana' => $p->member->name_kana,
                'category' => $p->member->category,
            ] : null,
        ])->values()->all();
        return response()->json(['data' => $data]);
    }
}
