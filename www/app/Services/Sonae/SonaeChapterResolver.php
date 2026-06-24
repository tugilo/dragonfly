<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\User;
use App\Models\Workspace;
use App\Services\Religo\ReligoActorContext;

/**
 * SPEC-017 Phase 248: Religo workspace → SONAE chapter 解決。
 */
class SonaeChapterResolver
{
    public function findByWorkspaceId(int $workspaceId): ?SonaeChapter
    {
        return SonaeChapter::query()
            ->where('source_system', SonaeConstants::SOURCE_RELIGO)
            ->where('external_id', (string) $workspaceId)
            ->first();
    }

    public function resolveWorkspaceIdForUser(?User $user): ?int
    {
        return ReligoActorContext::resolveWorkspaceIdForUser($user);
    }

    public function resolveChapterForUser(?User $user): ?SonaeChapter
    {
        $workspaceId = $this->resolveWorkspaceIdForUser($user);
        if ($workspaceId === null) {
            return null;
        }

        return $this->findByWorkspaceId($workspaceId);
    }

    public function chapterAccessibleToUser(SonaeChapter $chapter, ?User $user): bool
    {
        $workspaceId = $this->resolveWorkspaceIdForUser($user);
        if ($workspaceId === null) {
            return false;
        }

        return $chapter->source_system === SonaeConstants::SOURCE_RELIGO
            && $chapter->external_id === (string) $workspaceId;
    }

    public function workspaceForUser(?User $user): ?Workspace
    {
        $workspaceId = $this->resolveWorkspaceIdForUser($user);
        if ($workspaceId === null) {
            return null;
        }

        return Workspace::query()->find($workspaceId);
    }
}
