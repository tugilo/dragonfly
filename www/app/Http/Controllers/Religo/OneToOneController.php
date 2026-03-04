<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\StoreOneToOneRequest;
use App\Services\Religo\OneToOneService;
use Illuminate\Http\JsonResponse;

class OneToOneController extends Controller
{
    public function __construct(
        private OneToOneService $oneToOneService
    ) {}

    /**
     * POST /api/one-to-ones — 1 to 1 登録. SSOT: DATA_MODEL §4.9.
     */
    public function store(StoreOneToOneRequest $request): JsonResponse
    {
        $data = $request->validated();
        $o2o = $this->oneToOneService->store($data);
        return response()->json([
            'id' => $o2o->id,
            'workspace_id' => $o2o->workspace_id,
            'owner_member_id' => $o2o->owner_member_id,
            'target_member_id' => $o2o->target_member_id,
            'meeting_id' => $o2o->meeting_id,
            'status' => $o2o->status,
            'scheduled_at' => $o2o->scheduled_at?->toIso8601String(),
            'started_at' => $o2o->started_at?->toIso8601String(),
            'ended_at' => $o2o->ended_at?->toIso8601String(),
            'notes' => $o2o->notes,
            'created_at' => $o2o->created_at?->toIso8601String(),
            'updated_at' => $o2o->updated_at?->toIso8601String(),
        ], 201);
    }
}
