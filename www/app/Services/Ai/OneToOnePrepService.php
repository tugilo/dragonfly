<?php

namespace App\Services\Ai;

use App\Models\ContactMemo;
use App\Models\OneToOne;
use App\Models\OneToOneAttachment;
use App\Models\UserAiCredential;

/**
 * SPEC-013: 1to1 事前準備ドキュメント（原稿）を AI で生成する。
 *
 * Cursor でローカル作成している md（基本プロフィール・サマリー・共通点・リファーラル戦略・
 * 台本/質問・次アクション・メモ）と同等の構成を、添付テキスト＋メンバー情報＋過去メモから生成する。
 * 出力は下書き（人が校正して保存）。
 */
class OneToOnePrepService
{
    private const MAX_SOURCE_CHARS = 16000;

    public function __construct(private AiClientFactory $factory) {}

    public function generate(OneToOne $oneToOne, UserAiCredential $credential): string
    {
        $generator = $this->factory->forCredential($credential);

        $systemPrompt = $this->systemPrompt();
        $userPrompt = $this->buildUserPrompt($oneToOne);

        return $generator->generate($systemPrompt, $userPrompt, $credential->model);
    }

    private function systemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI の 1 to 1（1対1ミーティング）の事前準備を支援する日本語アシスタントです。',
            '提供された相手プロフィール・メモから、紹介（リファーラル）につながる実践的な事前準備ドキュメントを作成します。',
            '次の見出しで、日本語の Markdown を出力してください:',
            '## 基本プロフィール / ## サマリー / ## 共通点・接点 / ## リファーラル戦略（紹介できそう・紹介してほしい） / ## 1to1 台本・質問リスト / ## 次アクション / ## メモ（人物・温度感）',
            '制約: 提供情報に無い事実は断定しない（推測は「推測」と明記）。簡潔で箇条書き中心。最後に「（AI 下書き・要校正）」と付記する。',
        ]);
    }

    private function buildUserPrompt(OneToOne $oneToOne): string
    {
        $oneToOne->loadMissing(['ownerMember:id,name', 'targetMember:id,name']);

        $owner = $oneToOne->ownerMember?->name ?? '（自分）';
        $target = $oneToOne->targetMember?->name ?? '（相手）';

        $parts = [];
        $parts[] = "# 1to1 事前準備の入力";
        $parts[] = "自分（owner）: {$owner}";
        $parts[] = "相手（target）: {$target}";

        if (! empty($oneToOne->notes)) {
            $parts[] = "\n## これまでの notes\n".$oneToOne->notes;
        }

        $memos = ContactMemo::query()
            ->where('one_to_one_id', $oneToOne->id)
            ->orderByDesc('created_at')
            ->limit(10)
            ->pluck('body')
            ->filter()
            ->all();
        if (! empty($memos)) {
            $parts[] = "\n## 過去メモ（新しい順）\n- ".implode("\n- ", $memos);
        }

        $attachments = OneToOneAttachment::query()
            ->where('one_to_one_id', $oneToOne->id)
            ->orderBy('id')
            ->get();
        if ($attachments->isNotEmpty()) {
            $parts[] = "\n## 相手プロフィール（添付からの抽出テキスト）";
            foreach ($attachments as $a) {
                $label = $a->original_name ?: ($a->source_url ?: $a->source_type);
                $text = trim((string) $a->extracted_text);
                if ($text !== '') {
                    $parts[] = "\n### 添付: {$label}\n".$text;
                }
            }
        } else {
            $parts[] = "\n## 相手プロフィール\n（添付なし。一般的な BNI 1to1 準備として、相手に確認すべき質問を中心に作成してください）";
        }

        $joined = implode("\n", $parts);

        // トークン/コスト保護のため上限で切り詰め。
        if (mb_strlen($joined) > self::MAX_SOURCE_CHARS) {
            $joined = mb_substr($joined, 0, self::MAX_SOURCE_CHARS)."\n…（以下省略）";
        }

        return $joined;
    }
}
