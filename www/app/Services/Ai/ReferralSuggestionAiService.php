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

    private function truncate(string $text): string
    {
        if (mb_strlen($text) <= self::MAX_BODY_CHARS) {
            return $text;
        }

        return mb_substr($text, 0, self::MAX_BODY_CHARS)."\n…（以下省略）";
    }
}
