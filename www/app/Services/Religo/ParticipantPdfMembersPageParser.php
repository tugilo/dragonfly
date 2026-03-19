<?php

namespace App\Services\Religo;

/**
 * M7-P8: メンバー表ページ（members）専用の候補抽出。
 * 見出し行・カテゴリ見出しを除外し、人名らしい行のみ候補化する。
 */
class ParticipantPdfMembersPageParser
{
    /** 候補から除外するヘッダ・見出しに含まれるキーワード（行全体がこれのみ or 含む場合は除外） */
    private const HEADER_KEYWORDS = [
        'No.',
        '名前',
        'よみがな',
        'カテゴリー',
        '役職',
        '備考',
        'メンバー表',
    ];

    /** カテゴリ見出しとして除外するパターン（例: 建設・不動産、IT・通信） */
    private const CATEGORY_HEADER_PATTERN = '/^[\p{L}\p{N}\s・\-]+$/u';

    /** 最小人名長（短すぎる行はノイズとみなす） */
    private const MIN_NAME_LENGTH = 2;

    /**
     * メンバー表ページのテキストから候補を抽出する。
     *
     * @return array{ candidates: array<int, array{name: string, raw_line: string, type_hint: string, page_type: string, source_section: null}>, line_count: int }
     */
    public function parse(string $pageText): array
    {
        $lines = preg_split('/\R/u', $pageText, -1, PREG_SPLIT_NO_EMPTY) ?: [];
        $candidates = [];
        foreach ($lines as $rawLine) {
            $line = trim($rawLine);
            if ($line === '') {
                continue;
            }
            if ($this->isHeaderOrCategoryLine($line)) {
                continue;
            }
            $name = $this->extractNameFromMemberLine($line);
            if (mb_strlen($name) < self::MIN_NAME_LENGTH) {
                continue;
            }
            $candidates[] = [
                'name' => $name,
                'raw_line' => $rawLine,
                'type_hint' => 'regular',
                'page_type' => 'members',
                'source_section' => null,
            ];
        }

        return [
            'candidates' => $candidates,
            'line_count' => count($lines),
        ];
    }

    private function isHeaderOrCategoryLine(string $line): bool
    {
        foreach (self::HEADER_KEYWORDS as $keyword) {
            if ($keyword !== '' && mb_strpos($line, $keyword, 0, 'UTF-8') !== false) {
                return true;
            }
        }
        // 行が短く、かつ ・ を含むカテゴリ見出し風（例: 建設・不動産、IT・通信）の場合は除外
        if (mb_strpos($line, '・', 0, 'UTF-8') !== false && preg_match(self::CATEGORY_HEADER_PATTERN, $line) && mb_strlen($line) <= 12) {
            return true;
        }

        return false;
    }

    /**
     * メンバー表の 1 行から名前部分を抽出する。
     * 先頭の "01 " のような番号を除き、姓名らしい部分を返す。
     */
    private function extractNameFromMemberLine(string $line): string
    {
        $line = trim($line);
        if ($line === '') {
            return '';
        }
        if (preg_match('/^\d+\s+/u', $line, $m)) {
            $line = trim(mb_substr($line, mb_strlen($m[0]), null, 'UTF-8'));
        }

        return $line;
    }
}
