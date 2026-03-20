<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET/PATCH /api/users/me — 現在ユーザーの owner / workspace 文脈. E-4 / BO-AUDIT-P3.
 *
 * **現在ユーザー:** `ReligoActorContext::actingUser()`（認証優先・無認証時は users id 昇順先頭）。
 */
class UserController extends Controller
{
    /**
     * GET /api/users/me — id・owner_member_id・member_id・workspace_id（推定、nullable 可）.
     */
    public function showMe(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if (! $user) {
            return response()->json(['message' => 'User not found.'], 404);
        }

        return response()->json(self::mePayload($user));
    }

    /**
     * PATCH /api/users/me — owner_member_id を更新（acting user の行のみ）.
     */
    public function updateMe(Request $request): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if (! $user) {
            return response()->json(['message' => 'User not found.'], 404);
        }
        $validated = $request->validate([
            'owner_member_id' => ['required', 'integer', 'exists:members,id'],
        ]);
        $user->update(['owner_member_id' => (int) $validated['owner_member_id']]);
        $user->refresh();

        return response()->json(self::mePayload($user));
    }

    /**
     * @return array{id: int, owner_member_id: int|null, member_id: int|null, workspace_id: int|null}
     */
    private static function mePayload(User $user): array
    {
        $ownerId = $user->owner_member_id;

        return [
            'id' => $user->id,
            'owner_member_id' => $ownerId,
            'member_id' => $ownerId,
            'workspace_id' => ReligoActorContext::resolveWorkspaceIdForOwnerMember($ownerId),
        ];
    }
}
