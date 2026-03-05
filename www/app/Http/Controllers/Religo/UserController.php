<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET/PATCH /api/users/me — 現在ユーザーの owner_member_id 取得・更新. E-4.
 * 認証なしのため「現在ユーザー」は user id 1 に固定。将来 auth()->user() に差し替え可。
 */
class UserController extends Controller
{
    private const ME_USER_ID = 1;

    /**
     * GET /api/users/me — owner_member_id のみ返す（Dashboard 用）.
     */
    public function showMe(): JsonResponse
    {
        $user = User::find(self::ME_USER_ID);
        if (! $user) {
            return response()->json(['message' => 'User not found.'], 404);
        }
        return response()->json(['owner_member_id' => $user->owner_member_id]);
    }

    /**
     * PATCH /api/users/me — owner_member_id を更新.
     */
    public function updateMe(Request $request): JsonResponse
    {
        $user = User::find(self::ME_USER_ID);
        if (! $user) {
            return response()->json(['message' => 'User not found.'], 404);
        }
        $validated = $request->validate([
            'owner_member_id' => ['required', 'integer', 'exists:members,id'],
        ]);
        $user->update(['owner_member_id' => (int) $validated['owner_member_id']]);
        return response()->json(['owner_member_id' => $user->owner_member_id]);
    }
}
