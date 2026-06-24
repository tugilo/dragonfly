<?php

namespace App\Console\Commands\Sonae;

use App\Services\Sonae\SonaeBootstrapService;
use Illuminate\Console\Command;

/**
 * SPEC-017: DragonFly（Religo workspace）を SONAE チャプターとして初期化する。
 */
class BootstrapDragonFlyCommand extends Command
{
    protected $signature = 'sonae:bootstrap-dragonfly
                            {--prefecture=静岡県 : 主対象都道府県（発報条件の初期値）}
                            {--workspace-slug=bni_dragonfly : Religo workspace slug}';

    protected $description = 'Bootstrap SONAE chapter from Religo DragonFly workspace and sync members';

    public function handle(SonaeBootstrapService $bootstrap): int
    {
        $workspace = $bootstrap->findDragonFlyWorkspace();

        if ($workspace === null) {
            $slug = (string) $this->option('workspace-slug');
            $workspace = \App\Models\Workspace::query()->where('slug', $slug)->first();
        }

        if ($workspace === null) {
            $this->error('DragonFly workspace not found. Run migrations/seed first.');

            return self::FAILURE;
        }

        $result = $bootstrap->bootstrapFromWorkspace(
            $workspace,
            (string) $this->option('prefecture')
        );

        $chapter = $result['chapter'];

        $this->info(sprintf(
            'SONAE chapter bootstrapped: %s (id=%d, chapter_key=%s)',
            $chapter->name,
            $chapter->id,
            $chapter->chapter_key
        ));
        $this->info(sprintf('Members synced: %d', $result['members_synced']));

        return self::SUCCESS;
    }
}
