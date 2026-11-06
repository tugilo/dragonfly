<?php

namespace Tests\Feature\Api;

use App\Models\Member;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

/**
 * Phase 321: members.left_at（退会日）。
 */
class DragonFlyMemberLeftAtTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    protected function setUp(): void
    {
        parent::setUp();
        $this->actingAsReligoUser(null, 'member-left-at-admin@example.com', \App\Models\User::RELIGO_ROLE_CHAPTER_ADMIN);
    }

    private function insertMember(string $name, ?string $leftAt = null): int
    {
        return (int) DB::table('members')->insertGetId([
            'name' => $name,
            'type' => 'member',
            'left_at' => $leftAt,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_put_sets_left_at(): void
    {
        $id = $this->insertMember('退会 太郎');

        $res = $this->putJson("/api/dragonfly/members/{$id}", ['left_at' => '2026-10-07']);

        $res->assertOk();
        $res->assertJsonPath('left_at', '2026-10-07');
        $this->assertSame('2026-10-07', DB::table('members')->where('id', $id)->value('left_at'));
    }

    public function test_put_null_clears_left_at(): void
    {
        $id = $this->insertMember('復帰 花子', '2026-10-07');

        $res = $this->putJson("/api/dragonfly/members/{$id}", ['left_at' => null]);

        $res->assertOk();
        $this->assertNull(DB::table('members')->where('id', $id)->value('left_at'));
    }

    public function test_put_rejects_invalid_left_at(): void
    {
        $id = $this->insertMember('不正 日付');

        $res = $this->putJson("/api/dragonfly/members/{$id}", ['left_at' => '2026/10/07']);

        $res->assertStatus(422);
        $res->assertJsonValidationErrors(['left_at']);
    }

    public function test_index_includes_left_at_and_excludes_left_when_requested(): void
    {
        $active = $this->insertMember('在籍');
        $left = $this->insertMember('退会済み', '2026-01-01');
        $future = $this->insertMember('予約退会', now()->addDays(30)->toDateString());

        $all = $this->getJson('/api/dragonfly/members')->assertOk()->json();
        $ids = collect($all)->pluck('id')->all();
        $this->assertContains($active, $ids);
        $this->assertContains($left, $ids);
        $this->assertSame('2026-01-01', collect($all)->firstWhere('id', $left)['left_at']);
        $this->assertNull(collect($all)->firstWhere('id', $active)['left_at']);

        $filtered = $this->getJson('/api/dragonfly/members?exclude_left=1')->assertOk()->json();
        $filteredIds = collect($filtered)->pluck('id')->all();
        $this->assertContains($active, $filteredIds);
        $this->assertContains($future, $filteredIds, '将来日付の退会予定は在籍扱い');
        $this->assertNotContains($left, $filteredIds);
    }

    public function test_model_is_left_and_scope(): void
    {
        $active = Member::find($this->insertMember('在籍'));
        $left = Member::find($this->insertMember('退会済み', '2026-01-01'));

        $this->assertFalse($active->isLeft());
        $this->assertTrue($left->isLeft());
        $this->assertFalse($left->isLeft('2025-12-31'), '退会日前の時点では在籍');

        $activeIds = Member::query()->activeMembers()->pluck('id')->all();
        $this->assertContains($active->id, $activeIds);
        $this->assertNotContains($left->id, $activeIds);
    }
}
