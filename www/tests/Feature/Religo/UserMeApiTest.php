<?php

namespace Tests\Feature\Religo;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

/**
 * GET /api/users/me, PATCH /api/users/me. E-4. 認証なしのため「現在ユーザー」は user id 1 固定.
 */
class UserMeApiTest extends TestCase
{
    use RefreshDatabase;

    private int $memberId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->memberId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function createMeUser(?int $ownerMemberId): void
    {
        DB::table('users')->insert([
            'id' => 1,
            'name' => 'Me',
            'email' => 'me@example.com',
            'password' => Hash::make('password'),
            'remember_token' => null,
            'created_at' => now(),
            'updated_at' => now(),
            'owner_member_id' => $ownerMemberId,
        ]);
    }

    public function test_show_me_returns_owner_member_id(): void
    {
        $this->createMeUser($this->memberId);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $data = $res->json();
        $this->assertSame($this->memberId, $data['owner_member_id']);
    }

    public function test_show_me_returns_null_when_not_set(): void
    {
        $this->createMeUser(null);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $data = $res->json();
        $this->assertNull($data['owner_member_id']);
    }

    public function test_show_me_returns_404_when_user_not_found(): void
    {
        $res = $this->getJson('/api/users/me');
        $res->assertStatus(404);
    }

    public function test_update_me_saves_owner_member_id(): void
    {
        $this->createMeUser(null);
        $res = $this->patchJson('/api/users/me', ['owner_member_id' => $this->memberId]);
        $res->assertOk();
        $data = $res->json();
        $this->assertSame($this->memberId, $data['owner_member_id']);
        $this->assertDatabaseHas('users', ['id' => 1, 'owner_member_id' => $this->memberId]);
    }

    public function test_update_me_returns_422_for_invalid_member(): void
    {
        $this->createMeUser(null);
        $res = $this->patchJson('/api/users/me', ['owner_member_id' => 99999]);
        $res->assertStatus(422);
    }

    public function test_update_me_returns_422_when_owner_member_id_missing(): void
    {
        $this->createMeUser(null);
        $res = $this->patchJson('/api/users/me', []);
        $res->assertStatus(422);
    }

    public function test_update_me_returns_404_when_user_not_found(): void
    {
        $res = $this->patchJson('/api/users/me', ['owner_member_id' => $this->memberId]);
        $res->assertStatus(404);
    }
}
