<?php

namespace Tests\Feature\Religo;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * POST /api/contact-memos と POST /api/one-to-ones. SSOT: DATA_MODEL §4.8, §4.9.
 * PLAN: PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_PLAN.md
 */
class RelationshipLogCreateTest extends TestCase
{
    use RefreshDatabase;

    private int $ownerId;
    private int $targetId;
    private int $workspaceId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->workspaceId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Default', 'slug' => 'default', 'created_at' => now(), 'updated_at' => now(),
        ]);
    }

    /** 1) other: body 必須で作れる */
    public function test_contact_memo_other_creates_with_body(): void
    {
        $res = $this->postJson('/api/contact-memos', [
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'memo_type' => 'other',
            'body' => 'Hello',
        ]);
        $res->assertStatus(201);
        $res->assertJsonPath('id', fn ($v) => $v !== null);
        $res->assertJsonPath('body', 'Hello');
        $res->assertJsonPath('memo_type', 'other');
        $res->assertJsonStructure(['created_at', 'updated_at']);
    }

    /** 2) one_to_one: one_to_one_id 無し → 422 */
    public function test_contact_memo_one_to_one_without_one_to_one_id_returns_422(): void
    {
        $res = $this->postJson('/api/contact-memos', [
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'memo_type' => 'one_to_one',
            'body' => 'note',
        ]);
        $res->assertStatus(422);
    }

    /** 3) meeting: meeting_id 無し → 422 */
    public function test_contact_memo_meeting_without_meeting_id_returns_422(): void
    {
        $res = $this->postJson('/api/contact-memos', [
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'memo_type' => 'meeting',
            'body' => 'note',
        ]);
        $res->assertStatus(422);
    }

    /** 4) workspace_id NULL 許容（single-workspace） */
    public function test_contact_memo_accepts_null_workspace_id(): void
    {
        $res = $this->postJson('/api/contact-memos', [
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'body' => 'No workspace',
        ]);
        $res->assertStatus(201);
        $res->assertJsonPath('workspace_id', null);
    }

    /** 5) owner/target 不正 → 422 */
    public function test_contact_memo_invalid_owner_returns_422(): void
    {
        $res = $this->postJson('/api/contact-memos', [
            'owner_member_id' => 99999,
            'target_member_id' => $this->targetId,
            'body' => 'x',
        ]);
        $res->assertStatus(422);
    }

    /** 6) one-to-ones: workspace_id 無し → 422 */
    public function test_one_to_one_without_workspace_id_returns_422(): void
    {
        $res = $this->postJson('/api/one-to-ones', [
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
        ]);
        $res->assertStatus(422);
    }

    /** 7) one-to-ones: status の値域不正 → 422 */
    public function test_one_to_one_invalid_status_returns_422(): void
    {
        $res = $this->postJson('/api/one-to-ones', [
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'invalid',
        ]);
        $res->assertStatus(422);
    }

    /** 8) one-to-ones: 作成成功 → 201、id/timestamps 含む */
    public function test_one_to_one_creates_success_201(): void
    {
        $res = $this->postJson('/api/one-to-ones', [
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-03-10 10:00:00',
        ]);
        $res->assertStatus(201);
        $res->assertJsonPath('status', 'planned');
        $res->assertJsonStructure(['id', 'created_at', 'updated_at']);
    }
}
