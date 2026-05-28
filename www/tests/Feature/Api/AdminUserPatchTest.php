<?php

namespace Tests\Feature\Api;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class AdminUserPatchTest extends TestCase
{
    use RefreshDatabase;

    private int $memberA;

    protected function setUp(): void
    {
        parent::setUp();
        $this->memberA = (int) DB::table('members')->insertGetId([
            'name' => 'A',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('members')->insertGetId([
            'name' => 'B',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_chapter_admin_can_patch_owner_member_id(): void
    {
        $admin = User::factory()->create([
            'religo_role' => User::RELIGO_ROLE_CHAPTER_ADMIN,
        ]);
        $target = User::factory()->create([
            'owner_member_id' => null,
        ]);

        $this->actingAs($admin);
        $res = $this->patchJson("/api/admin/users/{$target->id}", [
            'owner_member_id' => $this->memberA,
        ]);

        $res->assertOk();
        $res->assertJsonPath('owner_member_id', $this->memberA);
        $this->assertDatabaseHas('users', [
            'id' => $target->id,
            'owner_member_id' => $this->memberA,
        ]);
    }

    public function test_member_receives_403(): void
    {
        $member = User::factory()->create([
            'religo_role' => null,
        ]);
        $other = User::factory()->create();

        $this->actingAs($member);
        $this->patchJson("/api/admin/users/{$other->id}", [
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ])->assertStatus(403);
    }

    public function test_chapter_admin_can_set_religo_role(): void
    {
        $admin = User::factory()->create([
            'religo_role' => User::RELIGO_ROLE_CHAPTER_ADMIN,
        ]);
        $target = User::factory()->create([
            'religo_role' => null,
        ]);

        $this->actingAs($admin);
        $res = $this->patchJson("/api/admin/users/{$target->id}", [
            'religo_role' => User::RELIGO_ROLE_CHAPTER_ADMIN,
        ]);

        $res->assertOk();
        $res->assertJsonPath('religo_role', User::RELIGO_ROLE_CHAPTER_ADMIN);
    }

    public function test_validation_rejects_invalid_role(): void
    {
        $admin = User::factory()->create([
            'religo_role' => User::RELIGO_ROLE_CHAPTER_ADMIN,
        ]);
        $target = User::factory()->create();

        $this->actingAs($admin);
        $this->patchJson("/api/admin/users/{$target->id}", [
            'religo_role' => 'god_mode',
        ])->assertStatus(422);
    }

    public function test_empty_body_422(): void
    {
        $admin = User::factory()->create([
            'religo_role' => User::RELIGO_ROLE_CHAPTER_ADMIN,
        ]);
        $target = User::factory()->create();

        $this->actingAs($admin);
        $this->patchJson("/api/admin/users/{$target->id}", [])->assertStatus(422);
    }
}
