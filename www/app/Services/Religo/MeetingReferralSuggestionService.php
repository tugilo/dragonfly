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
    ) {}

    /**
     * @return array<string, mixed>
     */
    public function generate(Meeting $meeting, User $user, UserAiCredential $credential): array
    {
        $minute = $this->resolveMinute($meeting);
        $this->assertGeneratable($minute);

        $body = trim((string) $minute->body_markdown);
        $digest = ReferralSuggestionDigest::digest($body);
        $charCount = ReferralSuggestionDigest::charCount($body);
        $workspaceId = ReligoActorContext::resolveWorkspaceIdForUser($user);

        $existing = MeetingReferralSuggestionRun::query()
            ->where('meeting_id', $meeting->id)
            ->where('owner_member_id', $user->owner_member_id)
            ->where('body_digest', $digest)
            ->orderByDesc('id')
            ->first();

        if ($existing !== null) {
            $existing->load('suggestions');

            return $this->formatGenerateResponse($existing, $meeting, $minute, true);
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
        );

        $run = DB::transaction(function () use ($meeting, $minute, $user, $workspaceId, $digest, $charCount, $ai, $parsed) {
            $run = MeetingReferralSuggestionRun::create([
                'meeting_id' => $meeting->id,
                'meeting_minute_id' => $minute->id,
                'owner_member_id' => $user->owner_member_id,
                'workspace_id' => $workspaceId,
                'body_digest' => $digest,
                'body_char_count' => $charCount,
                'generator' => 'ai_'.$ai['provider'],
                'model' => $ai['model'],
                'raw_response' => $ai['raw'],
                'created_at' => now(),
            ]);

            foreach ($parsed as $row) {
                MeetingReferralSuggestion::create([
                    'run_id' => $run->id,
                    'meeting_id' => $meeting->id,
                    'source_section' => $row['source_section'],
                    'subject_member_id' => $row['subject_member_id'],
                    'direction' => $row['direction'],
                    'summary' => $row['summary'],
                    'rationale' => $row['rationale'],
                    'quality_notes' => $row['quality_notes'],
                    'suggested_from_member_id' => $row['suggested_from_member_id'],
                    'suggested_to_member_id' => $row['suggested_to_member_id'],
                    'suggested_to_label' => $row['suggested_to_label'],
                    'confidence' => $row['confidence'],
                    'status' => MeetingReferralSuggestion::STATUS_PENDING,
                ]);
            }

            return $run->load('suggestions');
        });

        return $this->formatGenerateResponse($run, $meeting, $minute, false);
    }

    /**
     * @return array<string, mixed>
     */
    public function list(Meeting $meeting, int $ownerMemberId, ?int $runId = null): array
    {
        $minute = $meeting->meetingMinute;
        $body = $minute ? trim((string) $minute->body_markdown) : '';
        $currentDigest = $body === '' ? null : ReferralSuggestionDigest::digest($body);

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

        $suggestions = [];
        if ($selectedRun !== null) {
            $suggestions = MeetingReferralSuggestion::query()
                ->where('run_id', $selectedRun->id)
                ->orderBy('id')
                ->get()
                ->map(fn (MeetingReferralSuggestion $s) => $this->formatSuggestion($s))
                ->all();
        }

        $latestDigest = $runs->first()['body_digest'] ?? null;
        $stale = $currentDigest !== null
            && $latestDigest !== null
            && $currentDigest !== $latestDigest;

        return [
            'runs' => $runs->values()->all(),
            'run' => $selectedRun ? $this->formatRunSummary($selectedRun) : null,
            'suggestions' => $suggestions,
            'current_body_digest' => $currentDigest,
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
        MeetingMinute $minute,
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
            'summary' => $s->summary,
            'rationale' => $s->rationale,
            'quality_notes' => $s->quality_notes,
            'suggested_from_member_id' => $s->suggested_from_member_id,
            'suggested_to_member_id' => $s->suggested_to_member_id,
            'suggested_to_label' => $s->suggested_to_label,
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
