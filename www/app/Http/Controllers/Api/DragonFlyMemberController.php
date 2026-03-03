<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Member;
use Illuminate\Http\JsonResponse;

class DragonFlyMemberController extends Controller
{
    /**
     * GET /api/dragonfly/members — 一覧（Autocomplete 等用）.
     */
    public function index(): JsonResponse
    {
        $members = Member::query()
            ->select('id', 'display_no', 'name', 'name_kana', 'category')
            ->orderBy('id')
            ->get();

        return response()->json($members);
    }
}
