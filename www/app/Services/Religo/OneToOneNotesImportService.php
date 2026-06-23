<?php

namespace App\Services\Religo;

use App\Models\OneToOne;
use Symfony\Component\Yaml\Exception\ParseException;
use Symfony\Component\Yaml\Yaml;

/**
 * 1to1 議事録 Markdown → one_to_ones.notes（SPEC-019 P1）。
 */
class OneToOneNotesImportService
{
    public function __construct(
        private OneToOneNotesMarkdownParser $parser,
    ) {}

    /**
     * @param  list<int>|null  $onlyIds
     * @return list<array{action: string, one_to_one_id: int|null, session_number: int|null, message: string}>
     */
    public function importFile(string $absolutePath, bool $dryRun, ?array $onlyIds): array
    {
        $content = file_get_contents($absolutePath);
        if ($content === false) {
            return [['action' => 'error', 'one_to_one_id' => null, 'session_number' => null, 'message' => "Failed to read: {$absolutePath}"]];
        }

        $content = $this->stripBom($content);
        [, $body] = $this->parseFrontMatter($content);
        $body = trim($body);
        if ($body === '') {
            return [['action' => 'skip', 'one_to_one_id' => null, 'session_number' => null, 'message' => '(skip empty body)']];
        }

        $fileSourcePath = $this->toRepoRelativePath($absolutePath);
        $sessions = $this->parser->parseSessions($body);

        if ($sessions === []) {
            return $this->importLegacyFullBody($fileSourcePath, $body, $dryRun, $onlyIds);
        }

        $results = [];
        foreach ($sessions as $session) {
            $sessionNumber = $session['session_number'];
            $oneToOneId = $session['one_to_one_id'];

            if ($oneToOneId === null) {
                $results[] = [
                    'action' => 'skip',
                    'one_to_one_id' => null,
                    'session_number' => $sessionNumber,
                    'message' => "第{$sessionNumber}回: one_to_ones.id 未記載",
                ];

                continue;
            }

            if ($onlyIds !== null && ! in_array($oneToOneId, $onlyIds, true)) {
                $results[] = [
                    'action' => 'skip',
                    'one_to_one_id' => $oneToOneId,
                    'session_number' => $sessionNumber,
                    'message' => 'id filter',
                ];

                continue;
            }

            $record = OneToOne::query()->find($oneToOneId);
            if ($record === null) {
                $results[] = [
                    'action' => 'skip',
                    'one_to_one_id' => $oneToOneId,
                    'session_number' => $sessionNumber,
                    'message' => "record not found #{$oneToOneId}",
                ];

                continue;
            }

            if ($record->status === 'canceled') {
                $results[] = [
                    'action' => 'skip',
                    'one_to_one_id' => $oneToOneId,
                    'session_number' => $sessionNumber,
                    'message' => 'canceled',
                ];

                continue;
            }

            $sourcePath = $this->canonicalSourcePathForRecord($record, $fileSourcePath);
            $notes = $this->buildSectionNotesPayload($sourcePath, $sessionNumber, $session['content']);
            $oldLen = mb_strlen((string) $record->notes);
            $newLen = mb_strlen($notes);

            if ($dryRun) {
                $results[] = [
                    'action' => 'update',
                    'one_to_one_id' => $oneToOneId,
                    'session_number' => $sessionNumber,
                    'message' => "[dry-run] #{$oneToOneId} 第{$sessionNumber}回 notes {$oldLen} → {$newLen} chars",
                ];

                continue;
            }

            $record->notes = $notes;
            $record->save();

            $results[] = [
                'action' => 'update',
                'one_to_one_id' => $oneToOneId,
                'session_number' => $sessionNumber,
                'message' => "#{$oneToOneId} 第{$sessionNumber}回 notes {$oldLen} → {$newLen} chars",
            ];
        }

        return $results;
    }

    /**
     * @param  list<int>|null  $onlyIds
     * @return list<array{action: string, one_to_one_id: int|null, session_number: int|null, message: string}>
     */
    private function importLegacyFullBody(string $fileSourcePath, string $body, bool $dryRun, ?array $onlyIds): array
    {
        $record = $this->resolveOneToOne($fileSourcePath, $body);
        if ($record === null) {
            return [['action' => 'skip', 'one_to_one_id' => null, 'session_number' => null, 'message' => '(no matching one_to_ones)']];
        }

        if ($onlyIds !== null && ! in_array((int) $record->id, $onlyIds, true)) {
            return [
                [
                    'action' => 'skip',
                    'one_to_one_id' => (int) $record->id,
                    'session_number' => null,
                    'message' => 'id filter',
                ],
            ];
        }

        if ($record->status === 'canceled') {
            return [
                [
                    'action' => 'skip',
                    'one_to_one_id' => (int) $record->id,
                    'session_number' => null,
                    'message' => 'canceled',
                ],
            ];
        }

        $sourcePath = $this->canonicalSourcePathForRecord($record, $fileSourcePath);
        $notes = $this->buildFullNotesPayload($sourcePath, $body);
        $oldLen = mb_strlen((string) $record->notes);
        $newLen = mb_strlen($notes);

        if ($dryRun) {
            return [
                [
                    'action' => 'update',
                    'one_to_one_id' => (int) $record->id,
                    'session_number' => null,
                    'message' => "[dry-run] #{$record->id} notes {$oldLen} → {$newLen} chars (legacy full)",
                ],
            ];
        }

        $record->notes = $notes;
        $record->save();

        return [
            [
                'action' => 'update',
                'one_to_one_id' => (int) $record->id,
                'session_number' => null,
                'message' => "#{$record->id} notes {$oldLen} → {$newLen} chars (legacy full)",
            ],
        ];
    }

    public function buildSectionNotesPayload(string $sourcePath, int $sessionNumber, string $sectionContent): string
    {
        return "【ソース: {$sourcePath}#第{$sessionNumber}回】\n\n".trim($sectionContent);
    }

    public function buildFullNotesPayload(string $sourcePath, string $body): string
    {
        return "【ソース: {$sourcePath}】\n\n".trim($body);
    }

    private function canonicalSourcePathForRecord(OneToOne $record, string $fileSourcePath): string
    {
        $existing = (string) $record->notes;
        $fromNotes = $this->parser->extractSourcePath($existing);
        if ($fromNotes !== null) {
            return $fromNotes;
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

        $id = $this->parser->extractOneToOneIdFromText($body);
        if ($id !== null) {
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
        } catch (ParseException) {
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
