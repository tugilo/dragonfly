<?php

namespace App\Console\Commands;

use App\Models\OneToOne;
use Illuminate\Console\Command;
use Symfony\Component\Yaml\Exception\ParseException;
use Symfony\Component\Yaml\Yaml;

/**
 * 1to1 議事録 Markdown を one_to_ones.notes に取り込む（file→DB）.
 *
 * Meetings の dragonfly:import-chapter-minutes と同様、本文は front matter 除去後の全文を保存する。
 * 既存レコードは notes 内の source path、または文書内の one_to_ones.id で突合する。
 *
 * 使用例:
 *   php artisan dragonfly:import-1to1-notes ../docs/meetings/1to1/1to1_yamamoto_yoko_idemitsu_credit.md
 *   php artisan dragonfly:import-1to1-notes ../docs/meetings/1to1/
 */
class ImportOneToOneNotesCommand extends Command
{
    protected $signature = 'dragonfly:import-1to1-notes
                            {path : Markdown ファイルまたはディレクトリ（1to1_*.md）}
                            {--dry-run : DB を更新せず突合結果のみ表示}
                            {--only-ids= : 更新対象 one_to_ones.id をカンマ区切りで限定}';

    protected $description = '1to1 議事録 Markdown を one_to_ones.notes に取り込む（file→DB・全文）';

    public function handle(): int
    {
        $pathArg = (string) $this->argument('path');
        $resolved = $this->resolveInputPath($pathArg);
        if ($resolved === null) {
            $this->error("Path not found or not readable: {$pathArg}");

            return self::FAILURE;
        }

        $onlyIds = $this->parseOnlyIdsOption();
        if ($onlyIds === false) {
            return self::FAILURE;
        }

        $files = is_dir($resolved)
            ? $this->collectMarkdownFiles($resolved)
            : [$resolved];

        if ($files === []) {
            $this->warn('No 1to1_*.md files found.');

            return self::SUCCESS;
        }

        $dryRun = (bool) $this->option('dry-run');
        $updated = 0;
        $skipped = 0;

        foreach ($files as $file) {
            $result = $this->importFile($file, $dryRun, $onlyIds);
            if ($result === self::FAILURE) {
                return self::FAILURE;
            }
            if ($result === 'updated') {
                $updated++;
            } else {
                $skipped++;
            }
        }

        $verb = $dryRun ? 'Would update' : 'Updated';
        $this->info("{$verb} {$updated} file(s), skipped {$skipped}.");

        return self::SUCCESS;
    }

    /**
     * @return list<int>|null|false
     */
    private function parseOnlyIdsOption(): array|null|false
    {
        $raw = $this->option('only-ids');
        if ($raw === null || $raw === '') {
            return null;
        }
        $parts = array_filter(array_map('trim', explode(',', (string) $raw)));
        $ids = [];
        foreach ($parts as $part) {
            if (! ctype_digit($part) || (int) $part <= 0) {
                $this->error('--only-ids must be comma-separated positive integers.');

                return false;
            }
            $ids[] = (int) $part;
        }

        return $ids;
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
        $files = glob(rtrim($directory, DIRECTORY_SEPARATOR).DIRECTORY_SEPARATOR.'1to1_*.md') ?: [];
        sort($files);

        return array_values(array_filter($files, fn (string $f) => is_file($f) && is_readable($f)));
    }

    /**
     * @param  list<int>|null  $onlyIds
     * @return 'updated'|'skipped'|int FAILURE
     */
    private function importFile(string $absolutePath, bool $dryRun, ?array $onlyIds): string|int
    {
        $content = file_get_contents($absolutePath);
        if ($content === false) {
            $this->error("Failed to read: {$absolutePath}");

            return self::FAILURE;
        }

        $content = $this->stripBom($content);
        [, $body] = $this->parseFrontMatter($content);
        $body = trim($body);
        if ($body === '') {
            $this->warn("  (skip empty body) {$absolutePath}");

            return 'skipped';
        }

        $fileSourcePath = $this->toRepoRelativePath($absolutePath);
        $record = $this->resolveOneToOne($fileSourcePath, $body);
        if ($record === null) {
            $this->warn("  (no matching one_to_ones) {$fileSourcePath}");

            return 'skipped';
        }

        if ($onlyIds !== null && ! in_array((int) $record->id, $onlyIds, true)) {
            $this->line("  (skip id filter) #{$record->id} ← {$fileSourcePath}");

            return 'skipped';
        }

        $sourcePath = $this->canonicalSourcePathForRecord($record, $fileSourcePath);
        $notes = $this->buildNotesPayload($sourcePath, $body);
        $oldLen = mb_strlen((string) $record->notes);
        $newLen = mb_strlen($notes);

        if ($dryRun) {
            $this->line("  [dry-run] #{$record->id} notes {$oldLen} → {$newLen} chars ← {$sourcePath}");

            return 'updated';
        }

        $record->notes = $notes;
        $record->save();

        $this->line("  #{$record->id} notes {$oldLen} → {$newLen} chars ← {$sourcePath}");

        return 'updated';
    }

    private function buildNotesPayload(string $sourcePath, string $body): string
    {
        return "【ソース: {$sourcePath}】\n\n".$body;
    }

    private function canonicalSourcePathForRecord(OneToOne $record, string $fileSourcePath): string
    {
        $existing = (string) $record->notes;
        if (preg_match('/ソース:\s*(docs\/meetings\/1to1\/[a-zA-Z0-9_.-]+\.md)/', $existing, $matches)) {
            return trim($matches[1]);
        }

        $basename = basename(str_replace('\\', '/', $fileSourcePath));
        if (preg_match('/^1to1_.+\.md$/', $basename)) {
            return 'docs/meetings/1to1/'.$basename;
        }

        return $fileSourcePath;
    }

    private function resolveOneToOne(string $sourcePath, string $body): ?OneToOne
    {
        $byPath = OneToOne::query()
            ->where('notes', 'like', '%'.$sourcePath.'%')
            ->orderBy('id')
            ->first();
        if ($byPath !== null) {
            return $byPath;
        }

        $basename = basename(str_replace('\\', '/', $sourcePath));
        if ($basename !== '' && preg_match('/^1to1_.+\.md$/', $basename)) {
            $byBasename = OneToOne::query()
                ->where('notes', 'like', '%'.$basename.'%')
                ->orderBy('id')
                ->first();
            if ($byBasename !== null) {
                return $byBasename;
            }
        }

        if (preg_match('/one_to_ones\.id`\s*=\s*\*\*(\d+)\*\*/', $body, $matches)) {
            $id = (int) $matches[1];

            return OneToOne::query()->find($id);
        }

        return null;
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
            $this->warn('YAML parse warning (body only): '.$e->getMessage());

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
