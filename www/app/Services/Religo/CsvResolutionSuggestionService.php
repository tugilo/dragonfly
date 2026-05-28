<?php

namespace App\Services\Religo;

use App\Models\Category;
use App\Models\Member;
use App\Models\Role;

/**
 * M8: CSV 未解決行向けのあいまい一致候補（スコア付き）。自動確定はしない。
 */
final class CsvResolutionSuggestionService
{
    public const TOP_LIMIT = 5;

    public const REASON_EXACT_MATCH = 'exact_match';

    public const REASON_NORMALIZED_MATCH = 'normalized_match';

    public const REASON_KANA_MATCH = 'kana_match';

    public const REASON_PREFIX_MATCH = 'prefix_match';

    public const REASON_PARTIAL_MATCH = 'partial_match';

    private const SCORE_EXACT = 100;

    private const SCORE_NORMALIZED = 90;

    private const SCORE_KANA = 70;

    private const SCORE_PREFIX = 65;

    private const SCORE_PARTIAL = 50;

    /**
     * 比較用正規化（元データは変更しない）。
     */
    public function normalizeForCompare(string $input): string
    {
        $s = trim($input);
        $s = mb_convert_kana($s, 's', 'UTF-8');
        $s = preg_replace('/\s+/u', ' ', $s) ?? $s;
        $s = trim($s);
        $s = str_replace(['・', '･', '•', '．', '.', '　'], ['', '', '', '', '', ' '], $s);
        $s = preg_replace('/\s+/u', '', $s) ?? $s;
        if ($s === '') {
            return '';
        }
        if (class_exists(\Transliterator::class)) {
            $t = \Transliterator::create('Katakana-Hiragana');
            if ($t !== null) {
                $s = $t->transliterate($s);
            }
        }
        $s = mb_strtolower($s, 'UTF-8');

        return $s;
    }

    /**
     * @return list<array{id: int, label: string, score: int, match_reason: string}>
     */
    public function suggestMembers(string $csvName, ?string $csvKana = null): array
    {
        $csvName = trim($csvName);
        if ($csvName === '') {
            return [];
        }
        $csvKana = $csvKana !== null && trim($csvKana) !== '' ? trim($csvKana) : null;

        $bestById = [];
        $members = Member::query()->get(['id', 'name', 'name_kana']);
        foreach ($members as $m) {
            $score = 0;
            $reason = '';
            $pair = $this->scoreNamePair($csvName, $m->name, self::SCORE_EXACT, self::SCORE_NORMALIZED, self::SCORE_PREFIX, self::SCORE_PARTIAL);
            if ($pair['score'] > $score) {
                $score = $pair['score'];
                $reason = $pair['reason'];
            }
            if ($csvKana !== null && $m->name_kana !== null && trim((string) $m->name_kana) !== '') {
                $kPair = $this->scoreNamePair($csvKana, (string) $m->name_kana, 0, self::SCORE_KANA, self::SCORE_PREFIX - 5, self::SCORE_PARTIAL - 5);
                if ($kPair['score'] > $score) {
                    $score = $kPair['score'];
                    $reason = $kPair['score'] >= self::SCORE_KANA ? self::REASON_KANA_MATCH : $kPair['reason'];
                }
            }
            if ($csvKana !== null) {
                $nk = $this->scoreNamePair($csvName, (string) ($m->name_kana ?? ''), 0, self::SCORE_KANA - 5, 0, self::SCORE_PARTIAL - 10);
                if ($nk['score'] > $score) {
                    $score = $nk['score'];
                    $reason = self::REASON_KANA_MATCH;
                }
            }
            if ($score > 0) {
                $id = (int) $m->id;
                if (! isset($bestById[$id]) || $score > $bestById[$id]['score']) {
                    $bestById[$id] = [
                        'id' => $id,
                        'label' => $m->name,
                        'score' => $score,
                        'match_reason' => $reason,
                    ];
                }
            }
        }

        return $this->sortAndLimit($bestById);
    }

    /**
     * @return array{score: int, reason: string}
     */
    private function scoreNamePair(string $a, string $b, int $exact, int $normalized, int $prefix, int $partial): array
    {
        $ta = trim($a);
        $tb = trim($b);
        if ($ta === '' || $tb === '') {
            return ['score' => 0, 'reason' => ''];
        }
        if ($ta === $tb) {
            return ['score' => $exact, 'reason' => self::REASON_EXACT_MATCH];
        }
        $na = $this->normalizeForCompare($ta);
        $nb = $this->normalizeForCompare($tb);
        if ($na === '' || $nb === '') {
            return ['score' => 0, 'reason' => ''];
        }
        if ($na === $nb) {
            return ['score' => $normalized, 'reason' => self::REASON_NORMALIZED_MATCH];
        }
        if (mb_strlen($na, 'UTF-8') >= 2 && mb_strlen($nb, 'UTF-8') >= 2) {
            if (str_starts_with($nb, $na) || str_starts_with($na, $nb)) {
                return ['score' => $prefix, 'reason' => self::REASON_PREFIX_MATCH];
            }
        }
        if (mb_strlen($na, 'UTF-8') >= 2 && (mb_strpos($nb, $na, 0, 'UTF-8') !== false || mb_strpos($na, $nb, 0, 'UTF-8') !== false)) {
            return ['score' => $partial, 'reason' => self::REASON_PARTIAL_MATCH];
        }

        return ['score' => 0, 'reason' => ''];
    }

    /**
     * @return list<array{id: int, label: string, score: int, match_reason: string}>
     */
    public function suggestCategories(string $sourceLabel): array
    {
        $sourceLabel = trim($sourceLabel);
        if ($sourceLabel === '') {
            return [];
        }
        $bestById = [];
        $categories = Category::query()->get(['id', 'group_name', 'name']);
        foreach ($categories as $c) {
            $label = $c->group_name === $c->name ? $c->name : ($c->group_name.' / '.$c->name);
            $score = 0;
            $reason = '';
            foreach ([$label, $c->group_name, $c->name] as $target) {
                $pair = $this->scoreNamePair($sourceLabel, $target, self::SCORE_EXACT, self::SCORE_NORMALIZED, self::SCORE_PREFIX, self::SCORE_PARTIAL);
                if ($pair['score'] > $score) {
                    $score = $pair['score'];
                    $reason = $pair['reason'];
                }
            }
            if ($score > 0) {
                $id = (int) $c->id;
                if (! isset($bestById[$id]) || $score > $bestById[$id]['score']) {
                    $bestById[$id] = [
                        'id' => $id,
                        'label' => $label,
                        'score' => $score,
                        'match_reason' => $reason,
                    ];
                }
            }
        }

        return $this->sortAndLimit($bestById);
    }

    /**
     * @return list<array{id: int, label: string, score: int, match_reason: string}>
     */
    public function suggestRoles(string $csvRoleName): array
    {
        $csvRoleName = trim($csvRoleName);
        if ($csvRoleName === '') {
            return [];
        }
        $bestById = [];
        $roles = Role::query()->get(['id', 'name']);
        foreach ($roles as $r) {
            $pair = $this->scoreNamePair($csvRoleName, (string) $r->name, self::SCORE_EXACT, self::SCORE_NORMALIZED, self::SCORE_PREFIX, self::SCORE_PARTIAL);
            if ($pair['score'] > 0) {
                $id = (int) $r->id;
                if (! isset($bestById[$id]) || $pair['score'] > $bestById[$id]['score']) {
                    $bestById[$id] = [
                        'id' => $id,
                        'label' => $r->name,
                        'score' => $pair['score'],
                        'match_reason' => $pair['reason'],
                    ];
                }
            }
        }

        return $this->sortAndLimit($bestById);
    }

    /**
     * @param  array<int, array{id: int, label: string, score: int, match_reason: string}>  $bestById
     * @return list<array{id: int, label: string, score: int, match_reason: string}>
     */
    private function sortAndLimit(array $bestById): array
    {
        $list = array_values($bestById);
        usort($list, static function (array $x, array $y): int {
            if ($x['score'] !== $y['score']) {
                return $y['score'] <=> $x['score'];
            }

            return $x['id'] <=> $y['id'];
        });

        return array_slice($list, 0, self::TOP_LIMIT);
    }
}
