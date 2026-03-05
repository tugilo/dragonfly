<?php

namespace App\Services\Religo;

use App\Models\ContactMemo;
use App\Models\Meeting;
use App\Models\Member;
use App\Models\OneToOne;
use App\Queries\Religo\MemberSummaryQuery;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

/**
 * Dashboard 用集計. GET /api/dashboard/stats, tasks, activity.
 * SSOT: docs/SSOT/DASHBOARD_REQUIREMENTS.md §5.
 */
class DashboardService
{
    private const STALE_DAYS = 30;
    private const ACTIVITY_DEFAULT_LIMIT = 6;

    public function __construct(
        private MemberSummaryQuery $summaryQuery
    ) {}

    /**
     * GET /api/dashboard/stats 用.
     *
     * @return array{stale_contacts_count: int, monthly_one_to_one_count: int, monthly_intro_memo_count: int, monthly_meeting_memo_count: int, subtexts: array<string, string>}
     */
    public function getStats(int $ownerMemberId): array
    {
        $memberIds = Member::query()->where('id', '!=', $ownerMemberId)->pluck('id')->all();
        $staleCount = 0;
        if ($memberIds !== []) {
            $batch = $this->summaryQuery->getSummaryLiteBatch($ownerMemberId, $memberIds, null);
            $cutoff = now()->subDays(self::STALE_DAYS)->format('c');
            foreach ($batch as $lite) {
                $at = $lite['last_contact_at'] ?? null;
                if ($at === null || $at < $cutoff) {
                    $staleCount++;
                }
            }
        }

        $startOfMonth = now()->startOfMonth()->toDateTimeString();
        $endOfMonth = now()->endOfMonth()->endOfDay()->toDateTimeString();

        $monthlyOneToOne = OneToOne::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('status', 'completed')
            ->whereBetween('started_at', [$startOfMonth, $endOfMonth])
            ->count();

        $monthlyIntroMemo = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('memo_type', 'introduction')
            ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
            ->count();

        $monthlyMeetingMemo = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('memo_type', 'meeting')
            ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
            ->count();

        return [
            'stale_contacts_count' => $staleCount,
            'monthly_one_to_one_count' => $monthlyOneToOne,
            'monthly_intro_memo_count' => $monthlyIntroMemo,
            'monthly_meeting_memo_count' => $monthlyMeetingMemo,
            'subtexts' => [
                'stale' => '要フォロー',
                'one_to_one' => '先月比 +2',
                'intro' => 'BO含む',
                'meeting' => '例会#247 含む',
            ],
        ];
    }

    /**
     * GET /api/dashboard/tasks 用. 型は UI が扱いやすい形で返す.
     *
     * @return array<int, array{id: string, kind: string, title: string, person_name: string|null, meeting_number: string|null, action: array{label: string, href: string|null, disabled: bool}, badge: string|null, meta?: string}>
     */
    public function getTasks(int $ownerMemberId): array
    {
        $tasks = [];
        $memberIds = Member::query()->where('id', '!=', $ownerMemberId)->pluck('id')->all();
        $cutoff = now()->subDays(self::STALE_DAYS)->format('c');

        if ($memberIds !== []) {
            $batch = $this->summaryQuery->getSummaryLiteBatch($ownerMemberId, $memberIds, null);
            $members = Member::query()->whereIn('id', $memberIds)->get()->keyBy('id');
            $staleTargets = [];
            foreach ($batch as $tid => $lite) {
                $at = $lite['last_contact_at'] ?? null;
                if ($at === null || $at < $cutoff) {
                    $staleTargets[] = $tid;
                }
            }
            foreach (array_slice($staleTargets, 0, 2) as $i => $tid) {
                $m = $members->get($tid);
                $name = $m ? $m->name : ('#' . $tid);
                $days = null;
                if (isset($batch[$tid]['last_contact_at']) && $batch[$tid]['last_contact_at']) {
                    $days = (int) Carbon::parse($batch[$tid]['last_contact_at'])->diffInDays(now());
                } else {
                    $days = 999;
                }
                $tasks[] = [
                    'id' => 'stale-' . $tid,
                    'kind' => 'stale_follow',
                    'title' => $name,
                    'person_name' => $name,
                    'meeting_number' => null,
                    'action' => [
                        'label' => $i === 0 ? '1to1予定' : 'メモ追加',
                        'href' => $i === 0 ? '/one-to-ones/create' : null,
                        'disabled' => $i !== 0,
                    ],
                    'badge' => null,
                    'meta' => $days . '日間未接触 — ' . ($i === 0 ? '1to1を検討' : 'フォローアップ要'),
                ];
            }
        }

        $plannedO2o = OneToOne::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('status', 'planned')
            ->where(function ($q) {
                $q->whereDate('scheduled_at', '>=', now()->toDateString())
                    ->orWhereNull('scheduled_at');
            })
            ->with('targetMember:id,name')
            ->orderBy('scheduled_at')
            ->first();
        if ($plannedO2o) {
            $tasks[] = [
                'id' => 'oto-' . $plannedO2o->id,
                'kind' => 'one_to_one_planned',
                'title' => ($plannedO2o->targetMember?->name ?? '') . ' との1to1',
                'person_name' => $plannedO2o->targetMember?->name,
                'meeting_number' => null,
                'action' => ['label' => '予定', 'href' => null, 'disabled' => true],
                'badge' => '予定',
                'meta' => $plannedO2o->scheduled_at ? $plannedO2o->scheduled_at->format('本日 H:i') . ' — ' : '',
            ];
        }

        $nextMeeting = Meeting::query()
            ->where('held_on', '>=', now()->toDateString())
            ->orderBy('held_on')
            ->first();
        if (! $nextMeeting) {
            $nextMeeting = Meeting::query()->orderByDesc('held_on')->first();
        }
        if ($nextMeeting) {
            $tasks[] = [
                'id' => 'meeting-memo-' . $nextMeeting->id,
                'kind' => 'meeting_memo_pending',
                'title' => '例会 #' . $nextMeeting->number . ' メモ未整理',
                'person_name' => null,
                'meeting_number' => (string) $nextMeeting->number,
                'action' => ['label' => 'Meetingsへ', 'href' => '/meetings', 'disabled' => false],
                'badge' => null,
                'meta' => '次回例会まであと5日',
            ];
        }

        return $tasks;
    }

    /**
     * GET /api/dashboard/activity 用. 時系列 N 件.
     *
     * @return array<int, array{id: string, occurred_at: string, kind: string, title: string, meta: string}>
     */
    public function getActivity(int $ownerMemberId, int $limit = self::ACTIVITY_DEFAULT_LIMIT): array
    {
        $rows = [];
        $memos = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->with('targetMember:id,name')
            ->orderByDesc('created_at')
            ->limit($limit)
            ->get();
        foreach ($memos as $m) {
            $rows[] = [
                'occurred_at' => $m->created_at?->toIso8601String() ?? '',
                'kind' => 'memo_added',
                'title' => ($m->targetMember?->name ?? '') . ' にメモ追加',
                'meta' => mb_substr($m->body ?? '', 0, 30) . (mb_strlen($m->body ?? '') > 30 ? '…' : ''),
                'id' => 'memo-' . $m->id,
            ];
        }
        $o2os = OneToOne::query()
            ->where('owner_member_id', $ownerMemberId)
            ->with('targetMember:id,name')
            ->orderByDesc(DB::raw('COALESCE(started_at, scheduled_at, created_at)'))
            ->limit($limit)
            ->get();
        foreach ($o2os as $o) {
            $rows[] = [
                'occurred_at' => ($o->started_at ?? $o->scheduled_at ?? $o->created_at)?->toIso8601String() ?? '',
                'kind' => $o->status === 'completed' ? 'one_to_one_completed' : 'one_to_one_created',
                'title' => ($o->targetMember?->name ?? '') . ' 1to1' . ($o->status === 'completed' ? '完了' : '登録'),
                'meta' => $o->notes ? mb_substr($o->notes, 0, 25) . (mb_strlen($o->notes) > 25 ? '…' : '') : '',
                'id' => 'oto-' . $o->id,
            ];
        }
        usort($rows, function ($a, $b) {
            return strcmp($b['occurred_at'], $a['occurred_at']);
        });
        $rows = array_slice($rows, 0, $limit);
        return array_values($rows);
    }
}
