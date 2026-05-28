<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Role;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

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

    /**
     * GET /api/roles/{id} — 1件取得.
     */
    public function show(int $id): JsonResponse
    {
        $role = Role::find($id);
        if (! $role) {
            return response()->json(['message' => 'Role not found'], 404);
        }

        return response()->json($role->only(['id', 'name', 'description']));
    }

    /**
     * POST /api/roles — 新規作成.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);
        $role = Role::create($validated);

        return response()->json($role->only(['id', 'name', 'description']), 201);
    }

    /**
     * PUT /api/roles/{id} — 更新.
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $role = Role::find($id);
        if (! $role) {
            return response()->json(['message' => 'Role not found'], 404);
        }
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
        ]);
        $role->update($validated);

        return response()->json($role->only(['id', 'name', 'description']));
    }

    /**
     * DELETE /api/roles/{id} — 削除. 役職履歴がいる場合は 422.
     */
    public function destroy(int $id): JsonResponse
    {
        $role = Role::find($id);
        if (! $role) {
            return response()->json(['message' => 'Role not found'], 404);
        }
        if ($role->memberRoles()->count() > 0) {
            return response()->json([
                'message' => 'Cannot delete role with member role history. Remove or reassign history first.',
            ], 422);
        }
        $role->delete();

        return response()->json(null, 204);
    }
}
