<?php

namespace App\Services\Ai;

/**
 * SPEC-013: HTML（NCAS プロフィール等）から本文テキストを抽出する簡易ユーティリティ。
 */
class HtmlTextExtractor
{
    public function extract(string $html): string
    {
        // script / style を除去
        $html = preg_replace('#<(script|style)\b[^>]*>.*?</\1>#is', ' ', $html) ?? $html;
        // 改行になりやすいタグを改行へ
        $html = preg_replace('#<(br|/p|/div|/tr|/li|/h[1-6])\s*/?>#i', "\n", $html) ?? $html;
        // 残りのタグ除去
        $text = strip_tags($html);
        // エンティティ復号
        $text = html_entity_decode($text, ENT_QUOTES | ENT_HTML5, 'UTF-8');
        // 連続空白・空行を整理
        $text = preg_replace('/[ \t]+/u', ' ', $text) ?? $text;
        $text = preg_replace('/\n\s*\n\s*\n+/u', "\n\n", $text) ?? $text;

        return trim($text);
    }
}
