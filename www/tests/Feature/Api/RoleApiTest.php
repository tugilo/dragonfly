<?php

namespace Tests\Feature\Api;

use App\Models\Member;
use App\Models\MemberRole;
use App\Models\Role;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * Roles API CRUD. Phase16C.
 */
class RoleApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_index_returns_roles(): void
    {
        Role::create(['name' => 'プレジ', 'description' => '代表']);
        Role::create(['name' => '書記', 'description' => null]);

        $res = $this->getJson('/api/roles');
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        $this->assertGreaterThanOrEqual(2, count($data));
        $names = array_column($data, 'name');
        $this->assertContains('プレジ', $names);
        $this->assertContains('書記', $names);
    }

    public function test_show_returns_one_role(): void
    {
        $role = Role::create(['name' => 'プレジ', 'description' => '代表']);

        $res = $this->getJson('/api/roles/' . $role->id);
        $res->assertOk();
        $res->assertJsonPath('id', $role->id);
        $res->assertJsonPath('name', 'プレジ');
        $res->assertJsonPath('description', '代表');
    }

    public function test_store_creates_role(): void
    {
        $res = $this->postJson('/api/roles', [
            'name' => 'メンター',
            'description' => '新人支援',
        ]);
        $res->assertCreated();
        $res->assertJsonPath('name', 'メンター');
        $this->assertDatabaseHas('roles', ['name' => 'メンター']);
    }

    public function test_update_modifies_role(): void
    {
        $role = Role::create(['name' => 'プレジ', 'description' => '代表']);

        $res = $this->putJson('/api/roles/' . $role->id, [
            'name' => 'プレジデント',
            'description' => 'チャプター代表',
        ]);
        $res->assertOk();
        $res->assertJsonPath('name', 'プレジデント');
        $role->refresh();
        $this->assertSame('プレジデント', $role->name);
    }

    public function test_delete_removes_role_without_member_roles(): void
    {
        $role = Role::create(['name' => 'Temp', 'description' => null]);

        $res = $this->deleteJson('/api/roles/' . $role->id);
        $res->assertNoContent();
        $this->assertDatabaseMissing('roles', ['id' => $role->id]);
    }

    public function test_delete_returns_422_when_role_has_member_roles(): void
    {
        $member = Member::create(['name' => 'Test', 'type' => 'active']);
        $role = Role::create(['name' => 'プレジ', 'description' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => '2025-01-01',
            'term_end' => null,
        ]);

        $res = $this->deleteJson('/api/roles/' . $role->id);
        $res->assertStatus(422);
        $res->assertJsonPath('message', 'Cannot delete role with member role history. Remove or reassign history first.');
        $this->assertDatabaseHas('roles', ['id' => $role->id]);
    }
}
