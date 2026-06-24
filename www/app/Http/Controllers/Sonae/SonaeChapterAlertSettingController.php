<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeAlertThresholdOption;
use App\Models\Sonae\SonaeAlertType;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeChapterAlertSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class SonaeChapterAlertSettingController extends Controller
{
    public function show(SonaeChapter $chapter): JsonResponse
    {
        return response()->json(['data' => $this->settingsPayload($chapter)]);
    }

    public function update(Request $request, SonaeChapter $chapter): JsonResponse
    {
        $validated = $request->validate([
            'settings' => ['required', 'array', 'min:1'],
            'settings.*.alert_type_code' => ['required', 'string', 'max:32'],
            'settings.*.is_enabled' => ['required', 'boolean'],
            'settings.*.threshold_code' => ['nullable', 'string', 'max:64'],
            'settings.*.target_prefectures' => ['nullable', 'array'],
            'settings.*.target_prefectures.*' => ['string', 'max:64'],
        ]);

        $settings = $validated['settings'] ?? [];
        foreach ($settings as $row) {
            $alertTypeCode = (string) ($row['alert_type_code'] ?? '');
            $alertType = SonaeAlertType::query()->where('code', $alertTypeCode)->first();
            if ($alertType === null) {
                throw ValidationException::withMessages([
                    'settings' => ["Unknown alert type: {$alertTypeCode}"],
                ]);
            }

            $thresholdCode = is_string($row['threshold_code'] ?? null) ? trim((string) $row['threshold_code']) : '';
            if ($thresholdCode !== '') {
                $hasThreshold = SonaeAlertThresholdOption::query()
                    ->where('alert_type_id', $alertType->id)
                    ->where('code', $thresholdCode)
                    ->where('is_active', true)
                    ->exists();
                if (! $hasThreshold) {
                    throw ValidationException::withMessages([
                        'settings' => ["Unknown threshold_code for {$alertTypeCode}: {$thresholdCode}"],
                    ]);
                }
            }

            $targetPrefectures = collect($row['target_prefectures'] ?? [])
                ->map(static fn ($value) => is_string($value) ? trim($value) : '')
                ->filter(static fn (string $value) => $value !== '')
                ->unique()
                ->values()
                ->all();

            SonaeChapterAlertSetting::query()->updateOrCreate(
                [
                    'chapter_id' => $chapter->id,
                    'alert_type_id' => $alertType->id,
                ],
                [
                    'is_enabled' => (bool) $row['is_enabled'],
                    'threshold_code' => $thresholdCode !== '' ? $thresholdCode : null,
                    'target_prefectures' => $targetPrefectures === [] ? null : $targetPrefectures,
                ]
            );
        }

        return response()->json(['data' => $this->settingsPayload($chapter->fresh())]);
    }

    /**
     * @return list<array<string, mixed>>
     */
    private function settingsPayload(SonaeChapter $chapter): array
    {
        $types = SonaeAlertType::query()
            ->where('is_active', true)
            ->orderBy('sort_order')
            ->orderBy('id')
            ->get();

        $settings = SonaeChapterAlertSetting::query()
            ->where('chapter_id', $chapter->id)
            ->get()
            ->keyBy('alert_type_id');

        return $types->map(function (SonaeAlertType $type) use ($settings) {
            $setting = $settings->get($type->id);
            $options = SonaeAlertThresholdOption::query()
                ->where('alert_type_id', $type->id)
                ->where('is_active', true)
                ->orderBy('sort_order')
                ->orderBy('id')
                ->get()
                ->map(fn (SonaeAlertThresholdOption $option) => [
                    'code' => $option->code,
                    'label' => $option->label,
                    'severity_rank' => $option->severity_rank,
                ])
                ->values()
                ->all();

            return [
                'alert_type_id' => $type->id,
                'alert_type_code' => $type->code,
                'alert_type_name' => $type->name,
                'is_enabled' => (bool) ($setting?->is_enabled ?? false),
                'threshold_code' => $setting?->threshold_code,
                'target_prefectures' => $setting?->target_prefectures ?? [],
                'threshold_options' => $options,
            ];
        })->values()->all();
    }
}
