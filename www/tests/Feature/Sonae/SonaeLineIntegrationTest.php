<?php

namespace Tests\Feature\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeLineAccount;
use App\Models\Sonae\SonaeLineUserLink;
use App\Models\Sonae\SonaeMember;
use App\Models\Sonae\SonaeOrganization;
use App\Models\User;
use App\Services\Sonae\SonaeLineLinkService;
use App\Services\Sonae\SonaeNotificationTargetResolver;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-017 Phase 245: SONAE LINE 連携。
 */
class SonaeLineIntegrationTest extends TestCase
{
    use RefreshDatabase;

    private User $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SonaeAlertTypeSeeder::class);

        $this->user = User::query()->create([
            'name' => 'Sonae Admin',
            'email' => 'sonae-line@example.com',
            'password' => Hash::make('password'),
        ]);
    }

    public function test_line_account_update_and_show(): void
    {
        Sanctum::actingAs($this->user);
        $chapter = $this->createChapterWithLineAccount();

        $this->putJson("/api/sonae/chapters/{$chapter->id}/line-account", [
            'channel_id' => '123456',
            'channel_secret' => 'secret-value',
            'messaging_api_access_token' => 'access-token-value',
            'friend_add_url' => 'https://line.me/R/ti/p/@test',
            'status' => 'active',
        ])->assertOk()
            ->assertJsonPath('data.channel_id', '123456')
            ->assertJsonPath('data.channel_secret_set', true)
            ->assertJsonPath('data.access_token_set', true)
            ->assertJsonPath('data.has_usable_credentials', true);

        $this->getJson("/api/sonae/chapters/{$chapter->id}/line-account")
            ->assertOk()
            ->assertJsonPath('data.webhook_url', url('/sonae/line/webhook/test_chapter'));
    }

    public function test_webhook_message_links_member_by_invite_token(): void
    {
        $chapter = $this->createChapterWithLineAccount('secret-value');
        $member = $this->createMember($chapter);
        $invite = app(SonaeLineLinkService::class)->issueInviteToken($member);

        $body = json_encode([
            'events' => [
                [
                    'type' => 'message',
                    'source' => ['userId' => 'U-test-user'],
                    'message' => [
                        'type' => 'text',
                        'text' => $invite['message'],
                    ],
                ],
            ],
        ], JSON_THROW_ON_ERROR);

        $signature = base64_encode(hash_hmac('sha256', $body, 'secret-value', true));

        $this->call(
            'POST',
            '/sonae/line/webhook/test_chapter',
            [],
            [],
            [],
            [
                'HTTP_X_LINE_SIGNATURE' => $signature,
                'CONTENT_TYPE' => 'application/json',
            ],
            $body
        )->assertOk();

        $this->assertDatabaseHas('sonae_line_user_links', [
            'member_id' => $member->id,
            'line_user_id' => 'U-test-user',
            'status' => SonaeConstants::LINE_LINK_ACTIVE,
        ]);

        $targets = app(SonaeNotificationTargetResolver::class)->resolveLinkedActiveMembers($chapter);
        $this->assertCount(1, $targets);
    }

    public function test_webhook_unfollow_unlinks_member(): void
    {
        $chapter = $this->createChapterWithLineAccount('secret-value');
        $member = $this->createMember($chapter);
        $lineAccount = $chapter->lineAccount;

        SonaeLineUserLink::query()->create([
            'line_account_id' => $lineAccount->id,
            'member_id' => $member->id,
            'line_user_id' => 'U-unfollow',
            'linked_at' => now(),
            'status' => SonaeConstants::LINE_LINK_ACTIVE,
        ]);

        $body = json_encode([
            'events' => [
                [
                    'type' => 'unfollow',
                    'source' => ['userId' => 'U-unfollow'],
                ],
            ],
        ], JSON_THROW_ON_ERROR);

        $signature = base64_encode(hash_hmac('sha256', $body, 'secret-value', true));

        $this->call(
            'POST',
            '/sonae/line/webhook/test_chapter',
            [],
            [],
            [],
            ['HTTP_X_LINE_SIGNATURE' => $signature, 'CONTENT_TYPE' => 'application/json'],
            $body
        )->assertOk();

        $this->assertDatabaseHas('sonae_line_user_links', [
            'member_id' => $member->id,
            'line_user_id' => 'U-unfollow',
            'status' => SonaeConstants::LINE_LINK_UNLINKED,
        ]);
    }

    public function test_direct_link_and_push_test(): void
    {
        Sanctum::actingAs($this->user);
        Http::fake([
            'api.line.me/*' => Http::response([], 200),
        ]);

        $chapter = $this->createChapterWithLineAccount();
        $lineAccount = $chapter->lineAccount;
        $lineAccount->channel_id = '123';
        $lineAccount->messaging_api_access_token_encrypted = 'access-token-value';
        $lineAccount->status = SonaeConstants::STATUS_ACTIVE;
        $lineAccount->save();

        $member = $this->createMember($chapter);

        $this->postJson("/api/sonae/chapters/{$chapter->id}/members/{$member->id}/line-link", [
            'line_user_id' => 'U-push-target',
        ])->assertOk();

        $this->postJson("/api/sonae/chapters/{$chapter->id}/members/{$member->id}/line-push-test", [
            'message' => 'テスト通知',
        ])->assertOk()
            ->assertJsonPath('data.sent', true);

        Http::assertSent(function ($request) {
            return $request->url() === 'https://api.line.me/v2/bot/message/push'
                && ($request['to'] ?? null) === 'U-push-target';
        });
    }

    private function createChapterWithLineAccount(?string $secret = null): SonaeChapter
    {
        $org = SonaeOrganization::query()->create([
            'name' => 'Test Org',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        $chapter = SonaeChapter::query()->create([
            'organization_id' => $org->id,
            'name' => 'Test Chapter',
            'code' => 'TEST',
            'chapter_key' => 'test_chapter',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        $account = SonaeLineAccount::query()->create([
            'chapter_id' => $chapter->id,
            'channel_id' => '',
            'status' => SonaeConstants::STATUS_INACTIVE,
        ]);

        if ($secret !== null) {
            $account->channel_secret_encrypted = $secret;
            $account->save();
        }

        $chapter->setRelation('lineAccount', $account->fresh());

        return $chapter->fresh(['lineAccount']);
    }

    private function createMember(SonaeChapter $chapter): SonaeMember
    {
        return SonaeMember::query()->create([
            'chapter_id' => $chapter->id,
            'name' => 'Line Member',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);
    }
}
