<?php

namespace Tests\Feature\Sonae;

use App\Models\User;
use App\Services\Sonae\Jma\SonaeJmaFeedProviderInterface;
use App\Services\Sonae\Jma\SonaeJmaFixtureFeedProvider;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class SonaeJmaIngestTest extends TestCase
{
    use RefreshDatabase;

    private string $fixtureDir;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SonaeAlertTypeSeeder::class);

        $this->fixtureDir = storage_path('framework/testing/sonae-jma-ingest-fixtures');
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

    public function test_ingest_creates_events_and_skips_duplicate_source_event_key(): void
    {
        File::put($this->fixtureDir.'/batch.json', json_encode([
            'entries' => [
                [
                    'type' => 'earthquake',
                    'source_event_key' => 'eq-20260624-001',
                    'title' => '静岡県中部 震度5弱',
                    'severity' => 'intensity_5_lower',
                    'severity_rank' => 50,
                    'occurred_at' => '2026-06-24T10:01:00+09:00',
                    'areas' => [
                        ['prefecture' => '静岡県', 'municipality' => '静岡市', 'area_code' => '22100', 'intensity' => '5-'],
                    ],
                ],
                [
                    'type' => 'earthquake',
                    'source_event_key' => 'eq-20260624-001',
                    'title' => '静岡県中部 震度5弱 (duplicate)',
                    'severity' => 'intensity_5_lower',
                    'severity_rank' => 50,
                    'occurred_at' => '2026-06-24T10:01:00+09:00',
                    'areas' => [
                        ['prefecture' => '静岡県', 'municipality' => '静岡市'],
                    ],
                ],
                [
                    'type' => 'tsunami',
                    'source_event_key' => 'tsu-20260624-001',
                    'title' => '津波注意報',
                    'severity' => 'tsunami_advisory',
                    'severity_rank' => 10,
                    'occurred_at' => '2026-06-24T10:10:00+09:00',
                    'areas' => [
                        ['prefecture' => '静岡県', 'municipality' => '下田市'],
                    ],
                ],
            ],
        ], JSON_THROW_ON_ERROR));

        $user = User::query()->create([
            'name' => 'Ingest Admin',
            'email' => 'sonae-jma-ingest@example.com',
            'password' => Hash::make('password'),
        ]);
        Sanctum::actingAs($user);

        $this->postJson('/api/sonae/jma/fetch')
            ->assertOk()
            ->assertJsonPath('data.fetched_count', 3)
            ->assertJsonPath('data.created_event_count', 2)
            ->assertJsonPath('data.skipped_duplicate_count', 1)
            ->assertJsonPath('data.status', 'success');

        $this->assertDatabaseCount('sonae_alert_events', 2);
        $this->assertDatabaseCount('sonae_alert_event_areas', 2);
        $this->assertDatabaseHas('sonae_alert_events', [
            'source_event_key' => 'eq-20260624-001',
            'title' => '静岡県中部 震度5弱',
        ]);
        $this->assertDatabaseHas('sonae_jma_fetch_logs', [
            'fetched_count' => 3,
            'created_event_count' => 2,
            'skipped_duplicate_count' => 1,
        ]);
    }
}
