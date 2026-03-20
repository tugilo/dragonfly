<?php

namespace Tests\Feature\Religo;

use App\Models\BoAssignmentAuditLog;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

/**
 * BO-AUDIT-P2: レガシー PUT breakout-assignments の監査と actor / workspace 整合。
 */
class DragonFlyBreakoutAssignmentAuditTest extends TestCase
{
    use RefreshDatabase;

    private int $meetingId;

    private int $meetingNumber = 880;

    private int $memberId;

    private int $participantId;

    private int $roommateParticipantId;

    protected function setUp(): void
    {
        parent::setUp();
        DB::table('workspaces')->insert([
            'name' => 'Audit WS',
            'slug' => 'audit-ws',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => $this->meetingNumber,
            'held_on' => now()->toDateString(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->memberId = (int) DB::table('members')->insertGetId([
            'name' => 'ActorMember',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->participantId = (int) DB::table('participants')->insertGetId([
            'meeting_id' => $this->meetingId,
            'member_id' => $this->memberId,
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $otherMember = (int) DB::table('members')->insertGetId([
            'name' => 'Roomie',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->roommateParticipantId = (int) DB::table('participants')->insertGetId([
            'meeting_id' => $this->meetingId,
            'member_id' => $otherMember,
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('users')->insert([
            'name' => 'AuditUser',
            'email' => 'audit-bo-p2@example.com',
            'password' => Hash::make('password'),
            'owner_member_id' => $this->memberId,
            'remember_token' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_put_creates_audit_row_with_workspace_and_dragonfly_source(): void
    {
        $user = User::query()->where('email', 'audit-bo-p2@example.com')->first();
        $this->assertNotNull($user);
        $this->actingAs($user);

        $wsId = (int) DB::table('workspaces')->orderBy('id')->value('id');

        $res = $this->putJson("/api/dragonfly/meetings/{$this->meetingNumber}/breakout-assignments", [
            'session' => 1,
            'participant_id' => $this->participantId,
            'room_label' => 'TableA',
            'roommate_participant_ids' => [$this->roommateParticipantId],
        ]);
        $res->assertOk();

        $this->assertDatabaseHas('bo_assignment_audit_logs', [
            'meeting_id' => $this->meetingId,
            'actor_user_id' => $user->id,
            'actor_owner_member_id' => $this->memberId,
            'workspace_id' => $wsId,
            'source' => BoAssignmentAuditLog::SOURCE_DRAGONFLY_BREAKOUT_ASSIGNMENTS,
        ]);

        $log = BoAssignmentAuditLog::query()->where('meeting_id', $this->meetingId)->first();
        $this->assertIsArray($log->payload);
        $this->assertSame(1, $log->payload['session']);
        $this->assertSame($this->participantId, $log->payload['participant_id']);
    }

    public function test_put_without_acting_as_uses_fallback_first_user(): void
    {
        $user = User::query()->where('email', 'audit-bo-p2@example.com')->first();
        $res = $this->putJson("/api/dragonfly/meetings/{$this->meetingNumber}/breakout-assignments", [
            'session' => 2,
            'participant_id' => $this->participantId,
            'room_label' => 'TableB',
            'roommate_participant_ids' => [],
        ]);
        $res->assertOk();
        $this->assertDatabaseHas('bo_assignment_audit_logs', [
            'meeting_id' => $this->meetingId,
            'actor_user_id' => $user->id,
            'source' => BoAssignmentAuditLog::SOURCE_DRAGONFLY_BREAKOUT_ASSIGNMENTS,
        ]);
    }

    public function test_delete_does_not_create_audit_row(): void
    {
        $before = BoAssignmentAuditLog::query()->count();
        $res = $this->deleteJson("/api/dragonfly/meetings/{$this->meetingNumber}/breakout-assignments", [
            'session' => 1,
            'participant_id' => $this->participantId,
        ]);
        $res->assertOk();
        $this->assertSame($before, BoAssignmentAuditLog::query()->count());
    }
}
