<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * 初期 bootstrap の workspace 表示名を BNI DragonFly チャプター名に合わせる（Phase 121 保留分）。
 */
return new class extends Migration
{
    public function up(): void
    {
        DB::table('workspaces')
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

    public function down(): void
    {
        DB::table('workspaces')
            ->where('slug', 'bni_dragonfly')
            ->where('name', 'DragonFly')
            ->update([
                'name' => 'Default Workspace',
                'slug' => 'default',
                'updated_at' => now(),
            ]);
    }
};
