<?php

namespace App\Services\Zoom;

/**
 * Zoom ミーティングが 1 to 1 候補かを判定する（SPEC-012 §4.4）。
 *
 * 判定は「候補・自信度」であり最終登録要否は人が選ぶ。
 * BNI 以外（定例会・チーム MTG・社内・私用）は候補から外し UI 既定を未選択にする。
 */
class ZoomOneToOneDetector
{
    /** 1to1 を示唆する件名キーワード。 */
    private const ONE_TO_ONE_KEYWORDS = [
        '1to1', '1on1', '121', '1 to 1', '1 on 1', 'one to one',
        '調整用', '面談', 'ミーティング',
    ];

    /** 1to1 ではないと推定する件名キーワード（除外）。 */
    private const EXCLUDE_KEYWORDS = [
        '定例', '例会', 'weekly', 'チーム', 'team', 'スリーバイス',
        '全体', 'all hands', 'all-hands', 'セミナー', '勉強会', '研修',
        'webinar', 'ウェビナー', '社内', 'mtg全体',
    ];

    /**
     * @return array{is_candidate: bool, confidence: string}
     */
    public function evaluate(?string $topic, ?int $participantsCount): array
    {
        $topicLower = mb_strtolower(trim((string) $topic));

        if ($this->matchesAny($topicLower, self::EXCLUDE_KEYWORDS)) {
            return ['is_candidate' => false, 'confidence' => 'low'];
        }

        $hasKeyword = $this->matchesAny($topicLower, self::ONE_TO_ONE_KEYWORDS)
            || $this->mentionsPerson($topic);
        // 参加者数が取れない（scheduled で null）場合は名前/件名のみで判定する。
        $isTwoParticipants = $participantsCount === null ? null : ($participantsCount === 2);

        if ($isTwoParticipants === true && $hasKeyword) {
            return ['is_candidate' => true, 'confidence' => 'high'];
        }
        if ($isTwoParticipants === true || $hasKeyword) {
            return ['is_candidate' => true, 'confidence' => 'medium'];
        }
        if ($isTwoParticipants === null && $topicLower !== '') {
            // 予定（人数不明）でキーワードも無い → 低確度の非候補。
            return ['is_candidate' => false, 'confidence' => 'low'];
        }

        return ['is_candidate' => false, 'confidence' => 'low'];
    }

    /**
     * 件名から相手の氏名らしき部分を推定する（「○○さん」「○○様」など）。
     */
    public function guessCounterpartName(?string $topic): ?string
    {
        $topic = trim((string) $topic);
        if ($topic === '') {
            return null;
        }
        // 「氏名さん」「氏名様」を優先抽出。
        if (preg_match('/([\x{3040}-\x{30ff}\x{4e00}-\x{9faf}A-Za-z]{2,})\s*(さん|様|氏)/u', $topic, $m)) {
            return $m[1];
        }

        return null;
    }

    /**
     * @param  array<int, string>  $keywords
     */
    private function matchesAny(string $haystackLower, array $keywords): bool
    {
        foreach ($keywords as $kw) {
            if ($kw !== '' && str_contains($haystackLower, mb_strtolower($kw))) {
                return true;
            }
        }

        return false;
    }

    private function mentionsPerson(?string $topic): bool
    {
        return $this->guessCounterpartName($topic) !== null;
    }
}
