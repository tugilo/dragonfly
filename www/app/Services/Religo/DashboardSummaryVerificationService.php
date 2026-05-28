<?php

namespace App\Services\Religo;

use Illuminate\Support\Facades\DB;

/**
 * Dashboard stats を「DB 直の集計」と突き合わせる（開発・検証用）.
 *
 * stale は単一 SELECT では表現できないため {@see DashboardService::countStaleContacts} と同一ロジックを正とする。
 */
final class DashboardSummaryVerificationService
{
    public function __construct(
        private DashboardService $dashboardService
    ) {}

    /**
     * @return array{
     *   owner_member_id: int,
     *   app_timezone: string,
     *   now_iso: string,
     *   db_raw: array<string, int|string|null>,
     *   service: array<string, mixed>,
     *   diff: array<string, int>,
     *   all_match: bool
     * }
     */
    public function verify(int $ownerMemberId): array
    {
        $startOfMonth = now()->copy()->startOfMonth()->toDateTimeString();
        $endOfMonth = now()->copy()->endOfMonth()->endOfDay()->toDateTimeString();

        $monthlyO2o = (int) DB::table('one_to_ones')
            ->where('owner_member_id', $ownerMemberId)
            ->where('status', 'completed')
            ->whereBetween('started_at', [$startOfMonth, $endOfMonth])
            ->count();

        $o2oTotal = (int) DB::table('one_to_ones')->where('owner_member_id', $ownerMemberId)->count();
        $o2oPlanned = (int) DB::table('one_to_ones')
            ->where('owner_member_id', $ownerMemberId)
            ->where('status', 'planned')
            ->count();
        $o2oCanceled = (int) DB::table('one_to_ones')
            ->where('owner_member_id', $ownerMemberId)
            ->where('status', 'canceled')
            ->count();

        $monthlyIntro = (int) DB::table('contact_memos')
            ->where('owner_member_id', $ownerMemberId)
            ->where('memo_type', 'introduction')
            ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
            ->count();

        $monthlyMeeting = (int) DB::table('contact_memos')
            ->where('owner_member_id', $ownerMemberId)
            ->where('memo_type', 'meeting')
            ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
            ->count();

        $staleFromService = $this->dashboardService->countStaleContacts($ownerMemberId);
        $stats = $this->dashboardService->getStats($ownerMemberId);

        $dbRaw = [
            'monthly_one_to_one_count' => $monthlyO2o,
            'one_to_one_total_count' => $o2oTotal,
            'one_to_one_planned_count' => $o2oPlanned,
            'one_to_one_canceled_count' => $o2oCanceled,
            'monthly_intro_memo_count' => $monthlyIntro,
            'monthly_meeting_memo_count' => $monthlyMeeting,
            'stale_contacts_count' => $staleFromService,
            'stale_note' => 'stale は MemberSummaryQuery（workspace null）+ 30 日閾値。本値は countStaleContacts と DB 集計の両方で service と一致確認用。',
        ];

        $diff = [
            'monthly_one_to_one_count' => $monthlyO2o - (int) $stats['monthly_one_to_one_count'],
            'one_to_one_total_count' => $o2oTotal - (int) $stats['one_to_one_total_count'],
            'one_to_one_planned_count' => $o2oPlanned - (int) $stats['one_to_one_planned_count'],
            'one_to_one_canceled_count' => $o2oCanceled - (int) $stats['one_to_one_canceled_count'],
            'monthly_intro_memo_count' => $monthlyIntro - (int) $stats['monthly_intro_memo_count'],
            'monthly_meeting_memo_count' => $monthlyMeeting - (int) $stats['monthly_meeting_memo_count'],
            'stale_contacts_count' => $staleFromService - (int) $stats['stale_contacts_count'],
        ];

        $allMatch = array_sum(array_map('abs', $diff)) === 0;

        return [
            'owner_member_id' => $ownerMemberId,
            'app_timezone' => (string) config('app.timezone'),
            'now_iso' => now()->toIso8601String(),
            'month_range' => ['start' => $startOfMonth, 'end' => $endOfMonth],
            'db_raw' => $dbRaw,
            'service' => [
                'stale_contacts_count' => $stats['stale_contacts_count'],
                'monthly_one_to_one_count' => $stats['monthly_one_to_one_count'],
                'one_to_one_total_count' => $stats['one_to_one_total_count'],
                'one_to_one_planned_count' => $stats['one_to_one_planned_count'],
                'one_to_one_canceled_count' => $stats['one_to_one_canceled_count'],
                'monthly_intro_memo_count' => $stats['monthly_intro_memo_count'],
                'monthly_meeting_memo_count' => $stats['monthly_meeting_memo_count'],
            ],
            'diff' => $diff,
            'all_match' => $allMatch,
        ];
    }
}
