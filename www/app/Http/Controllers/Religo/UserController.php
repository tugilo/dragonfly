<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET/PATCH /api/users/me — owner + membership workspace. E-4 / BO-AUDIT-P3〜P4.
 *
 * `default_workspace_id` is the user's BNI chapter workspace (DB column name unchanged).
 * **戻り `workspace_id`:** resolved chapter id, same formula as BO audit (USER_ME + WORKSPACE_RESOLUTION_POLICY SSOT).
 *
 * **現在ユーザー:** `ReligoActorContext::actingUser()`（認証優先・無認証時は users id 昇順先頭）。
 */
class UserController extends Controller
{
    /**
     * GET /api/users/me — id・owner・`default_workspace_id`（所属 workspace・DB）・`workspace_id`（解決済み・所属チャプター）.
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
     * PATCH /api/users/me — `owner_member_id` および / または `default_workspace_id`（所属 workspace）を更新（acting user の行のみ）.
     */
    public function updateMe(Request $request): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if (! $user) {
            return response()->json(['message' => 'User not found.'], 404);
        }

        $input = $request->all();
        $hasOwner = array_key_exists('owner_member_id', $input);
        $hasWs = array_key_exists('default_workspace_id', $input);
        if (! $hasOwner && ! $hasWs) {
            return response()->json(['message' => 'owner_member_id または default_workspace_id が必要です。'], 422);
        }

        $validated = $request->validate([
            'owner_member_id' => ['sometimes', 'integer', 'exists:members,id'],
            'default_workspace_id' => ['sometimes', 'nullable', 'integer', 'exists:workspaces,id'],
        ]);

        if (array_key_exists('owner_member_id', $validated)) {
            $user->owner_member_id = $validated['owner_member_id'];
        }
        if (array_key_exists('default_workspace_id', $validated)) {
            $user->default_workspace_id = $validated['default_workspace_id'];
        }
        $user->save();
        $user->refresh();

        return response()->json(self::mePayload($user));
    }

    /**
     * @return array{id: int, owner_member_id: int|null, member_id: int|null, default_workspace_id: int|null, workspace_id: int|null}
     */
    private static function mePayload(User $user): array
    {
        $ownerId = $user->owner_member_id;
        $dws = $user->default_workspace_id;

        return [
            'id' => $user->id,
            'owner_member_id' => $ownerId,
            'member_id' => $ownerId,
            'default_workspace_id' => $dws !== null ? (int) $dws : null,
            'workspace_id' => ReligoActorContext::resolveWorkspaceIdForUser($user),
        ];
    }
}
