<?php

namespace Tests\Feature;

use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Tests\TestCase;

class ImportOneToOneNotesCommandTest extends TestCase
{
    use RefreshDatabase;

    private string $fixturesDir;

    protected function setUp(): void
    {
        parent::setUp();
        $this->fixturesDir = storage_path('framework/testing/1to1_notes');
        File::ensureDirectoryExists($this->fixturesDir);
    }

    protected function tearDown(): void
    {
        File::deleteDirectory($this->fixturesDir);
        parent::tearDown();
    }

    public function test_imports_full_markdown_body_into_notes(): void
    {
        $workspaceId = (int) \Illuminate\Support\Facades\DB::table('workspaces')->insertGetId([
            'name' => 'Default',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $ownerId = (int) \Illuminate\Support\Facades\DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $targetId = (int) \Illuminate\Support\Facades\DB::table('members')->insertGetId([
            'name' => 'Target',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $sourcePath = 'docs/meetings/1to1/1to1_test_sample.md';
        OneToOne::query()->insert([
            'workspace_id' => $workspaceId,
            'owner_member_id' => $ownerId,
            'target_member_id' => $targetId,
            'status' => 'completed',
            'notes' => "【ソース: {$sourcePath}】\n短い要約のみ",
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $path = $this->writeFixture('1to1_test_sample.md', $this->sampleMarkdown($sourcePath, 'Full body with **bold** and table.'));

        $exitCode = Artisan::call('dragonfly:import-1to1-notes', ['path' => $path]);
        $this->assertSame(0, $exitCode);

        $row = OneToOne::query()->first();
        $this->assertNotNull($row);
        $this->assertStringContainsString($sourcePath, $row->notes);
        $this->assertStringContainsString('# Test 1to1', $row->notes);
        $this->assertStringContainsString('**bold**', $row->notes);
        $this->assertGreaterThan(100, mb_strlen((string) $row->notes));
    }

    public function test_dry_run_does_not_persist(): void
    {
        $workspaceId = (int) \Illuminate\Support\Facades\DB::table('workspaces')->insertGetId([
            'name' => 'Default',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $ownerId = (int) \Illuminate\Support\Facades\DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $targetId = (int) \Illuminate\Support\Facades\DB::table('members')->insertGetId([
            'name' => 'Target',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $sourcePath = 'docs/meetings/1to1/1to1_dry_run.md';
        OneToOne::query()->insert([
            'workspace_id' => $workspaceId,
            'owner_member_id' => $ownerId,
            'target_member_id' => $targetId,
            'status' => 'completed',
            'notes' => "【ソース: {$sourcePath}】",
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $path = $this->writeFixture('1to1_dry_run.md', $this->sampleMarkdown($sourcePath, 'Should not save'));

        Artisan::call('dragonfly:import-1to1-notes', ['path' => $path, '--dry-run' => true]);

        $row = OneToOne::query()->first();
        $this->assertSame("【ソース: {$sourcePath}】", $row->notes);
    }

    private function writeFixture(string $filename, string $content): string
    {
        $path = $this->fixturesDir.DIRECTORY_SEPARATOR.$filename;
        File::put($path, $content);

        return $path;
    }

    private function sampleMarkdown(string $sourcePath, string $bodyLine): string
    {
        return <<<MD
---
doc_type: 1to1_series
1to1_id: test
---

# Test 1to1

**Religo 1to1 レコード:** `one_to_ones.id` = **99**

{$bodyLine}

| col | val |
|-----|-----|
| a | 1 |

MD;
    }
}
