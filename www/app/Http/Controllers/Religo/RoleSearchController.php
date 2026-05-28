<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\Role;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * M7-M7: CSV 未解決解消用の役職検索。
 */
class RoleSearchController extends Controller
{
    private const LIMIT = 30;

    public function search(Request $request): JsonResponse
    {
        $q = $request->input('q');
        if (! is_string($q) || trim($q) === '') {
            return response()->json([]);
        }
        $q = trim($q);
        $roles = Role::query()
            ->where('name', 'like', '%'.$q.'%')
            ->orderBy('name')
            ->limit(self::LIMIT)
            ->get(['id', 'name']);

        return response()->json($roles->map(fn (Role $r) => ['id' => $r->id, 'name' => $r->name])->values()->all());
    }
}
