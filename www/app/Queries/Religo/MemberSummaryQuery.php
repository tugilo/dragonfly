<?php

namespace App\Queries\Religo;

use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Religo メンバー summary-lite バッチ取得用クエリ.
 * SSOT: docs/SSOT/DATA_MODEL.md §5.1（単一チャプター運用時の workspace スコープ）.
 * N+1 を避け一覧用に複数 target を一括取得する.
 *
 * `workspaceId` 非 null のとき、`contact_memos` / `one_to_ones` / `dragonfly_contact_flags` には
 * `(workspace_id = :id OR workspace_id IS NULL)` を適用する（legacy 行を現在チャプターに含める）。
 * `workspaceId` が null のときは workspace 列で絞らない（Dashboard stale 等）。
 */
final class MemberSummaryQuery
{
    private const BODY_SHORT_LEN = 80;

    /**
     * 複数 target に対する summary-lite を一括取得.
     *
     * @param  array<int>  $targetMemberIds
     * @return array<int, array{
     *   same_room_count: int,
     *   one_to_one_count: int,
     *   last_contact_at: string|null,
     *   last_bo_contact_at: string|null,
     *   last_one_to_one_contact_at: string|null,
     *   last_memo_contact_at: string|null,
     *   last_memo: array|null,
     *   interested: bool,
     *   want_1on1: bool
     * }>
     */
    public function getSummaryLiteBatch(int $ownerMemberId, array $targetMemberIds, ?int $workspaceId = null): array
    {
        if ($targetMemberIds === []) {
            return [];
        }

        $useWorkspace = $workspaceId !== null;
        $sameRoom = $this->batchSameRoomCount($ownerMemberId, $targetMemberIds);
        $oneToOneCount = $this->batchOneToOneCount($ownerMemberId, $targetMemberIds, $useWorkspace, $workspaceId);
        $lastMemos = $this->batchLastMemo($ownerMemberId, $targetMemberIds, $useWorkspace, $workspaceId);
        $contactBreakdown = $this->batchContactBreakdown($ownerMemberId, $targetMemberIds, $useWorkspace, $workspaceId);
        $flags = $this->batchFlags($ownerMemberId, $targetMemberIds, $useWorkspace, $workspaceId);

        $result = [];
        foreach ($targetMemberIds as $tid) {
            $memo = $lastMemos[$tid] ?? null;
            $bd = $contactBreakdown[$tid] ?? [
                'last_contact_at' => null,
                'last_bo_contact_at' => null,
                'last_one_to_one_contact_at' => null,
                'last_memo_contact_at' => null,
            ];
            if ($memo !== null && isset($memo['body']) && mb_strlen($memo['body']) > self::BODY_SHORT_LEN) {
                $memo['body_short'] = mb_substr($memo['body'], 0, self::BODY_SHORT_LEN).'…';
            } elseif ($memo !== null) {
                $memo['body_short'] = $memo['body'] ?? '';
            }
            if ($memo !== null) {
                unset($memo['body']);
            }

            $result[$tid] = [
                'same_room_count' => $sameRoom[$tid] ?? 0,
                'one_to_one_count' => $oneToOneCount[$tid] ?? 0,
                'last_contact_at' => $bd['last_contact_at'],
                'last_bo_contact_at' => $bd['last_bo_contact_at'],
                'last_one_to_one_contact_at' => $bd['last_one_to_one_contact_at'],
                'last_memo_contact_at' => $bd['last_memo_contact_at'],
                'last_memo' => $memo,
                'interested' => $flags[$tid]['interested'] ?? false,
                'want_1on1' => $flags[$tid]['want_1on1'] ?? false,
            ];
        }

        return $result;
    }

    /**
     * 単一チャプター運用: workspace 指定時は「= :id OR NULL」で legacy 行を含める（DATA_MODEL §5.1）.
     */
    private function applyWorkspaceScopeForSummary(Builder $q, string $table, bool $useWorkspace, ?int $workspaceId): void
    {
        if (! $useWorkspace || $workspaceId === null || ! Schema::hasColumn($table, 'workspace_id')) {
            return;
        }
        $q->where(function ($w) use ($workspaceId) {
            $w->whereNull('workspace_id')->orWhere('workspace_id', $workspaceId);
        });
    }

    /**
     * @return array<int, int>
     */
    private function batchSameRoomCount(int $ownerMemberId, array $targetMemberIds): array
    {
        $ids = implode(',', array_map('intval', $targetMemberIds));
        $rows = DB::select("
            SELECT pt.member_id AS target_id, COUNT(DISTINCT br.meeting_id) AS cnt
            FROM participant_breakout pbo
            JOIN participants po ON po.id = pbo.participant_id AND po.member_id = ?
            JOIN breakout_rooms br ON br.id = pbo.breakout_room_id
            JOIN participant_breakout pbt ON pbt.breakout_room_id = br.id AND pbt.participant_id != pbo.participant_id
            JOIN participants pt ON pt.id = pbt.participant_id AND pt.member_id IN ({$ids})
            WHERE po.type NOT IN ('absent','proxy') AND pt.type NOT IN ('absent','proxy')
            GROUP BY pt.member_id
        ", [$ownerMemberId]);

        $out = array_fill_keys($targetMemberIds, 0);
        foreach ($rows as $r) {
            $out[(int) $r->target_id] = (int) $r->cnt;
        }

        return $out;
    }

    /**
     * @return array<int, int>
     */
    private function batchOneToOneCount(int $ownerMemberId, array $targetMemberIds, bool $useWorkspace, ?int $workspaceId): array
    {
        $q = DB::table('one_to_ones')
            ->where('owner_member_id', $ownerMemberId)
            ->whereIn('target_member_id', $targetMemberIds)
            ->where('status', 'completed');
        $this->applyWorkspaceScopeForSummary($q, 'one_to_ones', $useWorkspace, $workspaceId);
        $rows = $q->selectRaw('target_member_id, COUNT(*) AS cnt')->groupBy('target_member_id')->get();
        $out = array_fill_keys($targetMemberIds, 0);
        foreach ($rows as $r) {
            $out[(int) $r->target_member_id] = (int) $r->cnt;
        }

        return $out;
    }

    /**
     * @return array<int, array{id: int, memo_type: string, created_at: string, body: string|null}>
     */
    private function batchLastMemo(int $ownerMemberId, array $targetMemberIds, bool $useWorkspace, ?int $workspaceId): array
    {
        $sub = DB::table('contact_memos')
            ->where('owner_member_id', $ownerMemberId)
            ->whereIn('target_member_id', $targetMemberIds);
        $this->applyWorkspaceScopeForSummary($sub, 'contact_memos', $useWorkspace, $workspaceId);
        $sub->orderByDesc('created_at');
        $rows = (clone $sub)->select('id', 'target_member_id', 'memo_type', 'created_at', 'body')
            ->orderByDesc('created_at')
            ->get();
        $byTarget = [];
        foreach ($rows as $r) {
            $tid = (int) $r->target_member_id;
            if (! isset($byTarget[$tid])) {
                $byTarget[$tid] = [
                    'id' => (int) $r->id,
                    'memo_type' => (string) ($r->memo_type ?? 'other'),
                    'created_at' => $r->created_at ? (new \DateTime($r->created_at))->format('c') : '',
                    'body' => $r->body,
                ];
            }
        }

        return $byTarget;
    }

    /**
     * Owner→target ごとに接触チャネル別の最終日時と合成 last_contact_at。
     * BO: participant_breakout 同一ルーム × meetings.held_on（日付は 00:00）。
     * メモ / 1to1: last_contact_at と同一規則（DATA_MODEL §5 · CONTACT_LOGIC_ALIGNMENT）。
     *
     * @return array<int, array{
     *   last_contact_at: string|null,
     *   last_bo_contact_at: string|null,
     *   last_one_to_one_contact_at: string|null,
     *   last_memo_contact_at: string|null
     * }>
     */
    private function batchContactBreakdown(int $ownerMemberId, array $targetMemberIds, bool $useWorkspace, ?int $workspaceId): array
    {
        $boByTarget = [];
        $memoByTarget = [];
        $o2oByTarget = [];
        foreach ($targetMemberIds as $tid) {
            $boByTarget[$tid] = [];
            $memoByTarget[$tid] = [];
            $o2oByTarget[$tid] = [];
        }

        $sameRoomMeetings = DB::table('participant_breakout as pbo')
            ->join('participants as po', 'po.id', '=', 'pbo.participant_id')
            ->join('breakout_rooms as br', 'br.id', '=', 'pbo.breakout_room_id')
            ->join('participant_breakout as pbt', function ($j) {
                $j->on('pbt.breakout_room_id', '=', 'br.id')->whereColumn('pbt.participant_id', '!=', 'pbo.participant_id');
            })
            ->join('participants as pt', 'pt.id', '=', 'pbt.participant_id')
            ->where('po.member_id', $ownerMemberId)
            ->whereIn('pt.member_id', $targetMemberIds)
            ->whereNotIn('po.type', ['absent', 'proxy'])
            ->whereNotIn('pt.type', ['absent', 'proxy'])
            ->select('pt.member_id as target_id', 'br.meeting_id', 'm.held_on')
            ->join('meetings as m', 'm.id', '=', 'br.meeting_id')
            ->whereNotNull('m.held_on')
            ->get();

        foreach ($sameRoomMeetings as $r) {
            $tid = (int) $r->target_id;
            if (isset($boByTarget[$tid])) {
                $boByTarget[$tid][] = (new \DateTime($r->held_on))->setTime(0, 0, 0)->format('c');
            }
        }

        $memos = DB::table('contact_memos')
            ->where('owner_member_id', $ownerMemberId)
            ->whereIn('target_member_id', $targetMemberIds)
            ->whereNotNull('created_at');
        $this->applyWorkspaceScopeForSummary($memos, 'contact_memos', $useWorkspace, $workspaceId);
        foreach ($memos->select('target_member_id', 'created_at')->get() as $r) {
            $tid = (int) $r->target_member_id;
            if (isset($memoByTarget[$tid])) {
                $memoByTarget[$tid][] = (new \DateTime($r->created_at))->format('c');
            }
        }

        $o2o = DB::table('one_to_ones')
            ->where('owner_member_id', $ownerMemberId)
            ->whereIn('target_member_id', $targetMemberIds)
            ->where('status', '!=', 'canceled');
        $this->applyWorkspaceScopeForSummary($o2o, 'one_to_ones', $useWorkspace, $workspaceId);
        foreach ($o2o->select('target_member_id', 'started_at', 'scheduled_at', 'created_at')->get() as $r) {
            $tid = (int) $r->target_member_id;
            if (! isset($o2oByTarget[$tid])) {
                continue;
            }
            $effective = $r->started_at ?? $r->scheduled_at ?? $r->created_at;
            if ($effective !== null && $effective !== '') {
                $o2oByTarget[$tid][] = (new \DateTime($effective))->format('c');
            }
        }

        $out = [];
        foreach ($targetMemberIds as $tid) {
            $lastBo = $this->maxIso8601Contact($boByTarget[$tid]);
            $lastMemo = $this->maxIso8601Contact($memoByTarget[$tid]);
            $lastO2o = $this->maxIso8601Contact($o2oByTarget[$tid]);
            $combined = array_values(array_filter([$lastBo, $lastMemo, $lastO2o], static fn ($v) => $v !== null && $v !== ''));
            $lastContact = null;
            if ($combined !== []) {
                $ts = max(array_map(static fn ($c) => (new \DateTime($c))->getTimestamp(), $combined));
                $lastContact = (new \DateTime)->setTimestamp($ts)->format('c');
            }
            $out[$tid] = [
                'last_contact_at' => $lastContact,
                'last_bo_contact_at' => $lastBo,
                'last_one_to_one_contact_at' => $lastO2o,
                'last_memo_contact_at' => $lastMemo,
            ];
        }

        return $out;
    }

    /**
     * @param  array<int, string>  $isoCandidates
     */
    private function maxIso8601Contact(array $isoCandidates): ?string
    {
        if ($isoCandidates === []) {
            return null;
        }
        $ts = max(array_map(static fn ($c) => (new \DateTime($c))->getTimestamp(), $isoCandidates));

        return (new \DateTime)->setTimestamp($ts)->format('c');
    }

    /**
     * @return array<int, array{interested: bool, want_1on1: bool}>
     */
    private function batchFlags(int $ownerMemberId, array $targetMemberIds, bool $useWorkspace, ?int $workspaceId): array
    {
        $q = DB::table('dragonfly_contact_flags')
            ->where('owner_member_id', $ownerMemberId)
            ->whereIn('target_member_id', $targetMemberIds);
        $this->applyWorkspaceScopeForSummary($q, 'dragonfly_contact_flags', $useWorkspace, $workspaceId);
        $rows = $q->select('target_member_id', 'interested', 'want_1on1')->get();
        $out = [];
        foreach ($targetMemberIds as $tid) {
            $out[$tid] = ['interested' => false, 'want_1on1' => false];
        }
        foreach ($rows as $r) {
            $out[(int) $r->target_member_id] = [
                'interested' => (bool) $r->interested,
                'want_1on1' => (bool) $r->want_1on1,
            ];
        }

        return $out;
    }
}
