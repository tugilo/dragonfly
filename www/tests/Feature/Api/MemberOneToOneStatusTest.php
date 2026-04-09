<?php

namespace Tests\Feature\Api;

use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET /api/dragonfly/members/one-to-one-status — ONETOONES-P5 / P6.
 * ルートは /dragonfly/members/{id} より前に定義され、数値 id と衝突しない。
 * P6: 要対応日数は config religo.one_to_one_lead_needs_action_days。
 */
class MemberOneToOneStatusTest extends TestCase
{
    use RefreshDatabase;

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        parent::tearDown();
    }

    private function insertMember(string $name, ?string $displayNo = null): int
    {
        return (int) DB::table('members')->insertGetId([
            'name' => $name,
            'name_kana' => null,
            'type' => 'active',
            'display_no' => $displayNo,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function insertCompletedOneToOne(int $ownerId, int $targetId, string $endedAt): void
    {
        DB::table('one_to_ones')->insert([
            'owner_member_id' => $ownerId,
            'target_member_id' => $targetId,
            'status' => 'completed',
            'scheduled_at' => null,
            'started_at' => null,
            'ended_at' => $endedAt,
            'notes' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_requires_owner_member_id(): void
    {
        $this->getJson('/api/dragonfly/members/one-to-one-status')
            ->assertUnprocessable();
    }

    public function test_rejects_invalid_owner_id(): void
    {
        $this->getJson('/api/dragonfly/members/one-to-one-status?owner_member_id=999999')
            ->assertUnprocessable();
    }

    public function test_path_is_not_shadowed_by_members_show(): void
    {
        $owner = $this->insertMember('Owner', '1');
        $target = $this->insertMember('Target', '2');

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        $this->assertCount(1, $data);
        $this->assertSame($target, $data[0]['member_id']);
        $this->assertSame('none', $data[0]['one_to_one_status']);
        $this->assertFalse($data[0]['want_1on1']);
        $this->assertNull($data[0]['category_label']);
    }

    public function test_excludes_guest_and_visitor_from_targets(): void
    {
        $owner = $this->insertMember('Owner', '1');
        $active = $this->insertMember('Active', '2');
        DB::table('members')->insert([
            'name' => 'Guest',
            'name_kana' => null,
            'type' => 'guest',
            'display_no' => 'G1',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('members')->insert([
            'name' => 'Visitor',
            'name_kana' => null,
            'type' => 'visitor',
            'display_no' => 'V1',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $data = $response->json();
        $this->assertCount(1, $data);
        $this->assertSame($active, $data[0]['member_id']);
    }

    public function test_includes_category_label_when_member_has_category(): void
    {
        $owner = $this->insertMember('Owner', '1');
        $catId = (int) DB::table('categories')->insertGetId([
            'group_name' => 'IT',
            'name' => 'Web制作',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $target = $this->insertMember('Target', '2');
        DB::table('members')->where('id', $target)->update(['category_id' => $catId]);

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $this->assertSame('IT / Web制作', $response->json()[0]['category_label']);
    }

    public function test_category_label_collapses_when_group_equals_name(): void
    {
        $owner = $this->insertMember('Owner', '1');
        $catId = (int) DB::table('categories')->insertGetId([
            'group_name' => '士業',
            'name' => '士業',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $target = $this->insertMember('Target', '2');
        DB::table('members')->where('id', $target)->update(['category_id' => $catId]);

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $this->assertSame('士業', $response->json()[0]['category_label']);
    }

    public function test_none_when_only_planned_exists(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-20 12:00:00', 'Asia/Tokyo'));

        $owner = $this->insertMember('Owner', '1');
        $target = $this->insertMember('Target', '2');

        DB::table('one_to_ones')->insert([
            'owner_member_id' => $owner,
            'target_member_id' => $target,
            'status' => 'planned',
            'scheduled_at' => '2026-03-19 10:00:00',
            'started_at' => null,
            'ended_at' => null,
            'notes' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $row = $response->json()[0];
        $this->assertSame('none', $row['one_to_one_status']);
        $this->assertNull($row['last_one_to_one_at']);
    }

    public function test_needs_action_when_last_completed_older_than_30_days(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-20 12:00:00', 'Asia/Tokyo'));

        $owner = $this->insertMember('Owner', '1');
        $target = $this->insertMember('Target', '2');

        // ちょうど 30 日前の同日午後は「まだ ok」になりうるため、明確に 30 日超にする。
        $this->insertCompletedOneToOne($owner, $target, '2026-02-17 15:00:00');

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $row = $response->json()[0];
        $this->assertSame('needs_action', $row['one_to_one_status']);
        $this->assertSame('2026-02-17', $row['last_one_to_one_at']);
    }

    public function test_ok_when_started_within_30_days(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-20 12:00:00', 'Asia/Tokyo'));

        $owner = $this->insertMember('Owner', '1');
        $target = $this->insertMember('Target', '2');

        $this->insertCompletedOneToOne($owner, $target, '2026-03-10 10:00:00');

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $row = $response->json()[0];
        $this->assertSame('ok', $row['one_to_one_status']);
        $this->assertSame('2026-03-10', $row['last_one_to_one_at']);
    }

    public function test_want_1on1_reflected_order_by_display_no(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-20 12:00:00', 'Asia/Tokyo'));

        $owner = $this->insertMember('Owner', '1');
        $tWant = $this->insertMember('Want', '2');
        $tPlain = $this->insertMember('Plain', '3');

        DB::table('dragonfly_contact_flags')->insert([
            'owner_member_id' => $owner,
            'target_member_id' => $tWant,
            'interested' => false,
            'want_1on1' => true,
            'extra_status' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $data = $response->json();
        $this->assertCount(2, $data);
        // 番号昇順: #2 Want → #3 Plain（tier / want では並べ替えない）
        $this->assertSame($tWant, $data[0]['member_id']);
        $this->assertTrue($data[0]['want_1on1']);
        $this->assertSame($tPlain, $data[1]['member_id']);
        $this->assertFalse($data[1]['want_1on1']);
    }

    public function test_order_follows_display_no_not_one_to_one_status_tier(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-20 12:00:00', 'Asia/Tokyo'));

        $owner = $this->insertMember('Owner', '1');
        // display_no は string 型のため、'10' と '2' だと辞書順で逆転する。桁を揃えた番号で「小さい番号が先」を検証する。
        $tLaterNone = $this->insertMember('LaterNone', '09');
        $tEarlyOk = $this->insertMember('EarlyOk', '02');

        $this->insertCompletedOneToOne($owner, $tEarlyOk, '2026-03-15 10:00:00');
        // $tLaterNone: completed なし → none

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $ids = array_column($response->json(), 'member_id');
        $this->assertSame([$tEarlyOk, $tLaterNone], $ids);
    }

    public function test_sorts_by_display_no_asc_even_when_none_after_ok_by_status(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-20 12:00:00', 'Asia/Tokyo'));

        $owner = $this->insertMember('Owner', '1');
        $tNone = $this->insertMember('NoO2o', '2');
        $tOk = $this->insertMember('HasO2o', '3');

        $this->insertCompletedOneToOne($owner, $tOk, '2026-03-15 10:00:00');

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $ids = array_column($response->json(), 'member_id');
        $this->assertSame([$tNone, $tOk], $ids);
    }

    public function test_needs_action_respects_reduced_config_days(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-20 12:00:00', 'Asia/Tokyo'));
        config(['religo.one_to_one_lead_needs_action_days' => 5]);

        $owner = $this->insertMember('Owner', '1');
        $target = $this->insertMember('Target', '2');
        $this->insertCompletedOneToOne($owner, $target, '2026-03-10 10:00:00');

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $this->assertSame('needs_action', $response->json()[0]['one_to_one_status']);
    }

    public function test_ok_when_within_extended_config_days(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-03-20 12:00:00', 'Asia/Tokyo'));
        config(['religo.one_to_one_lead_needs_action_days' => 60]);

        $owner = $this->insertMember('Owner', '1');
        $target = $this->insertMember('Target', '2');
        $this->insertCompletedOneToOne($owner, $target, '2026-02-08 10:00:00');

        $response = $this->getJson("/api/dragonfly/members/one-to-one-status?owner_member_id={$owner}");
        $response->assertOk();
        $this->assertSame('ok', $response->json()[0]['one_to_one_status']);
    }
}
