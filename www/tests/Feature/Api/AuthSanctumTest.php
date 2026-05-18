<?php

namespace Tests\Feature\Api;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\PersonalAccessToken;
use Tests\TestCase;

class AuthSanctumTest extends TestCase
{
    use RefreshDatabase;

    public function test_login_returns_bearer_token(): void
    {
        $user = User::factory()->create([
            'email' => 'actor@example.com',
            'password' => Hash::make('secret-pass'),
        ]);

        $res = $this->postJson('/api/auth/login', [
            'email' => 'actor@example.com',
            'password' => 'secret-pass',
            'device_name' => 'phpunit',
        ]);

        $res->assertOk();
        $res->assertJsonPath('token_type', 'Bearer');
        $res->assertJsonPath('user.id', $user->id);
        $this->assertNotEmpty($res->json('token'));
        $this->assertSame(1, PersonalAccessToken::query()->count());
    }

    public function test_login_rejects_bad_password(): void
    {
        User::factory()->create([
            'email' => 'u@example.com',
            'password' => Hash::make('right'),
        ]);

        $res = $this->postJson('/api/auth/login', [
            'email' => 'u@example.com',
            'password' => 'wrong',
        ]);

        $res->assertStatus(422);
    }

    public function test_me_uses_bearer_actor_not_first_user_fallback(): void
    {
        User::factory()->create(['email' => 'first@example.com']);
        $second = User::factory()->create([
            'email' => 'second@example.com',
            'password' => Hash::make('pw'),
            'owner_member_id' => null,
        ]);

        $login = $this->postJson('/api/auth/login', [
            'email' => 'second@example.com',
            'password' => 'pw',
        ]);
        $token = $login->json('token');

        $me = $this->withToken($token)->getJson('/api/users/me');
        $me->assertOk();
        $me->assertJsonPath('id', $second->id);
    }

    public function test_invalid_bearer_returns_401(): void
    {
        User::factory()->create();

        $this->withToken('not-a-real-token')->getJson('/api/users/me')
            ->assertStatus(401);
    }

    public function test_logout_revokes_token(): void
    {
        $user = User::factory()->create([
            'email' => 'logout@example.com',
            'password' => Hash::make('pw'),
        ]);

        $login = $this->postJson('/api/auth/login', [
            'email' => 'logout@example.com',
            'password' => 'pw',
        ]);
        $token = $login->json('token');

        $this->withToken($token)->postJson('/api/auth/logout')->assertOk();
        $this->assertDatabaseCount('personal_access_tokens', 0);

        $this->withToken($token)->getJson('/api/users/me')->assertStatus(401);
    }
}
