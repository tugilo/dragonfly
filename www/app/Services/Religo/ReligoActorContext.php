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
 * **workspace_id（解決済み・chapter 相当）** の優先順（BO-AUDIT-P4、`WORKSPACE_RESOLUTION_POLICY.md`）:
 * 1. `users.default_workspace_id`
 * 2. owner の既存データ（`dragonfly_contact_flags` → `one_to_ones` → `contact_memos` の `workspace_id`）
 * 3. `workspaces` id 昇順先頭
 * 4. 行が無ければ null
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
     * owner 由来の workspace のみ（flags → 1to1 → memos）。先頭 workspace は含めない。
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
     * GET /api/users/me の `workspace_id`・BO 監査 `workspace_id`・Dashboard 文脈で共有。
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
