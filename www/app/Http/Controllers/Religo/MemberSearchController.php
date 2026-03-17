<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\Member;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * M7-P5: 手動マッチング用の member 検索。
 * GET /api/members/search?q=... — name 部分一致、上限 15 件。
 */
class MemberSearchController extends Controller
{
    private const LIMIT = 15;

    public function search(Request $request): JsonResponse
    {
        $q = $request->input('q');
        if (! is_string($q) || trim($q) === '') {
            return response()->json([]);
        }

        $q = trim($q);
        $members = Member::query()
            ->where('name', 'like', '%' . $q . '%')
            ->orderBy('name')
            ->limit(self::LIMIT)
            ->get(['id', 'name'])
            ->map(fn (Member $m) => ['id' => $m->id, 'name' => $m->name]);

        return response()->json($members->values()->all());
    }
}
