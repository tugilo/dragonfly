<?php

namespace Tests\Feature\Religo;

use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET/PATCH /api/one-to-ones/{id}. OneToOnes list Phase 1.
 */
class OneToOneShowUpdateTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

    private OneToOne $o2o;

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
            'name' => 'Target Alpha',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->o2o = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-04-01 09:00:00',
            'notes' => 'Agenda note',
        ]);
    }

    public function test_show_returns_200_with_names(): void
    {
        $res = $this->getJson('/api/one-to-ones/' . $this->o2o->id);
        $res->assertOk();
        $res->assertJsonPath('id', $this->o2o->id);
        $res->assertJsonPath('owner_name', 'Owner');
        $res->assertJsonPath('target_name', 'Target Alpha');
        $res->assertJsonPath('notes', 'Agenda note');
    }

    public function test_patch_updates_notes_and_status(): void
    {
        $res = $this->patchJson('/api/one-to-ones/' . $this->o2o->id, [
            'status' => 'completed',
            'notes' => 'Done',
        ]);
        $res->assertOk();
        $res->assertJsonPath('status', 'completed');
        $res->assertJsonPath('notes', 'Done');
        $this->assertDatabaseHas('one_to_ones', [
            'id' => $this->o2o->id,
            'status' => 'completed',
            'notes' => 'Done',
        ]);
    }
}
