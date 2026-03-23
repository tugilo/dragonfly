<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\Member;
use App\Services\Religo\DashboardSummaryVerificationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * ローカル開発用: stats の DB 照合。本番ではルート未登録。
 */
class DashboardDebugController extends Controller
{
    public function verifySummary(Request $request, DashboardSummaryVerificationService $verification): JsonResponse
    {
        $ownerId = (int) ($request->query('owner_member_id') ?? 0);
        if ($ownerId <= 0) {
            return response()->json(['message' => 'owner_member_id query parameter is required.'], 422);
        }
        if (! Member::where('id', $ownerId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }

        return response()->json($verification->verify($ownerId));
    }
}
