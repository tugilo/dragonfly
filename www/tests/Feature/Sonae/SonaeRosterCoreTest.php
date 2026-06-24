<?php

namespace Tests\Feature\Sonae;

use App\Models\Member;
use App\Models\Sonae\SonaeAlertThresholdOption;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeLineAccount;
use App\Models\Sonae\SonaeLineUserLink;
use App\Models\Sonae\SonaeMember;
use App\Models\Sonae\SonaeOrganization;
use App\Models\User;
use App\Models\Workspace;
use App\Services\Sonae\SonaeMemberSyncService;
use App\Services\Sonae\SonaeNotificationTargetResolver;
use Database\Seeders\SonaeAlertThresholdOptionSeeder;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\Support\SonaeChapterTestHelpers;
use Tests\TestCase;

/**
 * SPEC-017 Phase 244: SONAE Roster Core.
 */
class SonaeRosterCoreTest extends TestCase
{
    use RefreshDatabase;
    use SonaeChapterTestHelpers;

    private User $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SonaeAlertTypeSeeder::class);
        $this->seed(SonaeAlertThresholdOptionSeeder::class);

        $this->user = User::query()->create([
            'name' => 'Sonae Admin',
            'email' => 'sonae-admin@example.com',
            'password' => Hash::make('password'),
        ]);
    }

    public function test_threshold_option_seeder_loads_earthquake_options(): void
    {
        $count = SonaeAlertThresholdOption::query()
            ->whereHas('alertType', fn ($q) => $q->where('code', 'earthquake'))
            ->count();

        $this->assertGreaterThanOrEqual(6, $count);
        $this->assertNotNull(
            SonaeAlertThresholdOption::query()
                ->where('code', 'intensity_5_lower_or_more')
                ->first()
        );
    }

    public function test_member_sync_excludes_guest_and_visitor(): void
    {
        $workspace = Workspace::query()->create([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
        ]);

        Member::query()->create([
            'name' => 'BNI Member',
            'type' => 'member',
            'workspace_id' => $workspace->id,
        ]);
        Member::query()->create([
            'name' => 'Guest Person',
            'type' => 'guest',
            'workspace_id' => $workspace->id,
        ]);
        Member::query()->create([
            'name' => 'Visitor Person',
            'type' => 'visitor',
            'workspace_id' => $workspace->id,
        ]);

        $chapter = $this->createReligoSonaeChapter($workspace);
        $result = app(SonaeMemberSyncService::class)->syncChapterFromReligo($chapter, $workspace);

        $this->assertSame(1, $result['synced']);
        $this->assertSame(2, $result['skipped']);
        $this->assertSame(1, SonaeMember::query()->where('chapter_id', $chapter->id)->count());
        $this->assertSame('BNI Member', SonaeMember::query()->first()?->name);
    }

    public function test_notification_target_resolver_returns_linked_members_only(): void
    {
        $chapter = $this->createStandaloneChapter();
        $lineAccount = SonaeLineAccount::query()->create([
            'chapter_id' => $chapter->id,
            'channel_id' => 'test-channel',
            'status' => SonaeConstants::STATUS_INACTIVE,
        ]);

        $linked = SonaeMember::query()->create([
            'chapter_id' => $chapter->id,
            'name' => 'Linked Member',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);
        SonaeMember::query()->create([
            'chapter_id' => $chapter->id,
            'name' => 'Unlinked Member',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        SonaeLineUserLink::query()->create([
            'line_account_id' => $lineAccount->id,
            'member_id' => $linked->id,
            'line_user_id' => 'U123',
            'linked_at' => now(),
            'status' => SonaeConstants::LINE_LINK_ACTIVE,
        ]);

        $targets = app(SonaeNotificationTargetResolver::class)->resolveLinkedActiveMembers($chapter);

        $this->assertCount(1, $targets);
        $this->assertSame('Linked Member', $targets->first()?->name);
    }

    public function test_csv_import_preview_and_import_via_api(): void
    {
        $workspace = $this->createReligoWorkspace();
        $chapter = $this->createReligoSonaeChapter($workspace);
        $this->authenticateSonaeUser($this->user, $workspace);

        $csv = <<<'CSV'
name,name_kana,email
山田太郎,やまだ,test@example.com
CSV;

        $file = UploadedFile::fake()->createWithContent('members.csv', $csv);

        $preview = $this->postJson("/api/sonae/chapters/{$chapter->id}/members/import-csv?preview=1", [
            'csv' => $file,
        ]);
        $preview->assertOk();
        $preview->assertJsonPath('preview', true);
        $preview->assertJsonPath('valid_rows.0.name', '山田太郎');

        $file2 = UploadedFile::fake()->createWithContent('members.csv', $csv);
        $import = $this->postJson("/api/sonae/chapters/{$chapter->id}/members/import-csv", [
            'csv' => $file2,
        ]);
        $import->assertOk();
        $import->assertJsonPath('imported', 1);

        $show = $this->getJson("/api/sonae/chapters/{$chapter->id}");
        $show->assertOk();
        $show->assertJsonPath('data.kpi.roster_count', 1);
        $show->assertJsonPath('data.kpi.unlinked_count', 1);
    }

    public function test_members_unlinked_list_and_update(): void
    {
        $workspace = $this->createReligoWorkspace();
        $chapter = $this->createReligoSonaeChapter($workspace);
        $this->authenticateSonaeUser($this->user, $workspace);
        $member = SonaeMember::query()->create([
            'chapter_id' => $chapter->id,
            'name' => 'Inactive Target',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        $this->getJson("/api/sonae/chapters/{$chapter->id}/members/unlinked")
            ->assertOk()
            ->assertJsonCount(1, 'data');

        $this->patchJson("/api/sonae/chapters/{$chapter->id}/members/{$member->id}", [
            'status' => 'inactive',
        ])
            ->assertOk()
            ->assertJsonPath('data.status', 'inactive');
    }

    public function test_religo_sync_endpoint(): void
    {
        $workspace = Workspace::query()->create([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
        ]);
        Member::query()->create([
            'name' => 'Sync Target',
            'type' => 'member',
            'workspace_id' => $workspace->id,
        ]);

        $chapter = $this->createReligoSonaeChapter($workspace);
        $this->authenticateSonaeUser($this->user, $workspace);

        $this->postJson("/api/sonae/chapters/{$chapter->id}/members/sync")
            ->assertOk()
            ->assertJsonPath('data.synced', 1);

        $this->getJson('/api/sonae/alert-threshold-options?alert_type_code=earthquake')
            ->assertOk()
            ->assertJson(fn ($json) => $json->has('data')->etc());
    }

    private function createStandaloneChapter(): SonaeChapter
    {
        $org = SonaeOrganization::query()->create([
            'name' => 'Test Org',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        return SonaeChapter::query()->create([
            'organization_id' => $org->id,
            'name' => 'Test Chapter',
            'code' => 'TEST',
            'chapter_key' => 'test_chapter',
            'source_system' => SonaeConstants::SOURCE_SONAE,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);
    }

    private function createReligoChapter(Workspace $workspace): SonaeChapter
    {
        return $this->createReligoSonaeChapter($workspace);
    }
}
