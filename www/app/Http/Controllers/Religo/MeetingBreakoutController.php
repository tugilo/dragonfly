<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\UpdateMeetingBreakoutsRequest;
use App\Models\Meeting;
use App\Services\Religo\BoAssignmentAuditLogWriter;
use App\Services\Religo\MeetingBreakoutService;
use Illuminate\Http\JsonResponse;

/**
 * GET/PUT /api/meetings/{meetingId}/breakouts — Religo BO1/BO2 割当取得・保存. SSOT: DATA_MODEL §4.5, §4.6.
 */
class MeetingBreakoutController extends Controller
{
    public function __construct(
        private MeetingBreakoutService $breakoutService
    ) {}

    public function show(int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }
        return response()->json($this->breakoutService->getBreakouts($meeting));
    }

    public function update(UpdateMeetingBreakoutsRequest $request, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }
        $roomsPayload = $request->validated()['rooms'];
        try {
            $this->breakoutService->updateBreakouts($meeting, $roomsPayload);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['message' => $e->getMessage(), 'errors' => $e->errors()], 422);
        }
        BoAssignmentAuditLogWriter::logFromBreakoutsPayload($meeting, $roomsPayload);
        return response()->json($this->breakoutService->getBreakouts($meeting));
    }
}
