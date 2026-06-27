<?php

namespace Tests\Feature\Religo;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

/**
 * SPEC-020 Phase C（順位 5）: マスタ・例会管理の編集系は chapter_admin 限定。
 */
class AdminRoleEnforcementTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    private int $memberId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->memberId = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
    }

    private function actAsMember(): void
    {
        $this->actingAsReligoUser($this->memberId, 'member-role@example.com', User::RELIGO_ROLE_MEMBER);
    }

    private function actAsAdmin(): void
    {
        $this->actingAsReligoUser($this->memberId, 'admin-role@example.com', User::RELIGO_ROLE_CHAPTER_ADMIN);
    }

    public function test_member_cannot_edit_member_master(): void
    {
        $this->actAsMember();
        $this->putJson('/api/dragonfly/members/'.$this->memberId, ['name' => 'Changed'])
            ->assertForbidden();
    }

    public function test_member_cannot_create_category(): void
    {
        $this->actAsMember();
        $this->postJson('/api/categories', ['name' => 'New Cat'])->assertForbidden();
    }

    public function test_member_cannot_create_role(): void
    {
        $this->actAsMember();
        $this->postJson('/api/roles', ['name' => 'New Role'])->assertForbidden();
    }

    public function test_member_cannot_create_meeting(): void
    {
        $this->actAsMember();
        $this->postJson('/api/meetings', ['number' => 999])->assertForbidden();
    }

    public function test_member_can_still_read_categories(): void
    {
        $this->actAsMember();
        $this->getJson('/api/categories')->assertOk();
    }

    public function test_member_can_still_read_meetings(): void
    {
        $this->actAsMember();
        $this->getJson('/api/meetings')->assertOk();
    }

    public function test_admin_is_not_forbidden_to_create_category(): void
    {
        $this->actAsAdmin();
        $res = $this->postJson('/api/categories', ['name' => 'Admin Cat']);
        $this->assertNotSame(403, $res->getStatusCode());
    }

    public function test_admin_is_not_forbidden_to_edit_member_master(): void
    {
        $this->actAsAdmin();
        $res = $this->putJson('/api/dragonfly/members/'.$this->memberId, ['name' => 'Admin Changed']);
        $this->assertNotSame(403, $res->getStatusCode());
    }
}
