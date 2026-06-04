<?php

namespace App\Services\Religo;

use App\Models\Introduction;
use App\Models\Member;

/**
 * 主役・依頼者に関する introductions 要約（Pack 用・§0.1 C）。
 */
final class ReferralRelationshipIntroductionSummary
{
    private const MAX_ROWS = 20;

    /**
     * @return array{prompt_section: string, count: int}
     */
    public function buildSection(
        ?int $workspaceId,
        int $subjectMemberId,
        int $requesterMemberId,
    ): array {
        $memberIds = array_values(array_unique(array_filter([
            $subjectMemberId,
            $requesterMemberId,
        ], fn ($id) => $id > 0)));

        if ($memberIds === []) {
            return ['prompt_section' => '', 'count' => 0];
        }

        $q = Introduction::query()
            ->where(function ($q) use ($memberIds) {
                $q->whereIn('from_member_id', $memberIds)
                    ->orWhereIn('to_member_id', $memberIds);
            })
            ->orderByDesc('introduced_at')
            ->orderByDesc('id')
            ->limit(self::MAX_ROWS);

        if ($workspaceId !== null) {
            $q->where(function ($q) use ($workspaceId) {
                $q->where('workspace_id', $workspaceId)->orWhereNull('workspace_id');
            });
        }

        $rows = $q->get(['id', 'from_member_id', 'to_member_id', 'introduced_at', 'note']);
        if ($rows->isEmpty()) {
            return ['prompt_section' => '', 'count' => 0];
        }

        $nameMap = Member::query()
            ->whereIn('id', $rows->flatMap(fn ($r) => [$r->from_member_id, $r->to_member_id])->unique()->all())
            ->pluck('name', 'id')
            ->all();

        $lines = [
            '# 既知の紹介履歴（introductions）— 同じ from/to の重複提案はしない',
        ];
        foreach ($rows as $row) {
            $fromName = $nameMap[$row->from_member_id] ?? "#{$row->from_member_id}";
            $toName = $nameMap[$row->to_member_id] ?? "#{$row->to_member_id}";
            $date = $row->introduced_at?->format('Y-m-d') ?? '?';
            $note = trim((string) $row->note);
            $noteExcerpt = $note === '' ? '' : ' — '.mb_substr($note, 0, 80).(mb_strlen($note) > 80 ? '…' : '');
            $lines[] = "- intro #{$row->id}: {$fromName} → {$toName} ({$date}){$noteExcerpt}";
        }

        return [
            'prompt_section' => implode("\n", $lines),
            'count' => $rows->count(),
        ];
    }
}
