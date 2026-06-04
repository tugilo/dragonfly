<?php

namespace App\Services\Religo;

use App\Models\OneToOne;
use App\Models\OneToOneReferralSuggestion;
use App\Models\OneToOneReferralSuggestionRun;
use App\Models\User;
use App\Models\UserAiCredential;
use App\Services\Ai\AiGenerationException;
use App\Services\Ai\ReferralSuggestionAiService;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;

/**
 * SPEC-015: 121 リファーラル提案 run / suggestion。
 */
class OneToOneReferralSuggestionService
{
    public function __construct(
        private ReferralSuggestionAiService $aiService,
        private ReferralSuggestionPayloadNormalizer $normalizer,
        private ReferralSuggestionMemberRoster $roster,
    ) {}

    /**
     * @return array<string, mixed>
     */
    public function generate(OneToOne $oneToOne, User $user, UserAiCredential $credential): array
    {
        $this->assertGeneratable($oneToOne);

        $notes = trim((string) $oneToOne->notes);
        $digest = ReferralSuggestionDigest::digest($notes);
        $charCount = ReferralSuggestionDigest::charCount($notes);

        $existing = OneToOneReferralSuggestionRun::query()
            ->where('one_to_one_id', $oneToOne->id)
            ->where('owner_member_id', $user->owner_member_id)
            ->where('notes_digest', $digest)
            ->orderByDesc('id')
            ->first();

        if ($existing !== null) {
            $existing->load('suggestions');

            return $this->formatGenerateResponse($existing, $oneToOne, true);
        }

        try {
            $ai = $this->aiService->generateForOneToOne($oneToOne, $credential);
        } catch (AiGenerationException $e) {
            throw new InvalidArgumentException($e->getMessage(), 0, $e);
        }

        $rosterRows = $this->roster->rosterForWorkspace($oneToOne->workspace_id);
        $validIds = $this->roster->validMemberIds($rosterRows);
        $parsed = $this->normalizer->parseOneToOneSuggestions(
            $ai['raw'],
            $validIds,
            (int) $oneToOne->owner_member_id,
            (int) $oneToOne->target_member_id,
        );

        $run = DB::transaction(function () use ($oneToOne, $user, $digest, $charCount, $ai, $parsed) {
            $run = OneToOneReferralSuggestionRun::create([
                'one_to_one_id' => $oneToOne->id,
                'owner_member_id' => $user->owner_member_id,
                'workspace_id' => $oneToOne->workspace_id,
                'notes_digest' => $digest,
                'notes_char_count' => $charCount,
                'generator' => 'ai_'.$ai['provider'],
                'model' => $ai['model'],
                'raw_response' => $ai['raw'],
                'created_at' => now(),
            ]);

            foreach ($parsed as $row) {
                OneToOneReferralSuggestion::create([
                    'run_id' => $run->id,
                    'one_to_one_id' => $oneToOne->id,
                    'direction' => $row['direction'],
                    'summary' => $row['summary'],
                    'rationale' => $row['rationale'],
                    'quality_notes' => $row['quality_notes'],
                    'suggested_from_member_id' => $row['suggested_from_member_id'],
                    'suggested_to_member_id' => $row['suggested_to_member_id'],
                    'suggested_to_label' => $row['suggested_to_label'],
                    'confidence' => $row['confidence'],
                    'status' => OneToOneReferralSuggestion::STATUS_PENDING,
                ]);
            }

            return $run->load('suggestions');
        });

        return $this->formatGenerateResponse($run, $oneToOne, false);
    }

    /**
     * @return array<string, mixed>
     */
    public function list(OneToOne $oneToOne, int $ownerMemberId, ?int $runId = null): array
    {
        $notes = trim((string) $oneToOne->notes);
        $currentDigest = $notes === '' ? null : ReferralSuggestionDigest::digest($notes);

        $runs = OneToOneReferralSuggestionRun::query()
            ->where('one_to_one_id', $oneToOne->id)
            ->where('owner_member_id', $ownerMemberId)
            ->orderByDesc('id')
            ->get()
            ->map(fn (OneToOneReferralSuggestionRun $r) => $this->formatRunSummary($r));

        $selectedRun = null;
        if ($runId !== null) {
            $selectedRun = OneToOneReferralSuggestionRun::query()
                ->where('one_to_one_id', $oneToOne->id)
                ->where('owner_member_id', $ownerMemberId)
                ->where('id', $runId)
                ->first();
        }
        if ($selectedRun === null) {
            $selectedRun = OneToOneReferralSuggestionRun::query()
                ->where('one_to_one_id', $oneToOne->id)
                ->where('owner_member_id', $ownerMemberId)
                ->orderByDesc('id')
                ->first();
        }

        $suggestions = [];
        if ($selectedRun !== null) {
            $suggestions = OneToOneReferralSuggestion::query()
                ->where('run_id', $selectedRun->id)
                ->orderBy('id')
                ->get()
                ->map(fn (OneToOneReferralSuggestion $s) => $this->formatSuggestion($s))
                ->all();
        }

        $latestDigest = $runs->first()['notes_digest'] ?? null;
        $stale = $currentDigest !== null
            && $latestDigest !== null
            && $currentDigest !== $latestDigest;

        return [
            'runs' => $runs->values()->all(),
            'run' => $selectedRun ? $this->formatRunSummary($selectedRun) : null,
            'suggestions' => $suggestions,
            'current_notes_digest' => $currentDigest,
            'referral_suggestion_stale' => $stale,
        ];
    }

    /**
     * @param  array<string, mixed>  $data
     * @return array<string, mixed>
     */
    public function updateSuggestion(OneToOneReferralSuggestion $suggestion, int $ownerMemberId, array $data): array
    {
        $suggestion->load('run');
        if ((int) $suggestion->run->owner_member_id !== $ownerMemberId) {
            throw new InvalidArgumentException('権限がありません。');
        }

        $status = (string) ($data['status'] ?? $suggestion->status);
        $suggestion->status = $status;
        if ($status === OneToOneReferralSuggestion::STATUS_DISMISSED) {
            $suggestion->dismissed_at = now();
        }
        if ($status === OneToOneReferralSuggestion::STATUS_ACCEPTED) {
            $suggestion->accepted_at = now();
        }
        if (array_key_exists('edited_snapshot', $data)) {
            $suggestion->edited_snapshot = $data['edited_snapshot'];
        }
        $suggestion->save();

        return $this->formatSuggestion($suggestion->fresh());
    }

    public function assertGeneratable(OneToOne $oneToOne): void
    {
        if ($oneToOne->status !== 'completed') {
            throw new InvalidArgumentException('リファーラル提案は実施済み（completed）の 1 to 1 のみ利用できます。');
        }
        if (trim((string) $oneToOne->notes) === '') {
            throw new InvalidArgumentException('notes が空のためリファーラル提案を生成できません。');
        }
    }

    /**
     * @return array<string, mixed>
     */
    private function formatGenerateResponse(OneToOneReferralSuggestionRun $run, OneToOne $oneToOne, bool $reused): array
    {
        $payload = $this->list($oneToOne, (int) $run->owner_member_id, (int) $run->id);
        $payload['reused_existing_run'] = $reused;

        return $payload;
    }

    /**
     * @return array<string, mixed>
     */
    private function formatRunSummary(OneToOneReferralSuggestionRun $run): array
    {
        return [
            'id' => $run->id,
            'one_to_one_id' => $run->one_to_one_id,
            'notes_digest' => $run->notes_digest,
            'notes_char_count' => $run->notes_char_count,
            'generator' => $run->generator,
            'model' => $run->model,
            'created_at' => $run->created_at?->toIso8601String(),
            'suggestion_count' => $run->relationLoaded('suggestions')
                ? $run->suggestions->count()
                : OneToOneReferralSuggestion::where('run_id', $run->id)->count(),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    public function formatSuggestion(OneToOneReferralSuggestion $s): array
    {
        return [
            'id' => $s->id,
            'run_id' => $s->run_id,
            'one_to_one_id' => $s->one_to_one_id,
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
