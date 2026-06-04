<?php

namespace Tests\Feature\Religo;

use App\Models\MemberReferralCorpusSetting;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ReferralCorpusSettingsTest extends TestCase
{
    use RefreshDatabase;

    private int $ownerId;

    private int $peerId;

    private User $user;

    protected function setUp(): void
    {
        parent::setUp();
        $wsId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'WS', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'workspace_id' => $wsId,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->peerId = (int) DB::table('members')->insertGetId([
            'name' => 'Peer', 'type' => 'active', 'workspace_id' => $wsId,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->user = User::create([
            'name' => 'owner',
            'email' => 'corpus-owner@example.com',
            'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->ownerId,
            'default_workspace_id' => $wsId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
    }

    public function test_show_defaults_to_opt_out(): void
    {
        Sanctum::actingAs($this->user);

        $this->getJson('/api/referral-corpus-settings')
            ->assertOk()
            ->assertJsonPath('allow_cross_corpus_contribution', false)
            ->assertJsonPath('consented_peer_count', 0);

        $this->assertDatabaseHas('member_referral_corpus_settings', [
            'member_id' => $this->ownerId,
            'allow_cross_corpus_contribution' => 0,
        ]);
    }

    public function test_patch_enables_contribution_and_counts_peers(): void
    {
        MemberReferralCorpusSetting::create([
            'member_id' => $this->peerId,
            'allow_cross_corpus_contribution' => true,
        ]);

        Sanctum::actingAs($this->user);

        $this->patchJson('/api/referral-corpus-settings', [
            'allow_cross_corpus_contribution' => true,
        ])
            ->assertOk()
            ->assertJsonPath('allow_cross_corpus_contribution', true)
            ->assertJsonPath('consented_peer_count', 1);
    }
}
