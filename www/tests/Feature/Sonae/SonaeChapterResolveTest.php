<?php

namespace Tests\Feature\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeOrganization;
use App\Models\User;
use App\Models\Workspace;
use Database\Seeders\SonaeAlertTypeSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-017 Phase 247: SONAE chapter resolve API。
 */
class SonaeChapterResolveTest extends TestCase
{
    use RefreshDatabase;

    public function test_resolve_returns_chapter_for_religo_workspace(): void
    {
        $this->seed(SonaeAlertTypeSeeder::class);

        $user = User::query()->create([
            'name' => 'Sonae Admin',
            'email' => 'sonae-resolve@example.com',
            'password' => Hash::make('password'),
        ]);
        Sanctum::actingAs($user);

        $workspace = Workspace::query()->create([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
        ]);

        $org = SonaeOrganization::query()->create([
            'name' => 'BNI',
            'source_system' => SonaeConstants::SOURCE_RELIGO,
            'external_id' => 'bni',
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        $chapter = SonaeChapter::query()->create([
            'organization_id' => $org->id,
            'name' => 'DragonFly',
            'code' => 'DRAGONFLY',
            'chapter_key' => 'bni_dragonfly',
            'source_system' => SonaeConstants::SOURCE_RELIGO,
            'external_id' => (string) $workspace->id,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        $this->getJson("/api/sonae/chapters/resolve?workspace_id={$workspace->id}")
            ->assertOk()
            ->assertJsonPath('data.id', $chapter->id)
            ->assertJsonPath('data.religo_linked', true);
    }

    public function test_resolve_returns_404_when_chapter_missing(): void
    {
        $user = User::query()->create([
            'name' => 'Sonae Admin',
            'email' => 'sonae-resolve-missing@example.com',
            'password' => Hash::make('password'),
        ]);
        Sanctum::actingAs($user);

        $this->getJson('/api/sonae/chapters/resolve?workspace_id=99999')
            ->assertNotFound();
    }
}
