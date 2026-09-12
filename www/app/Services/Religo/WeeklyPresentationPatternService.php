<?php

namespace App\Services\Religo;

use App\Models\Member;
use App\Models\MemberWeeklyPresentationUsage;
use Carbon\Carbon;
use Illuminate\Validation\ValidationException;

/**
 * ウィークリー稿パターンの解決・選択・利用履歴。SPEC-004 / Phase 307.
 */
class WeeklyPresentationPatternService
{
    public const USAGE_LIMIT = 12;

    /**
     * @return array{
     *     weekly_presentation_body: ?string,
     *     weekly_presentation_patterns: list<array{id: string, label: string, body: string}>,
     *     weekly_presentation_active_id: ?string,
     *     weekly_presentation_usages: list<array{pattern_id: string, label: string, used_on: string, used_at: string}>
     * }
     */
    public function payload(Member $member): array
    {
        $patterns = $this->normalizePatterns($member->weekly_presentation_patterns);
        $activeId = $this->resolveActiveId($member, $patterns);
        $body = $this->resolveBody($member, $patterns, $activeId);

        return [
            'weekly_presentation_body' => $this->normalizeBody($body),
            'weekly_presentation_patterns' => $patterns,
            'weekly_presentation_active_id' => $activeId,
            'weekly_presentation_usages' => $this->usageRows($member, $patterns),
        ];
    }

    /**
     * @return array{
     *     weekly_presentation_body: ?string,
     *     weekly_presentation_patterns: list<array{id: string, label: string, body: string}>,
     *     weekly_presentation_active_id: ?string,
     *     weekly_presentation_usages: list<array{pattern_id: string, label: string, used_on: string, used_at: string}>
     * }
     */
    public function select(Member $member, string $patternId): array
    {
        $chosen = $this->requirePattern($member, $patternId);
        $member->weekly_presentation_active_id = $chosen['id'];
        $member->weekly_presentation_body = $chosen['body'];
        $member->save();

        return $this->payload($member->fresh());
    }

    /**
     * 例会で使ったあと、その週の利用を残す。切替だけでは書かない。
     *
     * @return array{
     *     weekly_presentation_body: ?string,
     *     weekly_presentation_patterns: list<array{id: string, label: string, body: string}>,
     *     weekly_presentation_active_id: ?string,
     *     weekly_presentation_usages: list<array{pattern_id: string, label: string, used_on: string, used_at: string}>
     * }
     */
    public function recordUsage(Member $member, string $patternId): array
    {
        $chosen = $this->requirePattern($member, $patternId);
        $now = Carbon::now('Asia/Tokyo');
        $usedOn = $now->toDateString();

        $existing = MemberWeeklyPresentationUsage::query()
            ->where('member_id', $member->id)
            ->where('pattern_id', $chosen['id'])
            ->whereDate('used_on', $usedOn)
            ->first();
        if ($existing !== null) {
            $existing->used_at = $now;
            $existing->save();
        } else {
            MemberWeeklyPresentationUsage::query()->create([
                'member_id' => $member->id,
                'pattern_id' => $chosen['id'],
                'used_on' => $usedOn,
                'used_at' => $now,
            ]);
        }

        return $this->payload($member->fresh());
    }

    /**
     * @return array{id: string, label: string, body: string}
     */
    private function requirePattern(Member $member, string $patternId): array
    {
        $patterns = $this->normalizePatterns($member->weekly_presentation_patterns);
        $chosen = $this->findPattern($patterns, $patternId);
        if ($chosen === null) {
            throw ValidationException::withMessages([
                'pattern_id' => ['指定したパターンがありません。'],
            ]);
        }

        return $chosen;
    }

    /**
     * @param  mixed  $raw
     * @return list<array{id: string, label: string, body: string}>
     */
    public function normalizePatterns(mixed $raw): array
    {
        if (! is_array($raw)) {
            return [];
        }

        $out = [];
        foreach ($raw as $row) {
            if (! is_array($row)) {
                continue;
            }
            $id = trim((string) ($row['id'] ?? ''));
            $label = trim((string) ($row['label'] ?? ''));
            $body = (string) ($row['body'] ?? '');
            if ($id === '' || $label === '' || trim($body) === '') {
                continue;
            }
            $out[] = [
                'id' => $id,
                'label' => $label,
                'body' => $body,
            ];
        }

        return $out;
    }

    /**
     * @param  list<array{id: string, label: string, body: string}>  $patterns
     */
    private function resolveActiveId(Member $member, array $patterns): ?string
    {
        if ($patterns === []) {
            return null;
        }
        $active = trim((string) ($member->weekly_presentation_active_id ?? ''));
        if ($active !== '' && $this->findPattern($patterns, $active) !== null) {
            return $active;
        }
        $legacy = $this->normalizeBody($member->weekly_presentation_body);
        if ($legacy !== null) {
            foreach ($patterns as $pattern) {
                if ($pattern['body'] === $legacy) {
                    return $pattern['id'];
                }
            }
        }

        return $patterns[0]['id'];
    }

    /**
     * @param  list<array{id: string, label: string, body: string}>  $patterns
     */
    private function resolveBody(Member $member, array $patterns, ?string $activeId): ?string
    {
        if ($activeId !== null) {
            $chosen = $this->findPattern($patterns, $activeId);
            if ($chosen !== null) {
                return $chosen['body'];
            }
        }

        return $this->normalizeBody($member->weekly_presentation_body);
    }

    /**
     * @param  list<array{id: string, label: string, body: string}>  $patterns
     * @return array{id: string, label: string, body: string}|null
     */
    private function findPattern(array $patterns, string $patternId): ?array
    {
        foreach ($patterns as $pattern) {
            if ($pattern['id'] === $patternId) {
                return $pattern;
            }
        }

        return null;
    }

    /**
     * @param  list<array{id: string, label: string, body: string}>  $patterns
     * @return list<array{pattern_id: string, label: string, used_on: string, used_at: string}>
     */
    private function usageRows(Member $member, array $patterns): array
    {
        $labels = [];
        foreach ($patterns as $pattern) {
            $labels[$pattern['id']] = $pattern['label'];
        }

        $rows = MemberWeeklyPresentationUsage::query()
            ->where('member_id', $member->id)
            ->orderByDesc('used_at')
            ->orderByDesc('id')
            ->limit(self::USAGE_LIMIT)
            ->get();

        $out = [];
        foreach ($rows as $row) {
            $out[] = [
                'pattern_id' => $row->pattern_id,
                'label' => $labels[$row->pattern_id] ?? $row->pattern_id,
                'used_on' => $this->formatUsedOn($row->used_on),
                'used_at' => $row->used_at?->timezone('Asia/Tokyo')->format('Y-m-d H:i:s') ?? '',
            ];
        }

        return $out;
    }

    private function normalizeBody(?string $body): ?string
    {
        return ($body === null || $body === '') ? null : $body;
    }

    private function formatUsedOn(mixed $usedOn): string
    {
        if ($usedOn instanceof Carbon) {
            return $usedOn->toDateString();
        }
        if (is_string($usedOn) && $usedOn !== '') {
            return substr($usedOn, 0, 10);
        }

        return '';
    }
}
