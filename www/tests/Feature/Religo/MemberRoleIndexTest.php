<?php

namespace Tests\Feature\Religo;

use App\Models\Member;
use App\Models\MemberRole;
use App\Models\Role;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * GET /api/member-roles — 役職履歴一覧. Phase15B.
 */
class MemberRoleIndexTest extends TestCase
{
    use RefreshDatabase;

    private int $memberId;
    private int $roleId;
    private int $memberRoleId;

    protected function setUp(): void
    {
        parent::setUp();
        $member = Member::create(['name' => 'Test Member', 'type' => 'active']);
        $role = Role::create(['name' => 'プレジデント', 'description' => null]);
        $mr = MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => '2025-01-01',
            'term_end' => null,
        ]);
        $this->memberId = $member->id;
        $this->roleId = $role->id;
        $this->memberRoleId = $mr->id;
    }

    public function test_index_returns_list_sorted_by_term_start_desc(): void
    {
        $response = $this->getJson('/api/member-roles');
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        $this->assertNotEmpty($data);
        $first = $data[0];
        $this->assertArrayHasKey('id', $first);
        $this->assertArrayHasKey('member_id', $first);
        $this->assertArrayHasKey('member_name', $first);
        $this->assertArrayHasKey('role_id', $first);
        $this->assertArrayHasKey('role_name', $first);
        $this->assertArrayHasKey('term_start', $first);
        $this->assertArrayHasKey('term_end', $first);
        $this->assertSame('Test Member', $first['member_name']);
        $this->assertSame('プレジデント', $first['role_name']);
        $this->assertNull($first['term_end']);
    }

    public function test_filter_by_role_id(): void
    {
        $otherRole = Role::create(['name' => '書記', 'description' => null]);
        MemberRole::create([
            'member_id' => $this->memberId,
            'role_id' => $otherRole->id,
            'term_start' => '2024-06-01',
            'term_end' => '2024-12-31',
        ]);

        $response = $this->getJson('/api/member-roles?role_id=' . $this->roleId);
        $response->assertOk();
        $data = $response->json();
        $this->assertCount(1, $data);
        $this->assertSame('プレジデント', $data[0]['role_name']);
    }

    public function test_filter_by_member_id(): void
    {
        $otherMember = Member::create(['name' => 'Other', 'type' => 'active']);
        MemberRole::create([
            'member_id' => $otherMember->id,
            'role_id' => $this->roleId,
            'term_start' => '2024-01-01',
            'term_end' => '2024-12-31',
        ]);

        $response = $this->getJson('/api/member-roles?member_id=' . $this->memberId);
        $response->assertOk();
        $data = $response->json();
        $this->assertCount(1, $data);
        $this->assertSame('Test Member', $data[0]['member_name']);
    }

    public function test_filter_by_from_and_to_includes_term_end_null(): void
    {
        $response = $this->getJson('/api/member-roles?from=2025-06-01&to=2026-12-31');
        $response->assertOk();
        $data = $response->json();
        $this->assertNotEmpty($data);
        $this->assertNull($data[0]['term_end']);
    }

    public function test_sort_term_start_desc_then_id_desc(): void
    {
        MemberRole::create([
            'member_id' => $this->memberId,
            'role_id' => $this->roleId,
            'term_start' => '2026-01-01',
            'term_end' => null,
        ]);

        $response = $this->getJson('/api/member-roles');
        $response->assertOk();
        $data = $response->json();
        $this->assertGreaterThanOrEqual(2, count($data));
        $this->assertTrue($data[0]['term_start'] >= ($data[1]['term_start'] ?? ''));
    }
}
