<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Religo\Concerns\ResolvesReligoOwner;
use App\Http\Requests\Religo\IndexIntroductionsRequest;
use App\Http\Requests\Religo\StoreIntroductionRequest;
use App\Http\Requests\Religo\UpdateIntroductionRequest;
use App\Models\Introduction;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * 外部リファーラル（introductions）。SPEC-009 / DATA_MODEL §4.13.
 */
class IntroductionController extends Controller
{
    use ResolvesReligoOwner;

    public function index(Request $request, IndexIntroductionsRequest $indexRequest): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return $this->ownerNotConfiguredResponse();
        }
        if ($resp = $this->assertOwnerMemberExists($ownerMemberId)) {
            return $resp;
        }
        $limit = (int) ($indexRequest->validated()['limit'] ?? 50);

        $rows = Introduction::query()
            ->where('owner_member_id', $ownerMemberId)
            ->orderByDesc('id')
            ->limit($limit)
            ->get();

        return response()->json($rows->map(fn (Introduction $r) => $this->formatIntroduction($r))->values()->all());
    }

    public function store(Request $request, StoreIntroductionRequest $storeRequest): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return $this->ownerNotConfiguredResponse();
        }
        if ($resp = $this->assertOwnerMemberExists($ownerMemberId)) {
            return $resp;
        }
        $data = $storeRequest->validated();
        $row = new Introduction([
            'owner_member_id' => $ownerMemberId,
            'from_member_id' => (int) $data['from_member_id'],
            'to_member_id' => (int) $data['to_member_id'],
            'meeting_id' => $data['meeting_id'] ?? null,
            'note' => $data['note'] ?? null,
            'introduced_at' => $data['introduced_at'] ?? null,
            'workspace_id' => $data['workspace_id'] ?? null,
            'referral_kind' => 'external',
        ]);
        $row->save();
        $row->refresh();

        return response()->json($this->formatIntroduction($row), 201);
    }

    public function show(Request $request, Introduction $introduction): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return $this->ownerNotConfiguredResponse();
        }
        if ($introduction->owner_member_id !== $ownerMemberId) {
            return response()->json(['message' => 'Not found.'], 404);
        }

        return response()->json($this->formatIntroduction($introduction));
    }

    public function update(Request $request, UpdateIntroductionRequest $updateRequest, Introduction $introduction): JsonResponse
    {
        $ownerMemberId = $this->resolveOwnerMemberId($request);
        if ($ownerMemberId === false) {
            return $this->ownerNotConfiguredResponse();
        }
        if ($introduction->owner_member_id !== $ownerMemberId) {
            return response()->json(['message' => 'Not found.'], 404);
        }
        $data = $updateRequest->validated();
        $from = isset($data['from_member_id']) ? (int) $data['from_member_id'] : (int) $introduction->from_member_id;
        $to = isset($data['to_member_id']) ? (int) $data['to_member_id'] : (int) $introduction->to_member_id;
        if ($from === $to) {
            return response()->json(['message' => 'from_member_id と to_member_id は異なる必要があります。'], 422);
        }
        $data['referral_kind'] = 'external';
        $introduction->fill($data);
        $introduction->save();

        return response()->json($this->formatIntroduction($introduction->fresh()));
    }

    /**
     * @return array<string, mixed>
     */
    private function formatIntroduction(Introduction $r): array
    {
        return [
            'id' => $r->id,
            'workspace_id' => $r->workspace_id,
            'owner_member_id' => $r->owner_member_id,
            'from_member_id' => $r->from_member_id,
            'to_member_id' => $r->to_member_id,
            'referral_kind' => $r->referral_kind ?? 'external',
            'meeting_id' => $r->meeting_id,
            'introduced_at' => $r->introduced_at?->format('Y-m-d'),
            'note' => $r->note,
            'created_at' => $r->created_at?->toIso8601String(),
            'updated_at' => $r->updated_at?->toIso8601String(),
        ];
    }
}
