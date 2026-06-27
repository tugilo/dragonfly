<?php

namespace Tests\Feature\Religo;

use App\Services\Religo\TokyoNeRegionChapterSeedService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class TokyoNeRegionChapterSeedTest extends TestCase
{
    use RefreshDatabase;

    public function test_seed_is_idempotent_and_links_existing_workspaces(): void
    {
        $legacyId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'BNI トレスステラ',
            'slug' => 'bni_trestella',
            'region_id' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $service = new TokyoNeRegionChapterSeedService;
        $first = $service->run();
        $second = $service->run();

        $this->assertSame($first['region_id'], $second['region_id']);
        $this->assertGreaterThan(0, $first['region_id']);

        $updated = DB::table('workspaces')->where('id', $legacyId)->first();
        $this->assertSame('TRES STELLAS', $updated->name);
        $this->assertSame($first['region_id'], (int) $updated->region_id);

        $this->assertSame(25, DB::table('workspaces')->where('region_id', $first['region_id'])->count());
    }

    public function test_non_ne_chapters_get_correct_region_not_tokyo_ne(): void
    {
        $otonaId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'BNI 大人なじみ',
            'slug' => 'bni_otona_najimi',
            'region_id' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $creationsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'BNI クリエーションズ',
            'slug' => 'bni_creations',
            'region_id' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $result = (new TokyoNeRegionChapterSeedService)->run();
        $neRegionId = $result['region_id'];

        $otona = DB::table('workspaces')->where('id', $otonaId)->first();
        $creations = DB::table('workspaces')->where('id', $creationsId)->first();

        $this->assertNotSame($neRegionId, (int) $otona->region_id, '大人なじみは東京NEではない');
        $this->assertNotSame($neRegionId, (int) $creations->region_id, 'クリエーションズは東京NEではない');

        $otonaRegion = DB::table('regions')->where('id', $otona->region_id)->value('name');
        $creationsRegion = DB::table('regions')->where('id', $creations->region_id)->value('name');
        $this->assertSame('BNI 東京南リージョン', $otonaRegion);
        $this->assertSame('BNI 千葉セントラルリージョン', $creationsRegion);
    }

    public function test_known_121_targets_are_assigned_to_verified_regions(): void
    {
        $furuyaId = (int) DB::table('members')->insertGetId([
            'name' => '古屋　周治',
            'type' => 'guest',
            'workspace_id' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $kadomatsuId = (int) DB::table('members')->insertGetId([
            'name' => '門松直幸',
            'type' => 'guest',
            'workspace_id' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $tanabeId = (int) DB::table('members')->insertGetId([
            'name' => '田辺　光',
            'type' => 'guest',
            'workspace_id' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $result = (new TokyoNeRegionChapterSeedService)->run();

        $furuya = DB::table('members')->where('id', $furuyaId)->first();
        $kadomatsu = DB::table('members')->where('id', $kadomatsuId)->first();
        $tanabe = DB::table('members')->where('id', $tanabeId)->first();

        $furuyaWorkspace = DB::table('workspaces')->where('id', $furuya->workspace_id)->first();
        $kadomatsuWorkspace = DB::table('workspaces')->where('id', $kadomatsu->workspace_id)->first();
        $furuyaRegion = DB::table('regions')->where('id', $furuyaWorkspace->region_id)->value('name');
        $kadomatsuRegion = DB::table('regions')->where('id', $kadomatsuWorkspace->region_id)->value('name');

        $this->assertSame('インフィニティ', $furuyaWorkspace->name);
        $this->assertSame('BNI 静岡セントラルリージョン', $furuyaRegion);
        $this->assertSame('EduTech', $kadomatsuWorkspace->name);
        $this->assertSame($result['region_id'], (int) $kadomatsuWorkspace->region_id);
        $this->assertSame('BNI 東京 N.E.リージョン', $kadomatsuRegion);
        $this->assertNull($tanabe->workspace_id, '田辺さんはBNI会員ではないため所属チャプターを付けない');
    }
}
