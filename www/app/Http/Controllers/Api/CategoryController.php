<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    /**
     * GET /api/categories — 一覧（select 用）.
     */
    public function index(): JsonResponse
    {
        $categories = Category::orderBy('group_name')->orderBy('name')->get(['id', 'group_name', 'name']);

        return response()->json($categories);
    }

    /**
     * GET /api/categories/{id} — 1件取得.
     */
    public function show(int $id): JsonResponse
    {
        $category = Category::find($id);
        if (! $category) {
            return response()->json(['message' => 'Category not found'], 404);
        }

        return response()->json($category->only(['id', 'group_name', 'name']));
    }

    /**
     * POST /api/categories — 新規作成.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'group_name' => 'required|string|max:255',
            'name' => 'required|string|max:255',
        ]);
        $category = Category::create($validated);

        return response()->json($category->only(['id', 'group_name', 'name']), 201);
    }

    /**
     * PUT /api/categories/{id} — 更新.
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $category = Category::find($id);
        if (! $category) {
            return response()->json(['message' => 'Category not found'], 404);
        }
        $validated = $request->validate([
            'group_name' => 'sometimes|string|max:255',
            'name' => 'sometimes|string|max:255',
        ]);
        $category->update($validated);

        return response()->json($category->only(['id', 'group_name', 'name']));
    }

    /**
     * DELETE /api/categories/{id} — 削除. 所属メンバーがいる場合は 422.
     */
    public function destroy(int $id): JsonResponse
    {
        $category = Category::find($id);
        if (! $category) {
            return response()->json(['message' => 'Category not found'], 404);
        }
        if ($category->members()->count() > 0) {
            return response()->json([
                'message' => 'Cannot delete category with members. Move members to another category first.',
            ], 422);
        }
        $category->delete();

        return response()->json(null, 204);
    }
}
