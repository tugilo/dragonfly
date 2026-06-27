<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Religo\Concerns\ResolvesReligoOwner;
use App\Http\Requests\Religo\CancelOneToOneRequest;
use App\Http\Requests\Religo\IndexOneToOnesRequest;
use App\Http\Requests\Religo\OneToOneStatsRequest;
use App\Http\Requests\Religo\StoreOneToOneMemoRequest;
use App\Http\Requests\Religo\StoreOneToOneRequest;
use App\Http\Requests\Religo\UpdateOneToOneRequest;
use App\Models\ContactMemo;
use App\Models\OneToOne;
use App\Services\Religo\OneToOneIndexService;
use App\Services\Religo\OneToOneSeriesMarkdownService;
use App\Services\Religo\OneToOneService;
use App\Services\Religo\OneToOneStatsService;
use Illuminate\Http\JsonResponse;

class OneToOneController extends Controller
{
    use ResolvesReligoOwner;

    public function __construct(
        private OneToOneService $oneToOneService,
        private OneToOneIndexService $indexService,
        private OneToOneStatsService $statsService,
        private OneToOneSeriesMarkdownService $seriesMarkdownService,
    ) {}

    /**
     * GET /api/one-to-ones — 一覧. SSOT: PHASE11B PLAN.
     */
    public function index(IndexOneToOnesRequest $request): JsonResponse
    {
        $filters = $this->scopeFiltersToOwner($request, $request->validated());
        if ($filters instanceof JsonResponse) {
            return $filters;
        }
        $data = $this->indexService->getIndex($filters);
        return response()->json($data);
    }

    /**
     * GET /api/one-to-ones/stats — 一覧と同一 filter で集計（ONETOONES-P4）。
     */
    public function stats(OneToOneStatsRequest $request): JsonResponse
    {
        $filters = $this->scopeFiltersToOwner($request, $request->validated());
        if ($filters instanceof JsonResponse) {
            return $filters;
        }
        $payload = $this->statsService->getStats($filters);

        return response()->json($payload);
    }

    /**
     * 一覧/集計の filter を acting user の owner に固定する。
     * member: 自分 owner に固定（未設定は 422）。chapter_admin: query 指定 or 無指定（全件）。
     *
     * @param  array<string, mixed>  $filters
     * @return array<string, mixed>|JsonResponse
     */
    private function scopeFiltersToOwner($request, array $filters): array|JsonResponse
    {
        $owner = $this->resolveOwnerMemberId($request);
        if ($owner === false) {
            if (! $this->actorIsChapterAdmin(\App\Services\Religo\ReligoActorContext::actingUser())) {
                return $this->ownerNotConfiguredResponse();
            }
            unset($filters['owner_member_id']);

            return $filters;
        }
        $filters['owner_member_id'] = $owner;

        return $filters;
    }

    /**
     * POST /api/one-to-ones — 1 to 1 登録. SSOT: DATA_MODEL §4.9.
     */
    public function store(StoreOneToOneRequest $request): JsonResponse
    {
        $data = $request->validated();
        $owner = $this->resolveOwnerMemberId($request);
        if ($owner === false) {
            return $this->ownerNotConfiguredResponse();
        }
        $data['owner_member_id'] = $owner;
        $o2o = $this->oneToOneService->store($data);
        $o2o->load(['ownerMember:id,name', 'targetMember:id,name', 'meeting:id,number,held_on']);

        return response()->json($this->indexService->formatRecord($o2o), 201);
    }

    /**
     * GET /api/one-to-ones/{id} — 1 件取得（管理画面編集用）。
     */
    public function show(OneToOne $oneToOne): JsonResponse
    {
        $this->assertOwnerMatchesActor((int) $oneToOne->owner_member_id);

        return response()->json($this->indexService->formatRecord($oneToOne));
    }

    /**
     * PATCH /api/one-to-ones/{id} — 更新（管理画面編集用）。
     */
    public function update(UpdateOneToOneRequest $request, OneToOne $oneToOne): JsonResponse
    {
        $this->assertOwnerMatchesActor((int) $oneToOne->owner_member_id);
        $data = $request->validated();
        $o2o = $this->oneToOneService->update($oneToOne, $data);

        return response()->json($this->indexService->formatRecord($o2o));
    }

    /**
     * POST /api/one-to-ones/{id}/cancel — 予定キャンセル（planned のみ）。Phase 185.
     */
    public function cancel(CancelOneToOneRequest $request, OneToOne $oneToOne): JsonResponse
    {
        $this->assertOwnerMatchesActor((int) $oneToOne->owner_member_id);
        if ($oneToOne->status !== 'planned') {
            return response()->json([
                'message' => 'キャンセルできるのは予定中（planned）の 1 to 1 のみです。',
            ], 422);
        }

        $data = $request->validated();
        $remark = isset($data['cancel_remark']) ? trim((string) $data['cancel_remark']) : null;
        if ($remark === '') {
            $remark = null;
        }

        $o2o = $this->oneToOneService->cancel($oneToOne, [
            'cancel_reason' => $data['cancel_reason'],
            'cancel_remark' => $remark,
        ]);

        return response()->json($this->indexService->formatRecord($o2o));
    }

    /**
     * GET /api/one-to-ones/{id}/series-markdown — 相手共通の 1to1 シリーズ全文（SPEC-019 §4.6）。
     */
    public function seriesMarkdown(OneToOne $oneToOne): JsonResponse
    {
        $this->assertOwnerMatchesActor((int) $oneToOne->owner_member_id);
        $payload = $this->seriesMarkdownService->getSeriesMarkdown(
            (int) $oneToOne->owner_member_id,
            (int) $oneToOne->target_member_id,
        );

        return response()->json($payload);
    }

    /**
     * GET /api/one-to-ones/{id}/memos — 当該 1to1 に紐づく contact_memos（時系列 Desc）。
     */
    public function memosIndex(OneToOne $oneToOne): JsonResponse
    {
        $this->assertOwnerMatchesActor((int) $oneToOne->owner_member_id);
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
     * POST /api/one-to-ones/{id}/memos — 履歴メモ追加（任意の追記。主記録は one_to_ones.notes）。memo_type = one_to_one、owner/target は 1to1 から複製。
     */
    public function memosStore(StoreOneToOneMemoRequest $request, OneToOne $oneToOne): JsonResponse
    {
        $this->assertOwnerMatchesActor((int) $oneToOne->owner_member_id);
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
