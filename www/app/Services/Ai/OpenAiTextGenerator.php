<?php

namespace App\Services\Ai;

use Illuminate\Support\Facades\Http;

/**
 * SPEC-013: OpenAI（Chat Completions）アダプタ。
 * API キーはユーザーごと（user_ai_credentials）から渡される。
 */
class OpenAiTextGenerator implements AiTextGenerator
{
    public function __construct(private string $apiKey, private ?string $model = null) {}

    public function provider(): string
    {
        return 'openai';
    }

    public function generate(string $systemPrompt, string $userPrompt, ?string $model = null): string
    {
        if ($this->apiKey === '') {
            throw new AiGenerationException('OpenAI API キーが未設定です。');
        }

        $base = rtrim((string) config('services.ai.openai.base_url'), '/');
        $useModel = $model ?: ($this->model ?: (string) config('services.ai.openai.default_model'));
        $timeout = (int) config('services.ai.request_timeout', 60);

        try {
            $response = Http::withToken($this->apiKey)
                ->acceptJson()
                ->timeout($timeout)
                ->post($base.'/chat/completions', [
                    'model' => $useModel,
                    'messages' => [
                        ['role' => 'system', 'content' => $systemPrompt],
                        ['role' => 'user', 'content' => $userPrompt],
                    ],
                    'temperature' => 0.4,
                ]);
        } catch (\Throwable $e) {
            throw new AiGenerationException('OpenAI への接続に失敗しました: '.$e->getMessage());
        }

        if ($response->status() === 401) {
            throw new AiGenerationException('OpenAI API キーが無効です（401）。設定を確認してください。');
        }
        if ($response->status() === 429) {
            throw new AiGenerationException('OpenAI のレート制限に達しました（429）。時間をおいて再試行してください。');
        }
        if (! $response->successful()) {
            $msg = $response->json('error.message') ?? ('HTTP '.$response->status());
            throw new AiGenerationException('OpenAI 生成に失敗しました: '.$msg);
        }

        $content = $response->json('choices.0.message.content');
        if (! is_string($content) || trim($content) === '') {
            throw new AiGenerationException('OpenAI から空の応答が返りました。');
        }

        return trim($content);
    }
}
