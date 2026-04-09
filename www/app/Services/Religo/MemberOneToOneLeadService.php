<?php

namespace App\Services\Religo;

use App\Models\Category;
use App\Models\DragonflyContactFlag;
use App\Models\Member;
use App\Models\OneToOne;
use Carbon\Carbon;

/**
 * ONETOONES-P5 / P6: Owner 視点で各メンバー（target）との 1 to 1 リード状況を集計する.
 *
 * **実施の定義（completed のみ）**
 * - `one_to_ones.status = completed` の行だけを「実施」と数え、最終日時は
 *   `COALESCE(ended_at, started_at, scheduled_at)` の MAX（Index / Stats と同系の代表日時）。
 * - `planned` / `canceled` は「実施済み回数」には含めない（未実施判定は completed 件数 0）。
 *
 * **one_to_one_status（UI ラベルは SSOT: DATA_MODEL.md §4.12.1）**
 * - `none` — completed が 0 件（**未実施**）
 * - `needs_action` — completed が 1 件以上かつ、最終 completed が **要対応閾値日時より前**
 * - `ok` — 最終 completed が **閾値以内**（**実施済** tier＝記録上の最終実施が直近である）
 *
 * **要対応閾値:** `config('religo.one_to_one_lead_needs_action_days')`（既定 30）。
 * `now(app.timezone)->copy()->subDays($days)` との厳密比較（`lt`）。端の日付解釈は P5 以来変更なし。
 *
 * **並び順（Dashboard / Members 整合）:** 応答配列は **会員番号の数値昇順**（`Member::orderByDisplayNoNumeric` — `display_no` が文字列でも 1,2,…,10,11… になる）。ステータス tier・want_1on1 による二次ソートは行わない。
 *
 * **対象から除外する members.type:** `guest`（ゲスト）・`visitor`（ビジター）は名簿上の在籍メンバーではないため **リード一覧に含めない**（`active` / `inactive` 等のみ）。
 */
class MemberOneToOneLeadService
{
    /** Dashboard「次の1to1候補」の target から除外する members.type */
    private const EXCLUDED_LEAD_TARGET_TYPES = ['guest', 'visitor'];

    /**
     * @return list<array{
     *     member_id: int,
     *     name: string,
     *     category_label: string|null,
     *     last_one_to_one_at: string|null,
     *     one_to_one_status: string,
     *     want_1on1: bool
     * }>
     */
    public function indexForOwner(int $ownerMemberId): array
    {
        if (! Member::where('id', $ownerMemberId)->exists()) {
            return [];
        }

        $tz = (string) config('app.timezone');
        $now = Carbon::now($tz);
        $days = max(0, (int) config('religo.one_to_one_lead_needs_action_days', 30));
        $staleBefore = $now->copy()->subDays($days);

        $completedByTarget = OneToOne::query()
            ->selectRaw('target_member_id, MAX(COALESCE(ended_at, started_at, scheduled_at)) as last_completed_at')
            ->where('owner_member_id', $ownerMemberId)
            ->where('status', 'completed')
            ->groupBy('target_member_id')
            ->get()
            ->keyBy('target_member_id');

        $targetIds = Member::query()
            ->where('id', '!=', $ownerMemberId)
            ->whereNotIn('type', self::EXCLUDED_LEAD_TARGET_TYPES)
            ->orderByDisplayNoNumeric('asc')
            ->pluck('id')
            ->all();

        if ($targetIds === []) {
            return [];
        }

        $flags = DragonflyContactFlag::query()
            ->where('owner_member_id', $ownerMemberId)
            ->whereIn('target_member_id', $targetIds)
            ->get()
            ->keyBy('target_member_id');

        $members = Member::query()
            ->with('category')
            ->whereIn('id', $targetIds)
            ->orderByDisplayNoNumeric('asc')
            ->get(['id', 'display_no', 'name', 'category_id']);

        $rows = [];
        foreach ($members as $m) {
            $tid = (int) $m->id;
            $stat = $completedByTarget->get($tid);
            $lastRaw = $stat?->last_completed_at;
            $lastCarbon = $lastRaw !== null ? Carbon::parse($lastRaw, $tz) : null;

            if ($lastCarbon === null) {
                $status = 'none';
                $lastDate = null;
            } elseif ($lastCarbon->lt($staleBefore)) {
                $status = 'needs_action';
                $lastDate = $lastCarbon->toDateString();
            } else {
                $status = 'ok';
                $lastDate = $lastCarbon->toDateString();
            }

            $flagRow = $flags->get($tid);
            $want = $flagRow !== null && $flagRow->want_1on1 === true;

            $displayName = trim(
                ($m->display_no !== null ? '#'.$m->display_no.' ' : '').($m->name ?? '')
            ) ?: '#'.$tid;

            $rows[] = [
                'member_id' => $tid,
                'name' => $displayName,
                'category_label' => $this->formatCategoryLabel($m->category),
                'last_one_to_one_at' => $lastDate,
                'one_to_one_status' => $status,
                'want_1on1' => $want,
            ];
        }

        return $rows;
    }

    /**
     * categories の一覧表示と同じ規則（group_name === name なら name のみ）。
     */
    private function formatCategoryLabel(?Category $category): ?string
    {
        if ($category === null) {
            return null;
        }
        $g = (string) $category->group_name;
        $n = (string) $category->name;

        return $g === $n ? $n : $g.' / '.$n;
    }
}
