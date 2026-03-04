<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Member;
use App\Queries\Religo\MemberSummaryQuery;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DragonFlyMemberController extends Controller
{
    public function __construct(
        private MemberSummaryQuery $summaryQuery
    ) {}

    /**
     * GET /api/dragonfly/members — 一覧（Autocomplete 等用）.
     * with_summary=1 かつ owner_member_id ありの場合、各 member に summary_lite を同梱（N+1 回避のためバッチ取得）。
     */
    public function index(Request $request): JsonResponse
    {
        $members = Member::query()
            ->select('id', 'display_no', 'name', 'name_kana', 'category')
            ->orderBy('id')
            ->get();

        $withSummary = $request->boolean('with_summary') || $request->input('with_summary') === '1';
        $ownerMemberId = $request->filled('owner_member_id') ? (int) $request->input('owner_member_id') : null;

        if ($withSummary && $ownerMemberId !== null && Member::where('id', $ownerMemberId)->exists()) {
            $workspaceId = $request->filled('workspace_id') ? (int) $request->input('workspace_id') : null;
            $targetIds = $members->pluck('id')->all();
            $batch = $this->summaryQuery->getSummaryLiteBatch($ownerMemberId, $targetIds, $workspaceId);

            $members = $members->map(function ($m) use ($batch) {
                $lite = $batch[$m->id] ?? null;
                $arr = $m->toArray();
                if ($lite !== null) {
                    $arr['summary_lite'] = [
                        'same_room_count' => $lite['same_room_count'],
                        'one_to_one_count' => $lite['one_to_one_count'],
                        'last_contact_at' => $lite['last_contact_at'],
                        'last_memo' => $lite['last_memo'],
                        'interested' => $lite['interested'],
                        'want_1on1' => $lite['want_1on1'],
                    ];
                }
                return $arr;
            });
        } else {
            $members = $members->map(fn ($m) => $m->toArray());
        }

        return response()->json($members->values()->all());
    }
}
