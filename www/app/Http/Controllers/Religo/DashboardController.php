<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\Member;
use App\Services\Religo\DashboardService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET /api/dashboard/stats, tasks, activity. SSOT: DASHBOARD_REQUIREMENTS.md §5.
 */
class DashboardController extends Controller
{
    public function __construct(
        private DashboardService $dashboardService
    ) {}

    /**
     * GET /api/dashboard/stats — 未接触件数・今月1to1・紹介メモ・例会メモ.
     */
    public function stats(Request $request): JsonResponse
    {
        $ownerMemberId = (int) ($request->input('owner_member_id') ?? 1);
        if (! Member::where('id', $ownerMemberId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }
        $data = $this->dashboardService->getStats($ownerMemberId);
        return response()->json($data);
    }

    /**
     * GET /api/dashboard/tasks — 今日やることリスト.
     */
    public function tasks(Request $request): JsonResponse
    {
        $ownerMemberId = (int) ($request->input('owner_member_id') ?? 1);
        if (! Member::where('id', $ownerMemberId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }
        $data = $this->dashboardService->getTasks($ownerMemberId);
        return response()->json($data);
    }

    /**
     * GET /api/dashboard/activity — 最近の活動（時系列）.
     */
    public function activity(Request $request): JsonResponse
    {
        $ownerMemberId = (int) ($request->input('owner_member_id') ?? 1);
        if (! Member::where('id', $ownerMemberId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }
        $limit = (int) ($request->input('limit') ?? 6);
        if ($limit < 1 || $limit > 50) {
            $limit = 6;
        }
        $data = $this->dashboardService->getActivity($ownerMemberId, $limit);
        return response()->json($data);
    }
}
