<?php

namespace Tests\Feature\Religo;

use App\Models\ContactMemo;
use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class OneToOneSeriesMarkdownApiTest extends TestCase
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

    public function test_series_markdown_assembles_pair_sessions(): void
    {
        $first = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'started_at' => '2026-05-08 14:00:00',
            'notes' => "【ソース: docs/meetings/1to1/1to1_series_api.md#第1回】\n\n### 【第1回】\n\nAlpha session body.",
        ]);
        $second = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'started_at' => '2026-05-29 14:00:00',
            'notes' => "【ソース: docs/meetings/1to1/1to1_series_api.md#第2回】\n\n### 【第2回】\n\nBeta session body.",
        ]);

        $resFirst = $this->getJson('/api/one-to-ones/'.$first->id.'/series-markdown');
        $resSecond = $this->getJson('/api/one-to-ones/'.$second->id.'/series-markdown');

        $resFirst->assertOk();
        $resSecond->assertOk();

        $markdownFirst = $resFirst->json('markdown');
        $markdownSecond = $resSecond->json('markdown');
        $this->assertSame($markdownFirst, $markdownSecond);
        $this->assertStringContainsString('Alpha session body', $markdownFirst);
        $this->assertStringContainsString('Beta session body', $markdownFirst);
        $this->assertSame('docs/meetings/1to1/1to1_series_api.md', $resFirst->json('source_path'));
        $this->assertTrue($resFirst->json('has_series_memo'));
    }

    public function test_index_includes_has_series_memo_flag(): void
    {
        OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'notes' => 'Session notes present',
        ]);

        $res = $this->getJson('/api/one-to-ones?owner_member_id='.$this->ownerId);
        $res->assertOk();
        $res->assertJsonPath('0.has_series_memo', true);
    }

    public function test_series_markdown_includes_shared_contact_memo(): void
    {
        ContactMemo::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'workspace_id' => $this->workspaceId,
            'memo_type' => 'one_to_one',
            'body' => '## ■ サマリー\n\nShared summary block.',
            'one_to_one_id' => null,
        ]);

        $row = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'notes' => "【ソース: docs/meetings/1to1/1to1_shared.md#第1回】\n\nSession slice only.",
        ]);

        $res = $this->getJson('/api/one-to-ones/'.$row->id.'/series-markdown');
        $res->assertOk();
        $markdown = $res->json('markdown');
        $this->assertStringContainsString('Shared summary block', $markdown);
        $this->assertStringContainsString('Session slice only', $markdown);
    }
}
