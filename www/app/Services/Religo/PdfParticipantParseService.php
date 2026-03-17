<?php

namespace App\Services\Religo;

use Smalot\PdfParser\Parser;

/**
 * M7-P2-IMPLEMENT-1: PDF からテキスト抽出し、参加者候補を簡易生成する。
 * テキスト埋め込み PDF のみ対象。participants には触れない。
 */
class PdfParticipantParseService
{
    private const PARSER_VERSION = 1;

    public function __construct(
        private Parser $parser
    ) {}

    /**
     * PDF の絶対パスからテキストを抽出する。
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
