<?php

namespace Tests\Feature\Religo;

use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET /api/one-to-ones. Phase11B. SSOT: PHASE11B PLAN.
 */
class OneToOneIndexTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;
    private int $ownerId;
    private int $target1Id;
    private int $target2Id;

    protected function setUp(): void
    {
        parent::setUp();
        $this->workspaceId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Default',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->target1Id = (int) DB::table('members')->insertGetId([
            'name' => 'Target1',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->target2Id = (int) DB::table('members')->insertGetId([
            'name' => 'Target2',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_get_one_to_ones_returns_200(): void
    {
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->target1Id,
            'status' => 'completed',
            'scheduled_at' => '2026-03-01 10:00:00',
            'started_at' => '2026-03-01 10:05:00',
            'ended_at' => '2026-03-01 10:35:00',
            'notes' => 'Test',
        ]);
        $res = $this->getJson('/api/one-to-ones');
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        $this->assertCount(1, $data);
        $this->assertSame('Test', $data[0]['notes']);
        $this->assertSame('Owner', $data[0]['owner_name']);
        $this->assertSame('Target1', $data[0]['target_name']);
    }

    public function test_order_by_started_at_then_scheduled_at_desc(): void
    {
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->target1Id,
            'status' => 'planned',
            'scheduled_at' => '2026-03-01 12:00:00',
            'started_at' => null,
            'ended_at' => null,
            'notes' => 'First',
        ]);
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->target2Id,
            'status' => 'completed',
            'scheduled_at' => '2026-03-02 10:00:00',
            'started_at' => '2026-03-02 10:00:00',
            'ended_at' => '2026-03-02 10:30:00',
            'notes' => 'Second',
        ]);
        $res = $this->getJson('/api/one-to-ones');
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(2, $data);
        $this->assertSame('Second', $data[0]['notes']);
        $this->assertSame('First', $data[1]['notes']);
    }

    public function test_status_filter(): void
    {
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->target1Id,
            'status' => 'planned',
            'scheduled_at' => now(),
            'notes' => 'P',
        ]);
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->target2Id,
            'status' => 'completed',
            'scheduled_at' => now(),
            'notes' => 'C',
        ]);
        $res = $this->getJson('/api/one-to-ones?status=completed');
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(1, $data);
        $this->assertSame('completed', $data[0]['status']);
        $this->assertSame('C', $data[0]['notes']);
    }

    public function test_owner_member_id_filter(): void
    {
        $otherOwnerId = (int) DB::table('members')->insertGetId([
            'name' => 'Other',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->target1Id,
            'status' => 'planned',
            'notes' => 'Mine',
        ]);
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $otherOwnerId,
            'target_member_id' => $this->target1Id,
            'status' => 'planned',
            'notes' => 'Other',
        ]);
        $res = $this->getJson('/api/one-to-ones?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(1, $data);
        $this->assertSame('Mine', $data[0]['notes']);
    }

    public function test_limit_applied(): void
    {
        for ($i = 0; $i < 5; $i++) {
            OneToOne::create([
                'workspace_id' => $this->workspaceId,
                'owner_member_id' => $this->ownerId,
                'target_member_id' => $this->target1Id,
                'status' => 'planned',
                'scheduled_at' => now()->addDays($i),
                'notes' => "Note {$i}",
            ]);
        }
        $res = $this->getJson('/api/one-to-ones?owner_member_id=' . $this->ownerId . '&target_member_id=' . $this->target1Id . '&limit=2');
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(2, $data);
    }
}
