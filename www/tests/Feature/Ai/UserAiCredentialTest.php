<?php

namespace Tests\Feature\Ai;

use App\Models\User;
use App\Models\UserAiCredential;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-013: ユーザー AI 設定（BYO key・平文を返さない）。
 */
class UserAiCredentialTest extends TestCase
{
    use RefreshDatabase;

    private function user(): User
    {
        return User::create([
            'name' => 'u',
            'email' => 'u@example.com',
            'password' => bcrypt('secret-password'),
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
    }

    public function test_requires_authentication(): void
    {
        $this->getJson('/api/ai/credentials')->assertStatus(401);
    }

    public function test_save_and_mask_api_key(): void
    {
        Sanctum::actingAs($this->user());

        $this->putJson('/api/ai/credentials', [
            'ai_enabled' => true,
            'provider' => 'openai',
            'model' => 'gpt-4o-mini',
            'api_key' => 'sk-secret-123',
        ])->assertOk()
            ->assertJsonPath('ai_enabled', true)
            ->assertJsonPath('provider', 'openai')
            ->assertJsonPath('has_api_key', true);

        // 平文キーはレスポンスに含まれない
        $res = $this->getJson('/api/ai/credentials')->assertOk();
        $this->assertArrayNotHasKey('api_key', $res->json());
        $this->assertSame(true, $res->json('has_api_key'));

        // DB は暗号化（平文一致しない）
        $row = UserAiCredential::first();
        $this->assertNotSame('sk-secret-123', $row->getRawOriginal('api_key'));
        $this->assertSame('sk-secret-123', $row->api_key); // 復号で一致
    }

    public function test_empty_api_key_does_not_overwrite(): void
    {
        $u = $this->user();
        Sanctum::actingAs($u);
        $this->putJson('/api/ai/credentials', ['ai_enabled' => true, 'provider' => 'openai', 'api_key' => 'sk-keep']);

        // キー無しで provider/model 変更 → 既存キー維持
        $this->putJson('/api/ai/credentials', ['ai_enabled' => true, 'provider' => 'openai', 'model' => 'gpt-4o'])
            ->assertOk()
            ->assertJsonPath('has_api_key', true);
        $this->assertSame('sk-keep', UserAiCredential::first()->api_key);
    }
}
