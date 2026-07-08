<?php

namespace App\Services\Religo;

use App\Models\Member;
use App\Models\OneToOne;
use Illuminate\Support\Collection;

/**
 * SPEC-022: つなぐ準備 AI 入力コーパス（A/B 双方の 121 抜粋）。
 */
final class ReferralConnectCopyCorpusBuilder
{
    private const EXCERPT_CHARS = 2000;

    /**
     * @return array{prompt_text: string, source_o2o_ids: list<int>}
     */
    public function build(
        int $connectorMemberId,
        string $connectorName,
        Member $partyA,
        ?Member $partyB,
        ?string $partyBLabel,
        array $suggestionContext,
        ?string $parentDocument,
    ): array {
        $sections = [];
        $sourceIds = [];

        $sections[] = '# つなぎ手（文案を送る人）';
        $sections[] = "member_id: {$connectorMemberId}（{$connectorName}）";
        $sections[] = '';
        $sections[] = '# パーティ A';
        $sections[] = $this->formatMemberLine($partyA);
        $sections[] = '';
        $sections[] = '# パーティ B';
        if ($partyB !== null) {
            $sections[] = $this->formatMemberLine($partyB);
        } else {
            $sections[] = '（章外・未登録）: '.($partyBLabel ?? '—');
        }
        $sections[] = '';
        $sections[] = '# リファーラル提案（きっかけ）';
        $sections[] = 'summary: '.($suggestionContext['summary'] ?? '—');
        $sections[] = 'direction: '.($suggestionContext['direction'] ?? '—');
        $sections[] = 'rationale: '.($suggestionContext['rationale'] ?? '—');
        if (! empty($suggestionContext['suggested_contact_label'])) {
            $sections[] = 'contact: '.$suggestionContext['suggested_contact_label'];
        }

        if ($parentDocument !== null && trim($parentDocument) !== '') {
            $sections[] = '';
            $sections[] = '# 親議事録（121 または定例会）抜粋';
            $sections[] = $this->truncate($parentDocument);
        }

        $memberIds = array_filter([$partyA->id, $partyB?->id]);
        foreach ($memberIds as $targetId) {
            $rows = $this->connectorOneToOnesWithTarget($connectorMemberId, (int) $targetId);
            if ($rows->isEmpty()) {
                continue;
            }
            $sections[] = '';
            $sections[] = "# つなぎ手 ↔ member_id={$targetId} の 1 to 1 抜粋";
            foreach ($rows as $row) {
                $sections[] = $this->formatO2oExcerpt($row);
                $sourceIds[] = (int) $row->id;
            }
        }

        return [
            'prompt_text' => implode("\n", $sections),
            'source_o2o_ids' => array_values(array_unique($sourceIds)),
        ];
    }

    /**
     * @return Collection<int, OneToOne>
     */
    private function connectorOneToOnesWithTarget(int $ownerId, int $targetId): Collection
    {
        return OneToOne::query()
            ->where('owner_member_id', $ownerId)
            ->where('target_member_id', $targetId)
            ->where('status', 'completed')
            ->whereNotNull('notes')
            ->where('notes', '!=', '')
            ->orderByDesc('started_at')
            ->orderByDesc('id')
            ->limit(3)
            ->get(['id', 'started_at', 'notes']);
    }

    private function formatMemberLine(Member $member): string
    {
        $member->loadMissing('category:id,name');
        $cat = $member->category?->name ?? '—';

        return "member_id: {$member->id} · {$member->name}（{$cat}）";
    }

    private function formatO2oExcerpt(OneToOne $row): string
    {
        $date = $row->started_at?->format('Y-m-d') ?? '—';

        return "--- 121 #{$row->id} ({$date})\n".$this->truncate((string) $row->notes);
    }

    private function truncate(string $text): string
    {
        $text = trim($text);
        if (mb_strlen($text) <= self::EXCERPT_CHARS) {
            return $text;
        }

        return mb_substr($text, 0, self::EXCERPT_CHARS).'…';
    }
}
