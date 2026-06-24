<?php

namespace Tests\Feature\Sonae;

use App\Models\Member;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeOrganization;
use App\Models\User;
use App\Models\Workspace;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\Support\SonaeChapterTestHelpers;
use Tests\TestCase;

/**
 * SPEC-017 Phase 248: Religo Shell 統合（context・bootstrap・middleware）。
 */
class SonaeReligoShellTest extends TestCase
{
    use RefreshDatabase;
    use SonaeChapterTestHelpers;

    private User $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SonaeAlertTypeSeeder::class);

        $this->user = User::query()->create([
            'name' => 'Sonae Shell Admin',
            'email' => 'sonae-shell@example.com',
            'password' => Hash::make('password'),
        ]);
    }

    public function test_context_returns_bootstrap_required_when_chapter_missing(): void
    {
        $workspace = $this->createReligoWorkspace();
        $this->authenticateSonaeUser($this->user, $workspace);

        $this->getJson('/api/sonae/context')
            ->assertOk()
            ->assertJsonPath('data.workspace_id', $workspace->id)
            ->assertJsonPath('data.bootstrap_required', true)
            ->assertJsonPath('data.chapter', null);
    }

    public function test_bootstrap_creates_chapter_and_syncs_members(): void
    {
        $workspace = $this->createReligoWorkspace();
        Member::query()->create([
            'name' => 'Shell Member',
            'type' => 'member',
            'workspace_id' => $workspace->id,
        ]);
        $this->authenticateSonaeUser($this->user, $workspace);

        $this->postJson('/api/sonae/chapters/bootstrap', ['prefecture' => '静岡県'])
            ->assertCreated()
            ->assertJsonPath('data.members_synced', 1)
            ->assertJsonPath('data.chapter.prefecture', '静岡県');

        $this->getJson('/api/sonae/context')
            ->assertOk()
            ->assertJsonPath('data.bootstrap_required', false)
            ->assertJsonPath('data.chapter.kpi.roster_count', 1);
    }

    public function test_middleware_blocks_foreign_chapter_access(): void
    {
        $workspaceA = $this->createReligoWorkspace(['slug' => 'chapter_a']);
        $workspaceB = $this->createReligoWorkspace(['name' => 'Other', 'slug' => 'chapter_b']);
        $this->createReligoSonaeChapter($workspaceA);
        $chapterB = $this->createReligoSonaeChapter($workspaceB);

        $this->authenticateSonaeUser($this->user, $workspaceA);

        $this->getJson("/api/sonae/chapters/{$chapterB->id}")
            ->assertForbidden();
    }

    public function test_middleware_allows_own_chapter_access(): void
    {
        $workspace = $this->createReligoWorkspace();
        $chapter = $this->createReligoSonaeChapter($workspace);
        $this->authenticateSonaeUser($this->user, $workspace);

        $this->getJson("/api/sonae/chapters/{$chapter->id}")
            ->assertOk()
            ->assertJsonPath('data.id', $chapter->id);
    }
}
