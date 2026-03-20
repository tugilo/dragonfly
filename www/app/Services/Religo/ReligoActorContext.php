<?php

namespace App\Services\Religo;

use App\Models\ContactMemo;
use App\Models\DragonflyContactFlag;
use App\Models\OneToOne;
use App\Models\User;
use App\Models\Workspace;

/**
 * Religo 管理画面の「現在ユーザー」と BO 監査 actor の共通解決。
 *
 * Workspace resolution (SSOT: docs/SSOT/WORKSPACE_RESOLUTION_POLICY.md, DATA_MODEL §Workspace と User):
 * BNI前提では 1 user = 1 workspace; `default_workspace_id` is the user's membership workspace
 * (column name kept for API/DB compatibility), then legacy artifact hints, then single-row fallback.
 *
 * Order: 1) users.default_workspace_id 2) owner artifacts (flags → one_to_ones → contact_memos)
 * 3) first workspaces row by id 4) null.
 *
 * SSOT: docs/SSOT/USER_ME_AND_ACTOR_RESOLUTION.md
 */
final class ReligoActorContext
{
    public static function actingUser(): ?User
    {
        $u = auth()->user();
        if ($u instanceof User) {
            return $u;
        }

        return User::query()->orderBy('id')->first();
    }

    /**
     * Legacy complement only: workspace hints from owner-linked rows (flags → 1to1 → memos).
     * Does not include users.default_workspace_id or first workspaces row.
     */
    public static function resolveWorkspaceIdFromOwnerMemberArtifacts(?int $ownerMemberId): ?int
    {
        if ($ownerMemberId === null) {
            return null;
        }
        $fromFlag = DragonflyContactFlag::query()
            ->where('owner_member_id', $ownerMemberId)
            ->whereNotNull('workspace_id')
            ->orderBy('id')
            ->value('workspace_id');
        if ($fromFlag !== null) {
            return (int) $fromFlag;
        }
        $fromO2o = OneToOne::query()
            ->where('owner_member_id', $ownerMemberId)
            ->whereNotNull('workspace_id')
            ->orderBy('id')
            ->value('workspace_id');
        if ($fromO2o !== null) {
            return (int) $fromO2o;
        }
        $fromMemo = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->whereNotNull('workspace_id')
            ->orderBy('id')
            ->value('workspace_id');
        if ($fromMemo !== null) {
            return (int) $fromMemo;
        }

        return null;
    }

    /**
     * Resolved chapter workspace for GET /api/users/me, BO audit rows, and shared admin context.
     */
    public static function resolveWorkspaceIdForUser(?User $user): ?int
    {
        if ($user !== null && $user->default_workspace_id !== null) {
            return (int) $user->default_workspace_id;
        }
        $fromArtifacts = self::resolveWorkspaceIdFromOwnerMemberArtifacts($user?->owner_member_id);
        if ($fromArtifacts !== null) {
            return $fromArtifacts;
        }

        return self::defaultChapterWorkspaceId();
    }

    public static function defaultChapterWorkspaceId(): ?int
    {
        $id = Workspace::query()->orderBy('id')->value('id');

        return $id !== null ? (int) $id : null;
    }
}
