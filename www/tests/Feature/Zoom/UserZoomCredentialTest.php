<?php

namespace Tests\Feature\Zoom;

use App\Models\User;
use App\Models\UserZoomCredential;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-012 拡張: ユーザー Zoom 資格情報（BYO app credentials・平文を返さない）。
 */
class UserZoomCredentialTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        config([
            'services.zoom.redirect' => 'https://example.test/api/zoom/callback',
            'services.zoom.client_id' => '',
            'services.zoom.client_secret' => '',
        ]);
    }

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
        $this->getJson('/api/zoom/credentials')->assertStatus(401);
    }

    public function test_save_and_mask_secrets(): void
    {
        Sanctum::actingAs($this->user());

        $this->putJson('/api/zoom/credentials', [
            'client_id' => 'my-client-id',
            'client_secret' => 'my-client-secret',
            'webhook_secret_token' => 'wh-secret',
        ])->assertOk()
            ->assertJsonPath('client_id', 'my-client-id')
            ->assertJsonPath('has_client_secret', true)
            ->assertJsonPath('has_webhook_secret', true)
            ->assertJsonPath('configured', true)
            ->assertJsonPath('credential_source', 'user');

        $res = $this->getJson('/api/zoom/credentials')->assertOk();
        $this->assertArrayNotHasKey('client_secret', $res->json());
        $this->assertArrayNotHasKey('webhook_secret_token', $res->json());

        $row = UserZoomCredential::first();
        $this->assertNotSame('my-client-secret', $row->getRawOriginal('client_secret'));
        $this->assertSame('my-client-secret', $row->client_secret);
    }

    public function test_empty_secret_does_not_overwrite(): void
    {
        $u = $this->user();
        Sanctum::actingAs($u);
        $this->putJson('/api/zoom/credentials', [
            'client_id' => 'cid',
            'client_secret' => 'keep-secret',
        ]);

        $this->putJson('/api/zoom/credentials', ['client_id' => 'cid-updated'])
            ->assertOk()
            ->assertJsonPath('has_client_secret', true);

        $this->assertSame('keep-secret', UserZoomCredential::first()->client_secret);
        $this->assertSame('cid-updated', UserZoomCredential::first()->client_id);
    }

    public function test_env_fallback_when_user_has_no_credentials(): void
    {
        config([
            'services.zoom.client_id' => 'env-id',
            'services.zoom.client_secret' => 'env-secret',
        ]);
        Sanctum::actingAs($this->user());

        $this->getJson('/api/zoom/credentials')
            ->assertOk()
            ->assertJsonPath('configured', true)
            ->assertJsonPath('credential_source', 'env')
            ->assertJsonPath('has_user_credentials', false);
    }

    public function test_test_endpoint_requires_user_credentials(): void
    {
        Sanctum::actingAs($this->user());
        $this->postJson('/api/zoom/credentials/test')->assertStatus(422);
    }

    public function test_test_endpoint_ok_with_invalid_grant(): void
    {
        $u = $this->user();
        Sanctum::actingAs($u);
        UserZoomCredential::create([
            'user_id' => $u->id,
            'client_id' => 'cid',
            'client_secret' => 'csecret',
            'is_active' => true,
        ]);

        Http::fake([
            'zoom.us/oauth/token' => Http::response(['reason' => 'Invalid authorization code'], 400),
        ]);

        $this->postJson('/api/zoom/credentials/test')
            ->assertOk()
            ->assertJsonPath('ok', true);
    }

    public function test_test_endpoint_fails_on_unauthorized(): void
    {
        $u = $this->user();
        Sanctum::actingAs($u);
        UserZoomCredential::create([
            'user_id' => $u->id,
            'client_id' => 'bad',
            'client_secret' => 'bad',
            'is_active' => true,
        ]);

        Http::fake([
            'zoom.us/oauth/token' => Http::response(['error' => 'invalid_client'], 401),
        ]);

        $this->postJson('/api/zoom/credentials/test')
            ->assertStatus(422)
            ->assertJsonPath('ok', false);
    }
}
