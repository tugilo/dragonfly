<?php

namespace Tests\Feature\Religo;

use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * 1to1 API のクロスチャプター表示・国/リージョン階層。ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1。
 */
class OneToOneCrossChapterHierarchyTest extends TestCase
{
    use RefreshDatabase;

    public function test_show_includes_target_workspace_and_cross_chapter_flag(): void
    {
        $countryId = (int) DB::table('countries')->insertGetId([
            'name' => '日本',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $regionId = (int) DB::table('regions')->insertGetId([
            'country_id' => $countryId,
            'name' => '東京NEリージョン',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $wsDragon = (int) DB::table('workspaces')->insertGetId([
            'name' => 'DragonFly',
            'slug' => 'df',
            'region_id' => $regionId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $wsOther = (int) DB::table('workspaces')->insertGetId([
            'name' => 'OtherChapter',
            'slug' => 'oc',
            'region_id' => $regionId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner DF',
            'type' => 'active',
            'workspace_id' => $wsDragon,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target Other',
            'type' => 'active',
            'workspace_id' => $wsOther,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $o2o = OneToOne::create([
            'workspace_id' => $wsDragon,
            'owner_member_id' => $ownerId,
            'target_member_id' => $targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-05-01 10:00:00',
            'notes' => null,
        ]);

        $res = $this->getJson('/api/one-to-ones/'.$o2o->id);
        $res->assertOk();
        $res->assertJsonPath('recording_workspace_name', 'DragonFly');
        $res->assertJsonPath('target_workspace_name', 'OtherChapter');
        $res->assertJsonPath('target_region_name', '東京NEリージョン');
        $res->assertJsonPath('target_country_name', '日本');
        $res->assertJsonPath('is_cross_chapter', true);
    }

    public function test_same_chapter_is_not_cross(): void
    {
        $ws = (int) DB::table('workspaces')->insertGetId([
            'name' => 'SameWS',
            'slug' => 's',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'A',
            'type' => 'active',
            'workspace_id' => $ws,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'B',
            'type' => 'active',
            'workspace_id' => $ws,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $o2o = OneToOne::create([
            'workspace_id' => $ws,
            'owner_member_id' => $ownerId,
            'target_member_id' => $targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-05-01 10:00:00',
        ]);

        $res = $this->getJson('/api/one-to-ones/'.$o2o->id);
        $res->assertOk();
        $res->assertJsonPath('is_cross_chapter', false);
    }
}
