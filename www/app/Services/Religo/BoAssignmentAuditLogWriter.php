<?php

namespace App\Services\Religo;

use App\Models\BoAssignmentAuditLog;
use App\Models\Meeting;
use App\Models\User;

/**
 * BO 保存成功後に監査行を1件追加。
 *
 * actor / workspace: same as ReligoActorContext and GET /api/users/me.
 * workspace_id is the acting user's chapter workspace (default_workspace_id primary; see SSOT).
 */
final class BoAssignmentAuditLogWriter
{
    public static function resolveActorUser(): ?User
    {
        return ReligoActorContext::actingUser();
    }

    public static function resolveWorkspaceIdForAudit(?User $actor = null): ?int
    {
        $user = $actor ?? self::resolveActorUser();

        return ReligoActorContext::resolveWorkspaceIdForUser($user);
    }

    /**
     * PUT /api/meetings/{id}/breakouts 成功後.
     *
     * @param  array<int, array{room_label: string, notes?: string|null, member_ids?: array}>  $rooms
     */
    public static function logFromBreakoutsPayload(Meeting $meeting, array $rooms, string $source = BoAssignmentAuditLog::SOURCE_CONNECTIONS_BREAKOUTS, ?User $actor = null): void
    {
        self::createLog($meeting, $source, [
            'rooms' => array_map(static fn (array $r) => [
                'room_label' => $r['room_label'] ?? '',
                'member_ids' => array_values(array_unique(array_map('intval', $r['member_ids'] ?? []))),
                'notes' => $r['notes'] ?? null,
            ], $rooms),
        ], $actor);
    }

    /**
     * PUT /api/meetings/{id}/breakout-rounds 成功後（payload は検証済み rounds[]）.
     *
     * @param  array<int, mixed>  $rounds
     */
    public static function logFromBreakoutRoundsPayload(Meeting $meeting, array $rounds, ?User $actor = null): void
    {
        self::createLog($meeting, BoAssignmentAuditLog::SOURCE_BREAKOUT_ROUNDS, ['rounds' => $rounds], $actor);
    }

    /**
     * PUT /api/dragonfly/meetings/{number}/breakout-assignments 成功後（participant ベース・セション1/2）。
     *
     * DELETE（割当解除）は「保存」イベントと異なるため監査しない（BO-AUDIT-P2）。
     *
     * @param  array<int>  $roommateParticipantIds
     */
    public static function logFromDragonFlyBreakoutAssignment(
        Meeting $meeting,
        int $session,
        int $participantId,
        string $roomLabel,
        array $roommateParticipantIds,
        ?User $actor = null
    ): void {
        self::createLog($meeting, BoAssignmentAuditLog::SOURCE_DRAGONFLY_BREAKOUT_ASSIGNMENTS, [
            'session' => $session,
            'participant_id' => $participantId,
            'room_label' => $roomLabel,
            'roommate_participant_ids' => array_values(array_map('intval', $roommateParticipantIds)),
        ], $actor);
    }

    private static function createLog(Meeting $meeting, string $source, array $payload, ?User $actor = null): void
    {
        $user = $actor ?? self::resolveActorUser();
        BoAssignmentAuditLog::query()->create([
            'meeting_id' => $meeting->id,
            'actor_user_id' => $user?->id,
            'actor_owner_member_id' => $user?->owner_member_id,
            'workspace_id' => self::resolveWorkspaceIdForAudit($user),
            'source' => $source,
            'payload' => $payload,
            'occurred_at' => now(),
        ]);
    }
}
