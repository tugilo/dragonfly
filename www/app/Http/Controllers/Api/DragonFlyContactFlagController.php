<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\DragonFly\UpsertContactFlagRequest;
use App\Models\Member;
use App\Models\DragonflyContactFlag;
use App\Services\DragonFly\ContactFlagService;
use Illuminate\Http\JsonResponse;

class DragonFlyContactFlagController extends Controller
{
    public function __construct(
        private ContactFlagService $contactFlagService
    ) {}

    /**
     * GET /api/dragonfly/flags — owner のフラグ一覧.
     */
    public function index(): JsonResponse
    {
        $ownerMemberId = request()->query('owner_member_id');
        if ($ownerMemberId === null || $ownerMemberId === '') {
            return response()->json(['message' => 'owner_member_id is required.'], 400);
        }
        $ownerMemberId = (int) $ownerMemberId;
        if (! Member::where('id', $ownerMemberId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }

        $flags = DragonflyContactFlag::where('owner_member_id', $ownerMemberId)
            ->get()
            ->map(fn (DragonflyContactFlag $f) => [
                'target_member_id' => $f->target_member_id,
                'interested' => $f->interested,
                'want_1on1' => $f->want_1on1,
                'extra_status' => $f->extra_status,
            ]);

        return response()->json($flags);
    }

    /**
     * PUT /api/dragonfly/flags/{target_member_id} — 1 件 upsert.
     */
    public function update(UpsertContactFlagRequest $request, int $target_member_id): JsonResponse
    {
        $ownerMemberId = (int) $request->input('owner_member_id');
        $targetMemberId = (int) $target_member_id;

        if (! Member::where('id', $ownerMemberId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }
        if (! Member::where('id', $targetMemberId)->exists()) {
            return response()->json(['message' => 'Target member not found.'], 404);
        }

        $flag = $this->contactFlagService->upsertFlag(
            $ownerMemberId,
            $targetMemberId,
            $request->input('interested'),
            $request->input('want_1on1'),
            $request->input('extra_status'),
            $request->input('reason'),
            $request->input('meeting_id') !== null ? (int) $request->input('meeting_id') : null
        );

        return response()->json([
            'id' => $flag->id,
            'owner_member_id' => $flag->owner_member_id,
            'target_member_id' => $flag->target_member_id,
            'interested' => $flag->interested,
            'want_1on1' => $flag->want_1on1,
            'extra_status' => $flag->extra_status,
            'created_at' => $flag->created_at?->toIso8601String(),
            'updated_at' => $flag->updated_at?->toIso8601String(),
        ]);
    }
}
