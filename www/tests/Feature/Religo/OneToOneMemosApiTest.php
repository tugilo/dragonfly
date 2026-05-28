<?php

namespace Tests\Feature\Religo;

use App\Models\ContactMemo;
use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET/POST /api/one-to-ones/{id}/memos. ONETOONES-P4.
 */
class OneToOneMemosApiTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

    private OneToOne $oneToOne;

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
        $this->oneToOne = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-03-20 10:00:00',
        ]);
    }

    public function test_index_returns_empty_array(): void
    {
        $res = $this->getJson('/api/one-to-ones/' . $this->oneToOne->id . '/memos');
        $res->assertOk();
        $res->assertJson([]);
    }

    public function test_store_creates_contact_memo_linked(): void
    {
        $res = $this->postJson('/api/one-to-ones/' . $this->oneToOne->id . '/memos', [
            'body' => 'Follow-up call done',
        ]);
        $res->assertStatus(201);
        $res->assertJsonPath('body', 'Follow-up call done');
        $res->assertJsonPath('memo_type', 'one_to_one');
        $this->assertDatabaseHas('contact_memos', [
            'one_to_one_id' => $this->oneToOne->id,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'memo_type' => 'one_to_one',
            'body' => 'Follow-up call done',
        ]);
    }

    public function test_index_returns_memos_newest_first(): void
    {
        ContactMemo::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'workspace_id' => $this->workspaceId,
            'memo_type' => 'one_to_one',
            'body' => 'First',
            'one_to_one_id' => $this->oneToOne->id,
        ]);
        ContactMemo::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'workspace_id' => $this->workspaceId,
            'memo_type' => 'one_to_one',
            'body' => 'Second',
            'one_to_one_id' => $this->oneToOne->id,
        ]);

        $res = $this->getJson('/api/one-to-ones/' . $this->oneToOne->id . '/memos');
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(2, $data);
        $bodies = array_column($data, 'body');
        sort($bodies);
        $this->assertSame(['First', 'Second'], $bodies);
        $this->assertSame('Second', $data[0]['body']);
        $this->assertSame('First', $data[1]['body']);
    }

    public function test_store_422_when_body_missing(): void
    {
        $res = $this->postJson('/api/one-to-ones/' . $this->oneToOne->id . '/memos', []);
        $res->assertStatus(422);
    }
}
