<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingMinute;
use App\Models\OneToOne;
use Illuminate\Support\Collection;

/**
 * Phase 195: 主役 Pack ＋ 同意済み横断コーパス（§0.1）。
 */
class ReferralRelationshipContextBuilder
{
    private const MAX_MEETINGS = 6;

    private const MAX_PEER_O2O = 20;

    private const EXCERPT_CHARS = 1800;

    public function __construct(
        private ReferralCorpusSettingsService $corpusSettings,
        private ReferralRelationshipIntroductionSummary $introductionSummary,
    ) {}

    /**
     * @return array{prompt_text: string, digest: string, meta: array<string, int>, subject_member_id: int}
     */
    public function buildForOneToOne(OneToOne $oneToOne, int $requesterMemberId): array
    {
        $oneToOne->loadMissing(['ownerMember:id,name', 'targetMember:id,name']);
        $workspaceId = $oneToOne->workspace_id !== null ? (int) $oneToOne->workspace_id : null;
        $subjectId = (int) $oneToOne->target_member_id;

        $sections = [];
        $sections[] = '# 依頼者（記録者・リファーラル受け手の典型）';
        $sections[] = "member_id: {$requesterMemberId}";
        $sections[] = '';
        $sections[] = '# 主役（subject）— 121 相手。社外紹介・他者ネットワークの contact 発見の文脈（章内メンバー同士の紹介は対象外）';
        $sections[] = "member_id: {$subjectId}（{$oneToOne->targetMember?->name}）";
        $sections[] = '';
        $sections[] = '# 当該 1 to 1 議事録';
        $sections[] = $this->truncate((string) $oneToOne->notes);

        $subjectO2os = $this->subjectOneToOnes($workspaceId, $subjectId, (int) $oneToOne->id);
        $o2oExcerptCount = 0;
        if ($subjectO2os->isNotEmpty()) {
            $sections[] = '';
            $sections[] = '# 主役に関する過去 1 to 1';
            foreach ($subjectO2os as $row) {
                $sections[] = $this->formatO2oExcerpt($row);
                $o2oExcerptCount++;
            }
        }

        $consentedIds = $this->corpusSettings->consentedOwnerMemberIds($workspaceId, $requesterMemberId);
        $peerO2os = $this->peerOneToOnes($workspaceId, $consentedIds, (int) $oneToOne->id);
        if ($peerO2os->isNotEmpty()) {
            $sections[] = '';
            $sections[] = '# 他メンバー（横断共有 ON）の 1 to 1 抜粋';
            foreach ($peerO2os as $row) {
                $sections[] = $this->formatO2oExcerpt($row);
                $o2oExcerptCount++;
            }
        }

        $intro = $this->introductionSummary->buildSection($workspaceId, $subjectId, $requesterMemberId);
        if ($intro['prompt_section'] !== '') {
            $sections[] = '';
            $sections[] = $intro['prompt_section'];
        }

        $meetings = $this->recentMeetingExcerpts($workspaceId, null, [$subjectId]);
        $meetingCount = $this->countMeetingBlocks($meetings);
        if ($meetings !== '') {
            $sections[] = '';
            $sections[] = '# 主役が参加した定例会議事録抜粋（直近）';
            $sections[] = $meetings;
        }

        $promptText = implode("\n", $sections);
        $digest = ReferralSuggestionDigest::digest($promptText);

        return [
            'prompt_text' => $promptText,
            'digest' => $digest,
            'subject_member_id' => $subjectId,
            'meta' => [
                'consented_owner_count' => count($consentedIds),
                'o2o_excerpt_count' => $o2oExcerptCount,
                'meeting_count' => $meetingCount,
                'introduction_count' => $intro['count'],
            ],
        ];
    }

    /**
     * @param  list<array{member_id: int, name: string, type: string|null, category: string|null}>  $participants
     * @return array{prompt_text: string, digest: string, meta: array<string, int>, subject_member_id: null}
     */
    public function buildForMeeting(
        Meeting $meeting,
        MeetingMinute $minute,
        int $requesterMemberId,
        ?int $workspaceId,
        array $participants,
    ): array {
        $sections = [];
        $sections[] = '# 依頼者（記録者）';
        $sections[] = "member_id: {$requesterMemberId}";
        $sections[] = '';
        $sections[] = '# 当該定例会議事録';
        $held = $meeting->held_on?->format('Y-m-d') ?? '?';
        $sections[] = "第{$meeting->number}回（{$held}）meeting_id={$meeting->id}";
        $sections[] = $this->truncate(trim((string) $minute->body_markdown));
        $sections[] = '';
        $sections[] = '# 当回参加者';
        if ($participants === []) {
            $sections[] = '（なし）';
        } else {
            foreach ($participants as $p) {
                $sections[] = "- id={$p['member_id']}: {$p['name']}（{$p['type']}, {$p['category']}）";
            }
        }

        $consentedIds = $this->corpusSettings->consentedOwnerMemberIds($workspaceId, $requesterMemberId);
        $peerO2os = $this->peerOneToOnes($workspaceId, $consentedIds, -1);
        $o2oExcerptCount = 0;
        if ($peerO2os->isNotEmpty()) {
            $sections[] = '';
            $sections[] = '# 他メンバー（横断共有 ON）の 1 to 1 抜粋';
            foreach ($peerO2os as $row) {
                $sections[] = $this->formatO2oExcerpt($row);
                $o2oExcerptCount++;
            }
        }

        $participantIds = array_values(array_unique(array_filter(
            array_map(fn (array $p) => (int) $p['member_id'], $participants),
            fn ($id) => $id > 0,
        )));

        $introSubjectId = $participantIds[0] ?? 0;
        $intro = $this->introductionSummary->buildSection($workspaceId, $introSubjectId, $requesterMemberId);
        if ($intro['prompt_section'] !== '') {
            $sections[] = '';
            $sections[] = $intro['prompt_section'];
        }

        $meetings = $this->recentMeetingExcerpts($workspaceId, (int) $meeting->id, $participantIds);
        $meetingCount = $this->countMeetingBlocks($meetings);
        if ($meetings !== '') {
            $sections[] = '';
            $sections[] = '# 当回参加者が登場した定例会議事録抜粋（当回除く）';
            $sections[] = $meetings;
        }

        $promptText = implode("\n", $sections);
        $digest = ReferralSuggestionDigest::digest($promptText);

        return [
            'prompt_text' => $promptText,
            'digest' => $digest,
            'subject_member_id' => null,
            'meta' => [
                'consented_owner_count' => count($consentedIds),
                'o2o_excerpt_count' => $o2oExcerptCount,
                'meeting_count' => $meetingCount,
                'introduction_count' => $intro['count'],
                'participant_count' => count($participantIds),
            ],
        ];
    }

    /**
     * @return Collection<int, OneToOne>
     */
    private function subjectOneToOnes(?int $workspaceId, int $subjectMemberId, int $excludeId): Collection
    {
        $q = OneToOne::query()
            ->where('status', 'completed')
            ->where('id', '!=', $excludeId)
            ->where(function ($q) use ($subjectMemberId) {
                $q->where('target_member_id', $subjectMemberId)
                    ->orWhere('owner_member_id', $subjectMemberId);
            })
            ->whereNotNull('notes')
            ->where('notes', '!=', '')
            ->orderByDesc('id')
            ->limit(8);

        $this->corpusSettings->applyOneToOneWorkspaceScope($q, $workspaceId);

        return $q->get(['id', 'owner_member_id', 'target_member_id', 'notes', 'started_at']);
    }

    /**
     * @param  list<int>  $consentedOwnerIds
     * @return Collection<int, OneToOne>
     */
    private function peerOneToOnes(?int $workspaceId, array $consentedOwnerIds, int $excludeId): Collection
    {
        if ($consentedOwnerIds === []) {
            return collect();
        }

        $q = OneToOne::query()
            ->where('status', 'completed')
            ->whereIn('owner_member_id', $consentedOwnerIds)
            ->whereNotNull('notes')
            ->where('notes', '!=', '')
            ->orderByDesc('id')
            ->limit(self::MAX_PEER_O2O);

        if ($excludeId > 0) {
            $q->where('id', '!=', $excludeId);
        }

        $this->corpusSettings->applyOneToOneWorkspaceScope($q, $workspaceId);

        return $q->get(['id', 'owner_member_id', 'target_member_id', 'notes', 'started_at']);
    }

    /**
     * @param  list<int>  $relatedMemberIds  空なら章全体の直近（後方互換）。非空なら参加者がいる回のみ。
     */
    private function recentMeetingExcerpts(
        ?int $workspaceId,
        ?int $excludeMeetingId = null,
        array $relatedMemberIds = [],
    ): string {
        $q = Meeting::query()
            ->whereHas('meetingMinute', fn ($m) => $m->whereNotNull('body_markdown')->where('body_markdown', '!=', ''))
            ->with(['meetingMinute:id,meeting_id,body_markdown'])
            ->orderByDesc('held_on')
            ->orderByDesc('number')
            ->limit(self::MAX_MEETINGS);

        if ($excludeMeetingId !== null) {
            $q->where('id', '!=', $excludeMeetingId);
        }

        if ($relatedMemberIds !== []) {
            $q->whereHas('participants', fn ($p) => $p->whereIn('member_id', $relatedMemberIds));
        }

        $blocks = [];
        foreach ($q->get(['id', 'number', 'held_on']) as $meeting) {
            $body = trim((string) $meeting->meetingMinute?->body_markdown);
            if ($body === '') {
                continue;
            }
            $held = $meeting->held_on?->format('Y-m-d') ?? '?';
            $blocks[] = "## 第{$meeting->number}回（{$held}）meeting_id={$meeting->id}\n".$this->truncate($body);
        }

        return implode("\n\n", $blocks);
    }

    private function countMeetingBlocks(string $meetings): int
    {
        if ($meetings === '') {
            return 0;
        }

        return substr_count($meetings, '## 第');
    }

    private function formatO2oExcerpt(OneToOne $row): string
    {
        $date = $row->started_at?->format('Y-m-d') ?? '';

        return "### 121 #{$row->id} owner={$row->owner_member_id} target={$row->target_member_id} {$date}\n"
            .$this->truncate((string) $row->notes);
    }

    private function truncate(string $text): string
    {
        $text = trim($text);
        if (mb_strlen($text) <= self::EXCERPT_CHARS) {
            return $text;
        }

        return mb_substr($text, 0, self::EXCERPT_CHARS)."\n…（省略）";
    }
}
