<?php

namespace Tests\Feature\Api;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

class DragonFlyMembersWorkspaceRegionFilterTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    protected function setUp(): void
    {
        parent::setUp();
        $this->actingAsReligoUser();
    }

    public function test_index_filters_by_workspace_id(): void
    {
        $wsA = (int) DB::table('workspaces')->insertGetId([
            'name' => 'A', 'slug' => 'a', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $wsB = (int) DB::table('workspaces')->insertGetId([
            'name' => 'B', 'slug' => 'b', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $inA = (int) DB::table('members')->insertGetId([
            'name' => 'In A', 'type' => 'active', 'workspace_id' => $wsA, 'created_at' => now(), 'updated_at' => now(),
        ]);
        DB::table('members')->insert([
            'name' => 'In B', 'type' => 'active', 'workspace_id' => $wsB, 'created_at' => now(), 'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/dragonfly/members?workspace_id='.$wsA);
        $res->assertOk();
        $ids = collect($res->json())->pluck('id')->all();
        $this->assertSame([$inA], $ids);
    }

    public function test_index_filters_by_region_id(): void
    {
        $countryId = (int) DB::table('countries')->insertGetId([
            'name' => 'Japan', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $regionId = (int) DB::table('regions')->insertGetId([
            'country_id' => $countryId, 'name' => 'NE', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $wsIn = (int) DB::table('workspaces')->insertGetId([
            'name' => 'InRegion', 'slug' => 'in', 'region_id' => $regionId, 'created_at' => now(), 'updated_at' => now(),
        ]);
        $wsOut = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Out', 'slug' => 'out', 'region_id' => null, 'created_at' => now(), 'updated_at' => now(),
        ]);
        $memberIn = (int) DB::table('members')->insertGetId([
            'name' => 'Region Member', 'type' => 'active', 'workspace_id' => $wsIn, 'created_at' => now(), 'updated_at' => now(),
        ]);
        DB::table('members')->insert([
            'name' => 'Other', 'type' => 'active', 'workspace_id' => $wsOut, 'created_at' => now(), 'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/dragonfly/members?region_id='.$regionId);
        $res->assertOk();
        $ids = collect($res->json())->pluck('id')->all();
        $this->assertSame([$memberIn], $ids);
    }

    public function test_dragonfly_chapter_only_excludes_other_chapter_members(): void
    {
        $dragonflyWs = (int) DB::table('workspaces')->insertGetId([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $otherWs = (int) DB::table('workspaces')->insertGetId([
            'name' => 'DIANA',
            'slug' => 'bni_diana',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $dragonflyMember = (int) DB::table('members')->insertGetId([
            'name' => 'DragonFly Member',
            'type' => 'active',
            'workspace_id' => $dragonflyWs,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $legacyMember = (int) DB::table('members')->insertGetId([
            'name' => 'Legacy DragonFly',
            'type' => 'active',
            'workspace_id' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('members')->insert([
            'name' => 'Other Chapter',
            'type' => 'member',
            'workspace_id' => $otherWs,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/dragonfly/members?dragonfly_chapter_only=1');
        $res->assertOk();
        $ids = collect($res->json())->pluck('id')->sort()->values()->all();
        $this->assertSame([$dragonflyMember, $legacyMember], $ids);
    }
}
