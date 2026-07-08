<?php

namespace App\Services\Ai;

use App\Models\UserAiCredential;
use InvalidArgumentException;

/**
 * SPEC-022: つなぐ準備文案を AI 生成する。
 */
class ReferralConnectCopyAiService
{
    private const BLOCK_LABELS = [
        'consent_a' => '了承依頼（A向け）',
        'consent_b' => '了承依頼（B向け）',
        'intro_a_to_b' => 'A向け: Bの紹介（グループ用）',
        'intro_b_to_a' => 'B向け: Aの紹介（グループ用）',
        'group_opening' => 'グループ初回投稿',
        'connector_request' => 'つなぎ手への紹介依頼',
    ];

    public function __construct(
        private AiClientFactory $factory,
    ) {}

    /**
     * @return array{blocks: list<array{key: string, label: string, text: string}>, provider: string, model: string|null}
     */
    public function generate(
        string $corpusText,
        string $direction,
        string $channelHint,
        bool $bothMembers,
        bool $isViaConnector,
        bool $bIsLabelOnly,
        UserAiCredential $credential,
    ): array {
        $generator = $this->factory->forCredential($credential);

        $blockKeys = $this->requestedBlockKeys($bothMembers, $isViaConnector, $bIsLabelOnly);
        $keysList = implode(', ', $blockKeys);

        $userPrompt = implode("\n", [
            '# 入力コーパス',
            $corpusText,
            '',
            '# 生成条件',
            "提案 direction: {$direction}",
            "チャネル文体ヒント: {$channelHint}",
            "生成する block key: {$keysList}",
            '',
            '上記コーパスの範囲で、BNI 運用に沿った敬体の文案を JSON で出力してください。',
            '議事録に無い固有名詞・事例は創作しない。不明時はカテゴリ程度に留める。',
            '各 text は 400〜800 字目安（LINE/Messenger で読める長さ）。',
        ]);

        $raw = $generator->generate($this->systemPrompt(), $userPrompt, $credential->model);
        $parsed = $this->parseBlocks($raw);
        $filtered = $this->filterBlocks($parsed, $blockKeys);

        return [
            'blocks' => $filtered,
            'provider' => $generator->provider(),
            'model' => $credential->model,
        ];
    }

    /**
     * @return list<string>
     */
    private function requestedBlockKeys(bool $bothMembers, bool $isViaConnector, bool $bIsLabelOnly): array
    {
        $keys = ['consent_a', 'consent_b'];

        if ($bothMembers) {
            $keys[] = 'intro_a_to_b';
            $keys[] = 'intro_b_to_a';
            $keys[] = 'group_opening';
        }

        if ($isViaConnector || $bIsLabelOnly) {
            $keys[] = 'connector_request';
        }

        return $keys;
    }

    private function systemPrompt(): string
    {
        return implode("\n", [
            'あなたは BNI 章のつなぎ手が LINE/Messenger で送る紹介・了承依頼文案を作成するアシスタントです。',
            '応答は **有効な JSON オブジェクトのみ**。',
            'スキーマ:',
            '{"blocks":[{"key":"consent_a|consent_b|intro_a_to_b|intro_b_to_a|group_opening|connector_request","label":"表示ラベル","text":"文案本文"}]}',
            'consent_a/b: 個別 DM の了承依頼（グループ作成可否を尋ねる）。',
            'intro_a_to_b / intro_b_to_a: グループ内で相手を紹介する短文。',
            'group_opening: つなぎ手名から始まる統合投稿（挨拶→B紹介→A紹介→接点→締め）。',
            'connector_request: つなぎ手へ社外 contact の紹介を依頼する DM。',
            '指定された key のみ出力。label は日本語で簡潔に。',
        ]);
    }

    /**
     * @return list<array{key: string, label: string, text: string}>
     */
    private function parseBlocks(string $raw): array
    {
        $trimmed = trim($raw);
        if (str_starts_with($trimmed, '```')) {
            $trimmed = preg_replace('/^```(?:json)?\s*/i', '', $trimmed) ?? $trimmed;
            $trimmed = preg_replace('/\s*```\s*$/', '', $trimmed) ?? $trimmed;
        }

        $decoded = json_decode($trimmed, true);
        if (! is_array($decoded) || ! isset($decoded['blocks']) || ! is_array($decoded['blocks'])) {
            throw new InvalidArgumentException('AI の応答を文案 JSON として解釈できませんでした。');
        }

        $blocks = [];
        foreach ($decoded['blocks'] as $item) {
            if (! is_array($item)) {
                continue;
            }
            $key = (string) ($item['key'] ?? '');
            $text = trim((string) ($item['text'] ?? ''));
            if ($key === '' || $text === '') {
                continue;
            }
            $blocks[] = [
                'key' => $key,
                'label' => (string) ($item['label'] ?? (self::BLOCK_LABELS[$key] ?? $key)),
                'text' => $text,
            ];
        }

        if ($blocks === []) {
            throw new InvalidArgumentException('AI が有効な文案ブロックを返しませんでした。');
        }

        return $blocks;
    }

    /**
     * @param  list<array{key: string, label: string, text: string}>  $blocks
     * @param  list<string>  $allowedKeys
     * @return list<array{key: string, label: string, text: string}>
     */
    private function filterBlocks(array $blocks, array $allowedKeys): array
    {
        $allowed = array_flip($allowedKeys);
        $out = [];
        foreach ($blocks as $block) {
            if (! isset($allowed[$block['key']])) {
                continue;
            }
            $out[] = [
                'key' => $block['key'],
                'label' => self::BLOCK_LABELS[$block['key']] ?? $block['label'],
                'text' => $block['text'],
            ];
        }

        if ($out === []) {
            throw new InvalidArgumentException('条件に合致する文案ブロックがありませんでした。');
        }

        return $out;
    }
}
