<?php

namespace App\Services\Religo;

use App\Models\BoAssignmentAuditLog;
use App\Models\Meeting;
use App\Models\User;

/**
 * BO 保存成功後に監査行を1件追加。認証は現行どおり user id 1 固定（UserController 同様）。
 */
final class BoAssignmentAuditLogWriter
{
    private const DEFAULT_ACTOR_USER_ID = 1;

    /**
     * PUT /api/meetings/{id}/breakouts 成功後.
     *
     * @param  array<int, array{room_label: string, notes?: string|null, member_ids?: array}>  $rooms
     */
    public static function logFromBreakoutsPayload(Meeting $meeting, array $rooms, string $source = BoAssignmentAuditLog::SOURCE_CONNECTIONS_BREAKOUTS): void
    {
        $user = User::find(self::DEFAULT_ACTOR_USER_ID);
        BoAssignmentAuditLog::query()->create([
            'meeting_id' => $meeting->id,
            'actor_user_id' => $user?->id,
            'actor_owner_member_id' => $user?->owner_member_id,
            'workspace_id' => null,
            'source' => $source,
            'payload' => [
                'rooms' => array_map(static fn (array $r) => [
                    'room_label' => $r['room_label'] ?? '',
                    'member_ids' => array_values(array_unique(array_map('intval', $r['member_ids'] ?? []))),
                    'notes' => $r['notes'] ?? null,
                ], $rooms),
            ],
            'occurred_at' => now(),
        ]);
    }

    /**
     * PUT /api/meetings/{id}/breakout-rounds 成功後（payload は検証済み rounds[]）.
     *
     * @param  array<int, mixed>  $rounds
     */
    public static function logFromBreakoutRoundsPayload(Meeting $meeting, array $rounds): void
    {
        $user = User::find(self::DEFAULT_ACTOR_USER_ID);
        BoAssignmentAuditLog::query()->create([
            'meeting_id' => $meeting->id,
            'actor_user_id' => $user?->id,
            'actor_owner_member_id' => $user?->owner_member_id,
            'workspace_id' => null,
            'source' => BoAssignmentAuditLog::SOURCE_BREAKOUT_ROUNDS,
            'payload' => ['rounds' => $rounds],
            'occurred_at' => now(),
        ]);
    }
}
