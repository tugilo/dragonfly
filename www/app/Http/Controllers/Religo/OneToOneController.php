<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\IndexOneToOnesRequest;
use App\Http\Requests\Religo\OneToOneStatsRequest;
use App\Http\Requests\Religo\StoreOneToOneMemoRequest;
use App\Http\Requests\Religo\StoreOneToOneRequest;
use App\Http\Requests\Religo\UpdateOneToOneRequest;
use App\Models\ContactMemo;
use App\Models\OneToOne;
use App\Services\Religo\OneToOneIndexService;
use App\Services\Religo\OneToOneService;
use App\Services\Religo\OneToOneStatsService;
use Illuminate\Http\JsonResponse;

class OneToOneController extends Controller
{
    public function __construct(
        private OneToOneService $oneToOneService,
        private OneToOneIndexService $indexService,
        private OneToOneStatsService $statsService
    ) {}

    /**
     * GET /api/one-to-ones — 一覧. SSOT: PHASE11B PLAN.
     */
    public function index(IndexOneToOnesRequest $request): JsonResponse
    {
        $filters = $request->validated();
        $data = $this->indexService->getIndex($filters);
        return response()->json($data);
    }

    /**
     * GET /api/one-to-ones/stats — 一覧と同一 filter で集計（ONETOONES-P4）。
     */
    public function stats(OneToOneStatsRequest $request): JsonResponse
    {
        $payload = $this->statsService->getStats($request->validated());

        return response()->json($payload);
    }

    /**
     * POST /api/one-to-ones — 1 to 1 登録. SSOT: DATA_MODEL §4.9.
     */
    public function store(StoreOneToOneRequest $request): JsonResponse
    {
        $data = $request->validated();
        $o2o = $this->oneToOneService->store($data);
        $o2o->load(['ownerMember:id,name', 'targetMember:id,name', 'meeting:id,number,held_on']);

        return response()->json($this->indexService->formatRecord($o2o), 201);
    }

    /**
     * GET /api/one-to-ones/{id} — 1 件取得（管理画面編集用）。
     */
    public function show(OneToOne $oneToOne): JsonResponse
    {
        return response()->json($this->indexService->formatRecord($oneToOne));
    }

    /**
     * PATCH /api/one-to-ones/{id} — 更新（管理画面編集用）。
     */
    public function update(UpdateOneToOneRequest $request, OneToOne $oneToOne): JsonResponse
    {
        $data = $request->validated();
        $o2o = $this->oneToOneService->update($oneToOne, $data);

        return response()->json($this->indexService->formatRecord($o2o));
    }

    /**
     * GET /api/one-to-ones/{id}/memos — 当該 1to1 に紐づく contact_memos（時系列 Desc）。
     */
    public function memosIndex(OneToOne $oneToOne): JsonResponse
    {
        $items = ContactMemo::query()
            ->where('one_to_one_id', $oneToOne->id)
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->get();

        $data = $items->map(fn (ContactMemo $m) => [
            'id' => $m->id,
            'body' => $m->body,
            'memo_type' => $m->memo_type,
            'created_at' => $m->created_at?->toIso8601String(),
            'updated_at' => $m->updated_at?->toIso8601String(),
        ])->values()->all();

        return response()->json($data);
    }

    /**
     * POST /api/one-to-ones/{id}/memos — 履歴メモ追加（memo_type = one_to_one、owner/target は 1to1 から複製）。
     */
    public function memosStore(StoreOneToOneMemoRequest $request, OneToOne $oneToOne): JsonResponse
    {
        $body = $request->validated()['body'];
        $memo = new ContactMemo([
            'owner_member_id' => $oneToOne->owner_member_id,
            'target_member_id' => $oneToOne->target_member_id,
            'workspace_id' => $oneToOne->workspace_id,
            'memo_type' => 'one_to_one',
            'body' => $body,
            'one_to_one_id' => $oneToOne->id,
            'meeting_id' => null,
        ]);
        $memo->save();

        return response()->json([
            'id' => $memo->id,
            'body' => $memo->body,
            'memo_type' => $memo->memo_type,
            'created_at' => $memo->created_at?->toIso8601String(),
            'updated_at' => $memo->updated_at?->toIso8601String(),
        ], 201);
    }
}
