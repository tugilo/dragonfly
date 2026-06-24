<?php

namespace App\Services\Sonae\Jma\Normalizers;

use App\Services\Sonae\Jma\SonaeJmaNormalizerInterface;
use Carbon\CarbonImmutable;

abstract class AbstractSonaeJmaTypeNormalizer implements SonaeJmaNormalizerInterface
{
    abstract protected function typeCode(): string;

    public function supports(array $entry): bool
    {
        return ($entry['type'] ?? null) === $this->typeCode();
    }

    public function normalize(array $entry): ?array
    {
        $sourceEventKey = $this->asString($entry['source_event_key'] ?? null);
        if ($sourceEventKey === null || $sourceEventKey === '') {
            return null;
        }

        $areas = [];
        $rawAreas = $entry['areas'] ?? [];
        if (is_array($rawAreas)) {
            foreach ($rawAreas as $rawArea) {
                if (! is_array($rawArea)) {
                    continue;
                }
                $areas[] = [
                    'prefecture' => $this->asString($rawArea['prefecture'] ?? null),
                    'municipality' => $this->asString($rawArea['municipality'] ?? null),
                    'area_code' => $this->asString($rawArea['area_code'] ?? null),
                    'intensity' => $this->asString($rawArea['intensity'] ?? null),
                    'warning_level' => $this->asString($rawArea['warning_level'] ?? null),
                ];
            }
        }

        $title = $this->asString($entry['title'] ?? null) ?? strtoupper($this->typeCode());
        $severity = $this->asString($entry['severity'] ?? null);
        $severityRank = $this->asInt($entry['severity_rank'] ?? null);

        return [
            'alert_type_code' => $this->typeCode(),
            'source_event_key' => $sourceEventKey,
            'title' => $title,
            'severity' => $severity,
            'severity_rank' => $severityRank,
            'occurred_at' => $this->toIso8601($entry['occurred_at'] ?? null),
            'announced_at' => $this->toIso8601($entry['announced_at'] ?? null),
            'areas' => $areas,
            'raw_payload' => $entry,
        ];
    }

    private function asString(mixed $value): ?string
    {
        if (! is_string($value)) {
            return null;
        }
        $trimmed = trim($value);

        return $trimmed === '' ? null : $trimmed;
    }

    private function asInt(mixed $value): ?int
    {
        if (is_int($value)) {
            return $value;
        }
        if (is_string($value) && is_numeric($value)) {
            return (int) $value;
        }

        return null;
    }

    private function toIso8601(mixed $value): ?string
    {
        $text = $this->asString($value);
        if ($text === null) {
            return null;
        }

        try {
            return CarbonImmutable::parse($text)->toIso8601String();
        } catch (\Throwable) {
            return null;
        }
    }
}
