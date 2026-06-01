<?php

namespace Tests\Feature\Zoom;

use App\Models\OneToOne;
use App\Models\User;
use App\Models\ZoomMeetingImport;
use App\Services\Zoom\ZoomImportApplyService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * SPEC-012 Phase B: 取り込み確定（planned/completed・保留・二重登録防止）。
 */
class ZoomImportApplyServiceTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

    private User $user;

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
        $this->user = User::create([
            'name' => 'Owner User',
            'email' => 'owner@example.com',
            'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->ownerId,
            'default_workspace_id' => $this->workspaceId,
        ]);
    }

    private function makeImport(array $overrides = []): ZoomMeetingImport
    {
        return ZoomMeetingImport::create(array_merge([
            'user_id' => $this->user->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'zoom_meeting_id' => '111',
            'zoom_meeting_uuid' => 'uuid-abc==',
            'kind' => ZoomMeetingImport::KIND_PAST,
            'topic' => 'Target Alpha 1to1',
            'start_time' => '2026-05-20 10:00:00',
            'end_time' => '2026-05-20 11:00:00',
            'is_one_to_one_candidate' => true,
            'confidence' => 'high',
            'matched_member_id' => $this->targetId,
            'match_status' => 'matched',
            'selected' => true,
            'status' => ZoomMeetingImport::STATUS_PENDING,
        ], $overrides));
    }

    public function test_create_member_links_and_blocks_duplicate(): void
    {
        \Laravel\Sanctum\Sanctum::actingAs($this->user);
        $import = $this->makeImport([
            'matched_member_id' => null,
            'match_status' => 'new',
            'counterpart_name' => '新規 太郎',
        ]);

        // 初回: 同名なし → 作成・紐付け
        $this->postJson("/api/zoom/imports/{$import->id}/create-member", [
            'name' => '新規 太郎', 'type' => 'guest',
        ])->assertCreated()->assertJsonPath('created', true);

        $import->refresh();
        $this->assertNotNull($import->matched_member_id);
        $this->assertSame('matched', $import->match_status);

        // 別 import で同名 → force なしは重複提示（作成しない）
        $import2 = $this->makeImport([
            'zoom_meeting_uuid' => 'uuid-dup==', 'zoom_meeting_id' => '222',
            'matched_member_id' => null, 'match_status' => 'new', 'counterpart_name' => '新規 太郎',
        ]);
        $res = $this->postJson("/api/zoom/imports/{$import2->id}/create-member", [
            'name' => '新規 太郎', 'type' => 'guest',
        ])->assertOk()->assertJsonPath('created', false);
        $this->assertNotEmpty($res->json('duplicates'));
    }

    public function test_apply_past_creates_completed_one_to_one(): void
    {
        $import = $this->makeImport();
        $service = app(ZoomImportApplyService::class);

        $result = $service->apply($this->user, [$import->id]);

        $this->assertSame(1, $result['imported']);
        $this->assertDatabaseHas('one_to_ones', [
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'external_source' => 'zoom',
            'zoom_meeting_uuid' => 'uuid-abc==',
        ]);
        $import->refresh();
        $this->assertSame(ZoomMeetingImport::STATUS_IMPORTED, $import->status);
        $this->assertNotNull($import->one_to_one_id);
    }

    public function test_same_owner_target_same_day_links_existing_and_backfills(): void
    {
        // 既存（手動・notes あり・時刻なし）
        $existing = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'external_source' => 'manual',
            'scheduled_at' => '2026-05-20 00:00:00',
            'notes' => '手動の議事録',
        ]);
        // 同日の Zoom 取り込み（実時刻あり・別 uuid）
        $import = $this->makeImport([
            'zoom_meeting_uuid' => 'uuid-newday==',
            'start_time' => '2026-05-20 10:00:00',
            'end_time' => '2026-05-20 11:00:00',
        ]);

        $service = app(ZoomImportApplyService::class);
        $result = $service->apply($this->user, [$import->id]);

        // 新規作成されず、既存に紐付き skip
        $this->assertSame(1, OneToOne::count());
        $this->assertSame(1, $result['skipped']);
        $existing->refresh();
        // Zoom 実時刻と uuid が既存へバックフィル、notes は保持
        $this->assertNotNull($existing->started_at);
        $this->assertNotNull($existing->ended_at);
        $this->assertSame('uuid-newday==', $existing->zoom_meeting_uuid);
        $this->assertSame('手動の議事録', $existing->notes);
    }

    public function test_apply_scheduled_creates_planned(): void
    {
        $import = $this->makeImport([
            'kind' => ZoomMeetingImport::KIND_SCHEDULED,
            'zoom_meeting_uuid' => null,
            'end_time' => null,
        ]);
        $service = app(ZoomImportApplyService::class);

        $service->apply($this->user, [$import->id]);

        $this->assertDatabaseHas('one_to_ones', [
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'external_source' => 'zoom',
        ]);
    }

    public function test_unmatched_counterpart_is_held(): void
    {
        $import = $this->makeImport([
            'matched_member_id' => null,
            'match_status' => 'new',
        ]);
        $service = app(ZoomImportApplyService::class);

        $result = $service->apply($this->user, [$import->id]);

        $this->assertSame(1, $result['held']);
        $this->assertSame(0, $result['imported']);
        $import->refresh();
        $this->assertSame(ZoomMeetingImport::STATUS_HELD, $import->status);
        $this->assertSame(0, OneToOne::count());
    }

    public function test_duplicate_uuid_is_skipped(): void
    {
        // 既に同じ Zoom ミーティングの one_to_one が存在する状況。
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'external_source' => 'zoom',
            'zoom_meeting_uuid' => 'uuid-abc==',
            'scheduled_at' => '2026-05-20 10:00:00',
        ]);
        $this->assertSame(1, OneToOne::count());

        $import = $this->makeImport();
        $service = app(ZoomImportApplyService::class);
        $result = $service->apply($this->user, [$import->id]);

        // 二重登録されず、ステージングは既存 one_to_one に紐付くだけ。
        $this->assertSame(1, OneToOne::count());
        $this->assertSame(1, $result['skipped']);
        $import->refresh();
        $this->assertSame(ZoomMeetingImport::STATUS_IMPORTED, $import->status);
        $this->assertNotNull($import->one_to_one_id);
    }
}
