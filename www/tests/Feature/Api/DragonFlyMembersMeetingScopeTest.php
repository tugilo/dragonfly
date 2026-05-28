<?php

namespace Tests\Feature\Api;

use App\Models\Participant;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET /api/dragonfly/members?meeting_id= — Connections 左ペイン用スコープ.
 */
class DragonFlyMembersMeetingScopeTest extends TestCase
{
    use RefreshDatabase;

    private int $ownerId;

    private int $meetingId;

    private int $inMeetingId;

    private int $notInMeetingId;

    private int $absentOnlyId;

    private int $proxyAttendeeId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'member', 'display_no' => '1', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 900,
            'held_on' => now()->toDateString(),
            'name' => '第900回',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->inMeetingId = (int) DB::table('members')->insertGetId([
            'name' => 'InMeeting', 'type' => 'member', 'display_no' => '2', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->notInMeetingId = (int) DB::table('members')->insertGetId([
            'name' => 'NotInMeeting', 'type' => 'member', 'display_no' => '3', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->absentOnlyId = (int) DB::table('members')->insertGetId([
            'name' => 'AbsentOnly', 'type' => 'member', 'display_no' => '4', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->proxyAttendeeId = (int) DB::table('members')->insertGetId([
            'name' => 'ProxyPerson', 'type' => 'guest', 'display_no' => 'P1', 'created_at' => now(), 'updated_at' => now(),
        ]);

        Participant::create([
            'meeting_id' => $this->meetingId,
            'member_id' => $this->inMeetingId,
            'type' => 'regular',
        ]);
        Participant::create([
            'meeting_id' => $this->meetingId,
            'member_id' => $this->absentOnlyId,
            'type' => 'absent',
        ]);
        Participant::create([
            'meeting_id' => $this->meetingId,
            'member_id' => $this->proxyAttendeeId,
            'type' => 'proxy',
        ]);
    }

    public function test_meeting_id_filters_to_participants_excluding_absent(): void
    {
        $url = '/api/dragonfly/members?owner_member_id='.$this->ownerId.'&with_summary=1&meeting_id='.$this->meetingId;
        $res = $this->getJson($url);
        $res->assertOk();
        $ids = array_column($res->json(), 'id');
        $this->assertContains($this->inMeetingId, $ids);
        $this->assertContains($this->proxyAttendeeId, $ids);
        $this->assertNotContains($this->notInMeetingId, $ids);
        $this->assertNotContains($this->absentOnlyId, $ids);
    }

    public function test_meeting_id_includes_bo_assignable_and_participant_type(): void
    {
        $url = '/api/dragonfly/members?meeting_id='.$this->meetingId;
        $res = $this->getJson($url);
        $res->assertOk();
        $rows = collect($res->json())->keyBy('id');
        $this->assertTrue($rows[$this->inMeetingId]['bo_assignable']);
        $this->assertSame('regular', $rows[$this->inMeetingId]['participant_type']);
        $this->assertFalse($rows[$this->proxyAttendeeId]['bo_assignable']);
        $this->assertSame('proxy', $rows[$this->proxyAttendeeId]['participant_type']);
    }

    public function test_without_meeting_id_omits_participant_fields(): void
    {
        $res = $this->getJson('/api/dragonfly/members');
        $res->assertOk();
        $first = $res->json()[0];
        $this->assertArrayNotHasKey('participant_type', $first);
        $this->assertArrayNotHasKey('bo_assignable', $first);
    }
}
