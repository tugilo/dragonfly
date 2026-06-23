<?php

namespace App\Console\Commands;

use App\Models\Meeting;
use App\Models\MeetingMinute;
use App\Models\MeetingType;
use App\Support\MeetingDisplay;
use Illuminate\Console\Command;
use Symfony\Component\Yaml\Exception\ParseException;
use Symfony\Component\Yaml\Yaml;

/**
 * チーム MTG 議事録 Markdown を Meeting / meeting_minutes に取り込む.
 *
 * 使用例:
 *   php artisan dragonfly:import-team-minutes ../docs/meetings/team/team_threebiz_20260623.md
 *   php artisan dragonfly:import-team-minutes ../docs/meetings/team/
 */
class ImportTeamMinutesCommand extends Command
{
    protected $signature = 'dragonfly:import-team-minutes
                            {path : Markdown ファイルまたはディレクトリ}
                            {--held_on= : session_date / held_on を YYYY-MM-DD で上書き}';

    protected $description = 'チーム MTG 議事録 Markdown を meetings / meeting_minutes に取り込む（file→DB）';

    public function handle(): int
    {
        $pathArg = (string) $this->argument('path');
        $resolved = $this->resolveInputPath($pathArg);
        if ($resolved === null) {
            $this->error("Path not found or not readable: {$pathArg}");

            return self::FAILURE;
        }

        $files = is_dir($resolved)
            ? $this->collectMarkdownFiles($resolved)
            : [$resolved];

        if ($files === []) {
            $this->warn('No team_*.md files found.');

            return self::SUCCESS;
        }

        $imported = 0;
        foreach ($files as $file) {
            if ($this->importFile($file) === self::FAILURE) {
                return self::FAILURE;
            }
            $imported++;
        }

        $this->info("Imported {$imported} file(s).");

        return self::SUCCESS;
    }

    private function resolveInputPath(string $path): ?string
    {
        $candidates = [
            $path,
            base_path($path),
            base_path('../'.$path),
            '/var/docs/'.ltrim(str_replace('\\', '/', preg_replace('#^\.\./docs/#', '', $path)), '/'),
            realpath($path) ?: null,
        ];

        foreach ($candidates as $candidate) {
            if ($candidate === null) {
                continue;
            }
            if ((is_file($candidate) || is_dir($candidate)) && is_readable($candidate)) {
                return $candidate;
            }
        }

        return null;
    }

    /**
     * @return list<string>
     */
    private function collectMarkdownFiles(string $directory): array
    {
        $files = glob(rtrim($directory, DIRECTORY_SEPARATOR).DIRECTORY_SEPARATOR.'team_*.md') ?: [];
        sort($files);

        return array_values(array_filter($files, function (string $f): bool {
            if (! is_file($f) || ! is_readable($f)) {
                return false;
            }

            return str_starts_with(basename($f), 'team_');
        }));
    }

    private function importFile(string $absolutePath): int
    {
        $content = file_get_contents($absolutePath);
        if ($content === false) {
            $this->error("Failed to read: {$absolutePath}");

            return self::FAILURE;
        }

        $content = $this->stripBom($content);
        [$frontMatter, $body] = $this->parseFrontMatter($content);
        if ($frontMatter === null) {
            $this->error("Invalid or missing YAML front matter: {$absolutePath}");

            return self::FAILURE;
        }

        $docType = $this->stringOrNull($frontMatter['doc_type'] ?? null);
        if ($docType !== 'team_meeting') {
            $this->error("doc_type must be team_meeting: {$absolutePath}");

            return self::FAILURE;
        }

        $teamId = $this->stringOrNull($frontMatter['team_id'] ?? null);
        if ($teamId === null) {
            $this->error("team_id is required in front matter: {$absolutePath}");

            return self::FAILURE;
        }

        $heldOn = $this->option('held_on');
        if ($heldOn === null || $heldOn === '') {
            $heldOn = $frontMatter['session_date'] ?? null;
        }
        if (! is_string($heldOn) || ! preg_match('/^\d{4}-\d{2}-\d{2}$/', $heldOn)) {
            $this->error("held_on / session_date must be YYYY-MM-DD: {$absolutePath}");

            return self::FAILURE;
        }

        $teamNameJa = $this->stringOrNull($frontMatter['team_name_ja'] ?? null);
        $name = $teamNameJa !== null
            ? MeetingDisplay::defaultName(MeetingDisplay::SESSION_TEAM_MEETING, null, $teamNameJa)
            : $teamId.' チームMTG';

        $teamMeetingTypeId = MeetingType::idForCode(MeetingDisplay::SESSION_TEAM_MEETING);
        $sourcePath = $this->toRepoRelativePath($absolutePath);
        $now = now();

        $meeting = Meeting::query()
            ->where('meeting_type_id', $teamMeetingTypeId)
            ->where('team_id', $teamId)
            ->whereDate('held_on', $heldOn)
            ->first();

        if ($meeting === null) {
            $meeting = new Meeting([
                'meeting_type_id' => $teamMeetingTypeId,
                'team_id' => $teamId,
                'held_on' => $heldOn,
            ]);
        }

        $meeting->fill([
            'session_type' => MeetingDisplay::SESSION_TEAM_MEETING,
            'number' => null,
            'name' => $name,
        ]);
        $meeting->save();

        MeetingMinute::updateOrCreate(
            ['meeting_id' => $meeting->id],
            [
                'body_markdown' => trim($body),
                'source_path' => $sourcePath,
                'doc_type' => $docType,
                'session_date' => $heldOn,
                'session_time_jst' => $this->stringOrNull($frontMatter['session_time_jst'] ?? null),
                'session_time_note' => $this->stringOrNull($frontMatter['session_time_note'] ?? null),
                'format' => $this->stringOrNull($frontMatter['format'] ?? null),
                'source' => $this->stringOrNull($frontMatter['source'] ?? null),
                'front_matter' => $frontMatter,
                'imported_at' => $now,
            ]
        );

        $this->line('  '.MeetingDisplay::displayLabel($meeting)." ({$heldOn}) ← {$sourcePath}");

        return self::SUCCESS;
    }

    /**
     * @return array{0: ?array<string, mixed>, 1: string}
     */
    private function parseFrontMatter(string $content): array
    {
        if (! preg_match('/\A---\r?\n(.*?)\r?\n---\r?\n/s', $content, $matches)) {
            return [null, $content];
        }

        try {
            $parsed = Yaml::parse($matches[1]);
        } catch (ParseException $e) {
            $this->error('YAML parse error: '.$e->getMessage());

            return [null, $content];
        }

        if (! is_array($parsed)) {
            return [null, $content];
        }

        $body = substr($content, strlen($matches[0]));

        return [$parsed, $body];
    }

    private function stripBom(string $content): string
    {
        $bom = "\xEF\xBB\xBF";
        if (str_starts_with($content, $bom)) {
            return substr($content, strlen($bom));
        }

        return $content;
    }

    private function stringOrNull(mixed $value): ?string
    {
        if ($value === null) {
            return null;
        }
        $s = trim((string) $value);

        return $s === '' ? null : $s;
    }

    private function toRepoRelativePath(string $absolutePath): string
    {
        $repoRoot = realpath(base_path('..'));
        $docsRoot = is_dir('/var/docs') ? realpath('/var/docs') : false;
        $real = realpath($absolutePath);
        if ($docsRoot !== false && $real !== false && str_starts_with($real, $docsRoot.DIRECTORY_SEPARATOR)) {
            return 'docs/'.ltrim(substr($real, strlen($docsRoot)), DIRECTORY_SEPARATOR);
        }
        if ($repoRoot !== false && $real !== false && str_starts_with($real, $repoRoot.DIRECTORY_SEPARATOR)) {
            return ltrim(substr($real, strlen($repoRoot)), DIRECTORY_SEPARATOR);
        }

        return $absolutePath;
    }
}
