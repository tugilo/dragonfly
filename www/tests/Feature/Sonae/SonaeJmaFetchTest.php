<?php

namespace Tests\Feature\Sonae;

use App\Models\User;
use App\Services\Sonae\Jma\SonaeJmaFeedProviderInterface;
use App\Services\Sonae\Jma\SonaeJmaFixtureFeedProvider;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-017 Phase 249: JMA 取得基盤。
 */
class SonaeJmaFetchTest extends TestCase
{
    use RefreshDatabase;

    private User $user;

    private string $fixtureDir;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SonaeAlertTypeSeeder::class);

        $this->user = User::query()->create([
            'name' => 'JMA Admin',
            'email' => 'sonae-jma@example.com',
            'password' => Hash::make('password'),
        ]);

        $this->fixtureDir = storage_path('framework/testing/sonae-jma-fixtures');
        File::ensureDirectoryExists($this->fixtureDir);
        File::put($this->fixtureDir.'/sample.json', json_encode([
            'entries' => [
                ['type' => 'earthquake', 'source_event_key' => 'test-1', 'title' => 'Test'],
            ],
        ], JSON_THROW_ON_ERROR));

        $this->app->bind(SonaeJmaFeedProviderInterface::class, fn () => new SonaeJmaFixtureFeedProvider($this->fixtureDir));
    }

    protected function tearDown(): void
    {
        File::deleteDirectory($this->fixtureDir);
        parent::tearDown();
    }

    public function test_manual_fetch_api_and_logs(): void
    {
        Sanctum::actingAs($this->user);

        $this->postJson('/api/sonae/jma/fetch')
            ->assertOk()
            ->assertJsonPath('data.fetched_count', 1)
            ->assertJsonPath('data.status', 'success');

        $this->getJson('/api/sonae/jma/logs')
            ->assertOk()
            ->assertJsonCount(1, 'data');
    }

    public function test_jma_settings_update(): void
    {
        Sanctum::actingAs($this->user);

        $this->putJson('/api/sonae/jma/settings', [
            'is_enabled' => true,
            'interval_minutes' => 10,
        ])->assertOk()
            ->assertJsonPath('data.is_enabled', true)
            ->assertJsonPath('data.interval_minutes', 10);
    }

    public function test_artisan_jma_fetch_command(): void
    {
        $exitCode = Artisan::call('sonae:jma-fetch', ['--manual' => true]);
        $this->assertSame(0, $exitCode);
        $this->assertStringContainsString('1 entries', Artisan::output());
    }
}
