<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Services\Religo\MemberRoleIndexService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET /api/member-roles — 役職履歴一覧（Phase15B）. 閲覧特化.
 */
class MemberRoleController extends Controller
{
    public function __construct(
        private MemberRoleIndexService $indexService
    ) {}

    public function index(Request $request): JsonResponse
    {
        $filters = [
            'role_id' => $request->input('role_id'),
            'member_id' => $request->input('member_id'),
            'from' => $request->input('from'),
            'to' => $request->input('to'),
        ];
        $filters = array_filter($filters, fn ($v) => $v !== null && $v !== '');

        $list = $this->indexService->getList($filters);

        return response()->json($list);
    }
}
