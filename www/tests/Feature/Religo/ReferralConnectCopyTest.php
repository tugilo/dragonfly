<?php

namespace Tests\Feature\Religo;

use App\Models\OneToOne;
use App\Models\OneToOneReferralSuggestion;
use App\Models\OneToOneReferralSuggestionRun;
use App\Models\User;
use App\Models\UserAiCredential;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-022: つなぐ準備文案 API — Phase 274.
 */
class ReferralConnectCopyTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

    private int $connectorId;

    private User $user;

    private OneToOneReferralSuggestion $suggestion;

    protected function setUp(): void
    {
        parent::setUp();
        $this->workspaceId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'WS', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'workspace_id' => $this->workspaceId,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'workspace_id' => $this->workspaceId,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->connectorId = (int) DB::table('members')->insertGetId([
            'name' => 'Connector', 'type' => 'active', 'workspace_id' => $this->workspaceId,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $this->user = User::create([
            'name' => 'owner', 'email' => 'owner-connect@example.com', 'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->ownerId, 'default_workspace_id' => $this->workspaceId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);

        $o2o = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'notes' => '紹介希望: 静岡の建設会社',
            'started_at' => '2026-06-04 09:00:00',
        ]);

        $run = OneToOneReferralSuggestionRun::create([
            'one_to_one_id' => $o2o->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'notes_digest' => 'abc',
            'notes_char_count' => 10,
            'generator' => 'manual',
            'created_at' => now(),
        ]);

        $this->suggestion = OneToOneReferralSuggestion::create([
            'run_id' => $run->id,
            'one_to_one_id' => $o2o->id,
            'direction' => 'owner_to_target',
            'summary' => '建設向け紹介',
            'rationale' => '議事録より',
            'suggested_from_member_id' => $this->ownerId,
            'suggested_to_member_id' => null,
            'suggested_to_label' => '静岡の建設会社',
            'confidence' => 'medium',
            'status' => 'pending',
        ]);
    }

    public function test_generate_connect_copy_requires_ai(): void
    {
        Sanctum::actingAs($this->user);

        $this->postJson("/api/one-to-one-referral-suggestions/{$this->suggestion->id}/generate-connect-copy", [
            'party_a_member_id' => $this->ownerId,
            'party_b_label' => '静岡の建設会社',
        ])->assertStatus(422);
    }

    public function test_generate_connect_copy_validates_party_b(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);

        $this->postJson("/api/one-to-one-referral-suggestions/{$this->suggestion->id}/generate-connect-copy", [
            'party_a_member_id' => $this->ownerId,
        ])->assertStatus(422);
    }

    public function test_generate_connect_copy_rejects_same_party(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);

        $this->postJson("/api/one-to-one-referral-suggestions/{$this->suggestion->id}/generate-connect-copy", [
            'party_a_member_id' => $this->ownerId,
            'party_b_member_id' => $this->ownerId,
        ])->assertStatus(422);
    }

    public function test_generate_connect_copy_success_with_label(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'model' => 'gpt-4o-mini', 'is_active' => true,
        ]);

        $json = json_encode([
            'blocks' => [
                ['key' => 'consent_a', 'label' => '了承依頼（A向け）', 'text' => 'Ownerさん、お疲れさまです。グループ作成してよろしいでしょうか？'],
                ['key' => 'consent_b', 'label' => '了承依頼（B向け）', 'text' => '建設会社の方へ。お繋ぎしたいと思っています。'],
                ['key' => 'connector_request', 'label' => 'つなぎ手への紹介依頼', 'text' => '紹介をお願いできますか。'],
            ],
        ], JSON_UNESCAPED_UNICODE);

        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => $json]]],
        ], 200)]);

        $res = $this->postJson("/api/one-to-one-referral-suggestions/{$this->suggestion->id}/generate-connect-copy", [
            'party_a_member_id' => $this->ownerId,
            'party_b_label' => '静岡の建設会社',
            'channel_hint' => 'messenger',
        ])->assertOk()
            ->assertJsonPath('suggestion_id', $this->suggestion->id)
            ->assertJsonPath('party_a_member_id', $this->ownerId)
            ->assertJsonPath('party_b_label', '静岡の建設会社');

        $blocks = $res->json('blocks');
        $this->assertIsArray($blocks);
        $this->assertNotEmpty($blocks);
        $keys = array_column($blocks, 'key');
        $this->assertContains('consent_a', $keys);
        $this->assertContains('consent_b', $keys);
    }

    public function test_generate_connect_copy_success_with_members(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);

        $json = json_encode([
            'blocks' => [
                ['key' => 'consent_a', 'label' => '了承', 'text' => 'A向け'],
                ['key' => 'consent_b', 'label' => '了承', 'text' => 'B向け'],
                ['key' => 'group_opening', 'label' => 'グループ', 'text' => 'お二人にお繋ぎします'],
            ],
        ], JSON_UNESCAPED_UNICODE);

        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => $json]]],
        ], 200)]);

        $this->postJson("/api/one-to-one-referral-suggestions/{$this->suggestion->id}/generate-connect-copy", [
            'party_a_member_id' => $this->ownerId,
            'party_b_member_id' => $this->targetId,
        ])->assertOk()
            ->assertJsonPath('party_b_member_id', $this->targetId)
            ->assertJsonStructure(['blocks', 'meta' => ['model', 'source_o2o_ids', 'generated_at']]);
    }

    public function test_other_owner_forbidden(): void
    {
        $other = User::create([
            'name' => 'x', 'email' => 'x-connect@example.com', 'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->targetId, 'default_workspace_id' => $this->workspaceId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
        Sanctum::actingAs($other);
        UserAiCredential::create([
            'user_id' => $other->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);

        $this->postJson("/api/one-to-one-referral-suggestions/{$this->suggestion->id}/generate-connect-copy", [
            'party_a_member_id' => $this->targetId,
            'party_b_member_id' => $this->ownerId,
        ])->assertStatus(403);
    }
}
