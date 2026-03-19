<?php

namespace Tests\Feature\Religo;

use App\Models\DragonflyContactFlag;
use App\Models\OneToOne;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET /api/one-to-ones/stats. ONETOONES-P2.
 */
class OneToOneStatsTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

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
        $this->targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_stats_requires_owner_member_id(): void
    {
        $res = $this->getJson('/api/one-to-ones/stats');
        $res->assertStatus(422);
    }

    public function test_stats_returns_counts(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-15 12:00:00', config('app.timezone')));

        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-04-01 10:00:00',
        ]);
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'started_at' => '2026-03-10 10:00:00',
            'ended_at' => '2026-03-10 11:00:00',
        ]);
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'canceled',
            'scheduled_at' => '2026-03-20 10:00:00',
            'updated_at' => '2026-03-12 10:00:00',
        ]);

        DragonflyContactFlag::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'interested' => false,
            'want_1on1' => true,
        ]);

        $res = $this->getJson('/api/one-to-ones/stats?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $res->assertJsonPath('planned_count', 1);
        $res->assertJsonPath('completed_this_month_count', 1);
        $res->assertJsonPath('canceled_this_month_count', 1);
        $res->assertJsonPath('want_1on1_on_count', 1);
        $res->assertJsonStructure(['period' => ['timezone', 'month_start', 'month_end']]);

        Carbon::setTestNow();
    }

    public function test_completed_outside_month_not_counted(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-15 12:00:00', config('app.timezone')));

        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'started_at' => '2026-02-28 10:00:00',
        ]);

        $res = $this->getJson('/api/one-to-ones/stats?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $res->assertJsonPath('completed_this_month_count', 0);

        Carbon::setTestNow();
    }

    public function test_stats_respects_q_filter_on_planned(): void
    {
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-04-01 10:00:00',
            'notes' => 'alpha unique match',
        ]);
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-04-02 10:00:00',
            'notes' => 'other',
        ]);

        $res = $this->getJson('/api/one-to-ones/stats?owner_member_id=' . $this->ownerId . '&q=' . rawurlencode('unique match'));
        $res->assertOk();
        $res->assertJsonPath('planned_count', 1);
    }

    public function test_stats_want_1on1_respects_list_filter_targets(): void
    {
        $targetB = (int) DB::table('members')->insertGetId([
            'name' => 'TargetB',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-04-01 10:00:00',
        ]);
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetB,
            'status' => 'planned',
            'scheduled_at' => '2026-04-02 10:00:00',
        ]);

        DragonflyContactFlag::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetB,
            'interested' => false,
            'want_1on1' => true,
        ]);

        $resAll = $this->getJson('/api/one-to-ones/stats?owner_member_id=' . $this->ownerId);
        $resAll->assertOk();
        $resAll->assertJsonPath('want_1on1_on_count', 1);

        $resA = $this->getJson('/api/one-to-ones/stats?owner_member_id=' . $this->ownerId . '&target_member_id=' . $this->targetId);
        $resA->assertOk();
        $resA->assertJsonPath('want_1on1_on_count', 0);
    }
}
