<?php

namespace App\Services\Religo;

use App\Models\BoAssignmentAuditLog;
use App\Models\ContactMemo;
use App\Models\DragonflyContactFlag;
use App\Models\Meeting;
use App\Models\Member;
use App\Models\OneToOne;
use App\Queries\Religo\MemberSummaryQuery;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

/**
 * Dashboard 用集計. GET /api/dashboard/stats, tasks, activity.
 * SSOT: docs/SSOT/DASHBOARD_DATA_SSOT.md, DASHBOARD_FIT_AND_GAP.md.
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
        $peerCount = count($memberIds);
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

        $startOfMonth = now()->copy()->startOfMonth()->toDateTimeString();
        $endOfMonth = now()->copy()->endOfMonth()->endOfDay()->toDateTimeString();
        $prevStart = now()->copy()->subMonthNoOverflow()->startOfMonth()->toDateTimeString();
        $prevEnd = now()->copy()->subMonthNoOverflow()->endOfMonth()->endOfDay()->toDateTimeString();

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

        $prevOneToOne = OneToOne::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('status', 'completed')
            ->whereBetween('started_at', [$prevStart, $prevEnd])
            ->count();
        $prevIntro = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('memo_type', 'introduction')
            ->whereBetween('created_at', [$prevStart, $prevEnd])
            ->count();
        $prevMeetingMemo = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->where('memo_type', 'meeting')
            ->whereBetween('created_at', [$prevStart, $prevEnd])
            ->count();

        $latestMeeting = Meeting::query()->orderByDesc('number')->first();

        return [
            'stale_contacts_count' => $staleCount,
            'monthly_one_to_one_count' => $monthlyOneToOne,
            'monthly_intro_memo_count' => $monthlyIntroMemo,
            'monthly_meeting_memo_count' => $monthlyMeetingMemo,
            'subtexts' => [
                'stale' => $this->buildStaleSubtext($staleCount, $peerCount),
                'one_to_one' => $this->buildMoMCountSubtext($monthlyOneToOne, $prevOneToOne),
                'intro' => $this->buildMoMCountSubtext($monthlyIntroMemo, $prevIntro),
                'meeting' => $this->buildMeetingMemoSubtext($monthlyMeetingMemo, $prevMeetingMemo, $latestMeeting),
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
                        'href' => $i === 0 ? '/one-to-ones/create' : '/members/' . $tid . '/show',
                        'disabled' => false,
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
        $hasUpcomingMeeting = $nextMeeting !== null;
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
                'meta' => $this->buildMeetingMemoTaskMeta($nextMeeting, $hasUpcomingMeeting),
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
            $isIntro = ($m->memo_type ?? '') === 'introduction';
            $label = $isIntro ? ' に紹介メモ' : ' にメモ追加';
            $rows[] = [
                'occurred_at' => $m->created_at?->toIso8601String() ?? '',
                'kind' => $isIntro ? 'memo_introduction' : 'memo_added',
                'title' => ($m->targetMember?->name ?? '') . $label,
                'meta' => mb_substr($m->body ?? '', 0, 30) . (mb_strlen($m->body ?? '') > 30 ? '…' : ''),
                'id' => 'memo-' . $m->id,
            ];
        }
        $flags = DragonflyContactFlag::query()
            ->where('owner_member_id', $ownerMemberId)
            ->with(['targetMember:id,name'])
            ->orderByDesc('updated_at')
            ->limit($limit)
            ->get();
        foreach ($flags as $f) {
            $rows[] = [
                'occurred_at' => $f->updated_at?->toIso8601String() ?? '',
                'kind' => 'flag_changed',
                'title' => ($f->targetMember?->name ?? '') . ' とのつながりを更新',
                'meta' => $this->formatFlagActivityMeta($f),
                'id' => 'flag-' . $f->id,
            ];
        }
        $boLogs = BoAssignmentAuditLog::query()
            ->where('actor_owner_member_id', $ownerMemberId)
            ->with('meeting:id,number')
            ->orderByDesc('occurred_at')
            ->limit($limit)
            ->get();
        foreach ($boLogs as $log) {
            $rows[] = [
                'occurred_at' => $log->occurred_at?->toIso8601String() ?? '',
                'kind' => 'bo_assigned',
                'title' => '例会 #' . ($log->meeting?->number ?? '?') . ' のBO割当を保存',
                'meta' => $this->formatBoAssignmentActivityMeta($log),
                'id' => 'bo-audit-' . $log->id,
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

    private function buildStaleSubtext(int $staleCount, int $peerCount): string
    {
        if ($peerCount <= 0) {
            return '比較対象メンバーなし（自分以外が未登録）';
        }
        $pct = (int) round(100 * $staleCount / $peerCount);

        return sprintf('30日超未接触 %d / %d 人（約 %d%%）・要フォロー', $staleCount, $peerCount, $pct);
    }

    private function buildMoMCountSubtext(int $current, int $previous): string
    {
        $delta = $current - $previous;
        if ($delta === 0) {
            return sprintf('先月も %d 件（変化なし）', $previous);
        }

        return sprintf('先月 %d 件・%s%d', $previous, $delta > 0 ? '増 ' : '減 ', abs($delta));
    }

    private function buildMeetingMemoSubtext(int $current, int $previous, ?Meeting $latest): string
    {
        $mom = $this->buildMoMCountSubtext($current, $previous);
        if ($latest !== null) {
            return $mom . '・直近登録 例会#' . $latest->number;
        }

        return $mom;
    }

    /**
     * 次回例会タスクの meta。日付は app timezone の暦日で丸める。
     */
    private function buildMeetingMemoTaskMeta(Meeting $meeting, bool $hasUpcomingMeeting): string
    {
        $held = Carbon::parse($meeting->held_on)->startOfDay();
        $today = now()->startOfDay();
        if ($hasUpcomingMeeting) {
            $days = (int) $today->diffInDays($held, false);
            if ($days === 0) {
                return '本日開催';
            }
            if ($days > 0) {
                return '次回例会まであと' . $days . '日';
            }

            return '終了済み';
        }

        return '次回例会は未登録（直近 例会#' . $meeting->number . '・終了済み）';
    }

    private function formatFlagActivityMeta(DragonflyContactFlag $f): string
    {
        $parts = [];
        if ($f->interested) {
            $parts[] = '関心あり';
        }
        if ($f->want_1on1) {
            $parts[] = '1to1希望';
        }
        $extra = $f->extra_status;
        if (is_array($extra) && $extra !== []) {
            $parts[] = 'メモあり';
        }

        return $parts !== [] ? implode('・', $parts) : 'フラグを更新';
    }

    private function formatBoAssignmentActivityMeta(BoAssignmentAuditLog $log): string
    {
        $payload = $log->payload ?? [];
        $memberIdSet = [];
        if ($log->source === BoAssignmentAuditLog::SOURCE_BREAKOUT_ROUNDS) {
            foreach ($payload['rounds'] ?? [] as $round) {
                foreach ($round['rooms'] ?? [] as $r) {
                    foreach ($r['member_ids'] ?? [] as $mid) {
                        $memberIdSet[(int) $mid] = true;
                    }
                }
            }
            $label = '複数Round';
        } else {
            foreach ($payload['rooms'] ?? [] as $r) {
                foreach ($r['member_ids'] ?? [] as $mid) {
                    $memberIdSet[(int) $mid] = true;
                }
            }
            $label = 'BO1/BO2';
        }
        $n = count($memberIdSet);

        return $label . '・割当 ' . $n . '名';
    }
}
