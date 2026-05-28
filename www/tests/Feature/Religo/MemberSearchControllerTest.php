<?php

namespace Tests\Feature\Religo;

use App\Models\Member;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * M7-P5: GET /api/members/search — 手動マッチング用 member 検索。
 */
class MemberSearchControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_search_returns_empty_when_q_empty(): void
    {
        $res = $this->getJson('/api/members/search');
        $res->assertOk();
        $res->assertExactJson([]);

        $res2 = $this->getJson('/api/members/search?q=');
        $res2->assertOk();
        $res2->assertExactJson([]);
    }

    public function test_search_returns_members_by_name_partial_match(): void
    {
        (int) DB::table('members')->insertGetId([
            'name' => '山田太郎',
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        (int) DB::table('members')->insertGetId([
            'name' => '山田花子',
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        (int) DB::table('members')->insertGetId([
            'name' => '佐藤一郎',
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/members/search?q=山田');
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        $this->assertCount(2, $data);
        $names = array_column($data, 'name');
        $this->assertContains('山田太郎', $names);
        $this->assertContains('山田花子', $names);
        foreach ($data as $row) {
            $this->assertArrayHasKey('id', $row);
            $this->assertArrayHasKey('name', $row);
        }
    }

    public function test_search_respects_limit(): void
    {
        for ($i = 0; $i < 20; $i++) {
            Member::create(['name' => "Member{$i}", 'type' => 'member']);
        }

        $res = $this->getJson('/api/members/search?q=Member');
        $res->assertOk();
        $data = $res->json();
        $this->assertLessThanOrEqual(15, count($data));
    }
}
