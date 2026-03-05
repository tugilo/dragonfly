<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Role;
use Illuminate\Http\JsonResponse;

class RoleController extends Controller
{
    /**
     * GET /api/roles — 一覧（select 用）.
     */
    public function index(): JsonResponse
    {
        $roles = Role::orderBy('name')->get(['id', 'name', 'description']);

        return response()->json($roles);
    }
}
