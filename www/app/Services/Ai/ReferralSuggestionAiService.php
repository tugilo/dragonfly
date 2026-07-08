<?php

namespace App\Services\Ai;

use App\Models\Meeting;
use App\Models\MeetingMinute;
use App\Models\OneToOne;
use App\Models\UserAiCredential;
use App\Services\Religo\ReferralSuggestionMemberRoster;

/**
 * SPEC-015/016: 議事録からリファーラル提案 JSON を AI 生成する。
 */
class ReferralSuggestionAiService
{
    private const MAX_BODY_CHARS = 24000;

    private const EXTERNAL_ONLY_RULE = <<<'TXT'
【禁止】同章（名簿）のメンバー同士を「紹介」「1 to 1 すべき」として提案しない。定例会で既に接続済みのため。
【許可】① 議事録の社外紹介先（suggested_to_member_id は null、suggested_to_label に業種像）② via_connector（つなぎ手 A の社外 contact B → 依頼者へ。connector_member_id は名簿の実 ID）
【禁止】via_connector の connector_member_id に requester_member_id（依頼者本人）を入れない。connector A は requester 以外の章内メンバーで、根拠コーパスに登場する人物に限る。
TXT;

    public function __construct(
        private AiClientFactory $factory,
        private ReferralSuggestionMemberRoster $roster,
    ) {}

    /**
     * @return array{raw: string, provider: string, model: string|null}
     */
    public function generateForOneToOne(OneToOne $oneToOne, UserAiCredential $credential): array
    {
        $oneToOne->loadMissing(['ownerMember:id,name', 'targetMember:id,name,category_id', 'targetMember.category:id,name']);
        $generator = $this->factory->forCredential($credential);
        $notes = trim((string) $oneToOne->notes);
        $rosterRows = $this->roster->rosterForWorkspace($oneToOne->workspace_id);
        $ownerId = (int) $oneToOne->owner_member_id;
        $targetId = (int) $oneToOne->target_member_id;

        $userPrompt = implode("\n", [
            '# 1 to 1 議事録（notes）',
            $this->truncate($notes),
            '',
            '# コンテキスト',
            "owner_member_id（記録者）: {$ownerId}（{$oneToOne->ownerMember?->name}）",
            "target_member_id（相手・121 相手）: {$targetId}（{$oneToOne->targetMember?->name}）",
            '',
            '# チャプターメンバー名簿（id・氏名・カテゴリのみ — 紹介先 id には使わない）',
            $this->roster->formatRosterForPrompt($rosterRows),
            '',
            self::EXTERNAL_ONLY_RULE,
            '',
            '上記から **社外リファーラル候補のみ** JSON で出力。suggested_to_member_id は常に null（社外は suggested_to_label）。',
        ]);

        $raw = $generator->generate($this->oneToOneSystemPrompt(), $userPrompt, $credential->model);

        return [
            'raw' => $raw,
            'provider' => $generator->provider(),
            'model' => $credential->model,
        ];
    }

    /**
     * Phase 195: 関係コンテキスト Pack から生成（§0.8 つなぎ手経由含む）。
     *
     * @return array{raw: string, provider: string, model: string|null}
     */
    public function generateForOneToOneRelationship(
        OneToOne $oneToOne,
        UserAiCredential $credential,
        string $relationshipPrompt,
        int $requesterMemberId,
    ): array {
        $oneToOne->loadMissing(['ownerMember:id,name', 'targetMember:id,name']);
        $generator = $this->factory->forCredential($credential);
        $rosterRows = $this->roster->rosterForWorkspace($oneToOne->workspace_id);

        $userPrompt = implode("\n", [
            $relationshipPrompt,
            '',
            '# チャプターメンバー名簿（つなぎ手 A の id 特定用。紹介先に member_id は使わない）',
            $this->roster->formatRosterForPrompt($rosterRows),
            '',
            "依頼者 requester_member_id: {$requesterMemberId}",
            "121 相手 subject_member_id: ".(int) $oneToOne->target_member_id.'（'.$oneToOne->targetMember?->name.'）',
            '',
            self::EXTERNAL_ONLY_RULE,
            '',
            '横断コーパスは **社外紹介・つなぎ手経由の発見**に使う（他者 121 に書かれた A の顧客・紹介希望など）。',
            '- via_connector: connector_member_id=A（requester 以外の章内メンバー）, suggested_to_member_id=依頼者, suggested_contact_label=B（必須）',
            '- 議事録に明示された社外紹介: direction=owner_to_target 等、suggested_to_label のみ（to_member_id は null）',
            '- subject_should_meet / match_member_id / 名簿メンバー同士の紹介は出力しない',
        ]);

        $raw = $generator->generate($this->oneToOneRelationshipSystemPrompt(), $userPrompt, $credential->model);

        return [
            'raw' => $raw,
            'provider' => $generator->provider(),
            'model' => $credential->model,
        ];
    }

    /**
     * @param  list<array{member_id: int, name: string, type: string|null, category: string|null}>  $participants
     * @return array{raw: string, provider: string, model: string|null}
     */
    public function generateForMeeting(
        Meeting $meeting,
        MeetingMinute $minute,
        UserAiCredential $credential,
        int $ownerMemberId,
        ?int $workspaceId,
        array $participants,
    ): array {
        $generator = $this->factory->forCredential($credential);
        $body = trim((string) $minute->body_markdown);
        $rosterRows = $this->roster->rosterForWorkspace($workspaceId);

        $participantLines = [];
        foreach ($participants as $p) {
            $participantLines[] = "- id={$p['member_id']}: {$p['name']}（type={$p['type']}, {$p['category']}）";
        }

        $userPrompt = implode("\n", [
            '# 定例会議事録',
            "第{$meeting->number}回 · held_on={$meeting->held_on?->format('Y-m-d')}",
            $this->truncate($body),
            '',
            '# 当回参加者（MP 主役の subject_member_id 特定用）',
            $participantLines === [] ? '（なし）' : implode("\n", $participantLines),
            '',
            '# 記録者 owner_member_id',
            (string) $ownerMemberId,
            '',
            '# チャプターメンバー名簿',
            $this->roster->formatRosterForPrompt($rosterRows),
            '',
            self::EXTERNAL_ONLY_RULE,
            '',
            'メインプレ・ウィークリー等から **社外の紹介希望先** のみ JSON で出力。リファラル件数報告は無視。',
            'suggested_to_member_id は null（社外は suggested_to_label）。章内メンバー同士の紹介は出さない。',
        ]);

        $raw = $generator->generate($this->meetingSystemPrompt(), $userPrompt, $credential->model);

        return [
            'raw' => $raw,
            'provider' => $generator->provider(),
            'model' => $credential->model,
        ];
    }

    /**
     * @param  list<array{member_id: int, name: string, type: string|null, category: string|null}>  $participants
     * @return array{raw: string, provider: string, model: string|null}
     */
    public function generateForMeetingRelationship(
        Meeting $meeting,
        UserAiCredential $credential,
        string $relationshipPrompt,
        int $requesterMemberId,
        ?int $workspaceId,
        array $participants,
    ): array {
        $generator = $this->factory->forCredential($credential);
        $rosterRows = $this->roster->rosterForWorkspace($workspaceId);

        $participantLines = [];
        foreach ($participants as $p) {
            $participantLines[] = "- id={$p['member_id']}: {$p['name']}（type={$p['type']}, {$p['category']}）";
        }

        $userPrompt = implode("\n", [
            $relationshipPrompt,
            '',
            '# チャプターメンバー名簿',
            $this->roster->formatRosterForPrompt($rosterRows),
            '',
            '# 当回参加者',
            $participantLines === [] ? '（なし）' : implode("\n", $participantLines),
            '',
            "依頼者 requester_member_id: {$requesterMemberId}",
            '',
            self::EXTERNAL_ONLY_RULE,
            '',
            '横断コーパスから **社外紹介・via_connector** のみ出力。subject_should_meet は禁止。',
        ]);

        $raw = $generator->generate($this->meetingRelationshipSystemPrompt(), $userPrompt, $credential->model);

        return [
            'raw' => $raw,
            'provider' => $generator->provider(),
            'model' => $credential->model,
        ];
    }

    private function oneToOneRelationshipSystemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI 章の記録から **社外リファーラル** と **つなぎ手経由（via_connector）** のきっかけだけを提案するアシスタントです。',
            '同章メンバー同士を紹介・つなぐ提案は禁止（定例会で既に接続済み）。',
            '応答は **有効な JSON オブジェクトのみ**。',
            'スキーマ:',
            '{"suggestions":[{"direction":"owner_to_target|target_to_owner|mutual|unclear|via_connector","corpus_source":"self|member_network","summary":"...","rationale":"引用 121# / 定例会","quality_notes":[],"connector_member_id":null,"suggested_from_member_id":null,"suggested_to_member_id":null,"suggested_contact_label":null,"suggested_to_label":null,"source_one_to_one_id":null,"source_meeting_id":null,"confidence":"high|medium|low"}]}',
            'via_connector: corpus_source=member_network, connector_member_id + suggested_contact_label 必須, suggested_to_member_id=依頼者。',
            'via_connector の connector_member_id は requester 以外の章内メンバー。requester 本人を connector にしない。',
            '社外紹介: suggested_to_member_id は null。suggested_to_label に紹介先像。',
            'Pack 内 introductions の既存 from→to は重複提案しない。',
        ]);
    }

    private function oneToOneSystemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI 活動の **社外** リファーラル候補を議事録から抽出するアシスタントです。',
            '同章メンバー同士の紹介は提案しない。',
            '応答は **有効な JSON オブジェクトのみ**。',
            'スキーマ:',
            '{"suggestions":[{"direction":"owner_to_target|target_to_owner|mutual|unclear","summary":"...","rationale":"...","quality_notes":[],"suggested_from_member_id":null,"suggested_to_member_id":null,"suggested_to_label":"社外紹介先の像","confidence":"high|medium|low"}]}',
            'suggested_to_member_id は常に null。名簿の member_id を紹介先に使わない。',
            '議事録に無い事実は提案しない。',
        ]);
    }

    private function meetingSystemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI 定例会議事録から **社外** リファーラル候補を抽出するアシスタントです。',
            '同章メンバー同士の紹介は提案しない。',
            '応答は **有効な JSON オブジェクトのみ**。',
            'スキーマ:',
            '{"suggestions":[{"source_section":"main_presentation|weekly_presentation|visitor_intro|share_story|education|other","subject_member_id":null,"direction":"subject_seeks_intros|owner_introduces_to_subject|mutual|unclear","summary":"...","rationale":"...","quality_notes":[],"suggested_from_member_id":null,"suggested_to_member_id":null,"suggested_to_label":"...","confidence":"high|medium|low"}]}',
            'MP の紹介希望先は suggested_to_label（社外）。suggested_to_member_id は null。',
        ]);
    }

    private function meetingRelationshipSystemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI 定例会・横断コーパスから **社外リファーラル** と **via_connector** のみを提案するアシスタントです。',
            '同章メンバー同士の紹介・subject_should_meet は禁止。',
            '応答は **有効な JSON オブジェクトのみ**。',
            'スキーマ:',
            '{"suggestions":[{"source_section":"main_presentation|weekly_presentation|visitor_intro|share_story|education|other","subject_member_id":null,"direction":"subject_seeks_intros|owner_introduces_to_subject|mutual|unclear|via_connector","corpus_source":"self|member_network","summary":"...","rationale":"...","quality_notes":[],"connector_member_id":null,"suggested_from_member_id":null,"suggested_to_member_id":null,"suggested_contact_label":null,"suggested_to_label":null,"source_one_to_one_id":null,"source_meeting_id":null,"confidence":"high|medium|low"}]}',
            'via_connector の connector_member_id は requester 以外の章内メンバー。requester 本人を connector にしない。',
            'リファラル件数報告は無視。社外は suggested_to_label、to_member_id は null。',
        ]);
    }

    private function truncate(string $text): string
    {
        if (mb_strlen($text) <= self::MAX_BODY_CHARS) {
            return $text;
        }

        return mb_substr($text, 0, self::MAX_BODY_CHARS)."\n…（以下省略）";
    }
}
