<?php

namespace Tests\Feature\Religo;

use App\Models\Meeting;
use App\Models\MeetingMinute;
use App\Models\MeetingReferralSuggestion;
use App\Models\MeetingReferralSuggestionRun;
use App\Models\User;
use App\Models\UserAiCredential;
use App\Services\Religo\ReferralSuggestionDigest;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-016: 定例会リファーラル提案 API — Phase 190.
 */
class MeetingReferralSuggestionTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private User $user;

    private Meeting $meeting;

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
        $this->user = User::create([
            'name' => 'owner', 'email' => 'meet-ref@example.com', 'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->ownerId, 'default_workspace_id' => $this->workspaceId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
        $this->meeting = Meeting::create([
            'number' => 210,
            'held_on' => '2026-06-02',
            'name' => '第210回定例会',
        ]);
        MeetingMinute::create([
            'meeting_id' => $this->meeting->id,
            'body_markdown' => "## メインプレゼン要点\n\n#### 紹介希望先\n- 高級宿の設計会社\n",
            'source_path' => 'docs/test.md',
            'imported_at' => now(),
        ]);
    }

    public function test_generate_without_minutes_fails(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);
        $emptyMeeting = Meeting::create(['number' => 999, 'held_on' => '2026-01-01']);

        $this->postJson("/api/meetings/{$emptyMeeting->id}/referral-suggestions/generate")
            ->assertStatus(422);
    }

    public function test_generate_creates_meeting_suggestions(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);

        $json = json_encode([
            'suggestions' => [[
                'source_section' => 'main_presentation',
                'subject_member_id' => null,
                'direction' => 'subject_seeks_intros',
                'summary' => '高級宿向け設計会社への紹介',
                'rationale' => 'MP 紹介希望先',
                'quality_notes' => [],
                'suggested_from_member_id' => $this->ownerId,
                'suggested_to_member_id' => null,
                'suggested_to_label' => '高級宿設計',
                'confidence' => 'high',
            ]],
        ], JSON_UNESCAPED_UNICODE);

        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => $json]]],
        ], 200)]);

        $this->postJson("/api/meetings/{$this->meeting->id}/referral-suggestions/generate")
            ->assertCreated()
            ->assertJsonPath('suggestions.0.source_section', 'main_presentation');

        $this->assertDatabaseCount('meeting_referral_suggestion_runs', 1);
        $this->assertDatabaseCount('meeting_referral_suggestions', 1);
    }

    public function test_same_body_digest_reuses_run(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);
        $minute = $this->meeting->meetingMinute;
        $digest = ReferralSuggestionDigest::digest((string) $minute->body_markdown);
        $run = MeetingReferralSuggestionRun::create([
            'meeting_id' => $this->meeting->id,
            'meeting_minute_id' => $minute->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'body_digest' => $digest,
            'body_char_count' => 10,
            'generator' => 'ai_openai',
            'created_at' => now(),
        ]);
        MeetingReferralSuggestion::create([
            'run_id' => $run->id,
            'meeting_id' => $this->meeting->id,
            'source_section' => 'other',
            'direction' => 'unclear',
            'summary' => 'cached',
            'confidence' => 'low',
            'status' => 'pending',
        ]);

        Http::fake();

        $this->postJson("/api/meetings/{$this->meeting->id}/referral-suggestions/generate")
            ->assertCreated()
            ->assertJsonPath('reused_existing_run', true);

        $this->assertDatabaseCount('meeting_referral_suggestion_runs', 1);
    }

    public function test_force_regenerate_creates_new_run_with_same_digest(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);
        $minute = $this->meeting->meetingMinute;
        $digest = ReferralSuggestionDigest::digest((string) $minute->body_markdown);
        $run = MeetingReferralSuggestionRun::create([
            'meeting_id' => $this->meeting->id,
            'meeting_minute_id' => $minute->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'body_digest' => $digest,
            'body_char_count' => 10,
            'generator' => 'ai_openai',
            'created_at' => now(),
        ]);
        MeetingReferralSuggestion::create([
            'run_id' => $run->id,
            'meeting_id' => $this->meeting->id,
            'source_section' => 'other',
            'direction' => 'unclear',
            'summary' => 'cached',
            'confidence' => 'low',
            'status' => 'pending',
        ]);

        $json = json_encode([
            'suggestions' => [[
                'source_section' => 'main_presentation',
                'direction' => 'subject_seeks_intros',
                'summary' => 'forced meeting regenerate',
                'rationale' => 'test',
                'quality_notes' => [],
                'suggested_from_member_id' => $this->ownerId,
                'suggested_to_member_id' => null,
                'suggested_to_label' => '新候補',
                'confidence' => 'medium',
            ]],
        ], JSON_UNESCAPED_UNICODE);

        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => $json]]],
        ], 200)]);

        $res = $this->postJson("/api/meetings/{$this->meeting->id}/referral-suggestions/generate", [
            'force' => true,
        ])
            ->assertCreated()
            ->assertJsonPath('reused_existing_run', false);

        $this->assertNotSame($run->id, $res->json('run.id'));
        $this->assertSame('forced meeting regenerate', $res->json('suggestions.0.summary'));
        $this->assertDatabaseCount('meeting_referral_suggestion_runs', 2);
        Http::assertSentCount(1);
    }

    public function test_patch_deferred(): void
    {
        Sanctum::actingAs($this->user);
        $minute = $this->meeting->meetingMinute;
        $run = MeetingReferralSuggestionRun::create([
            'meeting_id' => $this->meeting->id,
            'meeting_minute_id' => $minute->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'body_digest' => 'x',
            'body_char_count' => 1,
            'generator' => 'manual',
            'created_at' => now(),
        ]);
        $suggestion = MeetingReferralSuggestion::create([
            'run_id' => $run->id,
            'meeting_id' => $this->meeting->id,
            'source_section' => 'main_presentation',
            'direction' => 'unclear',
            'summary' => 'test',
            'confidence' => 'low',
            'status' => 'pending',
        ]);

        $this->patchJson("/api/meeting-referral-suggestions/{$suggestion->id}", [
            'status' => 'deferred',
        ])->assertOk()->assertJsonPath('status', 'deferred');
    }

    public function test_register_introduction_sets_meeting_id(): void
    {
        Sanctum::actingAs($this->user);
        $toId = (int) DB::table('members')->insertGetId([
            'name' => 'ToMember', 'type' => 'active', 'workspace_id' => $this->workspaceId,
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $minute = $this->meeting->meetingMinute;
        $run = MeetingReferralSuggestionRun::create([
            'meeting_id' => $this->meeting->id,
            'meeting_minute_id' => $minute->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'body_digest' => 'abc',
            'body_char_count' => 1,
            'generator' => 'manual',
            'created_at' => now(),
        ]);
        $suggestion = MeetingReferralSuggestion::create([
            'run_id' => $run->id,
            'meeting_id' => $this->meeting->id,
            'source_section' => 'main_presentation',
            'direction' => 'subject_seeks_intros',
            'summary' => '高級宿向け',
            'suggested_from_member_id' => $this->ownerId,
            'suggested_to_member_id' => $toId,
            'confidence' => 'high',
            'status' => 'pending',
        ]);

        $res = $this->postJson("/api/meeting-referral-suggestions/{$suggestion->id}/register-introduction", [
            'from_member_id' => $this->ownerId,
            'to_member_id' => $toId,
        ])->assertCreated();

        $this->assertSame($this->meeting->id, $res->json('introduction.meeting_id'));
        $this->assertDatabaseHas('introductions', [
            'id' => $res->json('introduction.id'),
            'meeting_id' => $this->meeting->id,
        ]);
    }

    public function test_meetings_index_includes_stale_flag(): void
    {
        Sanctum::actingAs($this->user);
        $minute = $this->meeting->meetingMinute;
        $body = (string) $minute->body_markdown;
        MeetingReferralSuggestionRun::create([
            'meeting_id' => $this->meeting->id,
            'meeting_minute_id' => $minute->id,
            'owner_member_id' => $this->ownerId,
            'workspace_id' => $this->workspaceId,
            'body_digest' => ReferralSuggestionDigest::digest($body),
            'body_char_count' => 10,
            'generator' => 'manual',
            'created_at' => now(),
        ]);
        $minute->update(['body_markdown' => $body . "\n\n追記"]);

        $row = collect($this->getJson('/api/meetings')->json())->firstWhere('id', $this->meeting->id);
        $this->assertNotNull($row);
        $this->assertTrue($row['referral_suggestion_stale']);
    }
}
