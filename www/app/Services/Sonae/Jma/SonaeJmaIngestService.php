<?php

namespace App\Services\Sonae\Jma;

use App\Models\Sonae\SonaeAlertEvent;
use App\Models\Sonae\SonaeAlertType;
use Illuminate\Database\QueryException;

class SonaeJmaIngestService
{
    public function __construct(
        private readonly SonaeJmaNormalizerRegistry $normalizers,
    ) {}

    /**
     * @param  list<array<string, mixed>>  $entries
     * @return array{created_events: list<SonaeAlertEvent>, created_event_count: int, skipped_duplicate_count: int}
     */
    public function ingest(array $entries): array
    {
        $createdEvents = [];
        $createdEventCount = 0;
        $skippedDuplicateCount = 0;

        foreach ($entries as $entry) {
            $normalized = $this->normalizers->normalizeEntry($entry);
            if ($normalized === null) {
                continue;
            }

            $sourceEventKey = (string) ($normalized['source_event_key'] ?? '');
            if ($sourceEventKey === '') {
                continue;
            }

            if (SonaeAlertEvent::query()->where('source_event_key', $sourceEventKey)->exists()) {
                $skippedDuplicateCount++;
                continue;
            }

            $alertTypeCode = (string) ($normalized['alert_type_code'] ?? '');
            $alertType = SonaeAlertType::query()->where('code', $alertTypeCode)->first();
            if ($alertType === null) {
                continue;
            }

            $rawPayload = is_array($normalized['raw_payload'] ?? null) ? $normalized['raw_payload'] : $entry;
            if (array_key_exists('severity_rank', $normalized)) {
                $rawPayload['severity_rank'] = $normalized['severity_rank'];
            }

            try {
                $event = SonaeAlertEvent::query()->create([
                    'alert_type_id' => $alertType->id,
                    'source' => 'jma',
                    'source_event_key' => $sourceEventKey,
                    'payload_hash' => hash('sha256', json_encode($rawPayload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) ?: ''),
                    'title' => (string) ($normalized['title'] ?? $sourceEventKey),
                    'severity' => is_string($normalized['severity'] ?? null) ? $normalized['severity'] : null,
                    'occurred_at' => is_string($normalized['occurred_at'] ?? null) ? $normalized['occurred_at'] : null,
                    'announced_at' => is_string($normalized['announced_at'] ?? null) ? $normalized['announced_at'] : null,
                    'raw_payload' => $rawPayload,
                ]);
            } catch (QueryException $e) {
                // source_event_key unique 制約の競合は重複スキップとして扱う。
                $sqlState = $e->errorInfo[0] ?? null;
                if ($sqlState === '23000') {
                    $skippedDuplicateCount++;
                    continue;
                }
                throw $e;
            }

            $areas = is_array($normalized['areas'] ?? null) ? $normalized['areas'] : [];
            foreach ($areas as $area) {
                if (! is_array($area)) {
                    continue;
                }
                $event->areas()->create([
                    'prefecture' => is_string($area['prefecture'] ?? null) ? $area['prefecture'] : null,
                    'municipality' => is_string($area['municipality'] ?? null) ? $area['municipality'] : null,
                    'area_code' => is_string($area['area_code'] ?? null) ? $area['area_code'] : null,
                    'intensity' => is_string($area['intensity'] ?? null) ? $area['intensity'] : null,
                    'warning_level' => is_string($area['warning_level'] ?? null) ? $area['warning_level'] : null,
                ]);
            }

            $createdEvents[] = $event->fresh(['areas', 'alertType']);
            $createdEventCount++;
        }

        return [
            'created_events' => $createdEvents,
            'created_event_count' => $createdEventCount,
            'skipped_duplicate_count' => $skippedDuplicateCount,
        ];
    }
}
