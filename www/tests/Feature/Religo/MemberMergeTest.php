<?php

namespace Tests\Feature\Religo;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

final class MemberMergeTest extends TestCase
{
    use RefreshDatabase;

    private string $token = 'merge-test-token-'.'x';

    protected function setUp(): void
    {
        parent::setUp();
        config(['religo.member_merge_token' => $this->token]);
    }

    public function test_merge_endpoint_hidden_when_token_not_configured(): void
    {
        config(['religo.member_merge_token' => null]);

        $this->postJson('/api/admin/member-merge/preview', [
            'canonical_member_id' => 1,
            'merge_member_id' => 2,
        ], [
            'X-Religo-Member-Merge-Token' => $this->token,
        ])->assertNotFound();
    }

    public function test_preview_rejects_wrong_token(): void
    {
        $this->postJson('/api/admin/member-merge/preview', [
            'canonical_member_id' => 1,
            'merge_member_id' => 2,
        ], [
            'X-Religo-Member-Merge-Token' => 'wrong',
        ])->assertForbidden();
    }

    public function test_preview_blocked_when_same_meeting_participants(): void
    {
        $mid = $this->seedMeeting();
        $canonical = $this->insertMember('Canon');
        $merge = $this->insertMember('MergeDup');
        $this->insertParticipant($mid, $canonical, 'regular');
        $this->insertParticipant($mid, $merge, 'regular');

        $res = $this->postJson('/api/admin/member-merge/preview', [
            'canonical_member_id' => $canonical,
            'merge_member_id' => $merge,
        ], [
            'X-Religo-Member-Merge-Token' => $this->token,
        ]);

        $res->assertOk();
        $data = $res->json();
        $this->assertTrue($data['blocked']);
        $this->assertContains($mid, $data['participant_meeting_overlap']);
    }

    public function test_execute_merges_and_deletes_merge_member(): void
    {
        $m1 = $this->seedMeeting();
        $m2 = $this->seedMeeting();
        $canonical = $this->insertMember('Keep');
        $merge = $this->insertMember('Lose');
        $this->insertParticipant($m1, $canonical, 'regular');
        $this->insertParticipant($m2, $merge, 'visitor');

        $this->postJson('/api/admin/member-merge/execute', [
            'canonical_member_id' => $canonical,
            'merge_member_id' => $merge,
            'confirm_phrase' => "MERGE {$merge} INTO {$canonical}",
        ], [
            'X-Religo-Member-Merge-Token' => $this->token,
        ])->assertOk()->assertJson(['ok' => true]);

        $this->assertDatabaseMissing('members', ['id' => $merge]);
        $this->assertDatabaseHas('participants', [
            'meeting_id' => $m2,
            'member_id' => $canonical,
        ]);
    }

    private function seedMeeting(): int
    {
        return (int) DB::table('meetings')->insertGetId([
            'number' => random_int(9000, 9999),
            'held_on' => now()->toDateString(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function insertMember(string $name): int
    {
        return (int) DB::table('members')->insertGetId([
            'name' => $name,
            'type' => 'member',
            'display_no' => (string) random_int(1, 99),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function insertParticipant(int $meetingId, int $memberId, string $type): void
    {
        DB::table('participants')->insert([
            'meeting_id' => $meetingId,
            'member_id' => $memberId,
            'type' => $type,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
