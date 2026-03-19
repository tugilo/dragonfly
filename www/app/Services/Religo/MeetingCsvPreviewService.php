<?php

namespace App\Services\Religo;

/**
 * M7-C2: 保存済み参加者CSVを読み込み、プレビュー用に整形する。
 * participants への反映は行わない。
 */
class MeetingCsvPreviewService
{
    private const REQUIRED_HEADERS = ['種別', '名前'];

    /** CSV ヘッダ名 → プレビュー用キー */
    private const HEADER_TO_KEY = [
        '種別' => 'type',
        'No' => 'no',
        '名前' => 'name',
        'よみがな' => 'kana',
        '大カテゴリー' => 'category_group',
        'カテゴリー' => 'category',
        '役職' => 'role',
        '紹介者' => 'introducer',
        'アテンド' => 'attendant',
        'オリエン' => 'orient',
    ];

    /** プレビューで返す列の順序（日本語ラベル）。No は表示用のみで識別には使わない。 */
    private const PREVIEW_HEADERS = ['種別', 'No', '名前', 'よみがな', '大カテゴリー', 'カテゴリー', '役職', '紹介者', 'アテンド', 'オリエン'];

    /**
     * CSV を読み込み、プレビュー用の headers / rows / row_count を返す。
     *
     * @param  string  $fullPath  CSV の絶対パス（Storage::path($file_path) 等）
     * @return array{headers: string[], rows: array<int, array<string, string|null>>, row_count: int}
     *
     * @throws \RuntimeException ファイルが読めない・必須列がない場合
     */
    public function preview(string $fullPath): array
    {
        $content = @file_get_contents($fullPath);
        if ($content === false) {
            throw new \RuntimeException('CSVファイルを読み込めませんでした。', 404);
        }

        $content = $this->stripBom($content);
        $lines = preg_split('/\r\n|\r|\n/', $content);
        if ($lines === false || count($lines) < 1) {
            throw new \RuntimeException('CSVにヘッダーがありません。', 422);
        }

        $headerLine = array_shift($lines);
        $headers = array_map('trim', str_getcsv($headerLine));

        foreach (self::REQUIRED_HEADERS as $required) {
            if (! in_array($required, $headers, true)) {
                throw new \RuntimeException("必須列がありません: {$required}", 422);
            }
        }

        $rows = [];
        foreach ($lines as $line) {
            $line = trim($line);
            if ($line === '') {
                continue;
            }
            $values = str_getcsv($line);
            if (count($values) < count($headers)) {
                $values = array_pad($values, count($headers), '');
            }
            $values = array_slice($values, 0, count($headers));
            $assoc = array_combine($headers, $values);
            if ($assoc === false) {
                continue;
            }
            $assoc = array_map(fn ($v) => is_string($v) ? trim($v) : $v, $assoc);
            $rows[] = $this->normalizeRow($assoc);
        }

        return [
            'headers' => self::PREVIEW_HEADERS,
            'rows' => $rows,
            'row_count' => count($rows),
        ];
    }

    private function stripBom(string $content): string
    {
        $bom = "\xEF\xBB\xBF";
        if (str_starts_with($content, $bom)) {
            return substr($content, strlen($bom));
        }

        return $content;
    }

    /**
     * @param  array<string, string>  $row  ヘッダをキーにした1行
     * @return array<string, string|null>  プレビュー用キー
     */
    private function normalizeRow(array $row): array
    {
        $out = [];
        foreach (self::HEADER_TO_KEY as $headerName => $key) {
            $value = $row[$headerName] ?? null;
            $out[$key] = $value === '' ? null : $value;
        }
        return $out;
    }
}
