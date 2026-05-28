<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Workspace;
use Illuminate\Http\JsonResponse;

/**
 * GET /api/workspaces — 一覧（単一 workspace 運用で 1 件取得用）. SSOT: DATA_MODEL §4.1.
 */
class WorkspaceController extends Controller
{
    public function index(): JsonResponse
    {
        $workspaces = Workspace::query()
            ->with(['region.country'])
            ->orderBy('id')
            ->get(['id', 'name', 'slug', 'region_id']);

        $data = $workspaces->map(function (Workspace $w) {
            $r = $w->region;

            return [
                'id' => $w->id,
                'name' => $w->name,
                'slug' => $w->slug,
                'region_id' => $w->region_id,
                'region_name' => $r?->name,
                'country_id' => $r?->country_id,
                'country_name' => $r?->country?->name,
            ];
        })->values()->all();

        return response()->json($data);
    }
}
