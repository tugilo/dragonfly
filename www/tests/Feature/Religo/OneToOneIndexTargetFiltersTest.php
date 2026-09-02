<?php

namespace Tests\Feature\Religo;

use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

/**
 * GET /api/one-to-ones — 相手（target）側フィルタ（Phase 303・SPEC-006 R2）.
 * target_workspace_id / target_group_name / target_category_id / cross_chapter を index と stats で検証.
 */
class OneToOneIndexTargetFiltersTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    private int $ownWs;

    private int $otherWs;

    private int $ownerId;

    /** 自チャプター・IT/Web制作 */
    private int $sameChapterWeb;

    /** 他チャプター・士業/税理士 */
    private int $otherChapterTax;

    /** workspace NULL（レガシー／会員外）・IT/AI */
    private int $noWorkspaceAi;

    private int $oneSame;

    private int $oneOther;

    private int $oneNoWs;

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
        $aiCat = (int) DB::table('categories')->insertGetId([
            'group_name' => 'IT', 'name' => 'AI業務改善', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $taxCat = (int) DB::table('categories')->insertGetId([
            'group_name' => '士業', 'name' => '税理士', 'created_at' => now(), 'updated_at' => now(),
        ]);

        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'workspace_id' => $this->ownWs,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->sameChapterWeb = (int) DB::table('members')->insertGetId([
            'name' => '同チャプター', 'name_kana' => 'どうちゃぷたー', 'type' => 'active', 'workspace_id' => $this->ownWs,
            'category_id' => $webCat, 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->otherChapterTax = (int) DB::table('members')->insertGetId([
            'name' => '他チャプター', 'type' => 'member', 'workspace_id' => $this->otherWs,
            'category_id' => $taxCat, 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->noWorkspaceAi = (int) DB::table('members')->insertGetId([
            'name' => 'レガシー', 'type' => 'active', 'workspace_id' => null,
            'category_id' => $aiCat, 'created_at' => now(), 'updated_at' => now(),
        ]);

        $this->oneSame = OneToOne::create([
            'workspace_id' => $this->ownWs, 'owner_member_id' => $this->ownerId, 'target_member_id' => $this->sameChapterWeb,
            'status' => 'planned', 'scheduled_at' => '2026-09-10 10:00:00',
        ])->id;
        $this->oneOther = OneToOne::create([
            'workspace_id' => $this->ownWs, 'owner_member_id' => $this->ownerId, 'target_member_id' => $this->otherChapterTax,
            'status' => 'planned', 'scheduled_at' => '2026-09-11 10:00:00',
        ])->id;
        $this->oneNoWs = OneToOne::create([
            'workspace_id' => $this->ownWs, 'owner_member_id' => $this->ownerId, 'target_member_id' => $this->noWorkspaceAi,
            'status' => 'planned', 'scheduled_at' => '2026-09-12 10:00:00',
        ])->id;

        $this->actingAsReligoUser($this->ownerId);
    }

    private function ids(string $query): array
    {
        $res = $this->getJson('/api/one-to-ones?'.$query);
        $res->assertOk();

        return collect($res->json())->pluck('id')->sort()->values()->all();
    }

    public function test_no_target_filter_returns_all(): void
    {
        $this->assertSame([$this->oneSame, $this->oneOther, $this->oneNoWs], $this->ids(''));
    }

    public function test_target_workspace_id_filters_by_partner_chapter(): void
    {
        $this->assertSame([$this->oneOther], $this->ids('target_workspace_id='.$this->otherWs));
        $this->assertSame([$this->oneSame], $this->ids('target_workspace_id='.$this->ownWs));
    }

    public function test_target_group_name_and_category_id_filter_by_partner_category(): void
    {
        $this->assertSame([$this->oneSame, $this->oneNoWs], $this->ids('target_group_name=IT'));
        $this->assertSame([$this->oneOther], $this->ids('target_group_name='.rawurlencode('士業')));

        $webCat = (int) DB::table('members')->where('id', $this->sameChapterWeb)->value('category_id');
        $this->assertSame([$this->oneSame], $this->ids('target_category_id='.$webCat));
    }

    public function test_cross_chapter_true_returns_only_other_chapter_partners(): void
    {
        $this->assertSame([$this->oneOther], $this->ids('cross_chapter=1'));
    }

    public function test_cross_chapter_false_returns_same_chapter_and_null_workspace_partners(): void
    {
        $this->assertSame([$this->oneSame, $this->oneNoWs], $this->ids('cross_chapter=0'));
    }

    public function test_cross_chapter_matches_is_cross_chapter_flag_in_response(): void
    {
        $rows = collect($this->getJson('/api/one-to-ones?cross_chapter=1')->json());
        $this->assertTrue($rows->every(fn ($r) => $r['is_cross_chapter'] === true));

        $rows = collect($this->getJson('/api/one-to-ones?cross_chapter=0')->json());
        $this->assertTrue($rows->every(fn ($r) => $r['is_cross_chapter'] === false));
    }

    public function test_q_matches_partner_name_kana(): void
    {
        $this->assertSame([$this->oneSame], $this->ids('q='.rawurlencode('どうちゃぷ')));
    }

    public function test_filters_combine(): void
    {
        $this->assertSame([$this->oneSame], $this->ids('cross_chapter=0&target_group_name=IT&target_workspace_id='.$this->ownWs));
        $this->assertSame([], $this->ids('cross_chapter=1&target_group_name=IT'));
    }

    public function test_stats_apply_same_target_filters(): void
    {
        $all = $this->getJson('/api/one-to-ones/stats')->assertOk()->json();
        $this->assertSame(3, $all['planned_count']);

        $cross = $this->getJson('/api/one-to-ones/stats?cross_chapter=1')->assertOk()->json();
        $this->assertSame(1, $cross['planned_count']);

        $byWs = $this->getJson('/api/one-to-ones/stats?target_workspace_id='.$this->otherWs)->assertOk()->json();
        $this->assertSame(1, $byWs['planned_count']);

        $byGroup = $this->getJson('/api/one-to-ones/stats?target_group_name=IT')->assertOk()->json();
        $this->assertSame(2, $byGroup['planned_count']);
    }

    public function test_invalid_target_filters_are_rejected(): void
    {
        $this->getJson('/api/one-to-ones?target_workspace_id=999999')->assertStatus(422);
        $this->getJson('/api/one-to-ones?target_category_id=999999')->assertStatus(422);
        $this->getJson('/api/one-to-ones?cross_chapter=maybe')->assertStatus(422);
    }
}
