<?php

namespace App\Console\Commands;

use App\Services\Religo\DashboardSummaryVerificationService;
use Illuminate\Console\Command;

class DashboardVerifySummaryCommand extends Command
{
    protected $signature = 'dashboard:verify-summary {owner_member_id : Owner member ID (users.owner_member_id / dashboard owner)}';

    protected $description = 'Compare GET /api/dashboard/stats aggregates with DB::table raw counts (see DASHBOARD_DATA_SSOT §6).';

    public function handle(DashboardSummaryVerificationService $verification): int
    {
        $ownerId = (int) $this->argument('owner_member_id');
        $result = $verification->verify($ownerId);

        $this->line('app.timezone: ' . $result['app_timezone']);
        $this->line('now: ' . $result['now_iso']);
        $this->line('month range: ' . $result['month_range']['start'] . ' .. ' . $result['month_range']['end']);
        $this->newLine();

        $rows = [
            ['Metric', 'db_raw', 'service', 'diff'],
            [
                'monthly_one_to_one_count',
                (string) $result['db_raw']['monthly_one_to_one_count'],
                (string) $result['service']['monthly_one_to_one_count'],
                (string) $result['diff']['monthly_one_to_one_count'],
            ],
            [
                'one_to_one_total_count',
                (string) $result['db_raw']['one_to_one_total_count'],
                (string) $result['service']['one_to_one_total_count'],
                (string) $result['diff']['one_to_one_total_count'],
            ],
            [
                'one_to_one_planned_count',
                (string) $result['db_raw']['one_to_one_planned_count'],
                (string) $result['service']['one_to_one_planned_count'],
                (string) $result['diff']['one_to_one_planned_count'],
            ],
            [
                'one_to_one_canceled_count',
                (string) $result['db_raw']['one_to_one_canceled_count'],
                (string) $result['service']['one_to_one_canceled_count'],
                (string) $result['diff']['one_to_one_canceled_count'],
            ],
            [
                'monthly_intro_memo_count',
                (string) $result['db_raw']['monthly_intro_memo_count'],
                (string) $result['service']['monthly_intro_memo_count'],
                (string) $result['diff']['monthly_intro_memo_count'],
            ],
            [
                'monthly_meeting_memo_count',
                (string) $result['db_raw']['monthly_meeting_memo_count'],
                (string) $result['service']['monthly_meeting_memo_count'],
                (string) $result['diff']['monthly_meeting_memo_count'],
            ],
            [
                'stale_contacts_count',
                (string) $result['db_raw']['stale_contacts_count'],
                (string) $result['service']['stale_contacts_count'],
                (string) $result['diff']['stale_contacts_count'],
            ],
        ];
        $this->table($rows[0], array_slice($rows, 1));

        if ($result['all_match']) {
            $this->info('all_match: OK');

            return self::SUCCESS;
        }
        $this->error('all_match: NG (see diff column)');

        return self::FAILURE;
    }
}
