<?php

namespace App\Services\Religo;

use App\Models\MemberRole;
use Illuminate\Support\Carbon;

/**
 * 役職履歴（member_roles）一覧の取得. Phase15B.
 * フィルタ: role_id, from, to, member_id. ソート: term_start DESC, id DESC.
 */
class MemberRoleIndexService
{
    /**
     * @param  array{role_id?: int, from?: string, to?: string, member_id?: int}  $filters
     * @return array<int, array{id: int, member_id: int, member_name: string, role_id: int, role_name: string, term_start: string|null, term_end: string|null}>
     */
    public function getList(array $filters = []): array
    {
        $query = MemberRole::query()
            ->with(['member:id,name', 'role:id,name'])
            ->orderByDesc('term_start')
            ->orderByDesc('id');

        if (! empty($filters['role_id'])) {
            $query->where('role_id', (int) $filters['role_id']);
        }
        if (! empty($filters['member_id'])) {
            $query->where('member_id', (int) $filters['member_id']);
        }
        if (! empty($filters['from'])) {
            $from = Carbon::parse($filters['from'])->startOfDay();
            $query->where(function ($q) use ($from) {
                $q->where('term_end', '>=', $from)->orWhereNull('term_end');
            });
        }
        if (! empty($filters['to'])) {
            $to = Carbon::parse($filters['to'])->endOfDay();
            $query->where('term_start', '<=', $to);
        }

        $rows = $query->get();

        return $rows->map(fn (MemberRole $mr) => [
            'id' => $mr->id,
            'member_id' => $mr->member_id,
            'member_name' => $mr->member?->name ?? '',
            'role_id' => $mr->role_id,
            'role_name' => $mr->role?->name ?? '',
            'term_start' => $mr->term_start?->format('Y-m-d'),
            'term_end' => $mr->term_end?->format('Y-m-d'),
        ])->values()->all();
    }
}
