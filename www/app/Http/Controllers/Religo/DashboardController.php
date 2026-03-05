<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\Member;
use App\Models\User;
use App\Services\Religo\DashboardService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET /api/dashboard/stats, tasks, activity. SSOT: DASHBOARD_REQUIREMENTS.md §5.
 * owner: query > user.owner_member_id > 422（E-4）.
 */
class DashboardController extends Controller
{
    private const ME_USER_ID = 1;

    public function __construct(
        private DashboardService $dashboardService
    ) {}

    private function resolveOwnerMemberId(Request $request): int|false
    {
        if ($request->filled('owner_member_id')) {
            return (int) $request->input('owner_member_id');
        }
        $user = User::find(self::ME_USER_ID);
        if ($user && $user->owner_member_id !== null) {
            return (int) $user->owner_member_id;
        }
        return false;
    }

    /**
     * GET /api/dashboard/stats — 未接触件数・今月1to1・紹介メモ・例会メモ.
     */
    public function stats(Request $request): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return response()->json(['message' => 'オーナーが未設定です。ダッシュボード上でオーナーを選択してください。'], 422);
        }
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
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return response()->json(['message' => 'オーナーが未設定です。ダッシュボード上でオーナーを選択してください。'], 422);
        }
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
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return response()->json(['message' => 'オーナーが未設定です。ダッシュボード上でオーナーを選択してください。'], 422);
        }
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
