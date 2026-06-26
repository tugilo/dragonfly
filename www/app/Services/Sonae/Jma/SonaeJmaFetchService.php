<?php

namespace App\Services\Sonae\Jma;

use App\Models\Sonae\SonaeJmaFetchLog;
use App\Models\Sonae\SonaeJmaFetchSetting;
use App\Services\Sonae\SonaeAlertAutoDispatchService;
use Illuminate\Support\Facades\DB;

/**
 * SPEC-017 Phase 249: JMA 取得とログ記録。
 */
class SonaeJmaFetchService
{
    public function __construct(
        private readonly SonaeJmaFeedProviderInterface $feedProvider,
        private readonly SonaeJmaIngestService $ingest,
        private readonly SonaeAlertAutoDispatchService $autoDispatch,
    ) {}

    /**
     * @return array{
     *     log: SonaeJmaFetchLog,
     *     fetched_count: int,
     *     created_event_count: int,
     *     skipped_duplicate_count: int,
     *     created_notification_count: int,
     *     skipped_notification_count: int
     * }
     */
    public function run(string $fetchType = 'manual'): array
    {
        $setting = $this->resolveSetting();

        return DB::transaction(function () use ($setting, $fetchType) {
            $log = SonaeJmaFetchLog::query()->create([
                'jma_fetch_setting_id' => $setting->id,
                'fetch_type' => $fetchType,
                'status' => 'running',
                'started_at' => now(),
            ]);

            try {
                $feed = $this->feedProvider->fetch();
                $entries = is_array($feed['entries'] ?? null) ? $feed['entries'] : [];
                $count = count($entries);
                $ingestResult = $this->ingest->ingest($entries);
                $dispatchResult = $this->autoDispatch->dispatchEvents($ingestResult['created_events']);

                $log->fetched_count = $count;
                $log->created_event_count = $ingestResult['created_event_count'];
                $log->skipped_duplicate_count = $ingestResult['skipped_duplicate_count'];
                $log->status = 'success';
                $log->finished_at = now();
                $log->save();

                $setting->last_fetched_at = now();
                if ($setting->is_enabled) {
                    $setting->next_fetch_at = now()->addMinutes(max(1, (int) $setting->interval_minutes));
                }
                $setting->save();

                return [
                    'log' => $log->fresh(),
                    'fetched_count' => $count,
                    'entries' => $entries,
                    'created_event_count' => $ingestResult['created_event_count'],
                    'skipped_duplicate_count' => $ingestResult['skipped_duplicate_count'],
                    'created_notification_count' => $dispatchResult['created_notification_count'],
                    'skipped_notification_count' => $dispatchResult['skipped_notification_count'],
                ];
            } catch (\Throwable $e) {
                $log->status = 'failed';
                $log->error_message = $e->getMessage();
                $log->finished_at = now();
                $log->save();

                throw $e;
            }
        });
    }

    public function resolveSetting(): SonaeJmaFetchSetting
    {
        $setting = SonaeJmaFetchSetting::query()->orderBy('id')->first();
        if ($setting !== null) {
            return $setting;
        }

        return SonaeJmaFetchSetting::query()->create([
            'is_enabled' => false,
            'interval_minutes' => 5,
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    public function settingsPayload(): array
    {
        $setting = $this->resolveSetting();

        return [
            'id' => $setting->id,
            'is_enabled' => $setting->is_enabled,
            'interval_minutes' => $setting->interval_minutes,
            'last_fetched_at' => $setting->last_fetched_at?->toIso8601String(),
            'next_fetch_at' => $setting->next_fetch_at?->toIso8601String(),
        ];
    }

    /**
     * @param  array<string, mixed>  $input
     */
    public function updateSettings(array $input): SonaeJmaFetchSetting
    {
        $setting = $this->resolveSetting();

        if (array_key_exists('is_enabled', $input)) {
            $setting->is_enabled = (bool) $input['is_enabled'];
        }
        if (array_key_exists('interval_minutes', $input)) {
            $setting->interval_minutes = max(1, min(60, (int) $input['interval_minutes']));
        }
        $setting->save();

        return $setting->fresh();
    }
}
