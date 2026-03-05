<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\JsonResponse;

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
}
