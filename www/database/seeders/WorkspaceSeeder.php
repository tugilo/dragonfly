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
        if (Workspace::count() > 0) {
            return;
        }
        Workspace::create([
            'name' => 'Default Workspace',
            'slug' => 'default',
        ]);
    }
}
