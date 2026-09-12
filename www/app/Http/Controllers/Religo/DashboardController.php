<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Religo\Concerns\ResolvesReligoOwner;
use App\Models\Member;
use App\Services\Religo\DashboardService;
use App\Services\Religo\WeeklyPresentationPatternService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET /api/dashboard/stats, tasks, activity, weekly-presentation. SSOT: DASHBOARD_REQUIREMENTS.md §5, SPEC-004.
 * owner: acting user の owner_member_id を正（chapter_admin のみ query 指定可）。未設定は 422（E-4 / BO-AUDIT-P4 / SPEC-020 §4.5）.
 */
class DashboardController extends Controller
{
    use ResolvesReligoOwner;

    public function __construct(
        private DashboardService $dashboardService,
        private WeeklyPresentationPatternService $weeklyPresentationPatternService
    ) {}

    /**
     * GET /api/dashboard/stats — 未接触件数・今月1to1・リファーラル件数（紹介メモ集計）・例会メモ.
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
        $limit = max(1, min(50, $limit));
        $data = $this->dashboardService->getActivity($ownerMemberId, $limit);
        return response()->json($data);
    }

    /**
     * GET /api/dashboard/weekly-presentation — Owner メンバーのプレゼン原稿（TEXT）.
     */
    public function weeklyPresentation(Request $request): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return response()->json(['message' => 'オーナーが未設定です。ダッシュボード上でオーナーを選択してください。'], 422);
        }
        $member = Member::query()->find($ownerMemberId);
        if (! $member) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }
        return response()->json([
            ...$this->weeklyPresentationPatternService->payload($member),
            'start_dash_presentation_body' => $this->normalizePresentationBody($member->start_dash_presentation_body),
        ]);
    }

    /**
     * POST /api/dashboard/weekly-presentation/select — 表示する稿を切り替える。利用日は書かない。
     */
    public function selectWeeklyPresentation(Request $request): JsonResponse
    {
        return $this->respondWeeklyMutation($request, function (Member $member, string $patternId) {
            return $this->weeklyPresentationPatternService->select($member, $patternId);
        });
    }

    /**
     * POST /api/dashboard/weekly-presentation/use — 例会で使ったあと、その週の利用を残す。
     */
    public function recordWeeklyPresentationUsage(Request $request): JsonResponse
    {
        return $this->respondWeeklyMutation($request, function (Member $member, string $patternId) {
            return $this->weeklyPresentationPatternService->recordUsage($member, $patternId);
        });
    }

    /**
     * @param  callable(Member, string): array  $mutate
     */
    private function respondWeeklyMutation(Request $request, callable $mutate): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return response()->json(['message' => 'オーナーが未設定です。ダッシュボード上でオーナーを選択してください。'], 422);
        }
        $member = Member::query()->find($ownerMemberId);
        if (! $member) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }

        $validated = $request->validate([
            'pattern_id' => ['required', 'string', 'max:32'],
        ]);

        $payload = $mutate($member, $validated['pattern_id']);

        return response()->json([
            ...$payload,
            'start_dash_presentation_body' => $this->normalizePresentationBody($member->fresh()?->start_dash_presentation_body),
        ]);
    }

    private function normalizePresentationBody(?string $body): ?string
    {
        return ($body === null || $body === '') ? null : $body;
    }
}
