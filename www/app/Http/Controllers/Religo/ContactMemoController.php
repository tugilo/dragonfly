<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\IndexContactMemosRequest;
use App\Http\Requests\Religo\StoreContactMemoRequest;
use App\Models\ContactMemo;
use App\Services\Religo\ContactMemoService;
use Illuminate\Http\JsonResponse;

class ContactMemoController extends Controller
{
    public function __construct(
        private ContactMemoService $contactMemoService
    ) {}

    /**
     * GET /api/contact-memos — 一覧. Phase17A. owner/target 必須、limit 任意.
     */
    public function index(IndexContactMemosRequest $request): JsonResponse
    {
        $validated = $request->validated();
        $limit = isset($validated['limit']) ? (int) $validated['limit'] : 20;
        $items = ContactMemo::query()
            ->where('owner_member_id', $validated['owner_member_id'])
            ->where('target_member_id', $validated['target_member_id'])
            ->orderByDesc('created_at')
            ->limit($limit)
            ->get();
        $data = $items->map(fn (ContactMemo $m) => [
            'id' => $m->id,
            'owner_member_id' => $m->owner_member_id,
            'target_member_id' => $m->target_member_id,
            'memo_type' => $m->memo_type,
            'body' => $m->body,
            'meeting_id' => $m->meeting_id,
            'one_to_one_id' => $m->one_to_one_id,
            'created_at' => $m->created_at?->toIso8601String(),
            'updated_at' => $m->updated_at?->toIso8601String(),
        ])->values()->all();
        return response()->json($data);
    }

    /**
     * POST /api/contact-memos — メモ追加. SSOT: DATA_MODEL §4.8.
     */
    public function store(StoreContactMemoRequest $request): JsonResponse
    {
        $data = $request->validated();
        $memo = $this->contactMemoService->store($data);
        return response()->json([
            'id' => $memo->id,
            'owner_member_id' => $memo->owner_member_id,
            'target_member_id' => $memo->target_member_id,
            'workspace_id' => $memo->workspace_id,
            'memo_type' => $memo->memo_type,
            'body' => $memo->body,
            'meeting_id' => $memo->meeting_id,
            'one_to_one_id' => $memo->one_to_one_id,
            'created_at' => $memo->created_at?->toIso8601String(),
            'updated_at' => $memo->updated_at?->toIso8601String(),
        ], 201);
    }
}
