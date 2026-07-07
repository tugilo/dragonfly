<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingReferralSuggestion;
use App\Models\Member;
use App\Models\OneToOne;
use App\Models\OneToOneReferralSuggestion;
use App\Models\User;
use App\Models\UserAiCredential;
use App\Services\Ai\AiGenerationException;
use App\Services\Ai\ReferralConnectCopyAiService;
use InvalidArgumentException;

/**
 * SPEC-022: つなぐ準備文案生成のオーケストレーション。
 */
class ReferralConnectCopyService
{
    public function __construct(
        private ReferralConnectCopyCorpusBuilder $corpusBuilder,
        private ReferralConnectCopyAiService $aiService,
    ) {}

    /**
     * @param  array<string, mixed>  $validated
     * @return array<string, mixed>
     */
    public function generateForOneToOne(
        OneToOneReferralSuggestion $suggestion,
        User $user,
        UserAiCredential $credential,
        array $validated,
    ): array {
        $suggestion->load(['run', 'oneToOne']);
        $this->assertOwner($suggestion->run->owner_member_id, $user);

        $workspaceId = (int) ($suggestion->run->workspace_id ?? $suggestion->oneToOne?->workspace_id ?? 0);
        $ownerId = (int) $user->owner_member_id;

        return $this->generate(
            $suggestion->id,
            $workspaceId,
            $ownerId,
            $this->suggestionContextFromOneToOne($suggestion),
            (string) $suggestion->direction,
            trim((string) ($suggestion->oneToOne?->notes ?? '')) ?: null,
            $validated,
            $credential,
            $suggestion->oneToOne?->target_member_id !== null
                ? (int) $suggestion->oneToOne->target_member_id
                : null,
        );
    }

    /**
     * @param  array<string, mixed>  $validated
     * @return array<string, mixed>
     */
    public function generateForMeeting(
        MeetingReferralSuggestion $suggestion,
        User $user,
        UserAiCredential $credential,
        array $validated,
    ): array {
        $suggestion->load(['run', 'meeting.meetingMinute']);
        $this->assertOwner($suggestion->run->owner_member_id, $user);

        $workspaceId = (int) ($suggestion->run->workspace_id ?? 0);
        $ownerId = (int) $user->owner_member_id;
        $parentDoc = $suggestion->meeting?->meetingMinute?->body_markdown;

        return $this->generate(
            $suggestion->id,
            $workspaceId,
            $ownerId,
            $this->suggestionContextFromMeeting($suggestion),
            (string) $suggestion->direction,
            $parentDoc !== null && trim((string) $parentDoc) !== '' ? (string) $parentDoc : null,
            $validated,
            $credential,
            $suggestion->subject_member_id !== null ? (int) $suggestion->subject_member_id : null,
        );
    }

    /**
     * @param  array<string, mixed>  $validated
     * @return array<string, mixed>
     */
    private function generate(
        int $suggestionId,
        int $workspaceId,
        int $ownerId,
        array $suggestionContext,
        string $direction,
        ?string $parentDocument,
        array $validated,
        UserAiCredential $credential,
        ?int $subjectMemberId,
    ): array {
        $partyAId = (int) $validated['party_a_member_id'];
        $partyBId = isset($validated['party_b_member_id']) && $validated['party_b_member_id'] !== null
            ? (int) $validated['party_b_member_id']
            : null;
        $partyBLabel = isset($validated['party_b_label']) ? trim((string) $validated['party_b_label']) : '';
        if ($partyBLabel === '') {
            $partyBLabel = null;
        }
        $channelHint = (string) ($validated['channel_hint'] ?? 'messenger');

        $partyA = $this->assertMemberInWorkspace($partyAId, $workspaceId);
        $partyB = $partyBId !== null ? $this->assertMemberInWorkspace($partyBId, $workspaceId) : null;
        $connector = Member::query()->find($ownerId);
        $connectorName = $connector?->name ?? 'つなぎ手';

        $corpus = $this->corpusBuilder->build(
            $ownerId,
            $connectorName,
            $partyA,
            $partyB,
            $partyBLabel,
            $suggestionContext,
            $parentDocument,
        );

        $bothMembers = $partyB !== null;
        $isViaConnector = $direction === 'via_connector';
        $bIsLabelOnly = $partyB === null && $partyBLabel !== null;

        try {
            $ai = $this->aiService->generate(
                $corpus['prompt_text'],
                $direction,
                $channelHint,
                $bothMembers,
                $isViaConnector,
                $bIsLabelOnly,
                $credential,
            );
        } catch (AiGenerationException $e) {
            throw new InvalidArgumentException($e->getMessage(), 0, $e);
        }

        return [
            'suggestion_id' => $suggestionId,
            'party_a_member_id' => $partyAId,
            'party_b_member_id' => $partyBId,
            'party_b_label' => $partyBLabel,
            'blocks' => $ai['blocks'],
            'meta' => [
                'model' => $ai['model'],
                'source_o2o_ids' => $corpus['source_o2o_ids'],
                'generated_at' => now()->toIso8601String(),
            ],
        ];
    }

    private function assertOwner(mixed $runOwnerId, User $user): void
    {
        if ($user->owner_member_id === null || (int) $runOwnerId !== (int) $user->owner_member_id) {
            throw new InvalidArgumentException('この提案を操作する権限がありません。');
        }
    }

    private function assertMemberInWorkspace(int $memberId, int $workspaceId): Member
    {
        $member = Member::query()
            ->where('id', $memberId)
            ->where('workspace_id', $workspaceId)
            ->first();

        if ($member === null) {
            throw new InvalidArgumentException('指定メンバーはこの workspace に属していません。');
        }

        return $member;
    }

    /**
     * @return array<string, mixed>
     */
    private function suggestionContextFromOneToOne(OneToOneReferralSuggestion $suggestion): array
    {
        return [
            'summary' => $suggestion->summary,
            'direction' => $suggestion->direction,
            'rationale' => $suggestion->rationale,
            'suggested_contact_label' => $suggestion->suggested_contact_label,
            'suggested_to_label' => $suggestion->suggested_to_label,
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function suggestionContextFromMeeting(MeetingReferralSuggestion $suggestion): array
    {
        return [
            'summary' => $suggestion->summary,
            'direction' => $suggestion->direction,
            'rationale' => $suggestion->rationale,
            'suggested_contact_label' => $suggestion->suggested_contact_label,
            'suggested_to_label' => $suggestion->suggested_to_label,
            'subject_member_id' => $suggestion->subject_member_id,
        ];
    }
}
