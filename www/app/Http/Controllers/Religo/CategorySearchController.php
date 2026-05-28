<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * M7-M7: CSV 未解決解消用のカテゴリー検索。
 */
class CategorySearchController extends Controller
{
    private const LIMIT = 30;

    public function search(Request $request): JsonResponse
    {
        $q = $request->input('q');
        if (! is_string($q) || trim($q) === '') {
            return response()->json([]);
        }
        $q = trim($q);
        $cats = Category::query()
            ->where(function ($query) use ($q) {
                $query->where('group_name', 'like', '%'.$q.'%')
                    ->orWhere('name', 'like', '%'.$q.'%');
            })
            ->orderBy('group_name')
            ->orderBy('name')
            ->limit(self::LIMIT)
            ->get();

        $out = $cats->map(function (Category $c) {
            $label = $c->group_name === $c->name ? $c->name : ($c->group_name.' / '.$c->name);

            return [
                'id' => $c->id,
                'name' => $label,
                'group_name' => $c->group_name,
                'category_name' => $c->name,
            ];
        });

        return response()->json($out->values()->all());
    }
}
