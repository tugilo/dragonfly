<?php

namespace Tests\Feature\Religo;

use App\Models\Meeting;
use App\Models\MeetingType;
use App\Support\MeetingDisplay;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class MeetingTypeApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_index_returns_active_meeting_types_sorted(): void
    {
        $res = $this->getJson('/api/meeting-types');
        $res->assertOk();

        $data = $res->json();
        $this->assertIsArray($data);
        $this->assertCount(5, $data);
        $this->assertSame('chapter_weekly', $data[0]['code']);
        $this->assertSame('定例会', $data[0]['name_ja']);
        $this->assertTrue($data[0]['is_numbered']);
        $this->assertFalse($data[0]['requires_team_id']);
        $this->assertTrue($data[0]['supports_participants']);

        $teamType = collect($data)->firstWhere('code', MeetingDisplay::SESSION_TEAM_MEETING);
        $this->assertNotNull($teamType);
        $this->assertTrue($teamType['requires_team_id']);
        $this->assertFalse($teamType['supports_participants']);
        $this->assertFalse($teamType['supports_breakouts']);
        $this->assertFalse($teamType['supports_referral_suggestions']);
    }

    public function test_inactive_meeting_types_are_excluded(): void
    {
        MeetingType::query()->where('code', 'webmaster_meeting')->update(['is_active' => false]);

        $res = $this->getJson('/api/meeting-types');
        $res->assertOk();

        $codes = collect($res->json())->pluck('code')->all();
        $this->assertNotContains('webmaster_meeting', $codes);
        $this->assertCount(4, $codes);
    }
}
