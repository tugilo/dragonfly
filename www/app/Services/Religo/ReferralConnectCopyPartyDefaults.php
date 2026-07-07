<?php

namespace App\Services\Religo;

/**
 * SPEC-022: 提案行からパーティ A/B の初期値を導出（案2 — UI 初期値のみ、サーバでも参照可）。
 */
final class ReferralConnectCopyPartyDefaults
{
    /**
     * @param  array<string, mixed>  $suggestion
     * @return array{party_a_member_id: int|null, party_b_member_id: int|null, party_b_label: string|null}
     */
    public static function fromSuggestion(array $suggestion, int $ownerMemberId, ?int $subjectMemberId): array
    {
        $direction = (string) ($suggestion['direction'] ?? '');
        $fromId = self::intOrNull($suggestion['suggested_from_member_id'] ?? null);
        $toId = self::intOrNull($suggestion['suggested_to_member_id'] ?? null);
        $toLabel = self::trimOrNull($suggestion['suggested_to_label'] ?? null);
        $contactLabel = self::trimOrNull($suggestion['suggested_contact_label'] ?? null);
        $rowSubjectId = self::intOrNull($suggestion['subject_member_id'] ?? null);
        $subjectId = $rowSubjectId ?? $subjectMemberId;

        $partyA = null;
        $partyB = null;
        $partyBLabel = null;

        if ($direction === 'via_connector') {
            $partyA = $ownerMemberId;
            $partyB = $fromId;
            if ($partyB === null && $contactLabel !== null) {
                $partyBLabel = $contactLabel;
            }
        } elseif ($direction === 'subject_should_meet') {
            $partyA = $subjectId ?? $ownerMemberId;
            $partyB = $toId;
        } elseif ($direction === 'target_to_owner') {
            $partyA = $fromId ?? $subjectId ?? $ownerMemberId;
            $partyB = $ownerMemberId;
        } else {
            $partyA = $fromId ?? $ownerMemberId;
            $partyB = $toId;
            if ($partyB === null && $toLabel !== null) {
                $partyBLabel = $toLabel;
            }
        }

        if ($partyA === null) {
            $partyA = $ownerMemberId;
        }

        if ($partyB === null && $partyBLabel === null) {
            $partyBLabel = $contactLabel ?? $toLabel;
        }

        return [
            'party_a_member_id' => $partyA,
            'party_b_member_id' => $partyB,
            'party_b_label' => $partyBLabel,
        ];
    }

    private static function intOrNull(mixed $value): ?int
    {
        if ($value === null || $value === '') {
            return null;
        }

        return (int) $value;
    }

    private static function trimOrNull(mixed $value): ?string
    {
        if ($value === null) {
            return null;
        }
        $s = trim((string) $value);

        return $s === '' ? null : $s;
    }
}
