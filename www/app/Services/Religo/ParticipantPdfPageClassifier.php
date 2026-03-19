<?php

namespace App\Services\Religo;

/**
 * M7-P7: PDF 1 ページ分のテキストを内容ベースで分類する。
 * 戻り値: ignore | members | participants
 */
class ParticipantPdfPageClassifier
{
    public const TYPE_IGNORE = 'ignore';
    public const TYPE_MEMBERS = 'members';
    public const TYPE_PARTICIPANTS = 'participants';

    /** ignore と判定するキーワード（説明・スケジュール等） */
    private const IGNORE_KEYWORDS = [
        'BNIとは',
        'TIME SCHEDULE',
        'コアバリュー',
    ];

    /** members と判定するキーワード（メンバー表） */
    private const MEMBERS_KEYWORDS = [
        'メンバー表',
        'よみがな',
        'カテゴリー',
        '役職',
    ];

    /** participants と判定するキーワード（参加者一覧） */
    private const PARTICIPANTS_KEYWORDS = [
        'ミーティング参加者',
        'ビジター様',
        '代理出席者様',
        'ゲスト様',
    ];

    /**
     * 1 ページ分のテキストからページ種別を判定する。
     *
     * @return string ignore | members | participants
     */
    public function classify(string $pageText): string
    {
        $text = $pageText;

        if ($this->containsAny($text, self::IGNORE_KEYWORDS)) {
            return self::TYPE_IGNORE;
        }
        if ($this->containsAny($text, self::PARTICIPANTS_KEYWORDS)) {
            return self::TYPE_PARTICIPANTS;
        }
        if ($this->containsAny($text, self::MEMBERS_KEYWORDS)) {
            return self::TYPE_MEMBERS;
        }

        return self::TYPE_IGNORE;
    }

    /**
     * @param string[] $keywords
     */
    private function containsAny(string $text, array $keywords): bool
    {
        foreach ($keywords as $keyword) {
            if ($keyword !== '' && mb_strpos($text, $keyword, 0, 'UTF-8') !== false) {
                return true;
            }
        }

        return false;
    }
}
