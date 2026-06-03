<?php

namespace Tests\Feature\Religo;

use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * POST /api/one-to-ones/{id}/cancel — Phase 185.
 */
class OneToOneCancelTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

    private OneToOne $planned;

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
        $this->planned = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-06-10 10:00:00',
        ]);
    }

    public function test_cancel_planned_with_owner_convenience(): void
    {
        $res = $this->postJson('/api/one-to-ones/' . $this->planned->id . '/cancel', [
            'cancel_reason' => 'owner_convenience',
        ]);
        $res->assertOk();
        $res->assertJsonPath('status', 'canceled');
        $res->assertJsonPath('cancel_reason', 'owner_convenience');
        $res->assertJsonPath('cancel_remark', null);
        $this->assertNotNull($res->json('canceled_at'));
        $this->assertDatabaseHas('one_to_ones', [
            'id' => $this->planned->id,
            'status' => 'canceled',
            'cancel_reason' => 'owner_convenience',
        ]);
    }

    public function test_cancel_other_requires_remark(): void
    {
        $res = $this->postJson('/api/one-to-ones/' . $this->planned->id . '/cancel', [
            'cancel_reason' => 'other',
        ]);
        $res->assertStatus(422);
        $res->assertJsonValidationErrors(['cancel_remark']);
    }

    public function test_cancel_other_with_remark(): void
    {
        $res = $this->postJson('/api/one-to-ones/' . $this->planned->id . '/cancel', [
            'cancel_reason' => 'other',
            'cancel_remark' => '重複登録のため',
        ]);
        $res->assertOk();
        $res->assertJsonPath('cancel_reason', 'other');
        $res->assertJsonPath('cancel_remark', '重複登録のため');
    }

    public function test_cancel_completed_returns_422(): void
    {
        $completed = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
        ]);
        $res = $this->postJson('/api/one-to-ones/' . $completed->id . '/cancel', [
            'cancel_reason' => 'owner_convenience',
        ]);
        $res->assertStatus(422);
    }

    public function test_patch_status_canceled_is_rejected(): void
    {
        $res = $this->patchJson('/api/one-to-ones/' . $this->planned->id, [
            'status' => 'canceled',
        ]);
        $res->assertStatus(422);
        $res->assertJsonValidationErrors(['status']);
    }
}
