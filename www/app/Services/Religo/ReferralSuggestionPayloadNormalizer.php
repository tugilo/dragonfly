<?php

namespace App\Services\Religo;

use Illuminate\Support\Collection;

/**
 * AI 出力 JSON のパースとサーバ側検証。
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
                if ($fromId === null || $contactLabel === null) {
                    continue;
                }
            } elseif ($direction === 'subject_should_meet') {
                $matchId = $this->filterId(
                    $item['match_member_id'] ?? $item['suggested_to_member_id'] ?? null,
                    $validMemberIds,
                );
                if ($matchId === null || $matchId === $targetMemberId) {
                    continue;
                }
                $fromId = $this->filterId($item['suggested_from_member_id'] ?? null, $validMemberIds, [$ownerMemberId])
                    ?? $ownerMemberId;
                $toId = $matchId;
                $contactLabel = null;
                $corpusSource = $corpusFromAi === 'member_network' ? 'member_network' : 'self';
                if ($relationshipMode && $sourceO2oId > 0) {
                    $corpusSource = 'member_network';
                }
            } else {
                $fromId = $this->filterId($item['suggested_from_member_id'] ?? null, $validMemberIds, [$ownerMemberId, $targetMemberId]);
                $toId = $this->filterId($item['suggested_to_member_id'] ?? null, $validMemberIds);
                $contactLabel = null;
                $corpusSource = $corpusFromAi === 'member_network' ? 'member_network' : 'self';
            }

            $out[] = [
                'direction' => $direction,
                'corpus_source' => $corpusSource,
                'summary' => $summary,
                'rationale' => $this->nullableString($item['rationale'] ?? null),
                'quality_notes' => $this->encodeQualityNotes($item['quality_notes'] ?? null),
                'suggested_from_member_id' => $fromId,
                'suggested_to_member_id' => $toId,
                'suggested_to_label' => $toId === null ? $this->nullableString($item['suggested_to_label'] ?? null) : null,
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
                if ($fromId === null || $contactLabel === null) {
                    continue;
                }
            } elseif ($direction === 'subject_should_meet') {
                $matchId = $this->filterId(
                    $item['match_member_id'] ?? $item['suggested_to_member_id'] ?? null,
                    $validMemberIds,
                );
                if ($matchId === null || ($subjectId !== null && $matchId === $subjectId)) {
                    continue;
                }
                $fromId = $this->filterId($item['suggested_from_member_id'] ?? null, $validMemberIds, [$ownerMemberId])
                    ?? $ownerMemberId;
                $toId = $matchId;
                $contactLabel = null;
                $corpusSource = $corpusFromAi === 'member_network' ? 'member_network' : 'self';
                if ($relationshipMode && $sourceO2oId > 0) {
                    $corpusSource = 'member_network';
                }
            } else {
                $fromId = $this->filterId($item['suggested_from_member_id'] ?? null, $validMemberIds, [$ownerMemberId, $subjectId]);
                $toId = $this->filterId($item['suggested_to_member_id'] ?? null, $validMemberIds);
                $contactLabel = null;
                $corpusSource = $corpusFromAi === 'member_network' ? 'member_network' : 'self';
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
                'suggested_to_label' => $toId === null ? $this->nullableString($item['suggested_to_label'] ?? null) : null,
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
