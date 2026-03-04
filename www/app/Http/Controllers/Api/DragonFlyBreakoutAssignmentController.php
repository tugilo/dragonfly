<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\DragonFly\UpsertBreakoutAssignmentRequest;
use App\Http\Requests\DragonFly\DeleteBreakoutAssignmentRequest;
use App\Services\DragonFly\BreakoutAssignmentService;
use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Http\JsonResponse;

class DragonFlyBreakoutAssignmentController extends Controller
{
    public function __construct(
        private BreakoutAssignmentService $assignmentService
    ) {}

    /**
     * 同室者（手動）を保存する.
     * PUT /api/dragonfly/meetings/{number}/breakout-assignments
     */
    public function store(UpsertBreakoutAssignmentRequest $request, int $number): JsonResponse
    {
        $meeting = Meeting::where('number', $number)->first();
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $participantId = (int) $request->input('participant_id');
        if (! Participant::where('meeting_id', $meeting->id)->where('id', $participantId)->exists()) {
            return response()->json(['message' => 'Participant not found in this meeting.'], 422);
        }
        $roommateIds = array_map('intval', $request->input('roommate_participant_ids', []));
        $validRoommateIds = Participant::where('meeting_id', $meeting->id)->whereIn('id', $roommateIds)->pluck('id')->all();
        if (count($validRoommateIds) !== count($roommateIds)) {
            return response()->json(['message' => 'All roommate_participant_ids must belong to this meeting.'], 422);
        }

        $session = (int) $request->input('session');
        $participantId = (int) $request->input('participant_id');
        $roomLabel = trim((string) $request->input('room_label'));
        $roommateIds = $validRoommateIds;

        $result = $this->assignmentService->saveAssignment(
            $meeting,
            $session,
            $participantId,
            $roomLabel,
            $roommateIds
        );

        return response()->json($result);
    }

    /**
     * 指定セッションの自分の同室記録を削除する.
     * DELETE /api/dragonfly/meetings/{number}/breakout-assignments
     */
    public function destroy(DeleteBreakoutAssignmentRequest $request, int $number): JsonResponse
    {
        $meeting = Meeting::where('number', $number)->first();
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $participantId = (int) $request->input('participant_id');
        if (! Participant::where('meeting_id', $meeting->id)->where('id', $participantId)->exists()) {
            return response()->json(['message' => 'Participant not found in this meeting.'], 422);
        }

        $session = (int) $request->input('session');
        $this->assignmentService->removeAssignment($meeting, $session, $participantId);

        return response()->json(['message' => 'Deleted.']);
    }
}
