<?php

namespace Tests\Feature\Api;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class DragonFlyMemberNcastProfileUrlTest extends TestCase
{
    use RefreshDatabase;

    public function test_put_updates_ncast_profile_url(): void
    {
        $id = (int) DB::table('members')->insertGetId([
            'name' => 'Test Member',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $url = 'https://ncast.example.com/profiles/abc123';

        $res = $this->putJson("/api/dragonfly/members/{$id}", [
            'ncast_profile_url' => $url,
        ]);

        $res->assertOk();
        $res->assertJsonPath('ncast_profile_url', $url);
        $this->assertSame($url, DB::table('members')->where('id', $id)->value('ncast_profile_url'));
    }

    public function test_put_null_clears_ncast_profile_url(): void
    {
        $id = (int) DB::table('members')->insertGetId([
            'name' => 'Test Member',
            'type' => 'active',
            'ncast_profile_url' => 'https://ncast.example.com/old',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->putJson("/api/dragonfly/members/{$id}", [
            'ncast_profile_url' => null,
        ]);

        $res->assertOk();
        $this->assertNull(DB::table('members')->where('id', $id)->value('ncast_profile_url'));
    }

    public function test_index_includes_ncast_profile_url_in_select(): void
    {
        $id = (int) DB::table('members')->insertGetId([
            'name' => 'Listed',
            'type' => 'active',
            'ncast_profile_url' => 'https://ncast.example.com/x',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/dragonfly/members');
        $res->assertOk();
        $rows = $res->json();
        $this->assertIsArray($rows);
        $found = collect($rows)->firstWhere('id', $id);
        $this->assertNotNull($found);
        $this->assertSame('https://ncast.example.com/x', $found['ncast_profile_url']);
    }
}
