<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\DragonFly\MeetingAttendeesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DragonFlyMeetingController extends Controller
{
    public function __construct(
        private MeetingAttendeesService $attendeesService
    ) {}

    /**
     * 指定回の参加者一覧（今日の参加者）.
     * GET /api/dragonfly/meetings/{number}/attendees
     */
    public function attendees(Request $request, int $number): JsonResponse
    {
        $result = $this->attendeesService->getAttendeesByMeetingNumber($number);
        if ($result['meeting'] === null) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }
        return response()->json($result);
    }
}
