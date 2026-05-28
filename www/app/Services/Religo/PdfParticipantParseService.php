<?php

namespace App\Services\Religo;

use Smalot\PdfParser\Parser;

/**
 * M7-P2-IMPLEMENT-1: PDF からテキスト抽出し、参加者候補を簡易生成する。
 * M7-P7: ページ単位で内容判定し、ignore / members / participants に分類。ignore は候補抽出対象外。
 * M7-P8: members / participants ページで専用パーサを使い分ける。
 */
class PdfParticipantParseService
{
    private const PARSER_VERSION = 2;

    public function __construct(
        private Parser $parser,
        private ParticipantPdfPageClassifier $pageClassifier,
        private ParticipantPdfMembersPageParser $membersPageParser,
        private ParticipantPdfParticipantsPageParser $participantsPageParser
    ) {}

    /**
     * PDF の絶対パスからテキストを抽出する（全ページ結合）。後方互換用。
     *
     * @return string 抽出テキスト（失敗時は空文字または例外）
     * @throws \Exception パースに失敗した場合
     */
    public function extractText(string $fullPath): string
    {
        $pdf = $this->parser->parseFile($fullPath);
        $text = $pdf->getText();
        return $text !== null ? $text : '';
    }

    /**
     * M7-P7: PDF をページ単位で読み、内容判定のうえ members/participants ページのみから候補を生成する。
     *
     * @return array{ candidates: array, meta: array{ pages: array, line_count: int, parser_version: int }, extracted_text: string }
     * @throws \Exception パースに失敗した場合
     */
    public function parseFile(string $fullPath): array
    {
        $pdf = $this->parser->parseFile($fullPath);
        $pages = $pdf->getPages();
        $metaPages = [];
        $allCandidates = [];
        $textParts = [];
        $totalLines = 0;
        $pageNumber = 1;
        foreach ($pages as $page) {
            $pageText = $page !== null ? trim((string) $page->getText()) : '';
            $type = $this->pageClassifier->classify($pageText);
            $metaPages[] = ['page' => $pageNumber, 'type' => $type];

            if ($type !== ParticipantPdfPageClassifier::TYPE_IGNORE) {
                $textParts[] = $pageText;
                if ($type === ParticipantPdfPageClassifier::TYPE_MEMBERS) {
                    $result = $this->membersPageParser->parse($pageText);
                } elseif ($type === ParticipantPdfPageClassifier::TYPE_PARTICIPANTS) {
                    $result = $this->participantsPageParser->parse($pageText);
                } else {
                    $legacy = $this->buildCandidates($pageText);
                    $result = [
                        'candidates' => $this->ensureCandidateKeys($legacy['candidates']),
                        'line_count' => $legacy['meta']['line_count'],
                    ];
                }
                foreach ($result['candidates'] as $c) {
                    $allCandidates[] = $c;
                }
                $totalLines += $result['line_count'];
            }
            $pageNumber++;
        }

        $extractedText = implode("\n\n", $textParts);
        $meta = [
            'pages' => $metaPages,
            'line_count' => $totalLines,
            'parser_version' => self::PARSER_VERSION,
        ];

        return [
            'candidates' => $allCandidates,
            'meta' => $meta,
            'extracted_text' => $extractedText,
        ];
    }

    /**
     * 抽出テキストから参加者候補を生成する。
     * 行単位で 1 候補。type_hint は行内のキーワードで推定、なければ regular。
     *
     * @return array{ candidates: array<int, array{name: string, raw_line: string, type_hint: string|null}>, meta: array{ line_count: int, parser_version: int } }
     */
    public function buildCandidates(string $text): array
    {
        $lines = preg_split('/\R/u', $text, -1, PREG_SPLIT_NO_EMPTY) ?: [];
        $candidates = [];
        foreach ($lines as $line) {
            $raw = $line;
            $line = trim($line);
            if ($line === '') {
                continue;
            }
            $typeHint = $this->inferTypeHint($line);
            $candidates[] = [
                'name' => $line,
                'raw_line' => $raw,
                'type_hint' => $typeHint,
            ];
        }
        return [
            'candidates' => $candidates,
            'meta' => [
                'line_count' => count($lines),
                'parser_version' => self::PARSER_VERSION,
            ],
        ];
    }

    /**
     * 既存 buildCandidates の戻り値に page_type / source_section を付与する（フォールバック用）。
     */
    private function ensureCandidateKeys(array $candidates): array
    {
        $out = [];
        foreach ($candidates as $c) {
            $c['page_type'] = $c['page_type'] ?? 'participants';
            $c['source_section'] = $c['source_section'] ?? null;
            $out[] = $c;
        }

        return $out;
    }

    private function inferTypeHint(string $line): ?string
    {
        if (preg_match('/ゲスト/u', $line)) {
            return 'guest';
        }
        if (preg_match('/ビジター|ビジタ/u', $line)) {
            return 'visitor';
        }
        if (preg_match('/代理/u', $line)) {
            return 'proxy';
        }
        return 'regular';
    }
}
