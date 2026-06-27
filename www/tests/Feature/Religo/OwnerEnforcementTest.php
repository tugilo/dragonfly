<?php

namespace Tests\Feature\Religo;

use App\Models\OneToOne;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

/**
 * SPEC-020 Phase B（順位 3〜4）: owner サーバ固定・route model owner 403・users/me owner 変更制限。
 */
class OwnerEnforcementTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    private int $workspaceId;

    private int $ownerA;

    private int $ownerB;

    private int $targetId;

    private OneToOne $o2oA;

    private OneToOne $o2oB;

    protected function setUp(): void
    {
        parent::setUp();
        $this->workspaceId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'Default',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->ownerA = (int) DB::table('members')->insertGetId([
            'name' => 'Owner A', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->ownerB = (int) DB::table('members')->insertGetId([
            'name' => 'Owner B', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->o2oA = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerA,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-04-01 09:00:00',
            'notes' => 'A note',
        ]);
        $this->o2oB = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerB,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'scheduled_at' => '2026-04-02 09:00:00',
            'notes' => 'B note',
        ]);
    }

    public function test_member_cannot_show_other_owner_one_to_one(): void
    {
        $this->actingAsReligoUser($this->ownerA);
        $this->getJson('/api/one-to-ones/'.$this->o2oB->id)->assertForbidden();
    }

    public function test_member_can_show_own_one_to_one(): void
    {
        $this->actingAsReligoUser($this->ownerA);
        $this->getJson('/api/one-to-ones/'.$this->o2oA->id)->assertOk();
    }

    public function test_member_index_owner_param_mismatch_is_forbidden(): void
    {
        $this->actingAsReligoUser($this->ownerA);
        $this->getJson('/api/one-to-ones?owner_member_id='.$this->ownerB)->assertForbidden();
    }

    public function test_member_index_is_scoped_to_own_owner(): void
    {
        $this->actingAsReligoUser($this->ownerA);
        $res = $this->getJson('/api/one-to-ones');
        $res->assertOk();
        foreach ($res->json('data') ?? $res->json() as $row) {
            if (is_array($row) && array_key_exists('owner_member_id', $row)) {
                $this->assertSame($this->ownerA, (int) $row['owner_member_id']);
            }
        }
    }

    public function test_member_cannot_cancel_other_owner_one_to_one(): void
    {
        $this->actingAsReligoUser($this->ownerA);
        $this->postJson('/api/one-to-ones/'.$this->o2oB->id.'/cancel', [
            'cancel_reason' => 'other',
            'cancel_remark' => 'test remark',
        ])->assertForbidden();
    }

    public function test_chapter_admin_can_query_any_owner(): void
    {
        $this->actingAsReligoUser($this->ownerA, 'admin@example.com', User::RELIGO_ROLE_CHAPTER_ADMIN);
        $this->getJson('/api/one-to-ones?owner_member_id='.$this->ownerB)->assertOk();
        $this->getJson('/api/one-to-ones/'.$this->o2oB->id)->assertOk();
    }

    public function test_member_cannot_change_owner_member_id_once_set(): void
    {
        $this->actingAsReligoUser($this->ownerA);
        $this->patchJson('/api/users/me', ['owner_member_id' => $this->ownerB])
            ->assertForbidden();
    }

    public function test_member_can_set_owner_member_id_first_time(): void
    {
        $user = $this->createReligoUser(null, 'fresh@example.com');
        \Laravel\Sanctum\Sanctum::actingAs($user);
        $this->patchJson('/api/users/me', ['owner_member_id' => $this->ownerA])
            ->assertOk()
            ->assertJsonPath('owner_member_id', $this->ownerA);
    }

    public function test_chapter_admin_can_change_owner_member_id(): void
    {
        $this->actingAsReligoUser($this->ownerA, 'admin@example.com', User::RELIGO_ROLE_CHAPTER_ADMIN);
        $this->patchJson('/api/users/me', ['owner_member_id' => $this->ownerB])
            ->assertOk()
            ->assertJsonPath('owner_member_id', $this->ownerB);
    }

    public function test_member_contact_memos_owner_param_mismatch_is_forbidden(): void
    {
        $this->actingAsReligoUser($this->ownerA);
        $this->getJson('/api/contact-memos?owner_member_id='.$this->ownerB.'&target_member_id='.$this->targetId)
            ->assertForbidden();
    }
}
