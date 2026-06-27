<?php

namespace Tests\Feature\Religo;

use App\Models\DragonflyContactFlag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * GET /api/users/me, PATCH /api/users/me. E-4 / BO-AUDIT-P3〜P4.
 * 現在ユーザー: Sanctum Bearer または web session（actingAs）。phpunit で RELIGO_ACTING_USER_FALLBACK=false のため未認証では解決しない。
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

    private function createMeUser(?int $ownerMemberId, int $id = 1, ?int $defaultWorkspaceId = null): void
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
            'default_workspace_id' => $defaultWorkspaceId,
        ]);
    }

    private function actingAsUserId(int $id): void
    {
        Sanctum::actingAs(User::findOrFail($id));
    }

    public function test_show_me_returns_owner_member_id(): void
    {
        $this->createMeUser($this->memberId);
        $this->actingAsUserId(1);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['id']);
        $this->assertSame($this->memberId, $data['owner_member_id']);
        $this->assertSame($this->memberId, $data['member_id']);
        $this->assertArrayHasKey('default_workspace_id', $data);
        $this->assertNull($data['default_workspace_id']);
        $this->assertArrayHasKey('religo_role', $data);
        $this->assertSame('member', $data['religo_role']);
    }

    public function test_show_me_returns_stored_religo_role(): void
    {
        $this->createMeUser($this->memberId);
        DB::table('users')->where('id', 1)->update([
            'religo_role' => User::RELIGO_ROLE_CHAPTER_ADMIN,
        ]);
        $this->actingAsUserId(1);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $this->assertSame(User::RELIGO_ROLE_CHAPTER_ADMIN, $res->json('religo_role'));
    }

    public function test_show_me_returns_null_when_not_set(): void
    {
        $this->createMeUser(null);
        $this->actingAsUserId(1);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['id']);
        $this->assertNull($data['owner_member_id']);
        $this->assertNull($data['member_id']);
        $this->assertNull($data['default_workspace_id']);
        $this->assertNull($data['workspace_id']);
        $this->assertSame('member', $data['religo_role']);
    }

    public function test_show_me_returns_401_when_unauthenticated(): void
    {
        $res = $this->getJson('/api/users/me');
        $res->assertUnauthorized();
    }

    public function test_show_me_when_acting_as_second_user_returns_that_user(): void
    {
        $this->createMeUser($this->memberId, 1);
        $this->createMeUser($this->otherMemberId, 2);
        Sanctum::actingAs(User::find(2));
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
        $this->actingAsUserId(1);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $this->assertSame($wsId, $res->json('workspace_id'));
    }

    public function test_show_me_resolved_workspace_id_prefers_default_workspace_over_artifacts(): void
    {
        $wsFromFlag = (int) DB::table('workspaces')->insertGetId([
            'name' => 'FromFlag',
            'slug' => 'from-flag',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $wsDefault = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Default',
            'slug' => 'default',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->createMeUser($this->memberId, 1, $wsDefault);
        DragonflyContactFlag::create([
            'owner_member_id' => $this->memberId,
            'target_member_id' => $this->otherMemberId,
            'interested' => true,
            'want_1on1' => false,
            'workspace_id' => $wsFromFlag,
        ]);
        $this->actingAsUserId(1);
        $res = $this->getJson('/api/users/me');
        $res->assertOk();
        $this->assertSame($wsDefault, $res->json('workspace_id'));
        $this->assertSame($wsDefault, $res->json('default_workspace_id'));
    }

    public function test_update_me_saves_owner_member_id(): void
    {
        $this->createMeUser(null);
        $this->actingAsUserId(1);
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
        Sanctum::actingAs(User::find(2));
        $res = $this->patchJson('/api/users/me', ['owner_member_id' => $this->memberId]);
        $res->assertOk();
        $this->assertSame(2, $res->json('id'));
        $this->assertDatabaseHas('users', ['id' => 2, 'owner_member_id' => $this->memberId]);
        $this->assertDatabaseHas('users', ['id' => 1, 'owner_member_id' => null]);
    }

    public function test_update_me_returns_422_for_invalid_member(): void
    {
        $this->createMeUser(null);
        $this->actingAsUserId(1);
        $res = $this->patchJson('/api/users/me', ['owner_member_id' => 99999]);
        $res->assertStatus(422);
    }

    public function test_update_me_returns_422_when_no_updatable_keys_in_body(): void
    {
        $this->createMeUser(null);
        $this->actingAsUserId(1);
        $res = $this->patchJson('/api/users/me', []);
        $res->assertStatus(422);
    }

    public function test_update_me_saves_default_workspace_id_without_owner_change(): void
    {
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Ch',
            'slug' => 'ch',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->createMeUser($this->memberId);
        $this->actingAsUserId(1);
        $res = $this->patchJson('/api/users/me', ['default_workspace_id' => $wsId]);
        $res->assertOk();
        $this->assertSame($wsId, $res->json('default_workspace_id'));
        $this->assertSame($wsId, $res->json('workspace_id'));
        $this->assertDatabaseHas('users', ['id' => 1, 'default_workspace_id' => $wsId, 'owner_member_id' => $this->memberId]);
    }

    public function test_update_me_can_clear_default_workspace_id(): void
    {
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Ch',
            'slug' => 'ch2',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->createMeUser($this->memberId, 1, $wsId);
        $this->actingAsUserId(1);
        $res = $this->patchJson('/api/users/me', ['default_workspace_id' => null]);
        $res->assertOk();
        $this->assertNull($res->json('default_workspace_id'));
        $this->assertDatabaseHas('users', ['id' => 1, 'default_workspace_id' => null]);
    }

    public function test_update_me_returns_401_when_unauthenticated(): void
    {
        $res = $this->patchJson('/api/users/me', ['owner_member_id' => $this->memberId]);
        $res->assertUnauthorized();
    }
}
