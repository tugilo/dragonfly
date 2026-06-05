<?php

namespace Tests\Feature\Ai;

use App\Models\User;
use App\Models\UserAiCredential;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
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
        $this->assertIsArray($res->json('available_models.openai'));
        $this->assertNotEmpty($res->json('available_models.openai'));

        // DB は暗号化（平文一致しない）
        $row = UserAiCredential::first();
        $this->assertNotSame('sk-secret-123', $row->getRawOriginal('api_key'));
        $this->assertSame('sk-secret-123', $row->api_key); // 復号で一致
    }

    public function test_test_endpoint_requires_setup(): void
    {
        Sanctum::actingAs($this->user());
        $this->postJson('/api/ai/credentials/test')->assertStatus(422);
    }

    public function test_test_endpoint_ok_with_openai_fake(): void
    {
        $u = $this->user();
        Sanctum::actingAs($u);
        UserAiCredential::create([
            'user_id' => $u->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'model' => 'gpt-4o-mini', 'is_active' => true,
        ]);
        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => 'OK']]],
        ], 200)]);

        $this->postJson('/api/ai/credentials/test')
            ->assertOk()
            ->assertJsonPath('ok', true)
            ->assertJsonPath('provider', 'openai');
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

    public function test_rejects_unknown_openai_model(): void
    {
        Sanctum::actingAs($this->user());

        $this->putJson('/api/ai/credentials', [
            'ai_enabled' => true,
            'provider' => 'openai',
            'model' => 'not-a-real-model',
            'api_key' => 'sk-test',
        ])->assertStatus(422);
    }

    public function test_show_handles_unreadable_encrypted_api_key(): void
    {
        $u = $this->user();
        Sanctum::actingAs($u);
        $cred = UserAiCredential::create([
            'user_id' => $u->id,
            'ai_enabled' => true,
            'provider' => 'openai',
            'model' => 'gpt-4o-mini',
            'is_active' => true,
        ]);
        \Illuminate\Support\Facades\DB::table('user_ai_credentials')
            ->where('id', $cred->id)
            ->update(['api_key' => 'eyJpdiI6InRlc3QiLCJ2YWx1ZSI6ImZha2UiLCJtYWMiOiJmYWtlIiwidGFnIjoiIn0=']);

        $this->getJson('/api/ai/credentials')
            ->assertOk()
            ->assertJsonPath('has_api_key', false)
            ->assertJsonPath('credential_decrypt_error', true);
    }

    public function test_accepts_gpt5_5_model(): void
    {
        Sanctum::actingAs($this->user());

        $this->putJson('/api/ai/credentials', [
            'ai_enabled' => true,
            'provider' => 'openai',
            'model' => 'gpt-5.5',
            'api_key' => 'sk-test',
        ])->assertOk()
            ->assertJsonPath('model', 'gpt-5.5');
    }
}
