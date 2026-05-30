<?php

namespace App\Services\Ai;

/**
 * SPEC-013: AI テキスト生成のプロバイダ抽象。
 * provider ごとにアダプタを実装し、ユーザーの選択に応じて切替える。
 */
interface AiTextGenerator
{
    public function provider(): string;

    /**
     * システムプロンプト＋ユーザープロンプトから本文を生成して返す。
     *
     * @throws AiGenerationException 認証・レート・通信エラー等
     */
    public function generate(string $systemPrompt, string $userPrompt, ?string $model = null): string;
}
