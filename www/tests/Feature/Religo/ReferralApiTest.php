<?php

namespace Tests\Feature\Religo;

use App\Models\Introduction;
use App\Models\InternalReferral;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

/**
 * SPEC-009: GET/POST/PATCH introductions / internal-referrals.
 */
class ReferralApiTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    private int $ownerId;

    private int $peerA;

    private int $peerB;

    private int $wsId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'workspace_id' => $this->wsId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->peerA = (int) DB::table('members')->insertGetId([
            'name' => 'A',
            'type' => 'active',
            'workspace_id' => $this->wsId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->peerB = (int) DB::table('members')->insertGetId([
            'name' => 'B',
            'type' => 'active',
            'workspace_id' => $this->wsId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        // クロス owner のドメインロジック検証のため chapter_admin として実行（owner 指定可）。
        $this->actingAsReligoUser($this->ownerId, 'referral-admin@example.com', \App\Models\User::RELIGO_ROLE_CHAPTER_ADMIN);
    }

    public function test_introductions_index_returns_empty(): void
    {
        $res = $this->getJson('/api/introductions?owner_member_id='.$this->ownerId);
        $res->assertOk();
        $this->assertSame([], $res->json());
    }

    public function test_introductions_store_sets_external_kind(): void
    {
        $res = $this->postJson('/api/introductions?owner_member_id='.$this->ownerId, [
            'from_member_id' => $this->peerA,
            'to_member_id' => $this->peerB,
            'note' => 'テスト',
        ]);
        $res->assertCreated();
        $data = $res->json();
        $this->assertSame('external', $data['referral_kind']);
        $this->assertSame($this->ownerId, $data['owner_member_id']);
        $this->assertDatabaseHas('introductions', [
            'id' => $data['id'],
            'owner_member_id' => $this->ownerId,
            'referral_kind' => 'external',
        ]);
    }

    public function test_introductions_show_404_for_other_owner(): void
    {
        $other = (int) DB::table('members')->insertGetId([
            'name' => 'Other',
            'type' => 'active',
            'workspace_id' => $this->wsId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $row = Introduction::create([
            'owner_member_id' => $other,
            'from_member_id' => $this->peerA,
            'to_member_id' => $this->peerB,
            'referral_kind' => 'external',
        ]);
        $res = $this->getJson('/api/introductions/'.$row->id.'?owner_member_id='.$this->ownerId);
        $res->assertNotFound();
    }

    public function test_internal_referrals_store_requires_owner_party(): void
    {
        $res = $this->postJson('/api/internal-referrals?owner_member_id='.$this->ownerId, [
            'buyer_member_id' => $this->peerA,
            'seller_member_id' => $this->peerB,
            'summary' => '税理契約',
        ]);
        $res->assertStatus(422);
    }

    public function test_internal_referrals_store_buyer_owner_ok(): void
    {
        $res = $this->postJson('/api/internal-referrals?owner_member_id='.$this->peerA, [
            'buyer_member_id' => $this->peerA,
            'seller_member_id' => $this->peerB,
            'summary' => '税理契約',
            'amount_yen' => 120000,
        ]);
        $res->assertCreated();
        $j = $res->json();
        $this->assertSame($this->peerA, $j['buyer_member_id']);
        $this->assertSame($this->peerB, $j['seller_member_id']);
        $this->assertSame(120000, $j['amount_yen']);
        $this->assertSame((string) $this->wsId, (string) $j['workspace_id']);
    }

    public function test_internal_referrals_rejects_mismatched_workspace(): void
    {
        $ws2 = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W2',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $other = (int) DB::table('members')->insertGetId([
            'name' => 'OtherChap',
            'type' => 'active',
            'workspace_id' => $ws2,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $res = $this->postJson('/api/internal-referrals?owner_member_id='.$this->peerA, [
            'buyer_member_id' => $this->peerA,
            'seller_member_id' => $other,
            'summary' => 'X',
        ]);
        $res->assertStatus(422);
    }

    public function test_internal_referrals_patch_owner_only(): void
    {
        $r = InternalReferral::create([
            'workspace_id' => $this->wsId,
            'owner_member_id' => $this->peerA,
            'buyer_member_id' => $this->peerA,
            'seller_member_id' => $this->peerB,
            'summary' => 'old',
        ]);
        $res = $this->patchJson('/api/internal-referrals/'.$r->id.'?owner_member_id='.$this->peerB, [
            'summary' => 'new',
        ]);
        $res->assertNotFound();
    }
}
