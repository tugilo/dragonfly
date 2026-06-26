<?php

namespace App\Services\Sonae;

use App\Models\Member;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeMember;
use App\Models\Workspace;
use App\Support\MemberEnrollmentType;
use Illuminate\Support\Facades\DB;

/**
 * SPEC-017: Religo members → sonae_members 同期。
 */
class SonaeMemberSyncService
{
    /**
     * @return array{synced: int, skipped: int}
     */
    public function syncChapterFromReligo(SonaeChapter $chapter, Workspace $workspace): array
    {
        $synced = 0;
        $skipped = 0;

        Member::query()
            ->where('workspace_id', $workspace->id)
            ->orderBy('id')
            ->chunkById(100, function ($members) use ($chapter, &$synced, &$skipped) {
                foreach ($members as $member) {
                    if ($this->syncOne($chapter, $member)) {
                        $synced++;
                    } else {
                        $skipped++;
                    }
                }
            });

        return ['synced' => $synced, 'skipped' => $skipped];
    }

    public function syncOne(SonaeChapter $chapter, Member $religoMember): bool
    {
        if (empty($religoMember->name)) {
            return false;
        }

        if (! MemberEnrollmentType::isBniMember($religoMember->type)) {
            return false;
        }

        $categoryName = null;
        if ($religoMember->relationLoaded('category') || $religoMember->category_id) {
            $religoMember->loadMissing('category');
            $categoryName = $religoMember->category?->name;
        }

        $roleLabel = $religoMember->currentRole()?->name;

        DB::transaction(function () use ($chapter, $religoMember, $categoryName, $roleLabel) {
            SonaeMember::query()->updateOrCreate(
                [
                    'chapter_id' => $chapter->id,
                    'source_system' => SonaeConstants::SOURCE_RELIGO,
                    'external_id' => (string) $religoMember->id,
                ],
                [
                    'name' => $religoMember->name,
                    'name_kana' => $religoMember->name_kana,
                    'email' => $religoMember->email,
                    'category' => $categoryName,
                    'role_label' => $roleLabel,
                    'status' => SonaeConstants::STATUS_ACTIVE,
                ]
            );
        });

        return true;
    }
}
