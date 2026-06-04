<?php

namespace Database\Seeders;

use App\Models\Workspace;
use Illuminate\Database\Seeder;

/**
 * workspaces を最低 1 件用意する（冪等）. Phase09. SSOT: DATA_MODEL §4.1.
 */
class WorkspaceSeeder extends Seeder
{
    public function run(): void
    {
        $this->ensureDragonflyBootstrapWorkspace();

        if (Workspace::count() > 0) {
            return;
        }

        Workspace::create([
            'name' => 'DragonFly',
            'slug' => 'bni_dragonfly',
        ]);
    }

    /** 本番ダンプ取り込み後も id=1 の表示名を DragonFly に揃える（legacy: Default Workspace / default）。 */
    private function ensureDragonflyBootstrapWorkspace(): void
    {
        Workspace::query()
            ->where(function ($q) {
                $q->where('slug', 'default')
                    ->orWhere('name', 'Default Workspace');
            })
            ->update([
                'name' => 'DragonFly',
                'slug' => 'bni_dragonfly',
                'updated_at' => now(),
            ]);
    }
}
