<?php

namespace App\Services\Religo;

/**
 * 提案 API レスポンス用の表示補助（氏名・根拠リンク文言）。
 */
final class ReferralSuggestionDisplayHelper
{
    /**
     * @param  list<array{id: int, name: string, category: string|null}>  $roster
     * @return array<int, string>
     */
    public function nameMapFromRoster(array $roster): array
    {
        $map = [];
        foreach ($roster as $row) {
            $map[(int) $row['id']] = (string) $row['name'];
        }

        return $map;
    }

    public function memberName(?int $memberId, array $nameMap): ?string
    {
        if ($memberId === null || $memberId <= 0) {
            return null;
        }

        return $nameMap[$memberId] ?? null;
    }

    /**
     * @return list<string>
     */
    public function evidenceLines(
        ?int $sourceOneToOneId,
        ?int $sourceMeetingId,
        ?string $rationale,
    ): array {
        $lines = [];
        if ($sourceOneToOneId !== null && $sourceOneToOneId > 0) {
            $lines[] = "根拠 121: #{$sourceOneToOneId}";
        }
        if ($sourceMeetingId !== null && $sourceMeetingId > 0) {
            $lines[] = "根拠 定例会: meeting_id={$sourceMeetingId}";
        }
        if ($rationale !== null && trim($rationale) !== '') {
            $lines[] = trim($rationale);
        }

        return $lines;
    }

    /**
     * @param  array<string, mixed>  $row
     * @return array<string, mixed>
     */
    public function enrichSuggestion(array $row, array $nameMap, ?int $subjectMemberId = null): array
    {
        $fromId = isset($row['suggested_from_member_id']) ? (int) $row['suggested_from_member_id'] : null;
        $toId = isset($row['suggested_to_member_id']) ? (int) $row['suggested_to_member_id'] : null;
        $subjectId = isset($row['subject_member_id']) ? (int) $row['subject_member_id'] : $subjectMemberId;

        $row['suggested_from_member_name'] = $this->memberName($fromId, $nameMap);
        $row['suggested_to_member_name'] = $this->memberName($toId, $nameMap);
        if ($subjectId !== null && $subjectId > 0) {
            $row['subject_member_name'] = $this->memberName($subjectId, $nameMap);
        }
        $row['evidence_lines'] = $this->evidenceLines(
            isset($row['source_one_to_one_id']) ? (int) $row['source_one_to_one_id'] : null,
            isset($row['source_meeting_id']) ? (int) $row['source_meeting_id'] : null,
            isset($row['rationale']) ? (string) $row['rationale'] : null,
        );

        return $row;
    }
}
