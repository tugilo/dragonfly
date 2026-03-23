<?php

namespace App\Services\Religo;

use App\Models\DragonflyContactFlag;
use App\Models\OneToOne;
use Carbon\Carbon;

/**
 * 1 to 1 一覧向け統計。Index と同一の filter を適用（ONETOONES-P4）。
 */
class OneToOneStatsService
{
    public function __construct(
        private OneToOneIndexService $indexService
    ) {}

    /**
     * @param  array{
     *     owner_member_id?: int,
     *     workspace_id?: int,
     *     target_member_id?: int,
     *     status?: string,
     *     from?: string,
     *     to?: string,
     *     q?: string
     * }  $filters
     * @return array{
     *     planned_count: int,
     *     completed_this_month_count: int,
     *     canceled_this_month_count: int,
     *     want_1on1_on_count: int,
     *     period: array{timezone: string, month_start: string, month_end: string}
     * }
     */
    public function getStats(array $filters): array
    {
        $tz = (string) config('app.timezone');
        $now = Carbon::now($tz);
        $monthStart = $now->copy()->startOfMonth()->startOfDay();
        $monthEnd = $now->copy()->endOfMonth()->endOfDay();

        $ownerMemberId = isset($filters['owner_member_id']) && $filters['owner_member_id'] !== ''
            ? (int) $filters['owner_member_id']
            : null;

        $planned = OneToOne::query();
        $this->indexService->applyIndexFilters($planned, $filters);
        $planned->where('status', 'planned');
        $plannedCount = $planned->count();

        // 「実施/予定日」は一覧・EffectiveDateField と同様に started_at → scheduled_at を優先する。
        // ended_at を最優先にすると（UTC ずれ・入力順の差などで）一覧に「今月」と見える行が統計から外れる（ONETOONES-P4）。
        $completedEffective = 'COALESCE(started_at, scheduled_at, ended_at)';
        $completed = OneToOne::query();
        $this->indexService->applyIndexFilters($completed, $filters);
        $completed->where('status', 'completed')
            ->whereRaw("{$completedEffective} IS NOT NULL")
            ->whereRaw("{$completedEffective} >= ?", [$monthStart])
            ->whereRaw("{$completedEffective} <= ?", [$monthEnd]);
        $completedCount = $completed->count();

        $canceled = OneToOne::query();
        $this->indexService->applyIndexFilters($canceled, $filters);
        $canceled->where('status', 'canceled')
            ->whereRaw('COALESCE(updated_at, ended_at, started_at, scheduled_at) >= ?', [$monthStart])
            ->whereRaw('COALESCE(updated_at, ended_at, started_at, scheduled_at) <= ?', [$monthEnd]);
        $canceledCount = $canceled->count();

        $targetsQuery = OneToOne::query();
        $this->indexService->applyIndexFilters($targetsQuery, $filters);
        $targetIds = $targetsQuery->distinct()->pluck('target_member_id')->filter()->values()->all();

        $want1on1Count = 0;
        if ($ownerMemberId !== null && $targetIds !== []) {
            $want1on1Count = (int) DragonflyContactFlag::query()
                ->where('owner_member_id', $ownerMemberId)
                ->where('want_1on1', true)
                ->whereIn('target_member_id', $targetIds)
                ->count();
        }

        return [
            'planned_count' => $plannedCount,
            'completed_this_month_count' => $completedCount,
            'canceled_this_month_count' => $canceledCount,
            'want_1on1_on_count' => $want1on1Count,
            'period' => [
                'timezone' => $tz,
                'month_start' => $monthStart->toIso8601String(),
                'month_end' => $monthEnd->toIso8601String(),
            ],
        ];
    }
}
