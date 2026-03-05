<?php

namespace App\Services\Religo;

use App\Models\OneToOne;

/**
 * 1 to 1 一覧取得。GET /api/one-to-ones 用。SSOT: PHASE11B PLAN.
 */
class OneToOneIndexService
{
    /**
     * フィルタ・ソート済みの一覧を取得。owner/target 名を含む。
     *
     * @param  array{workspace_id?: int, owner_member_id?: int, target_member_id?: int, status?: string, from?: string, to?: string}  $filters
     * @return array<int, array<string, mixed>>
     */
    public function getIndex(array $filters = []): array
    {
        $query = OneToOne::query()
            ->with(['ownerMember:id,name', 'targetMember:id,name']);

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
        }
        if (! empty($filters['from'])) {
            $query->whereRaw('COALESCE(started_at, scheduled_at) >= ?', [$filters['from']]);
        }
        if (! empty($filters['to'])) {
            $query->whereRaw('COALESCE(started_at, scheduled_at) <= ?', [$filters['to']]);
        }

        $query->orderByRaw('COALESCE(started_at, scheduled_at) DESC, id DESC');

        $limit = isset($filters['limit']) ? (int) $filters['limit'] : null;
        if ($limit !== null) {
            $query->limit($limit);
        }

        $items = $query->get();

        return $items->map(function (OneToOne $o) {
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
                'created_at' => $o->created_at?->toIso8601String(),
                'updated_at' => $o->updated_at?->toIso8601String(),
                'owner_name' => $o->ownerMember?->name,
                'target_name' => $o->targetMember?->name,
            ];
        })->values()->all();
    }
}
