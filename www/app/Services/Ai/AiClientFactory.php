<?php

namespace App\Services\Ai;

use App\Models\UserAiCredential;

/**
 * SPEC-013: ユーザーの AI 資格情報から、provider に応じた生成アダプタを返す。
 * 現状 OpenAI を実装。anthropic / google は将来アダプタ追加で対応。
 */
class AiClientFactory
{
    public function forCredential(UserAiCredential $credential): AiTextGenerator
    {
        if (! $credential->hasUsableKey()) {
            throw new AiGenerationException('AI が有効化されていないか、API キーが未登録です。設定画面で登録してください。');
        }

        $apiKey = (string) $credential->api_key;
        $model = $credential->model;

        return match ($credential->provider) {
            UserAiCredential::PROVIDER_OPENAI => new OpenAiTextGenerator($apiKey, $model),
            UserAiCredential::PROVIDER_ANTHROPIC,
            UserAiCredential::PROVIDER_GOOGLE => throw new AiGenerationException(
                'プロバイダ「'.$credential->provider.'」は未対応です（現在は OpenAI のみ）。'
            ),
            default => throw new AiGenerationException('不明な AI プロバイダ: '.(string) $credential->provider),
        };
    }
}
