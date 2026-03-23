<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\OneToOne;
use Illuminate\Database\Eloquent\Builder;

/**
 * 1 to 1 一覧取得。GET /api/one-to-ones 用。SSOT: PHASE11B PLAN.
 */
class OneToOneIndexService
{
    /**
     * Index / Stats 共通の WHERE。一覧の filter と統計がズレないようにする（ONETOONES-P4）。
     *
     * @param  array{workspace_id?: int, owner_member_id?: int, target_member_id?: int, status?: string, from?: string, to?: string, q?: string, exclude_canceled?: bool|int|string}  $filters
     */
    public function applyIndexFilters(Builder $query, array $filters): void
    {
        if (! empty($filters['workspace_id'])) {
            $query->where('workspace_id', $filters['workspace_id']);
        }
        if (! empty($filters['owner_member_id'])) {
            $query->where('owner_member_id', $filters['owner_member_id']);
        }
        if (! empty($filters['target_member_id'])) {
            $query->where('target_member_id', $filters['target_member_id']);
        }
        if (! empty($filters['status'])) {
            $query->where('status', $filters['status']);
        } elseif ($this->shouldExcludeCanceled($filters)) {
            $query->where('status', '!=', 'canceled');
        }
        if (! empty($filters['from'])) {
            $query->whereRaw('COALESCE(started_at, scheduled_at) >= ?', [$filters['from']]);
        }
        if (! empty($filters['to'])) {
            $query->whereRaw('COALESCE(started_at, scheduled_at) <= ?', [$filters['to']]);
        }
        if (! empty($filters['q']) && is_string($filters['q'])) {
            $term = trim($filters['q']);
            if ($term !== '') {
                $like = '%' . addcslashes($term, '%_\\') . '%';
                $query->where(function ($q) use ($like) {
                    $q->where('notes', 'like', $like)
                        ->orWhereHas('targetMember', function ($mq) use ($like) {
                            $mq->where('name', 'like', $like);
                        });
                });
            }
        }
    }

    /**
     * 一覧の既定: キャンセル行を除く（ONETOONES-DELETE-POLICY-P1）。`status` が明示指定されているときは適用しない。
     */
    private function shouldExcludeCanceled(array $filters): bool
    {
        if (! array_key_exists('exclude_canceled', $filters)) {
            return false;
        }
        $v = $filters['exclude_canceled'];
        if ($v === true || $v === 1 || $v === '1') {
            return true;
        }
        if ($v === false || $v === 0 || $v === '0') {
            return false;
        }
        if (is_string($v)) {
            return filter_var($v, FILTER_VALIDATE_BOOLEAN);
        }

        return false;
    }

    /**
     * フィルタ・ソート済みの一覧を取得。owner/target 名を含む。
     *
     * @param  array{workspace_id?: int, owner_member_id?: int, target_member_id?: int, status?: string, from?: string, to?: string, q?: string, exclude_canceled?: bool|int|string}  $filters
     * @return array<int, array<string, mixed>>
     */
    public function getIndex(array $filters = []): array
    {
        $query = OneToOne::query()
            ->with(['ownerMember:id,name', 'targetMember:id,name', 'meeting:id,number,held_on']);

        $this->applyIndexFilters($query, $filters);

        $query->orderByRaw('COALESCE(started_at, scheduled_at) DESC, id DESC');

        $limit = isset($filters['limit']) ? (int) $filters['limit'] : null;
        if ($limit !== null) {
            $query->limit($limit);
        }

        $items = $query->get();

        return $items->map(fn (OneToOne $o) => $this->formatRecord($o))->values()->all();
    }

    /**
     * 単体レコードを API 一覧行形式に整形（GET/PATCH 応答でも利用）。
     *
     * @return array<string, mixed>
     */
    public function formatRecord(OneToOne $o): array
    {
        $o->loadMissing(['ownerMember:id,name', 'targetMember:id,name', 'meeting:id,number,held_on']);
        $meeting = $o->meeting;

        return [
            'id' => $o->id,
            'workspace_id' => $o->workspace_id,
            'owner_member_id' => $o->owner_member_id,
            'target_member_id' => $o->target_member_id,
            'status' => $o->status,
            'scheduled_at' => $o->scheduled_at?->toIso8601String(),
            'started_at' => $o->started_at?->toIso8601String(),
            'ended_at' => $o->ended_at?->toIso8601String(),
            'notes' => $o->notes,
            'meeting_id' => $o->meeting_id,
            'meeting_number' => $meeting?->number,
            'meeting_held_on' => $meeting?->held_on?->format('Y-m-d'),
            'meeting_label' => $this->formatMeetingLabel($meeting),
            'created_at' => $o->created_at?->toIso8601String(),
            'updated_at' => $o->updated_at?->toIso8601String(),
            'owner_name' => $o->ownerMember?->name,
            'target_name' => $o->targetMember?->name,
        ];
    }

    private function formatMeetingLabel(?Meeting $meeting): ?string
    {
        if ($meeting === null) {
            return null;
        }
        $num = $meeting->number;
        $date = $meeting->held_on?->format('Y-m-d');
        if ($num !== null && $date !== null) {
            return sprintf('#%s — %s', $num, $date);
        }
        if ($num !== null) {
            return sprintf('#%s', $num);
        }
        if ($date !== null) {
            return $date;
        }

        return null;
    }
}
