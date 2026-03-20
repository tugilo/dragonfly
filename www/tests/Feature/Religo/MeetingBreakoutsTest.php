<?php

namespace Tests\Feature\Religo;

use App\Models\BoAssignmentAuditLog;
use App\Models\BreakoutRoom;
use App\Models\DragonflyContactFlag;
use App\Models\Meeting;
use App\Models\Participant;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

/**
 * GET/PUT /api/meetings/{meetingId}/breakouts. Phase10. SSOT: DATA_MODEL §4.5, §4.6.
 */
class MeetingBreakoutsTest extends TestCase
{
    use RefreshDatabase;

    private int $meetingId;
    private int $member1;
    private int $member2;
    private int $member3;

    protected function setUp(): void
    {
        parent::setUp();
        $this->meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 100,
            'held_on' => now()->toDateString(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->member1 = (int) DB::table('members')->insertGetId([
            'name' => 'M1', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->member2 = (int) DB::table('members')->insertGetId([
            'name' => 'M2', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->member3 = (int) DB::table('members')->insertGetId([
            'name' => 'M3', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
    }

    public function test_put_then_get_returns_same_member_ids_and_notes(): void
    {
        $payload = [
            'rooms' => [
                ['room_label' => 'BO1', 'notes' => 'Room 1 memo', 'member_ids' => [$this->member1, $this->member2]],
                ['room_label' => 'BO2', 'notes' => 'Room 2 memo', 'member_ids' => [$this->member3]],
            ],
        ];
        $put = $this->putJson("/api/meetings/{$this->meetingId}/breakouts", $payload);
        $put->assertOk();
        $get = $this->getJson("/api/meetings/{$this->meetingId}/breakouts");
        $get->assertOk();
        $data = $get->json();
        $this->assertCount(2, $data['rooms']);
        $bo1 = collect($data['rooms'])->firstWhere('room_label', 'BO1');
        $bo2 = collect($data['rooms'])->firstWhere('room_label', 'BO2');
        $this->assertNotNull($bo1);
        $this->assertNotNull($bo2);
        $this->assertSame('Room 1 memo', $bo1['notes']);
        $this->assertSame('Room 2 memo', $bo2['notes']);
        sort($bo1['member_ids']);
        sort($bo2['member_ids']);
        $this->assertSame([$this->member1, $this->member2], $bo1['member_ids']);
        $this->assertSame([$this->member3], $bo2['member_ids']);
    }

    /** G11: 同一 member を BO1 と BO2 の両方に入れてよい。 */
    public function test_same_member_in_both_rooms_allowed(): void
    {
        $payload = [
            'rooms' => [
                ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1, $this->member2]],
                ['room_label' => 'BO2', 'notes' => null, 'member_ids' => [$this->member1]],
            ],
        ];
        $res = $this->putJson("/api/meetings/{$this->meetingId}/breakouts", $payload);
        $res->assertOk();
        $get = $this->getJson("/api/meetings/{$this->meetingId}/breakouts");
        $get->assertOk();
        $bo1 = collect($get->json('rooms'))->firstWhere('room_label', 'BO1');
        $bo2 = collect($get->json('rooms'))->firstWhere('room_label', 'BO2');
        $this->assertContains($this->member1, $bo1['member_ids']);
        $this->assertContains($this->member1, $bo2['member_ids']);
    }

    public function test_other_meeting_breakouts_unchanged(): void
    {
        $otherMeetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 101,
            'held_on' => now()->toDateString(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $roomOther = BreakoutRoom::create([
            'meeting_id' => $otherMeetingId,
            'room_label' => 'BO1',
            'sort_order' => 1,
        ]);
        $pOther = Participant::create([
            'meeting_id' => $otherMeetingId,
            'member_id' => $this->member1,
            'type' => 'regular',
        ]);
        DB::table('participant_breakout')->insert([
            'participant_id' => $pOther->id,
            'breakout_room_id' => $roomOther->id,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $payload = [
            'rooms' => [
                ['room_label' => 'BO1', 'notes' => 'Only here', 'member_ids' => [$this->member2]],
                ['room_label' => 'BO2', 'notes' => null, 'member_ids' => [$this->member3]],
            ],
        ];
        $this->putJson("/api/meetings/{$this->meetingId}/breakouts", $payload)->assertOk();

        $this->assertDatabaseHas('participant_breakout', [
            'participant_id' => $pOther->id,
            'breakout_room_id' => $roomOther->id,
        ]);
    }

    public function test_member_without_participant_gets_participant_created_and_assigned(): void
    {
        $this->assertSame(0, Participant::where('meeting_id', $this->meetingId)->count());
        $payload = [
            'rooms' => [
                ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1]],
                ['room_label' => 'BO2', 'notes' => null, 'member_ids' => []],
            ],
        ];
        $this->putJson("/api/meetings/{$this->meetingId}/breakouts", $payload)->assertOk();
        $p = Participant::where('meeting_id', $this->meetingId)->where('member_id', $this->member1)->first();
        $this->assertNotNull($p);
        $this->assertSame('regular', $p->type);
        $get = $this->getJson("/api/meetings/{$this->meetingId}/breakouts");
        $bo1 = collect($get->json('rooms'))->firstWhere('room_label', 'BO1');
        $this->assertSame([$this->member1], $bo1['member_ids']);
    }

    /** BO-AUDIT-P2: breakouts 保存監査に既定 workspace_id が載る */
    public function test_put_breakouts_audit_row_has_workspace_when_workspaces_exist(): void
    {
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W',
            'slug' => 'w',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $payload = [
            'rooms' => [
                ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1]],
                ['room_label' => 'BO2', 'notes' => null, 'member_ids' => []],
            ],
        ];
        $this->putJson("/api/meetings/{$this->meetingId}/breakouts", $payload)->assertOk();
        $log = BoAssignmentAuditLog::query()->where('meeting_id', $this->meetingId)->first();
        $this->assertNotNull($log);
        $this->assertSame($wsId, (int) $log->workspace_id);
    }

    /** BO-AUDIT-P3: owner の contact flag に workspace があれば先頭 workspace より優先 */
    public function test_put_breakouts_audit_workspace_from_owner_flag_when_acting_user_has_owner(): void
    {
        $wsFirst = (int) DB::table('workspaces')->insertGetId([
            'name' => 'First',
            'slug' => 'first',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $wsPreferred = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Preferred',
            'slug' => 'preferred',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $uId = (int) DB::table('users')->insertGetId([
            'name' => 'Op',
            'email' => 'op-bo-p3@example.com',
            'password' => Hash::make('x'),
            'owner_member_id' => $this->member1,
            'remember_token' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DragonflyContactFlag::create([
            'owner_member_id' => $this->member1,
            'target_member_id' => $this->member2,
            'interested' => false,
            'want_1on1' => false,
            'workspace_id' => $wsPreferred,
        ]);
        $this->actingAs(User::find($uId));
        $payload = [
            'rooms' => [
                ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1]],
                ['room_label' => 'BO2', 'notes' => null, 'member_ids' => []],
            ],
        ];
        $this->putJson("/api/meetings/{$this->meetingId}/breakouts", $payload)->assertOk();
        $log = BoAssignmentAuditLog::query()->where('meeting_id', $this->meetingId)->first();
        $this->assertNotNull($log);
        $this->assertSame($wsPreferred, (int) $log->workspace_id);
        $this->assertNotSame($wsFirst, (int) $log->workspace_id);
    }

    /** BO-AUDIT-P4: users.default_workspace_id があれば owner の flag より優先 */
    public function test_put_breakouts_audit_workspace_uses_user_default_workspace_over_owner_flag(): void
    {
        $wsFirst = (int) DB::table('workspaces')->insertGetId([
            'name' => 'First',
            'slug' => 'first-p4',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $wsFromFlag = (int) DB::table('workspaces')->insertGetId([
            'name' => 'FromFlag',
            'slug' => 'from-flag-p4',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $wsDefault = (int) DB::table('workspaces')->insertGetId([
            'name' => 'UserDefault',
            'slug' => 'user-default-p4',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $uId = (int) DB::table('users')->insertGetId([
            'name' => 'Op',
            'email' => 'op-bo-p4@example.com',
            'password' => Hash::make('x'),
            'owner_member_id' => $this->member1,
            'default_workspace_id' => $wsDefault,
            'remember_token' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DragonflyContactFlag::create([
            'owner_member_id' => $this->member1,
            'target_member_id' => $this->member2,
            'interested' => false,
            'want_1on1' => false,
            'workspace_id' => $wsFromFlag,
        ]);
        $this->actingAs(User::find($uId));
        $payload = [
            'rooms' => [
                ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1]],
                ['room_label' => 'BO2', 'notes' => null, 'member_ids' => []],
            ],
        ];
        $this->putJson("/api/meetings/{$this->meetingId}/breakouts", $payload)->assertOk();
        $log = BoAssignmentAuditLog::query()->where('meeting_id', $this->meetingId)->first();
        $this->assertNotNull($log);
        $this->assertSame($wsDefault, (int) $log->workspace_id);
        $this->assertNotSame($wsFromFlag, (int) $log->workspace_id);
        $this->assertNotSame($wsFirst, (int) $log->workspace_id);
    }
}
