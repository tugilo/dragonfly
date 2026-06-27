<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\ResolveCrossChapterTargetRequest;
use App\Services\Religo\CrossChapterTargetResolveService;
use Illuminate\Http\JsonResponse;

/**
 * POST /api/dragonfly/cross-chapter-targets/resolve — 他チャプター相手の解決。SPEC-021。
 */
class CrossChapterTargetController extends Controller
{
    public function resolve(
        ResolveCrossChapterTargetRequest $request,
        CrossChapterTargetResolveService $service
    ): JsonResponse {
        try {
            $result = $service->resolve($request->validated());
        } catch (\InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        return response()->json($result);
    }
}
