<?php

namespace Tests\Feature\Religo;

use App\Models\Meeting;
use App\Models\MeetingMinute;
use App\Models\OneToOne;
use App\Models\OneToOneReferralSuggestion;
use App\Models\OneToOneReferralSuggestionRun;
use App\Models\User;
use App\Models\UserAiCredential;
use App\Services\Religo\ReferralSuggestionDigest;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-015: 121 リファーラル提案 API — Phase 190.
 */
class OneToOneReferralSuggestionTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

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
        $this->user = User::create([
            'name' => 'owner', 'email' => 'owner-ref@example.com', 'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->ownerId, 'default_workspace_id' => $this->workspaceId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
        $this->completed = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'completed',
            'notes' => "| 項目 | 内容 |\n| 紹介（次廣→） | 建設・製造 |\n",
            'started_at' => '2026-06-04 09:00:00',
        ]);
    }

    public function test_generate_requires_ai(): void
    {
        Sanctum::actingAs($this->user);
        $this->postJson("/api/one-to-ones/{$this->completed->id}/referral-suggestions/generate")
            ->assertStatus(422);
    }

    public function test_generate_creates_run_and_suggestions(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'model' => 'gpt-4o-mini', 'is_active' => true,
        ]);

        $json = json_encode([
            'suggestions' => [[
                'direction' => 'owner_to_target',
                'summary' => '建設・製造向けに業務改善を紹介',
                'rationale' => '議事録の紹介表',
                'quality_notes' => [],
                'suggested_from_member_id' => $this->ownerId,
                'suggested_to_member_id' => null,
                'suggested_to_label' => '静岡の建設会社',
                'confidence' => 'medium',
            ]],
        ], JSON_UNESCAPED_UNICODE);

        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => $json]]],
        ], 200)]);

        $res = $this->postJson("/api/one-to-ones/{$this->completed->id}/referral-suggestions/generate")
            ->assertCreated()
            ->assertJsonPath('reused_existing_run', false);

        $this->assertCount(1, $res->json('suggestions'));
        $this->assertDatabaseCount('one_to_one_referral_suggestion_runs', 1);
        $this->assertDatabaseCount('one_to_one_referral_suggestions', 1);
    }

    public function test_same_digest_reuses_run(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);

        $digest = ReferralSuggestionDigest::digest((string) $this->completed->notes);
        $run = OneToOneReferralSuggestionRun::create([
            'one_to_one_id' => $this->completed->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'notes_digest' => $digest,
            'notes_char_count' => 10,
            'generator' => 'ai_openai',
            'created_at' => now(),
        ]);
        OneToOneReferralSuggestion::create([
            'run_id' => $run->id,
            'one_to_one_id' => $this->completed->id,
            'direction' => 'unclear',
            'summary' => 'existing',
            'confidence' => 'low',
            'status' => 'pending',
        ]);

        Http::fake();

        $res = $this->postJson("/api/one-to-ones/{$this->completed->id}/referral-suggestions/generate")
            ->assertCreated()
            ->assertJsonPath('reused_existing_run', true);

        $this->assertSame($run->id, $res->json('run.id'));
        $this->assertDatabaseCount('one_to_one_referral_suggestion_runs', 1);
        Http::assertNothingSent();
    }

    public function test_planned_one_to_one_rejected(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);
        $planned = OneToOne::create([
            'workspace_id' => $this->workspaceId,
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'status' => 'planned',
            'notes' => 'memo',
        ]);

        $this->postJson("/api/one-to-ones/{$planned->id}/referral-suggestions/generate")
            ->assertStatus(422);
    }

    public function test_patch_dismissed(): void
    {
        Sanctum::actingAs($this->user);
        $run = OneToOneReferralSuggestionRun::create([
            'one_to_one_id' => $this->completed->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'notes_digest' => 'abc',
            'notes_char_count' => 1,
            'generator' => 'manual',
            'created_at' => now(),
        ]);
        $suggestion = OneToOneReferralSuggestion::create([
            'run_id' => $run->id,
            'one_to_one_id' => $this->completed->id,
            'direction' => 'unclear',
            'summary' => 'test',
            'confidence' => 'low',
            'status' => 'pending',
        ]);

        $this->patchJson("/api/one-to-one-referral-suggestions/{$suggestion->id}", [
            'status' => 'dismissed',
        ])->assertOk()->assertJsonPath('status', 'dismissed');

        $this->assertNotNull($suggestion->fresh()->dismissed_at);
    }

    public function test_other_owner_forbidden(): void
    {
        $other = User::create([
            'name' => 'x', 'email' => 'x-ref@example.com', 'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->targetId, 'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
        Sanctum::actingAs($other);
        $this->getJson("/api/one-to-ones/{$this->completed->id}/referral-suggestions")
            ->assertStatus(403);
    }

    public function test_list_marks_stale_when_notes_changed(): void
    {
        Sanctum::actingAs($this->user);
        $oldDigest = ReferralSuggestionDigest::digest((string) $this->completed->notes);
        OneToOneReferralSuggestionRun::create([
            'one_to_one_id' => $this->completed->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'notes_digest' => $oldDigest,
            'notes_char_count' => 5,
            'generator' => 'ai_openai',
            'created_at' => now()->subHour(),
        ]);
        $this->completed->update(['notes' => $this->completed->notes."\n更新行"]);

        $this->getJson("/api/one-to-ones/{$this->completed->id}/referral-suggestions")
            ->assertOk()
            ->assertJsonPath('referral_suggestion_stale', true);
    }
}
