<?php

namespace App\Console\Commands\Sonae;

use App\Services\Sonae\Jma\SonaeJmaFetchService;
use Illuminate\Console\Command;

class JmaFetchCommand extends Command
{
    protected $signature = 'sonae:jma-fetch {--manual : 手動取得として記録}';

    protected $description = 'SONAE JMA フィードを取得しログに記録する（PoC: fixture）';

    public function handle(SonaeJmaFetchService $fetch): int
    {
        $type = $this->option('manual') ? 'manual' : 'scheduled';

        try {
            $result = $fetch->run($type);
        } catch (\Throwable $e) {
            $this->error($e->getMessage());

            return self::FAILURE;
        }

        $this->info(sprintf(
            'JMA fetch %s: %d entries, %d events, %d dispatches (log #%d)',
            $result['log']->status,
            $result['fetched_count'],
            $result['created_event_count'] ?? 0,
            $result['created_notification_count'] ?? 0,
            $result['log']->id
        ));

        return self::SUCCESS;
    }
}
