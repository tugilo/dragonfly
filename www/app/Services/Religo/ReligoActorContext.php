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
 * - **認証:** `auth()->user()` が `App\Models\User` なら採用。
 * - **フォールバック:** users を id 昇順で先頭（**認証未導入の単一管理者**運用。複数 User かつ未ログイン時は最小 id が「既定オペレータ」になる）。
 *
 * workspace_id（chapter 相当）: **owner_member_id 文脈**で flags → 1to1 → contact_memos の既存行から
 * `workspace_id` を探索し、無ければ **workspaces 先頭**（DragonFly 単一チャプター既定）。
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
     * Dashboard owner・BO 監査・/api/users/me の workspace 文脈（nullable）。
     *
     * Religo では **1 workspace ≒ 1 BNI チャプター（DragonFly）** として運用する前提（複数 workspace は将来拡張）。
     */
    public static function resolveWorkspaceIdForOwnerMember(?int $ownerMemberId): ?int
    {
        if ($ownerMemberId !== null) {
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
        }

        return self::defaultChapterWorkspaceId();
    }

    public static function defaultChapterWorkspaceId(): ?int
    {
        $id = Workspace::query()->orderBy('id')->value('id');

        return $id !== null ? (int) $id : null;
    }
}
