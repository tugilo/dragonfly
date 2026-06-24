<?php

namespace Tests\Feature\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeLineAccount;
use App\Models\Sonae\SonaeLineUserLink;
use App\Models\Sonae\SonaeMember;
use App\Models\Sonae\SonaeNotificationTarget;
use App\Models\Sonae\SonaeOrganization;
use App\Models\User;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-017 Phase 246: 訓練発報・回答・集計（L1）。
 */
class SonaeTrainingResponseTest extends TestCase
{
    use RefreshDatabase;

    private User $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SonaeAlertTypeSeeder::class);
        $this->user = User::query()->create([
            'name' => 'Sonae Admin',
            'email' => 'sonae-training@example.com',
            'password' => Hash::make('password'),
        ]);
    }

    public function test_training_dispatch_response_and_aggregation(): void
    {
        Sanctum::actingAs($this->user);
        Http::fake(['api.line.me/*' => Http::response([], 200)]);

        $chapter = $this->createChapterWithLinkedMember();

        $this->postJson("/api/sonae/chapters/{$chapter->id}/training-events/dispatch", [
            'name' => '2026年6月訓練',
        ])->assertCreated()
            ->assertJsonPath('data.sent', 1);

        $target = SonaeNotificationTarget::query()->first();
        $this->assertNotNull($target);
        $notificationId = $target->alert_notification_id;

        $pushBody = '';
        Http::assertSent(function ($request) use (&$pushBody) {
            $pushBody = (string) ($request['messages'][0]['text'] ?? '');

            return true;
        });
        $this->assertNotSame('', $pushBody);
        preg_match('#/sonae/respond/([A-Za-z0-9]+)#', $pushBody, $matches);
        $this->assertNotEmpty($matches[1] ?? null);
        $token = $matches[1];

        $this->get("/sonae/respond/{$token}")
            ->assertOk()
            ->assertSee('安否回答');

        $this->post("/sonae/respond/{$token}", [
            'safety_status' => SonaeConstants::SAFETY_MINOR_INJURY,
            'activity_status' => SonaeConstants::ACTIVITY_DIFFICULT,
            'meeting_attendance_status' => SonaeConstants::ATTENDANCE_CANNOT,
            'comment' => 'テスト回答',
        ])->assertRedirect();

        $this->getJson("/api/sonae/chapters/{$chapter->id}/notifications/{$notificationId}/summary")
            ->assertOk()
            ->assertJsonPath('data.summary.response_rate', 1)
            ->assertJsonPath('data.summary.harmful_count', 1)
            ->assertJsonPath('data.summary.activity_difficult_count', 1)
            ->assertJsonPath('data.summary.meeting_cannot_attend_count', 1)
            ->assertJsonPath('data.summary.unanswered_count', 0);

        $this->getJson("/api/sonae/chapters/{$chapter->id}/training-events")
            ->assertOk()
            ->assertJsonPath('data.0.response_rate', 1);
    }

    public function test_training_response_rate_comparison(): void
    {
        Sanctum::actingAs($this->user);
        Http::fake(['api.line.me/*' => Http::response([], 200)]);

        $chapter = $this->createChapterWithLinkedMember();

        $this->postJson("/api/sonae/chapters/{$chapter->id}/training-events/dispatch", [
            'name' => '第1回訓練',
        ])->assertCreated();

        $firstToken = $this->extractTokenFromLastPush();
        $this->post("/sonae/respond/{$firstToken}", [
            'safety_status' => SonaeConstants::SAFETY_SAFE,
            'activity_status' => SonaeConstants::ACTIVITY_NORMAL,
            'meeting_attendance_status' => SonaeConstants::ATTENDANCE_CAN,
        ]);

        $this->postJson("/api/sonae/chapters/{$chapter->id}/training-events/dispatch", [
            'name' => '第2回訓練',
        ])->assertCreated();

        $list = $this->getJson("/api/sonae/chapters/{$chapter->id}/training-events")
            ->assertOk()
            ->json('data');

        $this->assertCount(2, $list);
        // executed_at desc: 第2回が先頭
        $this->assertEqualsWithDelta(0.0, $list[0]['response_rate'], 0.0001);
        $this->assertEqualsWithDelta(-1.0, $list[0]['comparison']['delta'], 0.0001);
        $this->assertEqualsWithDelta(1.0, $list[1]['response_rate'], 0.0001);
        $this->assertNull($list[1]['comparison']);
    }

    private function extractTokenFromLastPush(): string
    {
        $pushBody = '';
        Http::assertSent(function ($request) use (&$pushBody) {
            $pushBody = (string) ($request['messages'][0]['text'] ?? '');

            return true;
        });
        preg_match('#/sonae/respond/([A-Za-z0-9]+)#', $pushBody, $matches);

        return $matches[1];
    }

    private function createChapterWithLinkedMember(): SonaeChapter
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

        $lineAccount = SonaeLineAccount::query()->create([
            'chapter_id' => $chapter->id,
            'channel_id' => '',
            'status' => SonaeConstants::STATUS_INACTIVE,
        ]);
        $lineAccount->channel_id = '123';
        $lineAccount->messaging_api_access_token_encrypted = 'access-token-value';
        $lineAccount->status = SonaeConstants::STATUS_ACTIVE;
        $lineAccount->save();

        $member = SonaeMember::query()->create([
            'chapter_id' => $chapter->id,
            'name' => 'Training Member',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        SonaeLineUserLink::query()->create([
            'line_account_id' => $lineAccount->id,
            'member_id' => $member->id,
            'line_user_id' => 'U-training',
            'linked_at' => now(),
            'status' => SonaeConstants::LINE_LINK_ACTIVE,
        ]);

        return $chapter->fresh(['lineAccount']);
    }
}
