<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeMember;
use Illuminate\Support\Collection;

/**
 * SPEC-017 §5.5: LINE 紐付け済み active メンバーのみを通知対象として解決する。
 */
class SonaeNotificationTargetResolver
{
    /**
     * @return Collection<int, SonaeMember>
     */
    public function resolveLinkedActiveMembers(SonaeChapter $chapter): Collection
    {
        return SonaeMember::query()
            ->where('chapter_id', $chapter->id)
            ->where('status', SonaeConstants::STATUS_ACTIVE)
            ->whereHas('lineUserLinks', function ($query) {
                $query->where('status', SonaeConstants::LINE_LINK_ACTIVE);
            })
            ->with(['activeLineUserLink'])
            ->orderBy('id')
            ->get();
    }
}
