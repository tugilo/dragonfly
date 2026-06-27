<?php

namespace Tests\Feature\Api;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

class RegionApiTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    protected function setUp(): void
    {
        parent::setUp();
        $this->actingAsReligoUser();
    }

    public function test_regions_index_returns_country(): void
    {
        $countryId = (int) DB::table('countries')->insertGetId([
            'name' => 'Japan', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $regionId = (int) DB::table('regions')->insertGetId([
            'country_id' => $countryId,
            'name' => 'BNI 東京 N.E.リージョン',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/regions');
        $res->assertOk();
        $res->assertJsonFragment([
            'id' => $regionId,
            'name' => 'BNI 東京 N.E.リージョン',
            'country_name' => 'Japan',
        ]);
    }
}
