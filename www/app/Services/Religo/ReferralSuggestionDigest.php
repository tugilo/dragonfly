<?php

namespace App\Services\Religo;

/**
 * SPEC-015/016: 議事録 Markdown の正規化と digest（SHA-256）。
 */
final class ReferralSuggestionDigest
{
    public static function normalize(string $body): string
    {
        $text = str_replace(["\r\n", "\r"], "\n", $body);
        $text = preg_replace("/[ \t]+/u", ' ', $text) ?? $text;
        $text = preg_replace("/\n{3,}/u", "\n\n", $text) ?? $text;

        return trim($text);
    }

    public static function digest(string $body): string
    {
        return hash('sha256', self::normalize($body));
    }

    public static function charCount(string $body): int
    {
        return mb_strlen(self::normalize($body));
    }
}
