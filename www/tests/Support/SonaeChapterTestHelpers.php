<?php

namespace Tests\Support;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeOrganization;
use App\Models\User;
use App\Models\Workspace;
use Laravel\Sanctum\Sanctum;

trait SonaeChapterTestHelpers
{
    protected function createReligoWorkspace(array $attributes = []): Workspace
    {
        return Workspace::query()->create(array_merge([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
        ], $attributes));
    }

    protected function createReligoSonaeChapter(Workspace $workspace): SonaeChapter
    {
        $org = SonaeOrganization::query()->create([
            'name' => 'BNI',
            'source_system' => SonaeConstants::SOURCE_RELIGO,
            'external_id' => 'bni',
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);

        return SonaeChapter::query()->create([
            'organization_id' => $org->id,
            'name' => $workspace->name,
            'code' => 'DF',
            'chapter_key' => $workspace->slug ?: ('workspace_'.$workspace->id),
            'source_system' => SonaeConstants::SOURCE_RELIGO,
            'external_id' => (string) $workspace->id,
            'status' => SonaeConstants::STATUS_ACTIVE,
        ]);
    }

    protected function authenticateSonaeUser(User $user, Workspace $workspace): void
    {
        $user->default_workspace_id = $workspace->id;
        $user->save();
        Sanctum::actingAs($user);
    }
}
