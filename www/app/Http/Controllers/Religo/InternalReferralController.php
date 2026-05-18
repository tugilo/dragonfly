<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Religo\Concerns\ResolvesReligoOwner;
use App\Http\Requests\Religo\IndexInternalReferralsRequest;
use App\Http\Requests\Religo\StoreInternalReferralRequest;
use App\Http\Requests\Religo\UpdateInternalReferralRequest;
use App\Models\InternalReferral;
use App\Models\Member;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * 内部リファーラル（TYFCB）。SPEC-009 / DATA_MODEL §4.14.
 */
class InternalReferralController extends Controller
{
    use ResolvesReligoOwner;

    public function index(Request $request, IndexInternalReferralsRequest $indexRequest): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return $this->ownerNotConfiguredResponse();
        }
        if ($resp = $this->assertOwnerMemberExists($ownerMemberId)) {
            return $resp;
        }
        $limit = (int) ($indexRequest->validated()['limit'] ?? 50);

        $rows = InternalReferral::query()
            ->where('owner_member_id', $ownerMemberId)
            ->orderByDesc('id')
            ->limit($limit)
            ->get();

        return response()->json($rows->map(fn (InternalReferral $r) => $this->formatInternalReferral($r))->values()->all());
    }

    public function store(Request $request, StoreInternalReferralRequest $storeRequest): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return $this->ownerNotConfiguredResponse();
        }
        if ($resp = $this->assertOwnerMemberExists($ownerMemberId)) {
            return $resp;
        }
        $data = $storeRequest->validated();

        if (! in_array($ownerMemberId, [(int) $data['buyer_member_id'], (int) $data['seller_member_id']], true)) {
            return response()->json(['message' => 'オーナーは買い手または売り手のいずれかと一致する必要があります。'], 422);
        }

        $buyer = Member::query()->findOrFail((int) $data['buyer_member_id']);
        $seller = Member::query()->findOrFail((int) $data['seller_member_id']);

        if ($buyer->workspace_id !== null && $seller->workspace_id !== null
            && (int) $buyer->workspace_id !== (int) $seller->workspace_id) {
            return response()->json(['message' => '買い手と売り手の所属チャプター（workspace）が一致しません。'], 422);
        }

        $workspaceId = $data['workspace_id'] ?? $buyer->workspace_id ?? $seller->workspace_id;

        $row = new InternalReferral(array_merge($data, [
            'owner_member_id' => $ownerMemberId,
            'workspace_id' => $workspaceId,
        ]));
        $row->save();

        return response()->json($this->formatInternalReferral($row->fresh()), 201);
    }

    public function show(Request $request, InternalReferral $internalReferral): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return $this->ownerNotConfiguredResponse();
        }
        if ($internalReferral->owner_member_id !== $ownerMemberId) {
            return response()->json(['message' => 'Not found.'], 404);
        }

        return response()->json($this->formatInternalReferral($internalReferral));
    }

    public function update(Request $request, UpdateInternalReferralRequest $updateRequest, InternalReferral $internalReferral): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return $this->ownerNotConfiguredResponse();
        }
        if ($internalReferral->owner_member_id !== $ownerMemberId) {
            return response()->json(['message' => 'Not found.'], 404);
        }

        $data = $updateRequest->validated();
        $internalReferral->fill($data);

        $buyerId = (int) $internalReferral->buyer_member_id;
        $sellerId = (int) $internalReferral->seller_member_id;
        if (! in_array($ownerMemberId, [$buyerId, $sellerId], true)) {
            return response()->json(['message' => 'オーナーは買い手または売り手のいずれかと一致する必要があります。'], 422);
        }

        $buyer = Member::query()->findOrFail($buyerId);
        $seller = Member::query()->findOrFail($sellerId);
        if ($buyer->workspace_id !== null && $seller->workspace_id !== null
            && (int) $buyer->workspace_id !== (int) $seller->workspace_id) {
            return response()->json(['message' => '買い手と売り手の所属チャプター（workspace）が一致しません。'], 422);
        }

        if ($internalReferral->workspace_id === null) {
            $internalReferral->workspace_id = $buyer->workspace_id ?? $seller->workspace_id;
        }

        $internalReferral->save();

        return response()->json($this->formatInternalReferral($internalReferral->fresh()));
    }

    /**
     * @return array<string, mixed>
     */
    private function formatInternalReferral(InternalReferral $r): array
    {
        return [
            'id' => $r->id,
            'workspace_id' => $r->workspace_id,
            'owner_member_id' => $r->owner_member_id,
            'buyer_member_id' => $r->buyer_member_id,
            'seller_member_id' => $r->seller_member_id,
            'summary' => $r->summary,
            'closed_on' => $r->closed_on?->format('Y-m-d'),
            'amount_yen' => $r->amount_yen,
            'notes' => $r->notes,
            'created_at' => $r->created_at?->toIso8601String(),
            'updated_at' => $r->updated_at?->toIso8601String(),
        ];
    }
}
