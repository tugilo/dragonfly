<?php

namespace Tests\Feature\Api;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET /api/dragonfly/members — summary_lite 同梱のレスポンス形状を検証.
 * SSOT: docs/SSOT/DATA_MODEL.md. PLAN: PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_PLAN.md
 */
class DragonFlyMembersListSummaryTest extends TestCase
{
    use RefreshDatabase;

    private int $ownerId;
    private int $targetId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
    }

    public function test_without_with_summary_returns_members_without_summary_lite(): void
    {
        $response = $this->getJson('/api/dragonfly/members');
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        $this->assertNotEmpty($data);
        foreach ($data as $member) {
            $this->assertArrayHasKey('id', $member);
            $this->assertArrayNotHasKey('summary_lite', $member);
        }
    }

    public function test_with_owner_and_with_summary_includes_summary_lite(): void
    {
        $response = $this->getJson('/api/dragonfly/members?owner_member_id=' . $this->ownerId . '&with_summary=1');
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        $this->assertNotEmpty($data);
        foreach ($data as $member) {
            $this->assertArrayHasKey('id', $member);
            $this->assertArrayHasKey('summary_lite', $member);
            $lite = $member['summary_lite'];
            $this->assertArrayHasKey('same_room_count', $lite);
            $this->assertArrayHasKey('one_to_one_count', $lite);
            $this->assertArrayHasKey('last_contact_at', $lite);
            $this->assertArrayHasKey('last_memo', $lite);
            $this->assertArrayHasKey('interested', $lite);
            $this->assertArrayHasKey('want_1on1', $lite);
            $this->assertIsInt($lite['same_room_count']);
            $this->assertIsInt($lite['one_to_one_count']);
            $this->assertIsBool($lite['interested']);
            $this->assertIsBool($lite['want_1on1']);
        }
    }

    public function test_with_summary_but_no_owner_returns_members_without_summary_lite(): void
    {
        $response = $this->getJson('/api/dragonfly/members?with_summary=1');
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        foreach ($data as $member) {
            $this->assertArrayNotHasKey('summary_lite', $member);
        }
    }
}
