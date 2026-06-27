<?php

namespace App\Console\Commands;

use App\Services\Religo\TokyoNeRegionChapterSeedService;
use Illuminate\Console\Command;

/**
 * SPEC-021: BNI 東京 N.E.リージョンとチャプター workspace を冪等シードする。
 */
class SeedTokyoNeRegionChapterCommand extends Command
{
    protected $signature = 'religo:seed-tokyo-ne-region';

    protected $description = 'Seed Japan + BNI Tokyo NE region and chapter workspaces (idempotent)';

    public function handle(TokyoNeRegionChapterSeedService $service): int
    {
        $result = $service->run();

        $this->info(sprintf(
            'Tokyo NE region seeded (country_id=%d, region_id=%d). NE chapters created=%d updated=%d / other regions=%d other chapters touched=%d / member assignments=%d',
            $result['country_id'],
            $result['region_id'],
            $result['created'],
            $result['updated'],
            $result['other_regions'],
            $result['other_chapters'],
            $result['member_assignments']
        ));

        return self::SUCCESS;
    }
}
