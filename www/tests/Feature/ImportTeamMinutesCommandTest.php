<?php

namespace Tests\Feature;

use App\Models\Meeting;
use App\Models\MeetingMinute;
use App\Models\MeetingType;
use App\Support\MeetingDisplay;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Tests\TestCase;

class ImportTeamMinutesCommandTest extends TestCase
{
    use RefreshDatabase;

    private string $fixturesDir;

    protected function setUp(): void
    {
        parent::setUp();
        $this->fixturesDir = storage_path('framework/testing/team_minutes');
        File::ensureDirectoryExists($this->fixturesDir);
    }

    protected function tearDown(): void
    {
        File::deleteDirectory($this->fixturesDir);
        parent::tearDown();
    }

    public function test_imports_markdown_and_creates_meeting_and_minute(): void
    {
        $path = $this->writeFixture('team_threebiz_20260623.md', $this->sampleMarkdown('threebiz', '2026-06-23'));

        $exitCode = Artisan::call('dragonfly:import-team-minutes', ['path' => $path]);
        $this->assertSame(0, $exitCode);

        $typeId = MeetingType::idForCode(MeetingDisplay::SESSION_TEAM_MEETING);
        $meeting = Meeting::query()
            ->where('meeting_type_id', $typeId)
            ->where('team_id', 'threebiz')
            ->whereDate('held_on', '2026-06-23')
            ->first();
        $this->assertNotNull($meeting);
        $this->assertSame('team_meeting', $meeting->session_type);
        $this->assertSame('スリーバイス チームMTG', $meeting->name);
        $this->assertNull($meeting->number);

        $minute = MeetingMinute::where('meeting_id', $meeting->id)->first();
        $this->assertNotNull($minute);
        $this->assertStringContainsString('# スリーバイス チームMTG', $minute->body_markdown);
        $this->assertSame('team_meeting', $minute->doc_type);
        $this->assertNotNull($minute->imported_at);
    }

    public function test_reimport_updates_same_row_without_duplicate(): void
    {
        $path = $this->writeFixture('team_threebiz_20260616.md', $this->sampleMarkdown('threebiz', '2026-06-16', 'First body'));

        Artisan::call('dragonfly:import-team-minutes', ['path' => $path]);
        $this->assertSame(1, MeetingMinute::count());

        File::put($path, $this->sampleMarkdown('threebiz', '2026-06-16', 'Updated body'));
        Artisan::call('dragonfly:import-team-minutes', ['path' => $path]);

        $this->assertSame(1, MeetingMinute::count());
        $minute = MeetingMinute::first();
        $this->assertStringContainsString('Updated body', $minute->body_markdown);
    }

    public function test_directory_import_processes_multiple_files(): void
    {
        $this->writeFixture('team_threebiz_20260609.md', $this->sampleMarkdown('threebiz', '2026-06-09'));
        $this->writeFixture('team_threebiz_20260616.md', $this->sampleMarkdown('threebiz', '2026-06-16'));

        $exitCode = Artisan::call('dragonfly:import-team-minutes', ['path' => $this->fixturesDir]);
        $this->assertSame(0, $exitCode);
        $this->assertSame(2, MeetingMinute::count());
    }

    public function test_fails_when_team_id_missing(): void
    {
        $path = $this->writeFixture('team_missing_id.md', $this->sampleMarkdown(null, '2026-06-23'));

        $exitCode = Artisan::call('dragonfly:import-team-minutes', ['path' => $path]);
        $this->assertSame(1, $exitCode);
        $this->assertSame(0, MeetingMinute::count());
    }

    public function test_same_day_different_teams_create_separate_meetings(): void
    {
        $this->writeFixture('team_threebiz_20260623.md', $this->sampleMarkdown('threebiz', '2026-06-23'));
        $this->writeFixture('team_other_20260623.md', $this->sampleMarkdown('other', '2026-06-23', 'Other team', 'Other Team'));

        Artisan::call('dragonfly:import-team-minutes', ['path' => $this->fixturesDir]);

        $this->assertSame(2, Meeting::count());
        $this->assertSame(2, MeetingMinute::count());
    }

    public function test_held_on_option_overrides_front_matter(): void
    {
        $path = $this->writeFixture('team_threebiz_test.md', $this->sampleMarkdown('threebiz', '2020-01-01'));

        Artisan::call('dragonfly:import-team-minutes', [
            'path' => $path,
            '--held_on' => '2026-06-02',
        ]);

        $typeId = MeetingType::idForCode(MeetingDisplay::SESSION_TEAM_MEETING);
        $meeting = Meeting::query()
            ->where('meeting_type_id', $typeId)
            ->where('team_id', 'threebiz')
            ->whereDate('held_on', '2026-06-02')
            ->first();
        $this->assertNotNull($meeting);
        $this->assertDatabaseMissing('meetings', [
            'team_id' => 'threebiz',
            'held_on' => '2020-01-01',
        ]);
    }

    private function writeFixture(string $filename, string $content): string
    {
        $path = $this->fixturesDir.'/'.$filename;
        File::put($path, $content);

        return $path;
    }

    private function sampleMarkdown(
        ?string $teamId,
        string $sessionDate,
        string $body = 'Sample team minutes body',
        string $teamNameJa = 'スリーバイス',
    ): string {
        $teamIdLine = $teamId !== null ? "team_id: {$teamId}" : '';

        return <<<MD
---
doc_type: team_meeting
{$teamIdLine}
team_name_ja: "{$teamNameJa}"
session_date: "{$sessionDate}"
session_time_jst: "08:00-08:45"
format: zoom
source: "test fixture"
---

# スリーバイス チームMTG — {$sessionDate}

{$body}
MD;
    }
}
