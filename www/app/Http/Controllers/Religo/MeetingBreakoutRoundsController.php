<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\UpdateMeetingBreakoutRoundsRequest;
use App\Models\Meeting;
use App\Services\Religo\BoAssignmentAuditLogWriter;
use App\Services\Religo\MeetingBreakoutRoundsService;
use Illuminate\Http\JsonResponse;

/**
 * GET/PUT /api/meetings/{meetingId}/breakout-rounds — Phase10R Round 可変. SSOT: PHASE10R PLAN.
 */
class MeetingBreakoutRoundsController extends Controller
{
    public function __construct(
        private MeetingBreakoutRoundsService $roundsService
    ) {}

    public function show(int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }
        return response()->json($this->roundsService->getBreakoutRounds($meeting));
    }

    public function update(UpdateMeetingBreakoutRoundsRequest $request, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }
        $roundsPayload = $request->validated()['rounds'];
        try {
            $this->roundsService->updateBreakoutRounds($meeting, $roundsPayload);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['message' => $e->getMessage(), 'errors' => $e->errors()], 422);
        }
        BoAssignmentAuditLogWriter::logFromBreakoutRoundsPayload($meeting, $roundsPayload);
        return response()->json($this->roundsService->getBreakoutRounds($meeting));
    }
}
