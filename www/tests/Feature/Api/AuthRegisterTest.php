<?php

namespace Tests\Feature\Api;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthRegisterTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        config(['religo.registration_expose_debug_code' => true]);
    }

    public function test_request_returns_debug_code_for_known_member_email(): void
    {
        $wsId = $this->createWorkspace();
        $this->createMember($wsId, 'taro@example.com', 'Taro');

        $res = $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);

        $res->assertOk();
        $res->assertJsonStructure(['message', 'debug_code']);
        $this->assertMatchesRegularExpression('/^\d{6}$/', $res->json('debug_code'));
    }

    public function test_request_is_generic_for_unknown_email(): void
    {
        $res = $this->postJson('/api/auth/register/request', [
            'email' => 'unknown@example.com',
        ]);

        $res->assertOk();
        $res->assertJsonMissing(['debug_code']);
    }

    public function test_complete_creates_user_bound_to_member(): void
    {
        $wsId = $this->createWorkspace();
        $memberId = $this->createMember($wsId, 'taro@example.com', 'Taro');

        $request = $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);
        $code = $request->json('debug_code');

        $res = $this->postJson('/api/auth/register/complete', [
            'email' => 'taro@example.com',
            'code' => $code,
            'password' => 'secret-pass',
            'password_confirmation' => 'secret-pass',
        ]);

        $res->assertCreated();
        $this->assertDatabaseHas('users', [
            'email' => 'taro@example.com',
            'owner_member_id' => $memberId,
            'default_workspace_id' => $wsId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);

        $login = $this->postJson('/api/auth/login', [
            'email' => 'taro@example.com',
            'password' => 'secret-pass',
        ]);
        $login->assertOk();
    }

    public function test_complete_rejects_wrong_code(): void
    {
        $wsId = $this->createWorkspace();
        $this->createMember($wsId, 'taro@example.com', 'Taro');

        $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);

        $res = $this->postJson('/api/auth/register/complete', [
            'email' => 'taro@example.com',
            'code' => '000000',
            'password' => 'secret-pass',
            'password_confirmation' => 'secret-pass',
        ]);

        $res->assertStatus(422);
    }

    public function test_request_rejects_existing_user_email(): void
    {
        $wsId = $this->createWorkspace();
        $this->createMember($wsId, 'taro@example.com', 'Taro');
        User::factory()->create(['email' => 'taro@example.com']);

        $res = $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);

        $res->assertStatus(422);
    }

    private function createWorkspace(): int
    {
        return (int) DB::table('workspaces')->insertGetId([
            'name' => 'Test WS',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function createMember(int $wsId, string $email, string $name): int
    {
        return (int) DB::table('members')->insertGetId([
            'name' => $name,
            'name_kana' => 'テスト',
            'display_no' => '1',
            'type' => 'active',
            'workspace_id' => $wsId,
            'email' => $email,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    protected function tearDown(): void
    {
        Cache::flush();
        parent::tearDown();
    }
}
