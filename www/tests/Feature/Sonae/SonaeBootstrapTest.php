<?php

namespace Tests\Feature\Sonae;

use App\Models\Member;
use App\Models\Sonae\SonaeAlertType;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeChapterAlertSetting;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeJmaFetchSetting;
use App\Models\Sonae\SonaeMember;
use App\Models\Workspace;
use App\Services\Sonae\SonaeBootstrapService;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Tests\TestCase;

/**
 * SPEC-017 Phase 242: SONAE DB + DragonFly bootstrap.
 */
class SonaeBootstrapTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SonaeAlertTypeSeeder::class);
    }

    public function test_migrations_create_sonae_tables(): void
    {
        $this->assertTrue(\Schema::hasTable('sonae_chapters'));
        $this->assertTrue(\Schema::hasTable('sonae_members'));
        $this->assertTrue(\Schema::hasTable('sonae_alert_notifications'));
    }

    public function test_alert_type_seeder_loads_nine_types(): void
    {
        $this->assertSame(9, SonaeAlertType::query()->count());
        $this->assertNotNull(SonaeAlertType::query()->where('code', 'earthquake')->first());
    }

    public function test_bootstrap_creates_chapter_and_syncs_members(): void
    {
        $workspace = Workspace::query()->create([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
        ]);

        Member::query()->create([
            'name' => 'テスト メンバー',
            'name_kana' => 'てすと',
            'type' => 'member',
            'workspace_id' => $workspace->id,
        ]);

        $service = app(SonaeBootstrapService::class);
        $result = $service->bootstrapFromWorkspace($workspace, '静岡県');

        $chapter = $result['chapter'];
        $this->assertInstanceOf(SonaeChapter::class, $chapter);
        $this->assertSame(SonaeConstants::SOURCE_RELIGO, $chapter->source_system);
        $this->assertSame((string) $workspace->id, $chapter->external_id);
        $this->assertSame('静岡県', $chapter->prefecture);
        $this->assertSame(1, $result['members_synced']);

        $sonaeMember = SonaeMember::query()->where('chapter_id', $chapter->id)->first();
        $this->assertNotNull($sonaeMember);
        $this->assertSame('テスト メンバー', $sonaeMember->name);

        $this->assertSame(
            9,
            SonaeChapterAlertSetting::query()->where('chapter_id', $chapter->id)->count()
        );
        $this->assertSame(1, SonaeJmaFetchSetting::query()->count());
    }

    public function test_bootstrap_dragonfly_artisan_command(): void
    {
        Workspace::query()->create([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
        ]);

        $exitCode = Artisan::call('sonae:bootstrap-dragonfly');
        $this->assertSame(0, $exitCode);

        $chapter = SonaeChapter::query()->where('chapter_key', 'bni_dragonfly')->first();
        $this->assertNotNull($chapter);
    }

    public function test_bootstrap_is_idempotent(): void
    {
        $workspace = Workspace::query()->create([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
        ]);

        Member::query()->create([
            'name' => 'Member A',
            'type' => 'member',
            'workspace_id' => $workspace->id,
        ]);

        $service = app(SonaeBootstrapService::class);
        $service->bootstrapFromWorkspace($workspace);
        $service->bootstrapFromWorkspace($workspace);

        $this->assertSame(1, SonaeChapter::query()->count());
        $this->assertSame(1, SonaeMember::query()->count());
    }
}
