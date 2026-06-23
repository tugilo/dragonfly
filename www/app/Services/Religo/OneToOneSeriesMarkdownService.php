<?php

namespace App\Services\Religo;

use App\Models\ContactMemo;
use App\Models\OneToOne;
use Illuminate\Support\Collection;

/**
 * owner×target の 1to1 シリーズ全文組み立て（SPEC-019 §4.6 / P3）。
 */
class OneToOneSeriesMarkdownService
{
    public function __construct(
        private OneToOneNotesMarkdownParser $parser,
    ) {}

    public function hasSeriesMemo(int $ownerMemberId, int $targetMemberId): bool
    {
        $hasShared = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('target_member_id', $targetMemberId)
            ->where('memo_type', 'one_to_one')
            ->whereNull('one_to_one_id')
            ->whereNotNull('body')
            ->where('body', '!=', '')
            ->exists();

        if ($hasShared) {
            return true;
        }

        return OneToOne::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('target_member_id', $targetMemberId)
            ->where('status', '!=', 'canceled')
            ->whereNotNull('notes')
            ->where('notes', '!=', '')
            ->exists();
    }

    /**
     * @return array{markdown: string, source_path: string|null, has_series_memo: bool}
     */
    public function getSeriesMarkdown(int $ownerMemberId, int $targetMemberId): array
    {
        $rows = OneToOne::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('target_member_id', $targetMemberId)
            ->where('status', '!=', 'canceled')
            ->orderByRaw('COALESCE(started_at, scheduled_at, created_at) ASC, id ASC')
            ->get();

        $sourcePath = $this->extractSourcePathFromRows($rows);
        $fallback = $this->findFullDocumentFallback($rows);

        if ($fallback !== null) {
            return [
                'markdown' => $this->notesBodyWithoutSourceLine($fallback),
                'source_path' => $sourcePath,
                'has_series_memo' => true,
            ];
        }

        $parts = [];

        $sharedBodies = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('target_member_id', $targetMemberId)
            ->where('memo_type', 'one_to_one')
            ->whereNull('one_to_one_id')
            ->whereNotNull('body')
            ->where('body', '!=', '')
            ->orderBy('created_at')
            ->orderBy('id')
            ->pluck('body');

        foreach ($sharedBodies as $body) {
            $trimmed = trim((string) $body);
            if ($trimmed !== '') {
                $parts[] = $trimmed;
            }
        }

        foreach ($rows as $row) {
            $notes = trim((string) $row->notes);
            if ($notes === '') {
                continue;
            }

            $bodyOnly = $this->notesBodyWithoutSourceLine($notes);
            if ($bodyOnly === '') {
                continue;
            }

            if (preg_match('/^###\s*【第/mu', $bodyOnly)) {
                $parts[] = $bodyOnly;
            } else {
                $date = $row->started_at ?? $row->scheduled_at ?? $row->created_at;
                $label = $date !== null ? $date->format('Y-m-d') : '記録';
                $parts[] = "### 【{$label}】\n\n".$bodyOnly;
            }
        }

        $markdown = implode("\n\n---\n\n", $parts);

        return [
            'markdown' => $markdown,
            'source_path' => $sourcePath,
            'has_series_memo' => $markdown !== '',
        ];
    }

    /**
     * @param  Collection<int, OneToOne>  $rows
     */
    private function findFullDocumentFallback(Collection $rows): ?string
    {
        $best = null;
        $bestLen = 0;

        foreach ($rows as $row) {
            $notes = trim((string) $row->notes);
            if ($notes === '') {
                continue;
            }

            $body = $this->notesBodyWithoutSourceLine($notes);
            if ($this->looksLikeFullDocument($notes, $body)) {
                $len = mb_strlen($notes);
                if ($len > $bestLen) {
                    $best = $notes;
                    $bestLen = $len;
                }
            }
        }

        return $best;
    }

    private function looksLikeFullDocument(string $rawNotes, string $bodyWithoutSource): bool
    {
        if (str_contains($rawNotes, '## ■')) {
            return true;
        }

        if (preg_match_all('/^###\s*【第\d+回】/mu', $bodyWithoutSource) > 1) {
            return true;
        }

        return mb_strlen($bodyWithoutSource) >= 3000;
    }

    /**
     * @param  Collection<int, OneToOne>  $rows
     */
    private function extractSourcePathFromRows(Collection $rows): ?string
    {
        foreach ($rows as $row) {
            $path = $this->parser->extractSourcePath((string) $row->notes);
            if ($path !== null) {
                return $path;
            }
        }

        return null;
    }

    private function notesBodyWithoutSourceLine(string $notes): string
    {
        $lines = preg_split('/\r\n|\r|\n/', $notes) ?: [];
        $filtered = [];
        foreach ($lines as $line) {
            if (preg_match('/^【ソース:/u', trim($line))) {
                continue;
            }
            $filtered[] = $line;
        }

        return trim(implode("\n", $filtered));
    }
}
