<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\IndexDragonFlyMemberOneToOneStatusRequest;
use App\Http\Requests\Api\IndexDragonFlyMembersRequest;
use App\Models\Member;
use App\Queries\Religo\MemberSummaryQuery;
use App\Support\MemberWorkspaceAttributes;
use App\Services\Religo\MemberOneToOneLeadService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DragonFlyMemberController extends Controller
{
    public function __construct(
        private MemberSummaryQuery $summaryQuery
    ) {}

    /**
     * GET /api/dragonfly/members/one-to-one-status — P5 リード一覧（{id} より上にルート定義すること）.
     */
    public function oneToOneStatus(
        IndexDragonFlyMemberOneToOneStatusRequest $request,
        MemberOneToOneLeadService $leadService
    ): JsonResponse {
        $owner = (int) $request->validated()['owner_member_id'];

        return response()->json($leadService->indexForOwner($owner));
    }

    /**
     * GET /api/dragonfly/members — 一覧（Autocomplete 等用）.
     * with_summary=1 かつ owner_member_id ありの場合、各 member に summary_lite を同梱（N+1 回避のためバッチ取得）。
     * M-3c: q, category_id, group_name, role_id, interested, want_1on1, sort, order で検索・フィルタ・ソート対応。
     * meeting_id: 当該例会の参加者に限定（participants.type が absent の行は除外）。各要素に participant_type / bo_assignable（proxy は false）を付与。SPEC-007。
     */
    public function index(IndexDragonFlyMembersRequest $request): JsonResponse
    {
        $meetingScopeId = $request->filled('meeting_id') ? (int) $request->validated()['meeting_id'] : null;

        $query = Member::query()
            ->with(['category', 'memberRoles.role', 'workspace.region.country'])
            ->select('id', 'display_no', 'name', 'name_kana', 'category_id', 'ncast_profile_url', 'workspace_id');

        if ($meetingScopeId !== null) {
            $query->whereHas('participants', function ($q) use ($meetingScopeId) {
                $q->where('meeting_id', $meetingScopeId)
                    ->where('type', '!=', 'absent');
            });
            $query->with(['participants' => function ($q) use ($meetingScopeId) {
                $q->where('meeting_id', $meetingScopeId)
                    ->where('type', '!=', 'absent');
            }]);
        }

        if ($request->filled('q')) {
            $q = '%' . addcslashes($request->input('q'), '%_\\') . '%';
            $query->where(function ($qb) use ($q) {
                $qb->where('name', 'like', $q)
                    ->orWhere('name_kana', 'like', $q)
                    ->orWhere('display_no', 'like', $q);
            });
        }

        if ($request->filled('category_id')) {
            $query->where('category_id', (int) $request->input('category_id'));
        }

        if ($request->filled('group_name')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('group_name', $request->input('group_name'));
            });
        }

        if ($request->filled('role_id')) {
            $roleId = (int) $request->input('role_id');
            $query->whereHas('memberRoles', function ($q) use ($roleId) {
                $q->whereNull('term_end')->where('role_id', $roleId);
            });
        }

        $ownerMemberId = $request->filled('owner_member_id') ? (int) $request->input('owner_member_id') : null;
        if ($ownerMemberId !== null) {
            if ($request->boolean('interested')) {
                $query->whereExists(function ($q) use ($ownerMemberId) {
                    $q->select(DB::raw(1))
                        ->from('dragonfly_contact_flags')
                        ->whereColumn('dragonfly_contact_flags.target_member_id', 'members.id')
                        ->where('dragonfly_contact_flags.owner_member_id', $ownerMemberId)
                        ->where('dragonfly_contact_flags.interested', true);
                });
            }
            if ($request->boolean('want_1on1')) {
                $query->whereExists(function ($q) use ($ownerMemberId) {
                    $q->select(DB::raw(1))
                        ->from('dragonfly_contact_flags')
                        ->whereColumn('dragonfly_contact_flags.target_member_id', 'members.id')
                        ->where('dragonfly_contact_flags.owner_member_id', $ownerMemberId)
                        ->where('dragonfly_contact_flags.want_1on1', true);
                });
            }
        }

        $sort = $request->input('sort', 'id');
        $order = strtolower((string) $request->input('order', 'asc')) === 'desc' ? 'desc' : 'asc';
        if (! in_array($sort, IndexDragonFlyMembersRequest::SORT_FIELDS, true)) {
            $sort = 'id';
        }
        if ($sort === 'display_no') {
            $query->orderByDisplayNoNumeric($order);
        } else {
            $query->orderBy($sort, $order);
        }

        $members = $query->get();

        $withSummary = $request->boolean('with_summary') || $request->input('with_summary') === '1';

        if ($withSummary && $ownerMemberId !== null && Member::where('id', $ownerMemberId)->exists()) {
            $workspaceId = $request->filled('workspace_id') ? (int) $request->input('workspace_id') : null;
            $targetIds = $members->pluck('id')->all();
            $batch = $this->summaryQuery->getSummaryLiteBatch($ownerMemberId, $targetIds, $workspaceId);

            $members = $members->map(function ($m) use ($batch, $meetingScopeId) {
                $lite = $batch[$m->id] ?? null;
                $arr = $m->toArray();
                unset($arr['workspace']);
                unset($arr['participants']);
                $arr = array_merge($arr, MemberWorkspaceAttributes::flatForMember($m));
                $arr['category'] = $m->category ? [
                    'id' => $m->category->id,
                    'group_name' => $m->category->group_name,
                    'name' => $m->category->name,
                ] : null;
                $arr['current_role'] = $m->currentRole()?->name;
                if ($meetingScopeId !== null) {
                    $p = $m->participants->first();
                    $arr['participant_type'] = $p?->type;
                    $arr['bo_assignable'] = $p !== null && $p->type !== 'proxy';
                }
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
            $members = $members->map(function ($m) use ($meetingScopeId) {
                $arr = $m->toArray();
                unset($arr['workspace']);
                unset($arr['participants']);
                $arr = array_merge($arr, MemberWorkspaceAttributes::flatForMember($m));
                $arr['category'] = $m->category ? [
                    'id' => $m->category->id,
                    'group_name' => $m->category->group_name,
                    'name' => $m->category->name,
                ] : null;
                $arr['current_role'] = $m->currentRole()?->name;
                if ($meetingScopeId !== null) {
                    $p = $m->participants->first();
                    $arr['participant_type'] = $p?->type;
                    $arr['bo_assignable'] = $p !== null && $p->type !== 'proxy';
                }
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
        $member = Member::with('category', 'memberRoles.role', 'workspace.region.country')->find($id);
        if (! $member) {
            return response()->json(['message' => 'Member not found.'], 404);
        }
        $arr = $member->toArray();
        unset($arr['workspace']);
        $arr = array_merge($arr, MemberWorkspaceAttributes::flatForMember($member));
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
        if ($request->exists('ncast_profile_url')) {
            $request->validate([
                'ncast_profile_url' => ['nullable', 'string', 'max:2048'],
            ]);
            $url = $request->input('ncast_profile_url');
            $member->ncast_profile_url = ($url !== null && $url !== '') ? $url : null;
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

        $member->load('category', 'memberRoles.role', 'workspace.region.country');
        $arr = $member->toArray();
        unset($arr['workspace']);
        $arr = array_merge($arr, MemberWorkspaceAttributes::flatForMember($member));
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
