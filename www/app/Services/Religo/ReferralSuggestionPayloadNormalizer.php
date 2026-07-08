<?php

namespace App\Services\Religo;

use Illuminate\Support\Collection;

/**
 * AI 出力 JSON のパースとサーバ側検証。
 *
 * 同章メンバー同士の「紹介」（subject_should_meet 等）は採用しない — 定例会で既に接続済みのため。
 * 社外紹介（suggested_to_label）と via_connector（つなぎ手→依頼者）のみ。
 */
final class ReferralSuggestionPayloadNormalizer
{
    private const CONFIDENCE = ['high', 'medium', 'low'];

    private const O2O_DIRECTIONS = [
        'owner_to_target',
        'target_to_owner',
        'mutual',
        'unclear',
        'subject_should_meet',
        'via_connector',
    ];

    private const MEETING_DIRECTIONS = [
        'subject_seeks_intros',
        'owner_introduces_to_subject',
        'owner_introduces_subject',
        'mutual',
        'unclear',
        'subject_should_meet',
        'via_connector',
    ];

    private const MEETING_SECTIONS = [
        'main_presentation',
        'weekly_presentation',
        'visitor_intro',
        'share_story',
        'education',
        'other',
    ];

    /**
     * @param  Collection<int, int>  $validMemberIds
     * @return list<array<string, mixed>>
     */
    public function parseOneToOneSuggestions(
        string $rawJson,
        Collection $validMemberIds,
        int $ownerMemberId,
        ?int $targetMemberId,
        bool $relationshipMode = false,
    ): array {
        $items = $this->extractSuggestionsArray($rawJson);
        $out = [];
        foreach ($items as $item) {
            if (! is_array($item)) {
                continue;
            }
            $summary = trim((string) ($item['summary'] ?? ''));
            if ($summary === '') {
                continue;
            }
            $direction = (string) ($item['direction'] ?? 'unclear');
            if (! in_array($direction, self::O2O_DIRECTIONS, true)) {
                $direction = 'unclear';
            }
            $confidence = (string) ($item['confidence'] ?? 'medium');
            if (! in_array($confidence, self::CONFIDENCE, true)) {
                $confidence = 'medium';
            }

            $connectorId = $this->filterId(
                $item['connector_member_id'] ?? null,
                $validMemberIds,
            );

            $sourceO2oId = isset($item['source_one_to_one_id']) ? (int) $item['source_one_to_one_id'] : null;
            $sourceMeetingId = isset($item['source_meeting_id']) ? (int) $item['source_meeting_id'] : null;
            $corpusFromAi = (string) ($item['corpus_source'] ?? '');

            if ($direction === 'via_connector') {
                $fromId = $connectorId ?? $this->filterId($item['suggested_from_member_id'] ?? null, $validMemberIds);
                $toId = $this->filterId($item['suggested_to_member_id'] ?? null, $validMemberIds, [$ownerMemberId])
                    ?? $ownerMemberId;
                $contactLabel = $this->nullableString(
                    $item['suggested_contact_label'] ?? $item['suggested_to_label'] ?? null,
                );
                $corpusSource = 'member_network';
                if ($this->rejectInvalidViaConnector($fromId, $toId, $ownerMemberId) || $contactLabel === null) {
                    continue;
                }
            } else {
                $fromId = $this->filterId($item['suggested_from_member_id'] ?? null, $validMemberIds, [$ownerMemberId, $targetMemberId]);
                $toId = $this->filterId($item['suggested_to_member_id'] ?? null, $validMemberIds);
                $contactLabel = null;
                $corpusSource = $corpusFromAi === 'member_network' ? 'member_network' : 'self';
            }

            if ($this->rejectSameChapterMemberReferral($direction, $toId, $fromId, $validMemberIds, $ownerMemberId, $targetMemberId, null)) {
                continue;
            }

            $out[] = [
                'direction' => $direction,
                'corpus_source' => $corpusSource,
                'summary' => $summary,
                'rationale' => $this->nullableString($item['rationale'] ?? null),
                'quality_notes' => $this->encodeQualityNotes($item['quality_notes'] ?? null),
                'suggested_from_member_id' => $fromId,
                'suggested_to_member_id' => $toId,
                'suggested_to_label' => $toId === null
                    ? $this->nullableString($item['suggested_to_label'] ?? $item['suggested_contact_label'] ?? null)
                    : null,
                'suggested_contact_label' => $contactLabel,
                'source_one_to_one_id' => $sourceO2oId > 0 ? $sourceO2oId : null,
                'source_meeting_id' => $sourceMeetingId > 0 ? $sourceMeetingId : null,
                'confidence' => $confidence,
            ];
        }

        return $out;
    }

    /**
     * @param  Collection<int, int>  $validMemberIds
     * @return list<array<string, mixed>>
     */
    public function parseMeetingSuggestions(
        string $rawJson,
        Collection $validMemberIds,
        int $ownerMemberId,
        bool $relationshipMode = false,
    ): array {
        $items = $this->extractSuggestionsArray($rawJson);
        $out = [];
        foreach ($items as $item) {
            if (! is_array($item)) {
                continue;
            }
            $summary = trim((string) ($item['summary'] ?? ''));
            if ($summary === '') {
                continue;
            }
            $direction = (string) ($item['direction'] ?? 'unclear');
            if (! in_array($direction, self::MEETING_DIRECTIONS, true)) {
                $direction = 'unclear';
            }
            $section = (string) ($item['source_section'] ?? 'other');
            if (! in_array($section, self::MEETING_SECTIONS, true)) {
                $section = 'other';
            }
            $confidence = (string) ($item['confidence'] ?? 'medium');
            if (! in_array($confidence, self::CONFIDENCE, true)) {
                $confidence = 'medium';
            }
            $subjectId = $this->filterId($item['subject_member_id'] ?? null, $validMemberIds);

            $connectorId = $this->filterId(
                $item['connector_member_id'] ?? null,
                $validMemberIds,
            );

            $sourceO2oId = isset($item['source_one_to_one_id']) ? (int) $item['source_one_to_one_id'] : null;
            $sourceMeetingId = isset($item['source_meeting_id']) ? (int) $item['source_meeting_id'] : null;
            $corpusFromAi = (string) ($item['corpus_source'] ?? '');

            if ($direction === 'via_connector') {
                $fromId = $connectorId ?? $this->filterId($item['suggested_from_member_id'] ?? null, $validMemberIds);
                $toId = $this->filterId($item['suggested_to_member_id'] ?? null, $validMemberIds, [$ownerMemberId])
                    ?? $ownerMemberId;
                $contactLabel = $this->nullableString(
                    $item['suggested_contact_label'] ?? $item['suggested_to_label'] ?? null,
                );
                $corpusSource = 'member_network';
                if ($this->rejectInvalidViaConnector($fromId, $toId, $ownerMemberId) || $contactLabel === null) {
                    continue;
                }
            } else {
                $fromId = $this->filterId($item['suggested_from_member_id'] ?? null, $validMemberIds, [$ownerMemberId, $subjectId]);
                $toId = $this->filterId($item['suggested_to_member_id'] ?? null, $validMemberIds);
                $contactLabel = null;
                $corpusSource = $corpusFromAi === 'member_network' ? 'member_network' : 'self';
            }

            if ($this->rejectSameChapterMemberReferral($direction, $toId, $fromId, $validMemberIds, $ownerMemberId, null, $subjectId)) {
                continue;
            }

            $toLabel = $toId === null
                ? $this->nullableString($item['suggested_to_label'] ?? $item['suggested_contact_label'] ?? null)
                : null;
            if ($toId !== null && $toLabel === null && $direction !== 'via_connector') {
                if ($subjectId === null || $toId !== $subjectId) {
                    continue;
                }
            }

            $out[] = [
                'source_section' => $section,
                'subject_member_id' => $subjectId,
                'direction' => $direction,
                'corpus_source' => $corpusSource,
                'summary' => $summary,
                'rationale' => $this->nullableString($item['rationale'] ?? null),
                'quality_notes' => $this->encodeQualityNotes($item['quality_notes'] ?? null),
                'suggested_from_member_id' => $fromId ?? $ownerMemberId,
                'suggested_to_member_id' => $toId,
                'suggested_to_label' => $toLabel,
                'suggested_contact_label' => $contactLabel,
                'source_one_to_one_id' => $sourceO2oId > 0 ? $sourceO2oId : null,
                'source_meeting_id' => $sourceMeetingId > 0 ? $sourceMeetingId : null,
                'confidence' => $confidence,
            ];
        }

        return $out;
    }

    /**
     * @return list<mixed>
     */
    private function extractSuggestionsArray(string $raw): array
    {
        $raw = trim($raw);
        if ($raw === '') {
            return [];
        }
        if (str_starts_with($raw, '```')) {
            $raw = preg_replace('/^```(?:json)?\s*/i', '', $raw) ?? $raw;
            $raw = preg_replace('/\s*```\s*$/', '', $raw) ?? $raw;
        }
        $decoded = json_decode($raw, true);
        if (! is_array($decoded)) {
            return [];
        }
        $suggestions = $decoded['suggestions'] ?? $decoded;
        if (! is_array($suggestions)) {
            return [];
        }

        return array_values($suggestions);
    }

    /**
     * 章内メンバー同士の紹介候補を弾く（社外・つなぎ手経由は残す）。
     */
    private function rejectSameChapterMemberReferral(
        string $direction,
        ?int $toId,
        ?int $fromId,
        Collection $validMemberIds,
        int $requesterMemberId,
        ?int $o2oTargetMemberId,
        ?int $meetingSubjectMemberId,
    ): bool {
        if ($direction === 'subject_should_meet') {
            return true;
        }

        if ($toId === null || ! $validMemberIds->contains($toId)) {
            return false;
        }

        if ($direction === 'via_connector' && $toId === $requesterMemberId) {
            return false;
        }

        if ($o2oTargetMemberId !== null && $toId === $o2oTargetMemberId) {
            return false;
        }

        if ($meetingSubjectMemberId !== null && $toId === $meetingSubjectMemberId) {
            return false;
        }

        return true;
    }

    private function rejectInvalidViaConnector(?int $fromId, ?int $toId, int $ownerMemberId): bool
    {
        if ($fromId === null || $toId === null) {
            return true;
        }

        return $fromId === $ownerMemberId || $fromId === $toId;
    }

    /**
     * @param  list<int|null>  $fallbackPool
     */
    private function filterId(mixed $value, Collection $validMemberIds, array $fallbackPool = []): ?int
    {
        if ($value === null || $value === '') {
            return null;
        }
        $id = (int) $value;
        if ($validMemberIds->contains($id)) {
            return $id;
        }
        foreach ($fallbackPool as $fb) {
            if ($fb !== null && $validMemberIds->contains((int) $fb)) {
                return (int) $fb;
            }
        }

        return null;
    }

    private function nullableString(mixed $value): ?string
    {
        if ($value === null) {
            return null;
        }
        $s = trim((string) $value);

        return $s === '' ? null : $s;
    }

    private function encodeQualityNotes(mixed $value): ?string
    {
        if ($value === null) {
            return null;
        }
        if (is_array($value)) {
            $encoded = json_encode($value, JSON_UNESCAPED_UNICODE);

            return $encoded === false ? null : $encoded;
        }

        return $this->nullableString($value);
    }
}
