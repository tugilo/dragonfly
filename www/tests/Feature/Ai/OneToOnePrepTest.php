<?php

namespace Tests\Feature\Ai;

use App\Models\ContactMemo;
use App\Models\OneToOne;
use App\Models\OneToOneAttachment;
use App\Models\User;
use App\Models\UserAiCredential;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-013: 1to1 事前準備（添付・URL 取込・AI 原稿生成）。OpenAI は Http::fake。
 */
class OneToOnePrepTest extends TestCase
{
    use RefreshDatabase;

    private int $workspaceId;

    private int $ownerId;

    private int $targetId;

    private User $user;

    private OneToOne $o2o;

    protected function setUp(): void
    {
        parent::setUp();
        $this->workspaceId = (int) DB::table('workspaces')->insertGetId(['name' => 'WS', 'created_at' => now(), 'updated_at' => now()]);
        $this->ownerId = (int) DB::table('members')->insertGetId(['name' => 'Owner', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()]);
        $this->targetId = (int) DB::table('members')->insertGetId(['name' => 'Furuya', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()]);
        $this->user = User::create([
            'name' => 'owner', 'email' => 'owner@example.com', 'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->ownerId, 'default_workspace_id' => $this->workspaceId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
        $this->o2o = OneToOne::create([
            'workspace_id' => $this->workspaceId, 'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId, 'status' => 'planned', 'scheduled_at' => '2026-06-01 10:00:00',
        ]);
    }

    public function test_url_attachment_extracts_text(): void
    {
        Sanctum::actingAs($this->user);
        Http::fake(['*' => Http::response('<html><body><h1>GAINS</h1><p>携帯回線 専門</p></body></html>', 200)]);

        $this->postJson("/api/one-to-ones/{$this->o2o->id}/attachments/url", ['url' => 'https://ncas.example/p'])
            ->assertCreated()
            ->assertJsonPath('source_type', 'url')
            ->assertJsonPath('has_text', true);

        $this->assertStringContainsString('携帯回線', (string) OneToOneAttachment::first()->extracted_text);
    }

    public function test_generate_requires_ai_setup(): void
    {
        Sanctum::actingAs($this->user);
        $this->postJson("/api/one-to-ones/{$this->o2o->id}/prep/generate", [])
            ->assertStatus(422); // AI 未設定
    }

    public function test_generate_with_openai_fake_and_save_to_notes(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'model' => 'gpt-4o-mini', 'is_active' => true,
        ]);
        OneToOneAttachment::create([
            'one_to_one_id' => $this->o2o->id, 'source_type' => 'text',
            'extracted_text' => '古屋さんは携帯回線と害虫ブロック、不動産の三本柱。守成クラブ静岡代表。',
        ]);

        Http::fake([
            'api.openai.com/*' => Http::response([
                'choices' => [['message' => ['content' => "## 基本プロフィール\n- 携帯回線\n（AI 下書き・要校正）"]]],
            ], 200),
        ]);

        $res = $this->postJson("/api/one-to-ones/{$this->o2o->id}/prep/generate", ['save_to' => 'notes'])
            ->assertOk()
            ->assertJsonPath('saved_to', 'notes');
        $this->assertStringContainsString('基本プロフィール', $res->json('draft'));
        $this->assertStringContainsString('基本プロフィール', (string) $this->o2o->fresh()->notes);
    }

    public function test_other_user_cannot_access(): void
    {
        $other = User::create([
            'name' => 'x', 'email' => 'x@example.com', 'password' => bcrypt('secret-password'),
            'owner_member_id' => $this->targetId, 'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);
        Sanctum::actingAs($other);
        $this->getJson("/api/one-to-ones/{$this->o2o->id}/attachments")->assertStatus(403);
    }

    public function test_generate_saves_to_memo(): void
    {
        Sanctum::actingAs($this->user);
        UserAiCredential::create([
            'user_id' => $this->user->id, 'ai_enabled' => true, 'provider' => 'openai',
            'api_key' => 'sk-test', 'is_active' => true,
        ]);
        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => '原稿本文']]],
        ], 200)]);

        $this->postJson("/api/one-to-ones/{$this->o2o->id}/prep/generate", ['save_to' => 'memo'])
            ->assertOk()
            ->assertJsonPath('saved_to', 'memo');
        $this->assertSame(1, ContactMemo::where('one_to_one_id', $this->o2o->id)->count());
    }
}
