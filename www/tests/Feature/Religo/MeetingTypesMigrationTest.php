<?php

namespace Tests\Feature\Religo;

use App\Models\Meeting;
use App\Models\MeetingType;
use App\Support\MeetingDisplay;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class MeetingTypesMigrationTest extends TestCase
{
    use RefreshDatabase;

    public function test_meeting_types_seeded_with_five_codes(): void
    {
        $this->assertSame(5, MeetingType::query()->count());

        $teamType = MeetingType::query()->where('code', MeetingDisplay::SESSION_TEAM_MEETING)->first();
        $this->assertNotNull($teamType);
        $this->assertTrue($teamType->requires_team_id);
        $this->assertFalse($teamType->supports_participants);
        $this->assertFalse($teamType->supports_breakouts);
        $this->assertFalse($teamType->supports_referral_suggestions);

        $weekly = MeetingType::query()->where('code', MeetingDisplay::SESSION_CHAPTER_WEEKLY)->first();
        $this->assertNotNull($weekly);
        $this->assertTrue($weekly->is_numbered);
        $this->assertTrue($weekly->supports_referral_suggestions);
    }

    public function test_chapter_weekly_meeting_gets_meeting_type_id_on_create(): void
    {
        $weeklyTypeId = MeetingType::query()->where('code', MeetingDisplay::SESSION_CHAPTER_WEEKLY)->value('id');

        $meeting = Meeting::query()->create([
            'number' => 301,
            'meeting_type_id' => $weeklyTypeId,
            'session_type' => MeetingDisplay::SESSION_CHAPTER_WEEKLY,
            'team_id' => '',
            'held_on' => '2026-06-23',
            'name' => '第301回定例会',
        ]);

        $this->assertSame($weeklyTypeId, $meeting->meeting_type_id);
        $this->assertSame('', $meeting->team_id);
        $this->assertTrue($meeting->meetingType->is_numbered);
    }

    public function test_team_meetings_unique_by_type_team_and_date(): void
    {
        $teamTypeId = MeetingType::query()->where('code', MeetingDisplay::SESSION_TEAM_MEETING)->value('id');

        Meeting::query()->create([
            'number' => null,
            'meeting_type_id' => $teamTypeId,
            'session_type' => MeetingDisplay::SESSION_TEAM_MEETING,
            'team_id' => 'threebiz',
            'held_on' => '2026-06-23',
            'name' => 'スリーバイス チームMTG',
        ]);

        $this->expectException(\Illuminate\Database\QueryException::class);

        Meeting::query()->create([
            'number' => null,
            'meeting_type_id' => $teamTypeId,
            'session_type' => MeetingDisplay::SESSION_TEAM_MEETING,
            'team_id' => 'threebiz',
            'held_on' => '2026-06-23',
            'name' => 'duplicate',
        ]);
    }

    public function test_different_teams_same_date_do_not_collide(): void
    {
        $teamTypeId = MeetingType::query()->where('code', MeetingDisplay::SESSION_TEAM_MEETING)->value('id');

        Meeting::query()->create([
            'number' => null,
            'meeting_type_id' => $teamTypeId,
            'session_type' => MeetingDisplay::SESSION_TEAM_MEETING,
            'team_id' => 'threebiz',
            'held_on' => '2026-06-23',
            'name' => 'スリーバイス チームMTG',
        ]);

        $other = Meeting::query()->create([
            'number' => null,
            'meeting_type_id' => $teamTypeId,
            'session_type' => MeetingDisplay::SESSION_TEAM_MEETING,
            'team_id' => 'other',
            'held_on' => '2026-06-23',
            'name' => '別チーム MTG',
        ]);

        $this->assertSame('other', $other->team_id);
        $this->assertSame(2, Meeting::query()
            ->whereDate('held_on', '2026-06-23')
            ->where('meeting_type_id', $teamTypeId)
            ->count());
    }

    public function test_momentum_backfill_uses_momentum_type(): void
    {
        $momentumTypeId = MeetingType::query()->where('code', MeetingDisplay::SESSION_MOMENTUM_TRAINING)->value('id');

        $id = DB::table('meetings')->insertGetId([
            'number' => null,
            'session_type' => MeetingDisplay::SESSION_MOMENTUM_TRAINING,
            'held_on' => '2026-06-16',
            'name' => 'モメンタムトレーニング',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        DB::table('meetings')->where('id', $id)->update([
            'meeting_type_id' => $momentumTypeId,
            'team_id' => '',
        ]);

        $row = Meeting::query()->find($id);
        $this->assertNotNull($row);
        $this->assertSame(MeetingDisplay::SESSION_MOMENTUM_TRAINING, $row->session_type);
        $this->assertSame($momentumTypeId, $row->meeting_type_id);
    }
}
