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
        $workspaces = Workspace::orderBy('id')->get(['id', 'name', 'slug']);
        return response()->json($workspaces);
    }
}
