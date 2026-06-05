<?php

namespace App\Http\Controllers\Ai;

use App\Http\Controllers\Controller;
use App\Models\UserAiCredential;
use App\Services\Ai\AiClientFactory;
use App\Services\Ai\AiGenerationException;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * SPEC-013: ユーザーごとの AI 設定（BYO key）。認証済みユーザー本人のみ。
 * API キーの平文は返さない（登録済みか否かのみ）。
 */
class UserAiCredentialController extends Controller
{
    public function __construct(private AiClientFactory $factory) {}

    public function show(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }
        $cred = UserAiCredential::where('user_id', $user->id)->first();

        return response()->json($this->payload($cred));
    }

    public function update(Request $request): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $provider = (string) ($request->input('provider') ?? UserAiCredential::where('user_id', $user->id)->value('provider') ?? UserAiCredential::PROVIDER_OPENAI);
        $modelRule = ['nullable', 'string', 'max:100'];
        if ($provider === UserAiCredential::PROVIDER_OPENAI) {
            $modelRule[] = Rule::in($this->openAiModelIds());
        }

        $validated = $request->validate([
            'ai_enabled' => ['required', 'boolean'],
            'provider' => ['nullable', 'string', Rule::in(UserAiCredential::PROVIDERS)],
            'model' => $modelRule,
            'api_key' => ['nullable', 'string', 'max:500'],
            'is_active' => ['nullable', 'boolean'],
        ]);

        $cred = UserAiCredential::firstOrNew(['user_id' => $user->id]);
        $cred->ai_enabled = (bool) $validated['ai_enabled'];
        if (array_key_exists('provider', $validated)) {
            $cred->provider = $validated['provider'];
        }
        if (array_key_exists('model', $validated)) {
            $cred->model = $validated['model'];
        }
        if (array_key_exists('is_active', $validated)) {
            $cred->is_active = (bool) $validated['is_active'];
        }
        // api_key は値が来たときのみ更新（空送信で既存を消さない）。
        if (! empty($validated['api_key'])) {
            $cred->api_key = $validated['api_key'];
        }
        $cred->save();

        return response()->json($this->payload($cred->refresh()));
    }

    /**
     * POST /api/ai/credentials/test — 保存済みキーで最小の AI 呼び出しを行い疎通確認する。
     */
    public function test(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }
        $cred = UserAiCredential::where('user_id', $user->id)->first();
        if ($cred !== null && $cred->apiKeyDecryptFailed()) {
            return response()->json([
                'ok' => false,
                'credential_decrypt_error' => true,
                'message' => '保存済みの API キーを復号できません（別環境の APP_KEY で暗号化されたデータの可能性があります）。API キーを再入力して保存してください。',
            ], 422);
        }
        if ($cred === null || ! $cred->hasUsableKey()) {
            return response()->json(['ok' => false, 'message' => 'AI が有効化されていないか、API キーが未登録です。先に保存してください。'], 422);
        }

        try {
            $generator = $this->factory->forCredential($cred);
            $reply = $generator->generate(
                'あなたは接続テスト用のアシスタントです。',
                '接続確認です。「OK」とだけ短く返答してください。',
                $cred->model
            );
        } catch (AiGenerationException $e) {
            return response()->json(['ok' => false, 'message' => $e->getMessage()], 422);
        }

        return response()->json([
            'ok' => true,
            'provider' => $cred->provider,
            'model' => $cred->model ?: (string) config('services.ai.openai.default_model'),
            'sample' => mb_substr(trim($reply), 0, 80),
            'message' => 'AI への接続に成功しました。',
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    private function payload(?UserAiCredential $cred): array
    {
        return [
            'ai_enabled' => (bool) ($cred?->ai_enabled ?? false),
            'provider' => $cred?->provider,
            'model' => $cred?->model,
            'is_active' => (bool) ($cred?->is_active ?? true),
            'has_api_key' => $cred !== null && $cred->readEncryptedAttribute('api_key') !== null,
            'credential_decrypt_error' => (bool) ($cred?->apiKeyDecryptFailed()),
            'available_providers' => UserAiCredential::PROVIDERS,
            'implemented_providers' => [UserAiCredential::PROVIDER_OPENAI],
            'default_model' => (string) config('services.ai.openai.default_model'),
            'available_models' => $this->availableModelsByProvider(),
        ];
    }

    /**
     * @return array<string, list<array{id: string, label: string}>>
     */
    private function availableModelsByProvider(): array
    {
        $openai = config('services.ai.openai.models', []);
        if (! is_array($openai)) {
            $openai = [];
        }

        return [
            UserAiCredential::PROVIDER_OPENAI => array_values(array_filter($openai, static function ($row): bool {
                return is_array($row) && isset($row['id'], $row['label']);
            })),
            UserAiCredential::PROVIDER_ANTHROPIC => [],
            UserAiCredential::PROVIDER_GOOGLE => [],
        ];
    }

    /**
     * @return list<string>
     */
    private function openAiModelIds(): array
    {
        $ids = [];
        foreach (config('services.ai.openai.models', []) as $row) {
            if (is_array($row) && isset($row['id']) && is_string($row['id'])) {
                $ids[] = $row['id'];
            }
        }

        return $ids;
    }
}
