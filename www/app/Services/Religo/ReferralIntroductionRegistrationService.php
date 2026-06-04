<?php

namespace App\Services\Religo;

use App\Models\Introduction;
use App\Models\Meeting;
use App\Models\MeetingReferralSuggestion;
use App\Models\OneToOne;
use App\Models\OneToOneReferralSuggestion;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;

/**
 * SPEC-015/016 Phase C: 提案 → introductions 登録。
 */
class ReferralIntroductionRegistrationService
{
    /**
     * @param  array<string, mixed>  $data
     * @return array{suggestion: array<string, mixed>, introduction: array<string, mixed>}
     */
    public function registerFromOneToOne(
        OneToOneReferralSuggestion $suggestion,
        int $ownerMemberId,
        array $data,
        callable $formatSuggestion,
    ): array {
        $suggestion->load(['run', 'oneToOne']);
        $this->assertOwner($suggestion->run->owner_member_id, $ownerMemberId);
        if ($suggestion->introduction_id !== null) {
            throw new InvalidArgumentException('この提案は既に紹介履歴に登録済みです。');
        }

        $oneToOne = $suggestion->oneToOne;
        if ($oneToOne === null) {
            throw new InvalidArgumentException('1 to 1 が見つかりません。');
        }

        $fromId = (int) ($data['from_member_id'] ?? $suggestion->suggested_from_member_id ?? 0);
        $toId = (int) ($data['to_member_id'] ?? $suggestion->suggested_to_member_id ?? 0);
        if ($fromId <= 0 || $toId <= 0) {
            throw new InvalidArgumentException('from_member_id と to_member_id（メンバー）が必要です。チャプター外の紹介先はラベルのみのため、to をメンバーで指定してください。');
        }
        if ($fromId === $toId) {
            throw new InvalidArgumentException('from_member_id と to_member_id は異なる必要があります。');
        }

        $note = $this->resolveNote(
            $data['note'] ?? null,
            $suggestion->summary,
            $suggestion->rationale,
            $suggestion->suggested_to_label,
            sprintf('[1 to 1 提案 #%d / 121 #%d]', $suggestion->id, $oneToOne->id),
        );

        $introducedAt = $data['introduced_at'] ?? $this->defaultOneToOneIntroducedAt($oneToOne);
        $snapshot = $data['edited_snapshot'] ?? $this->buildSnapshot($suggestion, $fromId, $toId, $note, $introducedAt);

        return DB::transaction(function () use (
            $suggestion,
            $ownerMemberId,
            $oneToOne,
            $fromId,
            $toId,
            $note,
            $introducedAt,
            $snapshot,
            $formatSuggestion,
        ) {
            $introduction = Introduction::create([
                'workspace_id' => $oneToOne->workspace_id,
                'owner_member_id' => $ownerMemberId,
                'from_member_id' => $fromId,
                'to_member_id' => $toId,
                'referral_kind' => 'external',
                'meeting_id' => null,
                'note' => $note,
                'introduced_at' => $introducedAt,
            ]);

            $suggestion->status = OneToOneReferralSuggestion::STATUS_ACCEPTED;
            $suggestion->accepted_at = now();
            $suggestion->introduction_id = $introduction->id;
            $suggestion->edited_snapshot = $snapshot;
            $suggestion->save();

            return [
                'suggestion' => $formatSuggestion($suggestion->fresh()),
                'introduction' => $this->formatIntroduction($introduction),
            ];
        });
    }

    /**
     * @param  array<string, mixed>  $data
     * @return array{suggestion: array<string, mixed>, introduction: array<string, mixed>}
     */
    public function registerFromMeeting(
        MeetingReferralSuggestion $suggestion,
        int $ownerMemberId,
        array $data,
        callable $formatSuggestion,
    ): array {
        $suggestion->load(['run', 'meeting']);
        $this->assertOwner($suggestion->run->owner_member_id, $ownerMemberId);
        if ($suggestion->introduction_id !== null) {
            throw new InvalidArgumentException('この提案は既に紹介履歴に登録済みです。');
        }

        $meeting = $suggestion->meeting;
        if ($meeting === null) {
            throw new InvalidArgumentException('例会が見つかりません。');
        }

        $fromId = (int) ($data['from_member_id'] ?? $suggestion->suggested_from_member_id ?? 0);
        $toId = (int) ($data['to_member_id'] ?? $suggestion->suggested_to_member_id ?? 0);
        if ($fromId <= 0 || $toId <= 0) {
            throw new InvalidArgumentException('from_member_id と to_member_id（メンバー）が必要です。');
        }
        if ($fromId === $toId) {
            throw new InvalidArgumentException('from_member_id と to_member_id は異なる必要があります。');
        }

        $note = $this->resolveNote(
            $data['note'] ?? null,
            $suggestion->summary,
            $suggestion->rationale,
            $suggestion->suggested_to_label,
            sprintf('[定例会提案 #%d / 第%s回]', $suggestion->id, $meeting->number ?? '?'),
        );

        $introducedAt = $data['introduced_at'] ?? $meeting->held_on?->format('Y-m-d');
        $snapshot = $data['edited_snapshot'] ?? $this->buildSnapshot($suggestion, $fromId, $toId, $note, $introducedAt);

        return DB::transaction(function () use (
            $suggestion,
            $ownerMemberId,
            $meeting,
            $fromId,
            $toId,
            $note,
            $introducedAt,
            $snapshot,
            $formatSuggestion,
        ) {
            $introduction = Introduction::create([
                'workspace_id' => $suggestion->run->workspace_id,
                'owner_member_id' => $ownerMemberId,
                'from_member_id' => $fromId,
                'to_member_id' => $toId,
                'referral_kind' => 'external',
                'meeting_id' => $meeting->id,
                'note' => $note,
                'introduced_at' => $introducedAt,
            ]);

            $suggestion->status = MeetingReferralSuggestion::STATUS_ACCEPTED;
            $suggestion->accepted_at = now();
            $suggestion->introduction_id = $introduction->id;
            $suggestion->edited_snapshot = $snapshot;
            $suggestion->save();

            return [
                'suggestion' => $formatSuggestion($suggestion->fresh()),
                'introduction' => $this->formatIntroduction($introduction),
            ];
        });
    }

    private function assertOwner(int $runOwnerId, int $ownerMemberId): void
    {
        if ($runOwnerId !== $ownerMemberId) {
            throw new InvalidArgumentException('権限がありません。');
        }
    }

    private function resolveNote(
        ?string $override,
        string $summary,
        ?string $rationale,
        ?string $suggestedToLabel,
        string $footer,
    ): string {
        if ($override !== null && trim($override) !== '') {
            return trim($override);
        }
        $parts = [trim($summary)];
        if ($rationale !== null && trim($rationale) !== '') {
            $parts[] = '根拠: ' . trim($rationale);
        }
        if ($suggestedToLabel !== null && trim($suggestedToLabel) !== '') {
            $parts[] = '紹介先候補: ' . trim($suggestedToLabel);
        }
        $parts[] = $footer;

        return implode("\n\n", array_filter($parts, fn ($p) => $p !== ''));
    }

    private function defaultOneToOneIntroducedAt(OneToOne $oneToOne): ?string
    {
        $dt = $oneToOne->started_at ?? $oneToOne->scheduled_at;

        return $dt?->format('Y-m-d');
    }

    /**
     * @return array<string, mixed>
     */
    private function buildSnapshot(
        OneToOneReferralSuggestion|MeetingReferralSuggestion $suggestion,
        int $fromId,
        int $toId,
        string $note,
        ?string $introducedAt,
    ): array {
        return [
            'from_member_id' => $fromId,
            'to_member_id' => $toId,
            'note' => $note,
            'introduced_at' => $introducedAt,
            'summary' => $suggestion->summary,
            'registered_at' => now()->toIso8601String(),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatIntroduction(Introduction $r): array
    {
        return [
            'id' => $r->id,
            'workspace_id' => $r->workspace_id,
            'owner_member_id' => $r->owner_member_id,
            'from_member_id' => $r->from_member_id,
            'to_member_id' => $r->to_member_id,
            'referral_kind' => $r->referral_kind ?? 'external',
            'meeting_id' => $r->meeting_id,
            'introduced_at' => $r->introduced_at?->format('Y-m-d'),
            'note' => $r->note,
            'created_at' => $r->created_at?->toIso8601String(),
            'updated_at' => $r->updated_at?->toIso8601String(),
        ];
    }
}
