<?php

namespace Tests\Feature\Religo;

use App\Models\ContactMemo;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET /api/meetings/{meetingId}/memo, PUT /api/meetings/{meetingId}/memo. Phase M4.
 */
class MeetingMemoControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_show_returns_404_for_unknown_meeting(): void
    {
        $this->getJson('/api/meetings/99999/memo')->assertNotFound();
    }

    public function test_show_returns_null_body_when_no_memo(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 300,
            'held_on' => '2026-04-01',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}/memo");
        $res->assertOk();
        $this->assertSame(['body' => null], $res->json());
    }

    public function test_show_returns_body_when_memo_exists(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 301,
            'held_on' => '2026-04-02',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $memberId = (int) DB::table('members')->insertGetId([
            'name' => 'M', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        ContactMemo::create([
            'owner_member_id' => $memberId,
            'target_member_id' => $memberId,
            'meeting_id' => $meetingId,
            'memo_type' => 'meeting',
            'body' => 'Some memo text',
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}/memo");
        $res->assertOk();
        $this->assertSame('Some memo text', $res->json('body'));
    }

    public function test_update_creates_memo_when_empty(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 302,
            'held_on' => '2026-04-03',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('members')->insert(['id' => 1, 'name' => 'First', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()]);

        $res = $this->putJson("/api/meetings/{$meetingId}/memo", ['body' => 'New body']);
        $res->assertOk();
        $res->assertJson(['body' => 'New body', 'has_memo' => true]);
        $this->assertDatabaseHas('contact_memos', ['meeting_id' => $meetingId, 'memo_type' => 'meeting', 'body' => 'New body']);
    }

    public function test_update_deletes_memo_when_body_empty(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 303,
            'held_on' => '2026-04-04',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $memberId = (int) DB::table('members')->insertGetId([
            'name' => 'M', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        ContactMemo::create([
            'owner_member_id' => $memberId,
            'target_member_id' => $memberId,
            'meeting_id' => $meetingId,
            'memo_type' => 'meeting',
            'body' => 'Existing',
        ]);

        $res = $this->putJson("/api/meetings/{$meetingId}/memo", ['body' => '']);
        $res->assertOk();
        $res->assertJson(['body' => null, 'has_memo' => false]);
        $this->assertDatabaseMissing('contact_memos', ['meeting_id' => $meetingId, 'memo_type' => 'meeting']);
    }

    public function test_update_updates_existing_memo(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 304,
            'held_on' => '2026-04-05',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $memberId = (int) DB::table('members')->insertGetId([
            'name' => 'M', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        ContactMemo::create([
            'owner_member_id' => $memberId,
            'target_member_id' => $memberId,
            'meeting_id' => $meetingId,
            'memo_type' => 'meeting',
            'body' => 'Old',
        ]);

        $res = $this->putJson("/api/meetings/{$meetingId}/memo", ['body' => 'Updated text']);
        $res->assertOk();
        $res->assertJson(['body' => 'Updated text', 'has_memo' => true]);
        $this->assertDatabaseHas('contact_memos', ['meeting_id' => $meetingId, 'body' => 'Updated text']);
    }
}
