<?php

namespace App\Services\Religo;

/**
 * M7-P8: 参加者一覧ページ（participants）専用の候補抽出。
 * ビジター様 / 代理出席者様 / ゲスト様 のセクションを追跡し、type_hint を付与する。
 */
class ParticipantPdfParticipantsPageParser
{
    private const SECTION_VISITOR = 'visitor';
    private const SECTION_PROXY = 'proxy';
    private const SECTION_GUEST = 'guest';

    /** セクション見出し → type_hint / source_section */
    private const SECTION_MARKERS = [
        'ビジター様' => self::SECTION_VISITOR,
        '代理出席者様' => self::SECTION_PROXY,
        'ゲスト様' => self::SECTION_GUEST,
    ];

    private const MIN_NAME_LENGTH = 2;

    /** ページ内の見出し行として候補にしないキーワード */
    private const PAGE_HEADER_KEYWORDS = ['ミーティング参加者'];

    /**
     * 参加者一覧ページのテキストから候補を抽出する。
     *
     * @return array{ candidates: array<int, array{name: string, raw_line: string, type_hint: string, page_type: string, source_section: string|null}>, line_count: int }
     */
    public function parse(string $pageText): array
    {
        $lines = preg_split('/\R/u', $pageText, -1, PREG_SPLIT_NO_EMPTY) ?: [];
        $candidates = [];
        $currentSection = null;
        $currentTypeHint = 'regular';

        foreach ($lines as $rawLine) {
            $line = trim($rawLine);
            if ($line === '') {
                continue;
            }

            $detected = $this->detectSectionMarker($line);
            if ($detected !== null) {
                $currentSection = $detected;
                $currentTypeHint = $detected;
                continue;
            }

            if ($this->isPageHeaderLine($line)) {
                continue;
            }

            $name = $this->extractNameFromParticipantLine($line);
            if (mb_strlen($name) < self::MIN_NAME_LENGTH) {
                continue;
            }

            $candidates[] = [
                'name' => $name,
                'raw_line' => $rawLine,
                'type_hint' => $currentTypeHint,
                'page_type' => 'participants',
                'source_section' => $currentSection,
            ];
        }

        return [
            'candidates' => $candidates,
            'line_count' => count($lines),
        ];
    }

    /**
     * 行がセクション見出しならその区分を、でなければ null を返す。
     */
    private function detectSectionMarker(string $line): ?string
    {
        foreach (self::SECTION_MARKERS as $marker => $section) {
            if ($marker !== '' && mb_strpos($line, $marker, 0, 'UTF-8') !== false) {
                return $section;
            }
        }

        return null;
    }

    private function isPageHeaderLine(string $line): bool
    {
        foreach (self::PAGE_HEADER_KEYWORDS as $keyword) {
            if ($keyword !== '' && mb_strpos($line, $keyword, 0, 'UTF-8') !== false) {
                return true;
            }
        }

        return false;
    }

    private function extractNameFromParticipantLine(string $line): string
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
