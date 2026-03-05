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
            ->with('category')
            ->with('memberRoles.role')
            ->select('id', 'display_no', 'name', 'name_kana', 'category_id')
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
                $arr['category'] = $m->category ? [
                    'id' => $m->category->id,
                    'group_name' => $m->category->group_name,
                    'name' => $m->category->name,
                ] : null;
                $arr['current_role'] = $m->currentRole()?->name;
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
            $members = $members->map(function ($m) {
                $arr = $m->toArray();
                $arr['category'] = $m->category ? [
                    'id' => $m->category->id,
                    'group_name' => $m->category->group_name,
                    'name' => $m->category->name,
                ] : null;
                $arr['current_role'] = $m->currentRole()?->name;
                return $arr;
            });
        }

        return response()->json($members->values()->all());
    }

    /**
     * GET /api/dragonfly/members/{id} — 1件取得（編集用）.
     */
    public function show(int $id): JsonResponse
    {
        $member = Member::with('category', 'memberRoles.role')->find($id);
        if (! $member) {
            return response()->json(['message' => 'Member not found.'], 404);
        }
        $arr = $member->toArray();
        $arr['category'] = $member->category ? [
            'id' => $member->category->id,
            'group_name' => $member->category->group_name,
            'name' => $member->category->name,
        ] : null;
        $arr['current_role'] = $member->currentRole()?->name;
        $arr['current_role_id'] = $member->currentRole()?->id;
        $arr['role_id'] = $member->currentRole()?->id;

        return response()->json($arr);
    }

    /**
     * PUT /api/dragonfly/members/{id} — 更新（category_id, 現在役職を member_roles で更新）.
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $member = Member::find($id);
        if (! $member) {
            return response()->json(['message' => 'Member not found.'], 404);
        }
        $categoryId = $request->input('category_id');
        if (array_key_exists('category_id', $request->all())) {
            $member->category_id = $categoryId ? (int) $categoryId : null;
        }
        $member->fill($request->only(['name', 'name_kana', 'type', 'display_no', 'introducer_member_id', 'attendant_member_id']));
        $member->save();

        if (array_key_exists('role_id', $request->all())) {
            $today = now()->toDateString();
            $member->memberRoles()->whereNull('term_end')->update(['term_end' => $today]);
            $roleId = $request->input('role_id');
            if ($roleId) {
                $member->memberRoles()->create([
                    'role_id' => (int) $roleId,
                    'term_start' => $today,
                    'term_end' => null,
                ]);
            }
        }

        $member->load('category', 'memberRoles.role');
        $arr = $member->toArray();
        $arr['category'] = $member->category ? [
            'id' => $member->category->id,
            'group_name' => $member->category->group_name,
            'name' => $member->category->name,
        ] : null;
        $arr['current_role'] = $member->currentRole()?->name;
        $arr['current_role_id'] = $member->currentRole()?->id;
        $arr['role_id'] = $member->currentRole()?->id;

        return response()->json($arr);
    }
}
