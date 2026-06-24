<?php

namespace Tests\Feature\Sonae;

use App\Models\Sonae\SonaeAlertNotification;
use App\Models\Sonae\SonaeAlertType;
use App\Models\Sonae\SonaeChapterAlertSetting;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeLineAccount;
use App\Models\Sonae\SonaeLineUserLink;
use App\Models\Sonae\SonaeMember;
use App\Models\User;
use App\Services\Sonae\Jma\SonaeJmaFeedProviderInterface;
use App\Services\Sonae\Jma\SonaeJmaFixtureFeedProvider;
use Database\Seeders\SonaeAlertThresholdOptionSeeder;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Laravel\Sanctum\Sanctum;
use Tests\Support\SonaeChapterTestHelpers;
use Tests\TestCase;

class SonaeAlertAutoDispatchTest extends TestCase
{
    use RefreshDatabase;
    use SonaeChapterTestHelpers;

    private string $fixtureDir;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SonaeAlertTypeSeeder::class);
        $this->seed(SonaeAlertThresholdOptionSeeder::class);

        $this->fixtureDir = storage_path('framework/testing/sonae-jma-auto-dispatch-fixtures');
        File::ensureDirectoryExists($this->fixtureDir);
        $this->app->bind(
            SonaeJmaFeedProviderInterface::class,
            fn () => new SonaeJmaFixtureFeedProvider($this->fixtureDir)
        );
    }

    protected function tearDown(): void
    {
        File::deleteDirectory($this->fixtureDir);
        parent::tearDown();
    }

    public function test_fetch_pipeline_auto_dispatches_alert_for_matching_chapter_setting(): void
    {
        Http::fake([
            'api.line.me/*' => Http::response([], 200),
        ]);

        File::put($this->fixtureDir.'/earthquake.json', json_encode([
            'entries' => [
                [
                    'type' => 'earthquake',
                    'source_event_key' => 'eq-auto-001',
                    'title' => '静岡県中部 震度5弱',
                    'severity' => 'intensity_5_lower',
                    'severity_rank' => 50,
                    'occurred_at' => '2026-06-24T11:00:00+09:00',
                    'areas' => [
                        ['prefecture' => '静岡県', 'municipality' => '静岡市', 'area_code' => '22100'],
                    ],
                ],
            ],
        ], JSON_THROW_ON_ERROR));

        $workspace = $this->createReligoWorkspace();
        $chapter = $this->createReligoSonaeChapter($workspace);

        $lineAccount = SonaeLineAccount::query()->create([
            'chapter_id' => $chapter->id,
            'channel_id' => 'line-channel-001',
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);
        $lineAccount->messaging_api_access_token_encrypted = 'line-access-token';
        $lineAccount->save();

        $member = SonaeMember::query()->create([
            'chapter_id' => $chapter->id,
            'name' => 'Auto Dispatch Target',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);
        SonaeLineUserLink::query()->create([
            'line_account_id' => $lineAccount->id,
            'member_id' => $member->id,
            'line_user_id' => 'U-auto-dispatch-target',
            'linked_at' => now(),
            'status' => SonaeConstants::LINE_LINK_ACTIVE,
        ]);

        $earthquakeType = SonaeAlertType::query()->where('code', 'earthquake')->firstOrFail();
        SonaeChapterAlertSetting::query()->create([
            'chapter_id' => $chapter->id,
            'alert_type_id' => $earthquakeType->id,
            'is_enabled' => true,
            'target_prefectures' => ['静岡県'],
            'threshold_code' => 'intensity_4_or_more',
        ]);

        $user = User::query()->create([
            'name' => 'Auto Dispatch Admin',
            'email' => 'sonae-auto-dispatch@example.com',
            'password' => Hash::make('password'),
        ]);
        Sanctum::actingAs($user);

        $this->postJson('/api/sonae/jma/fetch')
            ->assertOk()
            ->assertJsonPath('data.fetched_count', 1)
            ->assertJsonPath('data.created_event_count', 1)
            ->assertJsonPath('data.created_notification_count', 1);

        $notification = SonaeAlertNotification::query()
            ->where('chapter_id', $chapter->id)
            ->where('notification_type', SonaeConstants::NOTIFICATION_ALERT)
            ->first();

        $this->assertNotNull($notification);
        $this->assertDatabaseHas('sonae_notification_targets', [
            'alert_notification_id' => $notification->id,
            'member_id' => $member->id,
            'send_status' => 'sent',
        ]);

        Http::assertSent(function ($request) {
            return $request->url() === 'https://api.line.me/v2/bot/message/push'
                && ($request['to'] ?? null) === 'U-auto-dispatch-target';
        });

        // 同一 source_event_key の再取得ではイベント重複をスキップし、再発報しない。
        $this->postJson('/api/sonae/jma/fetch')
            ->assertOk()
            ->assertJsonPath('data.created_event_count', 0)
            ->assertJsonPath('data.skipped_duplicate_count', 1)
            ->assertJsonPath('data.created_notification_count', 0);

        $this->assertDatabaseCount('sonae_alert_notifications', 1);
        Http::assertSentCount(1);
    }
}
