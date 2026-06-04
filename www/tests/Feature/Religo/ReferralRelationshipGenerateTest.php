<?php

namespace Tests\Feature\Religo;

use App\Models\Introduction;
use App\Models\Meeting;
use App\Models\MeetingMinute;
use App\Models\MemberReferralCorpusSetting;
use App\Models\OneToOne;
use App\Models\Participant;
use App\Models\OneToOneReferralSuggestion;
use App\Models\User;
use App\Models\UserAiCredential;
use App\Services\Religo\ReferralRelationshipContextBuilder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Phase 195: relationship 生成・同意フィルタ・つなぎ手登録。
 */
class ReferralRelationshipGenerateTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

    private int $connectorId;

    private User $user;

    private OneToOne $completed;

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
            'name' => 'owner',
            'email' => 'rel-rel@example.com',
            'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->ownerId,
            'default_workspace_id' => $this->workspaceId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
        $this->completed = OneToOne::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'workspace_id' => $this->workspaceId,
            'status' => 'completed',
            'notes' => "相手は物流の紹介を希望。\n",
            'started_at' => now(),
        ]);
    }

    public function test_peer_o2o_excluded_when_contribution_off(): void
    {
        $unrelatedId = (int) DB::table('members')->insertGetId([
            'name' => 'Unrelated', 'type' => 'active', 'workspace_id' => $this->workspaceId,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        OneToOne::create([
            'owner_member_id' => $this->connectorId,
            'target_member_id' => $unrelatedId,
            'workspace_id' => $this->workspaceId,
            'status' => 'completed',
            'notes' => 'SECRET_PEER_NOTES',
            'started_at' => now()->subDay(),
        ]);

        $builder = app(ReferralRelationshipContextBuilder::class);
        $pack = $builder->buildForOneToOne($this->completed, $this->ownerId);

        $this->assertStringNotContainsString('SECRET_PEER_NOTES', $pack['prompt_text']);
        $this->assertSame(0, $pack['meta']['consented_owner_count']);
    }

    public function test_peer_o2o_included_when_contribution_on(): void
    {
        MemberReferralCorpusSetting::create([
            'member_id' => $this->connectorId,
            'workspace_id' => $this->workspaceId,
            'allow_cross_corpus_contribution' => true,
        ]);

        OneToOne::create([
            'owner_member_id' => $this->connectorId,
            'target_member_id' => $this->targetId,
            'workspace_id' => $this->workspaceId,
            'status' => 'completed',
            'notes' => 'VISIBLE_PEER_NOTES',
            'started_at' => now()->subDay(),
        ]);

        $builder = app(ReferralRelationshipContextBuilder::class);
        $pack = $builder->buildForOneToOne($this->completed, $this->ownerId);

        $this->assertStringContainsString('VISIBLE_PEER_NOTES', $pack['prompt_text']);
        $this->assertGreaterThanOrEqual(1, $pack['meta']['consented_owner_count']);
    }

    public function test_relationship_generate_persists_via_connector_suggestion(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id,
            'ai_enabled' => true,
            'provider' => 'openai',
            'api_key' => 'sk-test',
            'is_active' => true,
        ]);

        Http::fake([
            'api.openai.com/*' => Http::response([
                'choices' => [[
                    'message' => [
                        'content' => json_encode([
                            'suggestions' => [[
                                'direction' => 'via_connector',
                                'corpus_source' => 'member_network',
                                'summary' => 'つなぎ手経由の候補',
                                'rationale' => '121 #99',
                                'connector_member_id' => $this->connectorId,
                                'suggested_to_member_id' => $this->ownerId,
                                'suggested_contact_label' => '紹介先B',
                                'confidence' => 'medium',
                            ]],
                        ], JSON_UNESCAPED_UNICODE),
                    ],
                ]],
            ], 200),
        ]);

        $this->postJson("/api/one-to-ones/{$this->completed->id}/referral-suggestions/generate", [
            'context_mode' => 'relationship',
        ])
            ->assertCreated()
            ->assertJsonPath('run.context_mode', 'relationship');

        $this->assertDatabaseHas('one_to_one_referral_suggestions', [
            'one_to_one_id' => $this->completed->id,
            'direction' => 'via_connector',
            'corpus_source' => 'member_network',
            'suggested_from_member_id' => $this->connectorId,
            'suggested_to_member_id' => $this->ownerId,
        ]);
    }

    public function test_pack_includes_introductions_and_subject_meetings_only(): void
    {
        $otherMemberId = (int) DB::table('members')->insertGetId([
            'name' => 'Other', 'type' => 'active', 'workspace_id' => $this->workspaceId,
            'created_at' => now(), 'updated_at' => now(),
        ]);

        Introduction::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'from_member_id' => $this->ownerId,
            'to_member_id' => $this->targetId,
            'referral_kind' => 'external',
            'introduced_at' => '2026-05-01',
            'note' => '既紹介メモ',
        ]);

        $relatedMeeting = Meeting::create(['number' => 100, 'held_on' => '2026-05-01', 'name' => '関連回']);
        MeetingMinute::create([
            'meeting_id' => $relatedMeeting->id,
            'body_markdown' => '主役が参加した回の MP',
            'source_path' => 't.md',
            'imported_at' => now(),
        ]);
        Participant::create(['meeting_id' => $relatedMeeting->id, 'member_id' => $this->targetId, 'type' => 'member']);

        $unrelatedMeeting = Meeting::create(['number' => 99, 'held_on' => '2026-04-01', 'name' => '無関係回']);
        MeetingMinute::create([
            'meeting_id' => $unrelatedMeeting->id,
            'body_markdown' => '主役不参加',
            'source_path' => 'u.md',
            'imported_at' => now(),
        ]);
        Participant::create(['meeting_id' => $unrelatedMeeting->id, 'member_id' => $otherMemberId, 'type' => 'member']);

        $builder = app(ReferralRelationshipContextBuilder::class);
        $pack = $builder->buildForOneToOne($this->completed, $this->ownerId);

        $this->assertStringContainsString('既知の紹介履歴', $pack['prompt_text']);
        $this->assertStringContainsString('intro #', $pack['prompt_text']);
        $this->assertStringContainsString('主役が参加した定例会', $pack['prompt_text']);
        $this->assertStringContainsString('主役が参加した回の MP', $pack['prompt_text']);
        $this->assertStringNotContainsString('主役不参加', $pack['prompt_text']);
        $this->assertGreaterThanOrEqual(1, $pack['meta']['introduction_count']);
    }

    public function test_register_via_connector_defaults_from_connector_to_requester(): void
    {
        Sanctum::actingAs($this->user);
        $runId = (int) DB::table('one_to_one_referral_suggestion_runs')->insertGetId([
            'one_to_one_id' => $this->completed->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'notes_digest' => 'x',
            'notes_char_count' => 1,
            'context_mode' => 'relationship',
            'context_digest' => 'y',
            'generator' => 'manual',
            'created_at' => now(),
        ]);
        $suggestionId = (int) DB::table('one_to_one_referral_suggestions')->insertGetId([
            'run_id' => $runId,
            'one_to_one_id' => $this->completed->id,
            'direction' => 'via_connector',
            'corpus_source' => 'member_network',
            'summary' => '経由紹介',
            'suggested_from_member_id' => $this->connectorId,
            'suggested_to_member_id' => $this->ownerId,
            'suggested_contact_label' => 'Contact B',
            'confidence' => 'medium',
            'status' => 'pending',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->postJson("/api/one-to-one-referral-suggestions/{$suggestionId}/register-introduction", [
            'from_member_id' => $this->connectorId,
            'to_member_id' => $this->ownerId,
        ])->assertCreated();

        $this->assertDatabaseHas('introductions', [
            'from_member_id' => $this->connectorId,
            'to_member_id' => $this->ownerId,
            'owner_member_id' => $this->ownerId,
        ]);

        $suggestion = OneToOneReferralSuggestion::find($suggestionId);
        $this->assertNotNull($suggestion->introduction_id);
    }
}
