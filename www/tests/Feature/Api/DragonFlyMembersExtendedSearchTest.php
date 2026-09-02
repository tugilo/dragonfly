<?php

namespace Tests\Feature\Api;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

/**
 * GET /api/dragonfly/members — 1to1 他チャプター相手検索用の拡張（SPEC-021 T6 / Phase 302）.
 * q_extended（チャプター名・カテゴリ）・exclude_workspace_id・limit を検証.
 */
class DragonFlyMembersExtendedSearchTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    private int $ownWs;

    private int $otherWs;

    private int $ownMember;

    private int $otherByName;

    private int $otherByCategory;

    private int $noWorkspaceMember;

    protected function setUp(): void
    {
        parent::setUp();

        $this->ownWs = (int) DB::table('workspaces')->insertGetId([
            'name' => 'DragonFly', 'slug' => 'bni_dragonfly', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->otherWs = (int) DB::table('workspaces')->insertGetId([
            'name' => 'DIANA', 'slug' => 'bni_diana', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $webCat = (int) DB::table('categories')->insertGetId([
            'group_name' => 'IT', 'name' => 'Web制作', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $taxCat = (int) DB::table('categories')->insertGetId([
            'group_name' => '士業', 'name' => '税理士', 'created_at' => now(), 'updated_at' => now(),
        ]);

        $this->ownMember = (int) DB::table('members')->insertGetId([
            'name' => '自チャプター 太郎', 'type' => 'active', 'workspace_id' => $this->ownWs, 'category_id' => $webCat,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->otherByName = (int) DB::table('members')->insertGetId([
            'name' => '山田 花子', 'name_kana' => 'やまだ はなこ', 'type' => 'member', 'workspace_id' => $this->otherWs,
            'category_id' => $webCat, 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->otherByCategory = (int) DB::table('members')->insertGetId([
            'name' => '佐藤 次郎', 'type' => 'member', 'workspace_id' => $this->otherWs, 'category_id' => $taxCat,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->noWorkspaceMember = (int) DB::table('members')->insertGetId([
            'name' => '会員外 三郎', 'type' => 'visitor', 'workspace_id' => null, 'category_id' => null,
            'created_at' => now(), 'updated_at' => now(),
        ]);

        $this->actingAsReligoUser($this->ownMember);
    }

    private function ids(string $query): array
    {
        $res = $this->getJson('/api/dragonfly/members?'.$query);
        $res->assertOk();

        return collect($res->json())->pluck('id')->sort()->values()->all();
    }

    public function test_q_without_extended_does_not_match_chapter_or_category(): void
    {
        $this->assertSame([], $this->ids('q=DIANA'));
        $this->assertSame([], $this->ids('q='.rawurlencode('税理士')));
    }

    public function test_q_extended_matches_chapter_name(): void
    {
        $ids = $this->ids('q=DIANA&q_extended=1');
        $this->assertSame([$this->otherByName, $this->otherByCategory], $ids);
    }

    public function test_q_extended_matches_category_name_and_group(): void
    {
        $this->assertSame([$this->otherByCategory], $this->ids('q='.rawurlencode('税理士').'&q_extended=1'));
        $this->assertSame([$this->otherByCategory], $this->ids('q='.rawurlencode('士業').'&q_extended=1'));
        $this->assertSame([$this->ownMember, $this->otherByName], $this->ids('q=Web&q_extended=1'));
    }

    public function test_q_extended_still_matches_name_and_kana(): void
    {
        $this->assertSame([$this->otherByName], $this->ids('q='.rawurlencode('山田').'&q_extended=1'));
        $this->assertSame([$this->otherByName], $this->ids('q='.rawurlencode('やまだ').'&q_extended=1'));
    }

    public function test_exclude_workspace_id_removes_own_chapter_but_keeps_null_workspace(): void
    {
        $ids = $this->ids('exclude_workspace_id='.$this->ownWs);
        $this->assertSame([$this->otherByName, $this->otherByCategory, $this->noWorkspaceMember], $ids);
    }

    public function test_exclude_workspace_id_combined_with_extended_search(): void
    {
        $ids = $this->ids('q=Web&q_extended=1&exclude_workspace_id='.$this->ownWs);
        $this->assertSame([$this->otherByName], $ids);
    }

    public function test_limit_caps_result_count(): void
    {
        $res = $this->getJson('/api/dragonfly/members?limit=2');
        $res->assertOk();
        $this->assertCount(2, $res->json());
    }

    public function test_limit_out_of_range_is_rejected(): void
    {
        $this->getJson('/api/dragonfly/members?limit=0')->assertStatus(422);
        $this->getJson('/api/dragonfly/members?limit=201')->assertStatus(422);
    }

    public function test_exclude_workspace_id_must_exist(): void
    {
        $this->getJson('/api/dragonfly/members?exclude_workspace_id=999999')->assertStatus(422);
    }
}
