<?php

namespace App\Services\Religo;

use App\Models\Member;
use Illuminate\Support\Collection;

/**
 * workspace メンバー名簿サマリ（氏名・カテゴリ・id）— AI 入力用。
 */
final class ReferralSuggestionMemberRoster
{
    /**
     * @return list<array{id: int, name: string, category: string|null}>
     */
    public function rosterForWorkspace(?int $workspaceId): array
    {
        if ($workspaceId === null) {
            return [];
        }

        return Member::query()
            ->with('category:id,name')
            ->where('workspace_id', $workspaceId)
            ->orderBy('name')
            ->get(['id', 'name', 'category_id'])
            ->map(fn (Member $m) => [
                'id' => (int) $m->id,
                'name' => (string) $m->name,
                'category' => $m->category?->name,
            ])
            ->values()
            ->all();
    }

    /**
     * @param  list<array{id: int, name: string, category: string|null}>  $roster
     */
    public function formatRosterForPrompt(array $roster): string
    {
        if ($roster === []) {
            return '（名簿なし）';
        }

        $lines = [];
        foreach ($roster as $row) {
            $cat = $row['category'] ?? '—';
            $lines[] = "- id={$row['id']}: {$row['name']}（{$cat}）";
        }

        return implode("\n", $lines);
    }

    /**
     * @param  Collection<int, int>  $validIds
     */
    public function filterMemberId(?int $memberId, Collection $validIds): ?int
    {
        if ($memberId === null) {
            return null;
        }

        return $validIds->contains($memberId) ? $memberId : null;
    }

    /**
     * @param  list<array{id: int, name: string, category: string|null}>  $roster
     * @return Collection<int, int>
     */
    public function validMemberIds(array $roster): Collection
    {
        return collect($roster)->pluck('id')->map(fn ($id) => (int) $id);
    }
}
