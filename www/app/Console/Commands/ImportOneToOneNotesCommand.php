<?php

namespace App\Console\Commands;

use App\Services\Religo\OneToOneNotesImportService;
use Illuminate\Console\Command;

/**
 * 1to1 議事録 Markdown を one_to_ones.notes に取り込む（file→DB）.
 *
 * 複数回あるファイルは `### 【第N回】` 単位で既存 id 行を更新する（SPEC-019 P1）。
 * 見出しがない旧形式は 1ファイル → 1レコード・全文のまま（後方互換）。
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

    protected $description = '1to1 議事録 Markdown を one_to_ones.notes に取り込む（セクション単位・SPEC-019）';

    public function __construct(
        private OneToOneNotesImportService $importService,
    ) {
        parent::__construct();
    }

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
        $updatedFiles = 0;
        $skippedFiles = 0;

        foreach ($files as $file) {
            $label = basename($file);
            $this->line($label);

            $results = $this->importService->importFile($file, $dryRun, $onlyIds);
            $fileUpdated = false;

            foreach ($results as $result) {
                if ($result['action'] === 'error') {
                    $this->error('  '.$result['message']);

                    return self::FAILURE;
                }

                $prefix = match ($result['action']) {
                    'update' => '  [update]',
                    'skip' => '  [skip]',
                    default => '  ',
                };
                $this->line($prefix.' '.$result['message']);

                if ($result['action'] === 'update') {
                    $fileUpdated = true;
                }
            }

            if ($fileUpdated) {
                $updatedFiles++;
            } else {
                $skippedFiles++;
            }
        }

        $verb = $dryRun ? 'Would update' : 'Updated';
        $this->info("{$verb} {$updatedFiles} file(s), skipped {$skippedFiles}.");

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
}
