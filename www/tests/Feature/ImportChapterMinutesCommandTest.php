<?php

namespace Tests\Feature;

use App\Models\Meeting;
use App\Models\MeetingMinute;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Tests\TestCase;

class ImportChapterMinutesCommandTest extends TestCase
{
    use RefreshDatabase;

    private string $fixturesDir;

    protected function setUp(): void
    {
        parent::setUp();
        $this->fixturesDir = storage_path('framework/testing/chapter_minutes');
        File::ensureDirectoryExists($this->fixturesDir);
    }

    protected function tearDown(): void
    {
        File::deleteDirectory($this->fixturesDir);
        parent::tearDown();
    }

    public function test_imports_markdown_and_creates_meeting_and_minute(): void
    {
        $path = $this->writeFixture('chapter_weekly_20260512.md', $this->sampleMarkdown(207, '2026-05-12'));

        $exitCode = Artisan::call('dragonfly:import-chapter-minutes', ['path' => $path]);
        $this->assertSame(0, $exitCode);

        $meeting = Meeting::where('number', 207)->first();
        $this->assertNotNull($meeting);
        $this->assertSame('2026-05-12', $meeting->held_on->format('Y-m-d'));

        $minute = MeetingMinute::where('meeting_id', $meeting->id)->first();
        $this->assertNotNull($minute);
        $this->assertStringContainsString('# DragonFly 定例会', $minute->body_markdown);
        $this->assertSame('chapter_weekly', $minute->doc_type);
        $this->assertNotNull($minute->imported_at);
    }

    public function test_reimport_updates_same_row_without_duplicate(): void
    {
        $path = $this->writeFixture('chapter_weekly_20260519.md', $this->sampleMarkdown(208, '2026-05-19', 'First body'));

        Artisan::call('dragonfly:import-chapter-minutes', ['path' => $path]);
        $this->assertSame(1, MeetingMinute::count());

        File::put($path, $this->sampleMarkdown(208, '2026-05-19', 'Updated body'));
        Artisan::call('dragonfly:import-chapter-minutes', ['path' => $path]);

        $this->assertSame(1, MeetingMinute::count());
        $minute = MeetingMinute::first();
        $this->assertStringContainsString('Updated body', $minute->body_markdown);
    }

    public function test_directory_import_processes_multiple_files(): void
    {
        $this->writeFixture('chapter_weekly_20260512.md', $this->sampleMarkdown(207, '2026-05-12'));
        $this->writeFixture('chapter_weekly_20260519.md', $this->sampleMarkdown(208, '2026-05-19'));

        $exitCode = Artisan::call('dragonfly:import-chapter-minutes', ['path' => $this->fixturesDir]);
        $this->assertSame(0, $exitCode);
        $this->assertSame(2, MeetingMinute::count());
    }

    public function test_options_override_front_matter(): void
    {
        $path = $this->writeFixture('chapter_weekly_test.md', $this->sampleMarkdown(999, '2020-01-01'));

        Artisan::call('dragonfly:import-chapter-minutes', [
            'path' => $path,
            '--meeting_number' => '210',
            '--held_on' => '2026-06-02',
        ]);

        $meeting = Meeting::where('number', 210)->first();
        $this->assertNotNull($meeting);
        $this->assertSame('2026-06-02', $meeting->held_on->format('Y-m-d'));
        $this->assertDatabaseMissing('meetings', ['number' => 999]);
    }

    private function writeFixture(string $filename, string $content): string
    {
        $path = $this->fixturesDir.'/'.$filename;
        File::put($path, $content);

        return $path;
    }

    private function sampleMarkdown(int $number, string $sessionDate, string $body = 'Sample minutes body'): string
    {
        return <<<MD
---
doc_type: chapter_weekly
meeting_number: {$number}
session_date: "{$sessionDate}"
session_time_jst: "10:00-11:45"
format: zoom
source: "test fixture"
---

# DragonFly 定例会 — 第{$number}回（{$sessionDate}）

{$body}
MD;
    }
}
