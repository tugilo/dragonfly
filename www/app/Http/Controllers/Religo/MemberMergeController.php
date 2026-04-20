<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Services\Religo\MemberMergeService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use InvalidArgumentException;
use RuntimeException;

final class MemberMergeController extends Controller
{
    public function __construct(
        private readonly MemberMergeService $memberMergeService
    ) {}

    public function preview(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'canonical_member_id' => ['required', 'integer', 'min:1', 'different:merge_member_id'],
            'merge_member_id' => ['required', 'integer', 'min:1'],
        ]);

        try {
            $data = $this->memberMergeService->preview(
                (int) $validated['canonical_member_id'],
                (int) $validated['merge_member_id']
            );
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        return response()->json($data);
    }

    public function execute(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'canonical_member_id' => ['required', 'integer', 'min:1', 'different:merge_member_id'],
            'merge_member_id' => ['required', 'integer', 'min:1'],
            'confirm_phrase' => ['required', 'string'],
        ]);

        try {
            $this->memberMergeService->execute(
                (int) $validated['canonical_member_id'],
                (int) $validated['merge_member_id'],
                $validated['confirm_phrase']
            );
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        } catch (RuntimeException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        return response()->json(['ok' => true]);
    }
}
