<?php

namespace App\Http\Controllers\Religo\Concerns;

use App\Models\Member;
use App\Models\User;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * owner スコープ解決の単一の正。SPEC-010 §6.1 / SPEC-020 §4.5（順位 3〜4）。
 *
 * 方針:
 * - acting user の owner_member_id を正とする。
 * - chapter_admin はグローバル Owner 選択（SPEC-003）維持のため任意 owner を指定可。
 * - 一般 member が自分以外の owner を query/body で指定したら 403。
 */
trait ResolvesReligoOwner
{
    private function resolveOwnerMemberId(Request $request): int|false
    {
        $user = ReligoActorContext::actingUser();
        $actorOwner = ($user && $user->owner_member_id !== null) ? (int) $user->owner_member_id : null;

        if ($request->filled('owner_member_id')) {
            $requested = (int) $request->input('owner_member_id');
            if ($this->actorIsChapterAdmin($user) || ($actorOwner !== null && $requested === $actorOwner)) {
                return $requested;
            }
            abort(403, 'Forbidden: owner mismatch.');
        }

        return $actorOwner ?? false;
    }

    /**
     * route model 等で解決済みレコードの owner が acting user と一致するか強制する。
     * member の不一致は 403、chapter_admin は許可。
     */
    private function assertOwnerMatchesActor(int $ownerMemberId): void
    {
        $user = ReligoActorContext::actingUser();
        if ($this->actorIsChapterAdmin($user)) {
            return;
        }
        $actorOwner = ($user && $user->owner_member_id !== null) ? (int) $user->owner_member_id : null;
        if ($actorOwner === null || $ownerMemberId !== $actorOwner) {
            abort(403, 'Forbidden: owner mismatch.');
        }
    }

    private function actorIsChapterAdmin(?User $user): bool
    {
        return $user !== null && $user->religo_role === User::RELIGO_ROLE_CHAPTER_ADMIN;
    }

    private function ownerNotConfiguredResponse(): JsonResponse
    {
        return response()->json(['message' => 'オーナーが未設定です。ダッシュボード上でオーナーを選択してください。'], 422);
    }

    private function assertOwnerMemberExists(int $ownerMemberId): JsonResponse|null
    {
        if (! Member::where('id', $ownerMemberId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }

        return null;
    }
}
