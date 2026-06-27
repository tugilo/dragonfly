<?php

namespace Tests\Feature\Api;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

/**
 * PUT /api/dragonfly/members/{id} — members.email（SPEC-010 / Phase 127）.
 */
class DragonFlyMemberEmailTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    protected function setUp(): void
    {
        parent::setUp();
        $this->actingAsReligoUser(null, 'member-email-admin@example.com', \App\Models\User::RELIGO_ROLE_CHAPTER_ADMIN);
    }

    public function test_put_sets_and_returns_email(): void
    {
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $id = (int) DB::table('members')->insertGetId([
            'name' => 'Taro',
            'name_kana' => 'タロウ',
            'display_no' => '5',
            'type' => 'active',
            'workspace_id' => $wsId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->putJson("/api/dragonfly/members/{$id}", [
            'email' => 'taro@example.com',
        ]);
        $res->assertOk();
        $res->assertJsonPath('email', 'taro@example.com');

        $this->assertSame('taro@example.com', DB::table('members')->where('id', $id)->value('email'));
    }

    public function test_put_rejects_duplicate_email_in_same_workspace(): void
    {
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $id1 = (int) DB::table('members')->insertGetId([
            'name' => 'A',
            'name_kana' => 'エー',
            'display_no' => '1',
            'type' => 'active',
            'workspace_id' => $wsId,
            'email' => 'dup@example.com',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $id2 = (int) DB::table('members')->insertGetId([
            'name' => 'B',
            'name_kana' => 'ビー',
            'display_no' => '2',
            'type' => 'active',
            'workspace_id' => $wsId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->putJson("/api/dragonfly/members/{$id2}", [
            'email' => 'dup@example.com',
        ]);
        $res->assertStatus(422);
    }

    public function test_put_allows_same_email_in_different_workspace(): void
    {
        $ws1 = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W1',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $ws2 = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W2',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $id1 = (int) DB::table('members')->insertGetId([
            'name' => 'A',
            'name_kana' => 'エー',
            'display_no' => '1',
            'type' => 'active',
            'workspace_id' => $ws1,
            'email' => 'shared@example.com',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $id2 = (int) DB::table('members')->insertGetId([
            'name' => 'B',
            'name_kana' => 'ビー',
            'display_no' => '2',
            'type' => 'active',
            'workspace_id' => $ws2,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->putJson("/api/dragonfly/members/{$id2}", [
            'email' => 'shared@example.com',
        ]);
        $res->assertOk();
    }

    public function test_index_includes_email_in_select(): void
    {
        $id = (int) DB::table('members')->insertGetId([
            'name' => 'X',
            'name_kana' => 'エックス',
            'display_no' => '9',
            'type' => 'active',
            'email' => 'x@example.org',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/dragonfly/members');
        $res->assertOk();
        $rows = $res->json();
        $found = collect($rows)->firstWhere('id', $id);
        $this->assertNotNull($found);
        $this->assertSame('x@example.org', $found['email']);
    }
}
