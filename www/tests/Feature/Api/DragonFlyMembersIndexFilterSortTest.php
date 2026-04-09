<?php

namespace Tests\Feature\Api;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET /api/dragonfly/members — 検索・フィルタ・ソート (M-3c).
 * IndexDragonFlyMembersRequest と Controller の query 対応を検証.
 */
class DragonFlyMembersIndexFilterSortTest extends TestCase
{
    use RefreshDatabase;

    private int $ownerId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner',
            'name_kana' => 'オーナー',
            'display_no' => '1',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_q_filters_by_name(): void
    {
        DB::table('members')->insert([
            ['name' => 'Alice', 'name_kana' => 'アリス', 'display_no' => '10', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Bob', 'name_kana' => 'ボブ', 'display_no' => '20', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Alice Smith', 'name_kana' => null, 'display_no' => '30', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()],
        ]);

        $response = $this->getJson('/api/dragonfly/members?q=Alice');
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        $names = array_column($data, 'name');
        $this->assertContains('Alice', $names);
        $this->assertContains('Alice Smith', $names);
        $this->assertNotContains('Bob', $names);
        $this->assertCount(2, $data);
    }

    public function test_sort_display_no_asc(): void
    {
        DB::table('members')->insert([
            ['name' => 'Third', 'display_no' => '30', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'First', 'display_no' => '10', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Second', 'display_no' => '20', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()],
        ]);

        $response = $this->getJson('/api/dragonfly/members?sort=display_no&order=asc');
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        $displayNos = array_column($data, 'display_no');
        $this->assertGreaterThanOrEqual(4, count($displayNos));
        $this->assertSame('1', $displayNos[0]);
        $this->assertSame('10', $displayNos[1]);
        $this->assertSame('20', $displayNos[2]);
        $this->assertSame('30', $displayNos[3]);
    }

    /** display_no は文字列カラムのため、単純な辞書順だと 10 が 2 より先になる。数値としてソートする。 */
    public function test_sort_display_no_asc_is_numeric_not_lexicographic(): void
    {
        DB::table('members')->insert([
            ['name' => 'Ten', 'display_no' => '10', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Two', 'display_no' => '2', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()],
        ]);

        $response = $this->getJson('/api/dragonfly/members?sort=display_no&order=asc');
        $response->assertOk();
        $displayNos = array_column($response->json(), 'display_no');
        $idx2 = array_search('2', $displayNos, true);
        $idx10 = array_search('10', $displayNos, true);
        $this->assertNotFalse($idx2);
        $this->assertNotFalse($idx10);
        $this->assertLessThan($idx10, $idx2, '2 must sort before 10');
    }

    public function test_interested_filter_returns_only_members_with_flag(): void
    {
        $target1 = (int) DB::table('members')->insertGetId([
            'name' => 'Target1',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $target2 = (int) DB::table('members')->insertGetId([
            'name' => 'Target2',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        DB::table('dragonfly_contact_flags')->insert([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $target1,
            'interested' => true,
            'want_1on1' => false,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->getJson('/api/dragonfly/members?owner_member_id=' . $this->ownerId . '&interested=1');
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        $ids = array_column($data, 'id');
        $this->assertContains($target1, $ids);
        $this->assertNotContains($target2, $ids);
        $this->assertCount(1, $data);
    }
}
