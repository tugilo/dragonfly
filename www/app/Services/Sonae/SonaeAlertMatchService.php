<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeAlertEvent;
use App\Models\Sonae\SonaeAlertThresholdOption;
use App\Models\Sonae\SonaeChapterAlertSetting;

class SonaeAlertMatchService
{
    /**
     * @return list<SonaeChapterAlertSetting>
     */
    public function matchEnabledSettings(SonaeAlertEvent $event): array
    {
        $settings = SonaeChapterAlertSetting::query()
            ->with(['chapter', 'alertType'])
            ->where('alert_type_id', $event->alert_type_id)
            ->where('is_enabled', true)
            ->orderBy('id')
            ->get();

        $eventSeverityRank = $this->eventSeverityRank($event);
        $eventPrefectures = $this->eventPrefectures($event);

        $matched = [];
        foreach ($settings as $setting) {
            if (! $this->matchesThreshold($setting, $eventSeverityRank)) {
                continue;
            }
            if (! $this->matchesPrefectures($setting, $eventPrefectures)) {
                continue;
            }
            $matched[] = $setting;
        }

        return $matched;
    }

    private function eventSeverityRank(SonaeAlertEvent $event): ?int
    {
        $raw = $event->raw_payload;
        $rank = is_array($raw) ? ($raw['severity_rank'] ?? null) : null;
        if (is_int($rank)) {
            return $rank;
        }
        if (is_string($rank) && is_numeric($rank)) {
            return (int) $rank;
        }

        return null;
    }

    /**
     * @return list<string>
     */
    private function eventPrefectures(SonaeAlertEvent $event): array
    {
        return $event->areas()
            ->whereNotNull('prefecture')
            ->pluck('prefecture')
            ->map(static fn ($prefecture) => is_string($prefecture) ? trim($prefecture) : '')
            ->filter(static fn (string $prefecture) => $prefecture !== '')
            ->unique()
            ->values()
            ->all();
    }

    private function matchesThreshold(SonaeChapterAlertSetting $setting, ?int $eventSeverityRank): bool
    {
        $thresholdCode = is_string($setting->threshold_code) ? trim($setting->threshold_code) : '';
        if ($thresholdCode === '') {
            return true;
        }
        if ($eventSeverityRank === null) {
            return false;
        }

        $option = SonaeAlertThresholdOption::query()
            ->where('alert_type_id', $setting->alert_type_id)
            ->where('code', $thresholdCode)
            ->where('is_active', true)
            ->first();

        if ($option === null || $option->severity_rank === null) {
            return false;
        }

        return $eventSeverityRank >= (int) $option->severity_rank;
    }

    /**
     * @param  list<string>  $eventPrefectures
     */
    private function matchesPrefectures(SonaeChapterAlertSetting $setting, array $eventPrefectures): bool
    {
        $targetPrefectures = collect($setting->target_prefectures ?? [])
            ->map(static fn ($value) => is_string($value) ? trim($value) : '')
            ->filter(static fn (string $value) => $value !== '')
            ->unique()
            ->values()
            ->all();

        if ($targetPrefectures === []) {
            return true;
        }
        if ($eventPrefectures === []) {
            return false;
        }

        foreach ($eventPrefectures as $eventPrefecture) {
            if (in_array($eventPrefecture, $targetPrefectures, true)) {
                return true;
            }
        }

        return false;
    }
}
