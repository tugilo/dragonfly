<?php

namespace Tests\Feature\Queries;

use App\Queries\Religo\MemberSummaryQuery;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * MEMBER-SUMMARY-WORKSPACE-NULL-P1: workspace 指定時は contact_memos 等で NULL 行を含める.
 */
class MemberSummaryQueryWorkspaceScopeTest extends TestCase
{
    use RefreshDatabase;

    public function test_workspace_scoped_summary_includes_null_workspace_memo(): void
    {
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Chapter A', 'slug' => 'ch-a', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);

        DB::table('contact_memos')->insert([
            'owner_member_id' => $ownerId,
            'target_member_id' => $targetId,
            'memo_type' => 'other',
            'body' => 'legacy memo',
            'workspace_id' => null,
            'created_at' => now()->subDay(),
            'updated_at' => now()->subDay(),
        ]);

        $query = app(MemberSummaryQuery::class);
        $batch = $query->getSummaryLiteBatch($ownerId, [$targetId], $wsId);

        $this->assertArrayHasKey($targetId, $batch);
        $this->assertNotNull($batch[$targetId]['last_memo']);
        $this->assertSame('legacy memo', $batch[$targetId]['last_memo']['body_short'] ?? null);
    }

    public function test_workspace_scoped_summary_excludes_other_workspace_memo(): void
    {
        $wsA = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Chapter A', 'slug' => 'ch-a', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $wsB = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Chapter B', 'slug' => 'ch-b', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);

        DB::table('contact_memos')->insert([
            'owner_member_id' => $ownerId,
            'target_member_id' => $targetId,
            'memo_type' => 'other',
            'body' => 'other chapter only',
            'workspace_id' => $wsB,
            'created_at' => now()->subHour(),
            'updated_at' => now()->subHour(),
        ]);

        $query = app(MemberSummaryQuery::class);
        $batch = $query->getSummaryLiteBatch($ownerId, [$targetId], $wsA);

        $this->assertArrayHasKey($targetId, $batch);
        $this->assertNull($batch[$targetId]['last_memo']);
    }

    public function test_null_workspace_id_parameter_does_not_filter_by_workspace_column(): void
    {
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Chapter A', 'slug' => 'ch-a', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);

        DB::table('contact_memos')->insert([
            'owner_member_id' => $ownerId,
            'target_member_id' => $targetId,
            'memo_type' => 'other',
            'body' => 'scoped to ws',
            'workspace_id' => $wsId,
            'created_at' => now()->subHour(),
            'updated_at' => now()->subHour(),
        ]);

        $query = app(MemberSummaryQuery::class);
        $batch = $query->getSummaryLiteBatch($ownerId, [$targetId], null);

        $this->assertArrayHasKey($targetId, $batch);
        $this->assertNotNull($batch[$targetId]['last_memo']);
        $this->assertStringContainsString('scoped to ws', (string) ($batch[$targetId]['last_memo']['body_short'] ?? ''));
    }
}
