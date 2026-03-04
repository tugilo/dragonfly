<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\StoreContactMemoRequest;
use App\Services\Religo\ContactMemoService;
use Illuminate\Http\JsonResponse;

class ContactMemoController extends Controller
{
    public function __construct(
        private ContactMemoService $contactMemoService
    ) {}

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
