<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\Meeting;
use Illuminate\Http\JsonResponse;

/**
 * GET /api/meetings — 一覧（Religo BO ビルダー用）. SSOT: DATA_MODEL §4.3.
 */
class MeetingController extends Controller
{
    public function index(): JsonResponse
    {
        $meetings = Meeting::query()
            ->select('id', 'number', 'held_on')
            ->orderByDesc('held_on')
            ->orderByDesc('id')
            ->get()
            ->map(fn (Meeting $m) => [
                'id' => $m->id,
                'number' => $m->number,
                'held_on' => $m->held_on?->format('Y-m-d'),
            ]);
        return response()->json($meetings->values()->all());
    }
}
