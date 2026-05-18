<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class AdminUserController extends Controller
{
    /**
     * PATCH /api/admin/users/{user} — chapter_admin のみ。religo_role / owner_member_id。
     */
    public function update(Request $request, User $user): JsonResponse
    {
        $validated = $request->validate([
            'religo_role' => [
                'sometimes',
                'string',
                Rule::in([User::RELIGO_ROLE_MEMBER, User::RELIGO_ROLE_CHAPTER_ADMIN]),
            ],
            'owner_member_id' => ['sometimes', 'nullable', 'integer', 'exists:members,id'],
        ]);

        if ($validated === []) {
            return response()->json(['message' => 'religo_role または owner_member_id が必要です。'], 422);
        }

        $user->fill($validated);
        $user->save();
        $user->refresh();

        return response()->json([
            'id' => $user->id,
            'email' => $user->email,
            'religo_role' => $user->religo_role ?? User::RELIGO_ROLE_MEMBER,
            'owner_member_id' => $user->owner_member_id,
            'default_workspace_id' => $user->default_workspace_id !== null ? (int) $user->default_workspace_id : null,
        ]);
    }
}
