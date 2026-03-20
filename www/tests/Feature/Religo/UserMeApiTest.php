<?php

namespace Tests\Feature\Religo;

use App\Models\DragonflyContactFlag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

/**
 * GET /api/users/me, PATCH /api/users/me. E-4 / BO-AUDIT-P3.
 * 現在ユーザー: 認証時はその User、無認証時は users.id 昇順先頭。
 */
class UserMeApiTest extends TestCase
{
    use RefreshDatabase;

    private int $memberId;

    private int $otherMemberId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->memberId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->otherMemberId = (int) DB::table('members')->insertGetId([
            'name' => 'Other',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function createMeUser(?int $ownerMemberId, int $id = 1): void
    {
        DB::table('users')->insert([
            'id' => $id,
            'name' => 'Me',
            'email' => 'me'.$id.'@example.com',
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
        $this->assertSame(1, $data['id']);
        $this->assertSame($this->memberId, $data['owner_member_id']);
        $this->assertSame($this->memberId, $data['member_id']);
        $this->assertArrayHasKey('workspace_id', $data);
        $this->assertNull($data['workspace_id']);
    }

    public function test_show_me_returns_null_when_not_set(): void
    {
        $this->createMeUser(null);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['id']);
        $this->assertNull($data['owner_member_id']);
        $this->assertNull($data['member_id']);
        $this->assertNull($data['workspace_id']);
    }

    public function test_show_me_returns_404_when_user_not_found(): void
    {
        $res = $this->getJson('/api/users/me');
        $res->assertStatus(404);
    }

    public function test_show_me_when_acting_as_second_user_returns_that_user(): void
    {
        $this->createMeUser($this->memberId, 1);
        $this->createMeUser($this->otherMemberId, 2);
        $this->actingAs(User::find(2));
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(2, $data['id']);
        $this->assertSame($this->otherMemberId, $data['owner_member_id']);
    }

    public function test_show_me_includes_workspace_id_from_contact_flag(): void
    {
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Ch',
            'slug' => 'ch',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->createMeUser($this->memberId);
        DragonflyContactFlag::create([
            'owner_member_id' => $this->memberId,
            'target_member_id' => $this->otherMemberId,
            'interested' => true,
            'want_1on1' => false,
            'workspace_id' => $wsId,
        ]);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $this->assertSame($wsId, $res->json('workspace_id'));
    }

    public function test_update_me_saves_owner_member_id(): void
    {
        $this->createMeUser(null);
        $res = $this->patchJson('/api/users/me', ['owner_member_id' => $this->memberId]);
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['id']);
        $this->assertSame($this->memberId, $data['owner_member_id']);
        $this->assertSame($this->memberId, $data['member_id']);
        $this->assertDatabaseHas('users', ['id' => 1, 'owner_member_id' => $this->memberId]);
    }

    public function test_update_me_updates_acting_user_only(): void
    {
        $this->createMeUser(null, 1);
        $this->createMeUser(null, 2);
        $this->actingAs(User::find(2));
        $res = $this->patchJson('/api/users/me', ['owner_member_id' => $this->memberId]);
        $res->assertOk();
        $this->assertSame(2, $res->json('id'));
        $this->assertDatabaseHas('users', ['id' => 2, 'owner_member_id' => $this->memberId]);
        $this->assertDatabaseHas('users', ['id' => 1, 'owner_member_id' => null]);
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
