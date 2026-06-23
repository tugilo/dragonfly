<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\MeetingType;
use Illuminate\Http\JsonResponse;

/**
 * GET /api/meeting-types — 集会種別マスタ（フィルタ UI 用）. SPEC-018 §7.2.
 */
class MeetingTypeController extends Controller
{
    public function index(): JsonResponse
    {
        $types = MeetingType::query()
            ->where('is_active', true)
            ->orderBy('sort_order')
            ->orderBy('id')
            ->get()
            ->map(fn (MeetingType $type) => [
                'code' => $type->code,
                'name_ja' => $type->name_ja,
                'is_numbered' => $type->is_numbered,
                'requires_team_id' => $type->requires_team_id,
                'supports_participants' => $type->supports_participants,
                'supports_breakouts' => $type->supports_breakouts,
                'supports_referral_suggestions' => $type->supports_referral_suggestions,
                'sort_order' => $type->sort_order,
            ])
            ->values()
            ->all();

        return response()->json($types);
    }
}
