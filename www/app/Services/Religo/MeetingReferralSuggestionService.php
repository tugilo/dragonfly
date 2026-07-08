<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingMinute;
use App\Models\MeetingReferralSuggestion;
use App\Models\MeetingReferralSuggestionRun;
use App\Models\Participant;
use App\Models\User;
use App\Models\UserAiCredential;
use App\Services\Ai\AiGenerationException;
use App\Services\Ai\ReferralSuggestionAiService;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;

/**
 * SPEC-016: 定例会リファーラル提案 run / suggestion。
 */
class MeetingReferralSuggestionService
{
    public function __construct(
        private ReferralSuggestionAiService $aiService,
        private ReferralSuggestionPayloadNormalizer $normalizer,
        private ReferralSuggestionMemberRoster $roster,
        private ReferralRelationshipContextBuilder $contextBuilder,
        private ReferralSuggestionDisplayHelper $displayHelper,
    ) {}

    /**
     * @return array<string, mixed>
     */
    public function generate(
        Meeting $meeting,
        User $user,
        UserAiCredential $credential,
        string $contextMode = 'relationship',
        bool $force = false,
    ): array {
        $minute = $this->resolveMinute($meeting);
        $this->assertGeneratable($minute);

        $contextMode = $contextMode === 'document' ? 'document' : 'relationship';

        return $contextMode === 'document'
            ? $this->generateDocumentMode($meeting, $minute, $user, $credential, $force)
            : $this->generateRelationshipMode($meeting, $minute, $user, $credential, $force);
    }

    /**
     * @return array<string, mixed>
     */
    private function generateDocumentMode(
        Meeting $meeting,
        MeetingMinute $minute,
        User $user,
        UserAiCredential $credential,
        bool $force = false,
    ): array {
        $body = trim((string) $minute->body_markdown);
        $digest = ReferralSuggestionDigest::digest($body);
        $charCount = ReferralSuggestionDigest::charCount($body);
        $workspaceId = ReligoActorContext::resolveWorkspaceIdForUser($user);

        $existing = null;
        if (! $force) {
            $existing = MeetingReferralSuggestionRun::query()
                ->where('meeting_id', $meeting->id)
                ->where('owner_member_id', $user->owner_member_id)
                ->where('context_mode', 'document')
                ->where('body_digest', $digest)
                ->orderByDesc('id')
                ->first();
        }

        if ($existing !== null) {
            $existing->load('suggestions');

            return $this->formatGenerateResponse($existing, $meeting, true);
        }

        $participants = $this->participantsSummary($meeting);

        try {
            $ai = $this->aiService->generateForMeeting(
                $meeting,
                $minute,
                $credential,
                (int) $user->owner_member_id,
                $workspaceId,
                $participants,
            );
        } catch (AiGenerationException $e) {
            throw new InvalidArgumentException($e->getMessage(), 0, $e);
        }

        $rosterRows = $this->roster->rosterForWorkspace($workspaceId);
        $validIds = $this->roster->validMemberIds($rosterRows);
        $parsed = $this->normalizer->parseMeetingSuggestions(
            $ai['raw'],
            $validIds,
            (int) $user->owner_member_id,
            false,
        );

        $run = DB::transaction(function () use ($meeting, $minute, $user, $workspaceId, $digest, $charCount, $ai, $parsed) {
            $run = MeetingReferralSuggestionRun::create([
                'meeting_id' => $meeting->id,
                'meeting_minute_id' => $minute->id,
                'owner_member_id' => $user->owner_member_id,
                'workspace_id' => $workspaceId,
                'body_digest' => $digest,
                'body_char_count' => $charCount,
                'context_mode' => 'document',
                'context_digest' => $digest,
                'generator' => 'ai_'.$ai['provider'],
                'model' => $ai['model'],
                'raw_response' => $ai['raw'],
                'created_at' => now(),
            ]);

            $this->persistSuggestions($run, $meeting, $parsed);

            return $run->load('suggestions');
        });

        return $this->formatGenerateResponse($run, $meeting, false);
    }

    /**
     * @return array<string, mixed>
     */
    private function generateRelationshipMode(
        Meeting $meeting,
        MeetingMinute $minute,
        User $user,
        UserAiCredential $credential,
        bool $force = false,
    ): array {
        $body = trim((string) $minute->body_markdown);
        $bodyDigest = ReferralSuggestionDigest::digest($body);
        $charCount = ReferralSuggestionDigest::charCount($body);
        $workspaceId = ReligoActorContext::resolveWorkspaceIdForUser($user);
        $requesterId = (int) $user->owner_member_id;
        $participants = $this->participantsSummary($meeting);

        $pack = $this->contextBuilder->buildForMeeting($meeting, $minute, $requesterId, $workspaceId, $participants);
        $contextDigest = $pack['digest'];

        $existing = null;
        if (! $force) {
            $existing = MeetingReferralSuggestionRun::query()
                ->where('meeting_id', $meeting->id)
                ->where('owner_member_id', $user->owner_member_id)
                ->where('context_mode', 'relationship')
                ->where('context_digest', $contextDigest)
                ->orderByDesc('id')
                ->first();
        }

        if ($existing !== null) {
            $existing->load('suggestions');

            return $this->formatGenerateResponse($existing, $meeting, true);
        }

        try {
            $ai = $this->aiService->generateForMeetingRelationship(
                $meeting,
                $credential,
                $pack['prompt_text'],
                $requesterId,
                $workspaceId,
                $participants,
            );
        } catch (AiGenerationException $e) {
            throw new InvalidArgumentException($e->getMessage(), 0, $e);
        }

        $rosterRows = $this->roster->rosterForWorkspace($workspaceId);
        $validIds = $this->roster->validMemberIds($rosterRows);
        $parsed = $this->normalizer->parseMeetingSuggestions(
            $ai['raw'],
            $validIds,
            $requesterId,
            true,
        );

        $run = DB::transaction(function () use ($meeting, $minute, $user, $workspaceId, $bodyDigest, $charCount, $ai, $parsed, $pack) {
            $run = MeetingReferralSuggestionRun::create([
                'meeting_id' => $meeting->id,
                'meeting_minute_id' => $minute->id,
                'owner_member_id' => $user->owner_member_id,
                'workspace_id' => $workspaceId,
                'body_digest' => $bodyDigest,
                'body_char_count' => $charCount,
                'context_mode' => 'relationship',
                'context_digest' => $pack['digest'],
                'subject_member_id' => $pack['subject_member_id'],
                'corpus_meta' => $pack['meta'],
                'generator' => 'ai_'.$ai['provider'],
                'model' => $ai['model'],
                'raw_response' => $ai['raw'],
                'created_at' => now(),
            ]);

            $this->persistSuggestions($run, $meeting, $parsed);

            return $run->load('suggestions');
        });

        return $this->formatGenerateResponse($run, $meeting, false);
    }

    /**
     * @param  list<array<string, mixed>>  $parsed
     */
    private function persistSuggestions(
        MeetingReferralSuggestionRun $run,
        Meeting $meeting,
        array $parsed,
    ): void {
        foreach ($parsed as $row) {
            MeetingReferralSuggestion::create([
                'run_id' => $run->id,
                'meeting_id' => $meeting->id,
                'source_section' => $row['source_section'],
                'subject_member_id' => $row['subject_member_id'],
                'direction' => $row['direction'],
                'corpus_source' => $row['corpus_source'] ?? 'self',
                'summary' => $row['summary'],
                'rationale' => $row['rationale'],
                'quality_notes' => $row['quality_notes'],
                'suggested_from_member_id' => $row['suggested_from_member_id'],
                'suggested_to_member_id' => $row['suggested_to_member_id'],
                'suggested_to_label' => $row['suggested_to_label'],
                'suggested_contact_label' => $row['suggested_contact_label'] ?? null,
                'source_one_to_one_id' => $row['source_one_to_one_id'] ?? null,
                'source_meeting_id' => $row['source_meeting_id'] ?? null,
                'confidence' => $row['confidence'],
                'status' => MeetingReferralSuggestion::STATUS_PENDING,
            ]);
        }
    }

    /**
     * @return array<string, mixed>
     */
    public function list(Meeting $meeting, int $ownerMemberId, ?int $runId = null): array
    {
        $minute = $meeting->meetingMinute;
        $body = $minute ? trim((string) $minute->body_markdown) : '';
        $currentBodyDigest = $body === '' ? null : ReferralSuggestionDigest::digest($body);
        $currentContextDigest = null;
        if ($body !== '' && $minute !== null) {
            try {
                $participants = $this->participantsSummary($meeting);
                $pack = $this->contextBuilder->buildForMeeting($meeting, $minute, $ownerMemberId, null, $participants);
                $currentContextDigest = $pack['digest'];
            } catch (\Throwable) {
                $currentContextDigest = null;
            }
        }

        $runs = MeetingReferralSuggestionRun::query()
            ->where('meeting_id', $meeting->id)
            ->where('owner_member_id', $ownerMemberId)
            ->orderByDesc('id')
            ->get()
            ->map(fn (MeetingReferralSuggestionRun $r) => $this->formatRunSummary($r));

        $selectedRun = null;
        if ($runId !== null) {
            $selectedRun = MeetingReferralSuggestionRun::query()
                ->where('meeting_id', $meeting->id)
                ->where('owner_member_id', $ownerMemberId)
                ->where('id', $runId)
                ->first();
        }
        if ($selectedRun === null) {
            $selectedRun = MeetingReferralSuggestionRun::query()
                ->where('meeting_id', $meeting->id)
                ->where('owner_member_id', $ownerMemberId)
                ->orderByDesc('id')
                ->first();
        }

        $workspaceId = $selectedRun?->workspace_id;
        $nameMap = $this->displayHelper->nameMapFromRoster(
            $this->roster->rosterForWorkspace($workspaceId !== null ? (int) $workspaceId : null),
        );

        $suggestions = [];
        if ($selectedRun !== null) {
            $suggestions = MeetingReferralSuggestion::query()
                ->where('run_id', $selectedRun->id)
                ->orderBy('id')
                ->get()
                ->map(fn (MeetingReferralSuggestion $s) => $this->displayHelper->enrichSuggestion(
                    $this->formatSuggestion($s),
                    $nameMap,
                    $s->subject_member_id !== null ? (int) $s->subject_member_id : null,
                ))
                ->all();
        }

        $latestRun = $runs->first();
        $stale = false;
        if ($latestRun !== null && $currentBodyDigest !== null) {
            $mode = $latestRun['context_mode'] ?? 'document';
            if ($mode === 'relationship' && $currentContextDigest !== null) {
                $stale = ($latestRun['context_digest'] ?? null) !== $currentContextDigest;
            } else {
                $stale = ($latestRun['body_digest'] ?? null) !== $currentBodyDigest;
            }
        }

        return [
            'runs' => $runs->values()->all(),
            'run' => $selectedRun ? $this->formatRunSummary($selectedRun) : null,
            'suggestions' => $suggestions,
            'current_body_digest' => $currentBodyDigest,
            'current_context_digest' => $currentContextDigest,
            'referral_suggestion_stale' => $stale,
        ];
    }

    /**
     * @param  array<string, mixed>  $data
     * @return array<string, mixed>
     */
    public function updateSuggestion(MeetingReferralSuggestion $suggestion, int $ownerMemberId, array $data): array
    {
        $suggestion->load('run');
        if ((int) $suggestion->run->owner_member_id !== $ownerMemberId) {
            throw new InvalidArgumentException('権限がありません。');
        }

        $status = (string) ($data['status'] ?? $suggestion->status);
        $suggestion->status = $status;
        if ($status === MeetingReferralSuggestion::STATUS_DISMISSED) {
            $suggestion->dismissed_at = now();
        }
        if ($status === MeetingReferralSuggestion::STATUS_ACCEPTED) {
            $suggestion->accepted_at = now();
        }
        if (array_key_exists('edited_snapshot', $data)) {
            $suggestion->edited_snapshot = $data['edited_snapshot'];
        }
        $suggestion->save();

        return $this->formatSuggestion($suggestion->fresh());
    }

    public function assertGeneratable(MeetingMinute $minute): void
    {
        if (trim((string) $minute->body_markdown) === '') {
            throw new InvalidArgumentException('議事録が空のためリファーラル提案を生成できません。');
        }
    }

    private function resolveMinute(Meeting $meeting): MeetingMinute
    {
        $minute = $meeting->meetingMinute;
        if ($minute === null) {
            throw new InvalidArgumentException('この定例会には議事録がありません。');
        }

        return $minute;
    }

    /**
     * @return list<array{member_id: int, name: string, type: string|null, category: string|null}>
     */
    private function participantsSummary(Meeting $meeting): array
    {
        return Participant::query()
            ->where('meeting_id', $meeting->id)
            ->with(['member:id,name,category_id', 'member.category:id,name'])
            ->get()
            ->map(fn (Participant $p) => [
                'member_id' => (int) $p->member_id,
                'name' => (string) ($p->member?->name ?? ''),
                'type' => $p->type,
                'category' => $p->member?->category?->name,
            ])
            ->filter(fn (array $row) => $row['member_id'] > 0)
            ->values()
            ->all();
    }

    /**
     * @return array<string, mixed>
     */
    private function formatGenerateResponse(
        MeetingReferralSuggestionRun $run,
        Meeting $meeting,
        bool $reused,
    ): array {
        $payload = $this->list($meeting, (int) $run->owner_member_id, (int) $run->id);
        $payload['reused_existing_run'] = $reused;

        return $payload;
    }

    /**
     * @return array<string, mixed>
     */
    private function formatRunSummary(MeetingReferralSuggestionRun $run): array
    {
        return [
            'id' => $run->id,
            'meeting_id' => $run->meeting_id,
            'body_digest' => $run->body_digest,
            'body_char_count' => $run->body_char_count,
            'context_mode' => $run->context_mode ?? 'document',
            'context_digest' => $run->context_digest,
            'subject_member_id' => $run->subject_member_id,
            'corpus_meta' => $run->corpus_meta,
            'generator' => $run->generator,
            'model' => $run->model,
            'created_at' => $run->created_at?->toIso8601String(),
            'suggestion_count' => $run->relationLoaded('suggestions')
                ? $run->suggestions->count()
                : MeetingReferralSuggestion::where('run_id', $run->id)->count(),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    public function formatSuggestion(MeetingReferralSuggestion $s): array
    {
        return [
            'id' => $s->id,
            'run_id' => $s->run_id,
            'meeting_id' => $s->meeting_id,
            'source_section' => $s->source_section,
            'subject_member_id' => $s->subject_member_id,
            'direction' => $s->direction,
            'corpus_source' => $s->corpus_source ?? 'self',
            'summary' => $s->summary,
            'rationale' => $s->rationale,
            'quality_notes' => $s->quality_notes,
            'suggested_from_member_id' => $s->suggested_from_member_id,
            'suggested_to_member_id' => $s->suggested_to_member_id,
            'suggested_to_label' => $s->suggested_to_label,
            'suggested_contact_label' => $s->suggested_contact_label,
            'source_one_to_one_id' => $s->source_one_to_one_id,
            'source_meeting_id' => $s->source_meeting_id,
            'confidence' => $s->confidence,
            'status' => $s->status,
            'introduction_id' => $s->introduction_id,
            'accepted_at' => $s->accepted_at?->toIso8601String(),
            'dismissed_at' => $s->dismissed_at?->toIso8601String(),
            'edited_snapshot' => $s->edited_snapshot,
            'created_at' => $s->created_at?->toIso8601String(),
            'updated_at' => $s->updated_at?->toIso8601String(),
        ];
    }
}
