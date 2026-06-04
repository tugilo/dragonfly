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
            "target_member_id（相手）: {$targetId}（{$oneToOne->targetMember?->name}）",
            '',
            '# チャプターメンバー名簿（id・氏名・カテゴリのみ）',
            $this->roster->formatRosterForPrompt($rosterRows),
            '',
            '上記から外部リファーラル候補を JSON のみで出力してください。',
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
            '# チャプターメンバー名簿（id・氏名・カテゴリのみ）',
            $this->roster->formatRosterForPrompt($rosterRows),
            '',
            "依頼者 requester_member_id: {$requesterMemberId}（記録者）",
            "主役 subject_member_id: ".(int) $oneToOne->target_member_id.'（'.$oneToOne->targetMember?->name.'）',
            '',
            '上記から JSON のみで出力してください。**最優先は「主役が会うべき章内メンバー」**（direction=subject_should_meet）。',
            '- subject_should_meet: match_member_id=名簿のメンバー M（主役と 1 to 1 すべき相手）。suggested_to_member_id も同じ M。rationale に 121# / 定例会を引用',
            '- 他者 121 から見つけたマッチは corpus_source=member_network。主役本人の記録のみなら self',
            '- via_connector は **A の社外・顧客など chapter 外の B** がはっきり書いてあるときだけ。connector_member_id は名簿の実 ID（例の 1 は使わない）',
            '- via_connector: connector_member_id=A, suggested_to_member_id=依頼者, suggested_contact_label=B（必須）',
            '- 議事録の外部紹介先のみのときは owner_to_target 等',
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
            '# 当回参加者（members）',
            $participantLines === [] ? '（なし）' : implode("\n", $participantLines),
            '',
            '# 記録者 owner_member_id',
            (string) $ownerMemberId,
            '',
            '# チャプターメンバー名簿',
            $this->roster->formatRosterForPrompt($rosterRows),
            '',
            'メインプレ・ウィークリー・ビジター紹介等から外部リファーラル候補を JSON のみで出力してください。リファラル件数報告セクションは無視してください。',
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
            '# チャプターメンバー名簿（id・氏名・カテゴリのみ）',
            $this->roster->formatRosterForPrompt($rosterRows),
            '',
            '# 当回参加者（subject 候補）',
            $participantLines === [] ? '（なし）' : implode("\n", $participantLines),
            '',
            "依頼者 requester_member_id: {$requesterMemberId}",
            '',
            '上記から JSON のみで出力。**最優先は登壇者・主役（subject_member_id）が会うべき章内メンバー**（subject_should_meet）。',
            '- subject_should_meet: subject_member_id=主役, match_member_id=つなぐべきメンバー M（名簿の実 ID）',
            '- 横断 121 由来は corpus_source=member_network + source_one_to_one_id',
            '- via_connector は社外 contact が明記されている場合のみ（connector_member_id は実 ID、例の 1 禁止）',
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
            'あなたは BNI 章の記録から「主役メンバーが**会うべき章内メンバー**」と、必要なら「つなぎ手経由の社外紹介」を提案するアシスタントです。',
            '**出力の過半数は direction=subject_should_meet**（主役と match_member_id のメンバーをつなぐ）。',
            'Givers Gain: 社外 contact だけ via_connector（つなぎ手 A が依頼者に B を紹介）。',
            '応答は **有効な JSON オブジェクトのみ**。',
            'スキーマ（数値 id は名簿の実 ID のみ。プレースホルダー id は出力禁止）:',
            '{"suggestions":[{"direction":"subject_should_meet|owner_to_target|target_to_owner|mutual|unclear|via_connector","corpus_source":"self|member_network","summary":"誰と誰をなぜつなぐか1–2文","rationale":"引用: 121#38 の一文 / 第210回 MP など","quality_notes":[],"match_member_id":null,"connector_member_id":null,"suggested_from_member_id":null,"suggested_to_member_id":null,"suggested_contact_label":null,"suggested_to_label":null,"source_one_to_one_id":null,"source_meeting_id":null,"confidence":"high|medium|low"}]}',
            'subject_should_meet: match_member_id 必須（主役≠match）。source_* で根拠を特定。',
            'via_connector: connector_member_id + suggested_contact_label 必須。社外 B が議事録にいる場合のみ。',
            '議事録・抜粋に無い事実は提案しない。最低 1 件、根拠がある subject_should_meet を優先。',
            'Pack 内の introductions に既にある from→to の組み合わせは提案しない。',
        ]);
    }

    private function oneToOneSystemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI 活動の外部リファーラル（人のつなぎ）候補を議事録から抽出するアシスタントです。',
            '応答は **有効な JSON オブジェクトのみ**（説明文・Markdown 禁止）。',
            'スキーマ:',
            '{"suggestions":[{"direction":"owner_to_target|target_to_owner|mutual|unclear","summary":"...","rationale":"...","quality_notes":[],"suggested_from_member_id":1,"suggested_to_member_id":2,"suggested_to_label":null,"confidence":"high|medium|low"}]}',
            'member_id は名簿に存在する id のみ。suggested_to_member_id が不明なら null と suggested_to_label に業種像を書く。',
            '議事録に無い事実は提案しない。',
        ]);
    }

    private function meetingSystemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI 定例会議事録から外部リファーラル候補を抽出するアシスタントです。',
            '応答は **有効な JSON オブジェクトのみ**。',
            'スキーマ:',
            '{"suggestions":[{"source_section":"main_presentation|weekly_presentation|visitor_intro|share_story|education|other","subject_member_id":1,"direction":"subject_seeks_intros|owner_introduces_to_subject|owner_introduces_subject|mutual|unclear","summary":"...","rationale":"...","quality_notes":[],"suggested_from_member_id":1,"suggested_to_member_id":null,"suggested_to_label":"...","confidence":"high|medium|low"}]}',
            'MP の「紹介希望先」「求めている紹介先」を優先。member_id は名簿・参加者に存在するもののみ。',
        ]);
    }

    private function meetingRelationshipSystemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI 定例会・章内記録から「登壇者・主役が会うべき章内メンバー」を最優先で提案するアシスタントです。',
            '**過半数は direction=subject_should_meet**（subject_member_id の主役と match_member_id をつなぐ）。',
            '社外 contact のみ via_connector。応答は **有効な JSON オブジェクトのみ**。',
            'スキーマ（id は名簿・参加者の実 ID のみ）:',
            '{"suggestions":[{"source_section":"main_presentation|weekly_presentation|visitor_intro|share_story|education|other","subject_member_id":null,"direction":"subject_should_meet|subject_seeks_intros|owner_introduces_to_subject|owner_introduces_subject|mutual|unclear|via_connector","corpus_source":"self|member_network","summary":"...","rationale":"121# / 第N回 を引用","quality_notes":[],"match_member_id":null,"connector_member_id":null,"suggested_from_member_id":null,"suggested_to_member_id":null,"suggested_contact_label":null,"suggested_to_label":null,"source_one_to_one_id":null,"source_meeting_id":null,"confidence":"high|medium|low"}]}',
            'リファラル件数報告セクションは無視。',
            'Pack 内の introductions に既にある from→to は重複提案しない。',
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
