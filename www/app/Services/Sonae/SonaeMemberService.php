<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeMember;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

/**
 * SPEC-017 §2.6: sonae_members 名簿の参照・更新・KPI。
 */
class SonaeMemberService
{
    /**
     * @return array{
     *     roster_count: int,
     *     linked_count: int,
     *     link_rate: float|null,
     *     unlinked_count: int
     * }
     */
    public function chapterKpi(SonaeChapter $chapter): array
    {
        $rosterCount = SonaeMember::query()
            ->where('chapter_id', $chapter->id)
            ->where('status', SonaeConstants::STATUS_ACTIVE)
            ->count();

        $linkedCount = SonaeMember::query()
            ->where('chapter_id', $chapter->id)
            ->where('status', SonaeConstants::STATUS_ACTIVE)
            ->whereHas('lineUserLinks', function ($query) {
                $query->where('status', SonaeConstants::LINE_LINK_ACTIVE);
            })
            ->count();

        $unlinkedCount = max(0, $rosterCount - $linkedCount);

        return [
            'roster_count' => $rosterCount,
            'linked_count' => $linkedCount,
            'link_rate' => $rosterCount > 0 ? round($linkedCount / $rosterCount, 4) : null,
            'unlinked_count' => $unlinkedCount,
        ];
    }

    public function listMembers(SonaeChapter $chapter, int $perPage = 50): LengthAwarePaginator
    {
        return SonaeMember::query()
            ->where('chapter_id', $chapter->id)
            ->with(['activeLineUserLink'])
            ->orderBy('name')
            ->paginate($perPage);
    }

    /**
     * @return Collection<int, SonaeMember>
     */
    public function listUnlinkedMembers(SonaeChapter $chapter): Collection
    {
        return SonaeMember::query()
            ->where('chapter_id', $chapter->id)
            ->where('status', SonaeConstants::STATUS_ACTIVE)
            ->whereDoesntHave('lineUserLinks', function ($query) {
                $query->where('status', SonaeConstants::LINE_LINK_ACTIVE);
            })
            ->orderBy('name')
            ->get();
    }

    /**
     * @param  array<string, mixed>  $attributes
     */
    public function updateMember(SonaeMember $member, array $attributes): SonaeMember
    {
        $allowed = array_intersect_key($attributes, array_flip([
            'name',
            'name_kana',
            'email',
            'phone',
            'category',
            'role_label',
            'status',
        ]));

        if ($allowed !== []) {
            $member->fill($allowed);
            $member->save();
        }

        return $member->fresh(['activeLineUserLink']);
    }

    /**
     * @return array<string, mixed>
     */
    public function memberToArray(SonaeMember $member): array
    {
        return [
            'id' => $member->id,
            'chapter_id' => $member->chapter_id,
            'name' => $member->name,
            'name_kana' => $member->name_kana,
            'email' => $member->email,
            'phone' => $member->phone,
            'category' => $member->category,
            'role_label' => $member->role_label,
            'source_system' => $member->source_system,
            'external_id' => $member->external_id,
            'status' => $member->status,
            'line_linked' => $member->hasActiveLineLink(),
            'line_user_id' => $member->activeLineUserLink?->line_user_id,
        ];
    }
}
