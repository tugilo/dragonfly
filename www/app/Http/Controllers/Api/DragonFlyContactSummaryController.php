<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Religo\Concerns\ResolvesReligoOwner;
use App\Http\Requests\DragonFly\GetContactSummaryRequest;
use App\Models\Member;
use App\Services\DragonFly\ContactSummaryService;
use Illuminate\Http\JsonResponse;

class DragonFlyContactSummaryController extends Controller
{
    use ResolvesReligoOwner;

    public function __construct(
        private ContactSummaryService $contactSummaryService
    ) {}

    /**
     * GET /api/dragonfly/contacts/{target_member_id}/summary — 人物カード用サマリ（owner は acting user 固定・SPEC-020 §4.5）.
     */
    public function __invoke(GetContactSummaryRequest $request, int $target_member_id): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return response()->json(['message' => 'owner_member_id is required.'], 400);
        }
        $targetMemberId = (int) $target_member_id;

        if (! Member::where('id', $ownerMemberId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }
        if (! Member::where('id', $targetMemberId)->exists()) {
            return response()->json(['message' => 'Target member not found.'], 404);
        }

        $limitMemos = (int) ($request->input('limit_memos') ?? 3);
        if ($limitMemos < 1 || $limitMemos > 10) {
            $limitMemos = 3;
        }
        $meetingNumber = $request->input('meeting_number') !== null ? (int) $request->input('meeting_number') : null;

        $summary = $this->contactSummaryService->getSummary(
            $ownerMemberId,
            $targetMemberId,
            $limitMemos,
            $meetingNumber
        );

        return response()->json($summary);
    }
}
