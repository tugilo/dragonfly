<?php

namespace Tests\Feature\Api;

use App\Services\Religo\TokyoNeRegionChapterSeedService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

class CrossChapterTargetResolveTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    protected function setUp(): void
    {
        parent::setUp();
        $this->actingAsReligoUser();
    }

    public function test_resolve_creates_workspace_and_member_for_manual_chapter(): void
    {
        $seed = (new TokyoNeRegionChapterSeedService)->run();

        $res = $this->postJson('/api/dragonfly/cross-chapter-targets/resolve', [
            'region_id' => $seed['region_id'],
            'workspace_name' => 'BNI Manual Chapter',
            'target_name' => '山田 太郎',
        ]);

        $res->assertOk();
        $res->assertJsonPath('target_name', '山田 太郎');
        $res->assertJsonPath('workspace_name', 'BNI Manual Chapter');
        $res->assertJsonPath('created_member', true);
        $res->assertJsonPath('created_workspace', true);

        $memberId = (int) $res->json('target_member_id');
        $row = DB::table('members')->where('id', $memberId)->first();
        // 他チャプター相手は別チャプターの BNI 会員のため在籍メンバー扱い。
        $this->assertSame('member', $row->type);
        $this->assertSame('山田 太郎', $row->name);
    }

    public function test_resolve_reuses_existing_member_in_workspace(): void
    {
        $seed = (new TokyoNeRegionChapterSeedService)->run();
        $wsId = (int) DB::table('workspaces')->where('slug', 'bni_diana')->value('id');
        $existingId = (int) DB::table('members')->insertGetId([
            'name' => '既存 相手',
            'type' => 'visitor',
            'workspace_id' => $wsId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->postJson('/api/dragonfly/cross-chapter-targets/resolve', [
            'region_id' => $seed['region_id'],
            'workspace_id' => $wsId,
            'target_name' => '既存 相手',
        ]);

        $res->assertOk();
        $res->assertJsonPath('target_member_id', $existingId);
        $res->assertJsonPath('created_member', false);
    }

    public function test_resolve_manual_region_and_chapter(): void
    {
        $res = $this->postJson('/api/dragonfly/cross-chapter-targets/resolve', [
            'region_name' => 'BNI テストリージョン',
            'workspace_name' => 'BNI Test Chapter',
            'target_name' => 'テスト 花子',
        ]);

        $res->assertOk();
        $res->assertJsonPath('region_name', 'BNI テストリージョン');
        $res->assertJsonPath('created_region', true);
        $res->assertJsonPath('created_workspace', true);
    }
}
