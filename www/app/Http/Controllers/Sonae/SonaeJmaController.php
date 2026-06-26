<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeJmaFetchLog;
use App\Services\Sonae\Jma\SonaeJmaFetchService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SonaeJmaController extends Controller
{
    public function showSettings(SonaeJmaFetchService $fetch): JsonResponse
    {
        return response()->json(['data' => $fetch->settingsPayload()]);
    }

    public function updateSettings(Request $request, SonaeJmaFetchService $fetch): JsonResponse
    {
        $validated = $request->validate([
            'is_enabled' => ['sometimes', 'boolean'],
            'interval_minutes' => ['sometimes', 'integer', 'min:1', 'max:60'],
        ]);

        $setting = $fetch->updateSettings($validated);

        return response()->json([
            'data' => [
                'id' => $setting->id,
                'is_enabled' => $setting->is_enabled,
                'interval_minutes' => $setting->interval_minutes,
                'last_fetched_at' => $setting->last_fetched_at?->toIso8601String(),
                'next_fetch_at' => $setting->next_fetch_at?->toIso8601String(),
            ],
        ]);
    }

    public function fetchManual(SonaeJmaFetchService $fetch): JsonResponse
    {
        $result = $fetch->run('manual');

        return response()->json([
            'data' => [
                'log_id' => $result['log']->id,
                'fetched_count' => $result['fetched_count'],
                'created_event_count' => $result['created_event_count'] ?? 0,
                'skipped_duplicate_count' => $result['skipped_duplicate_count'] ?? 0,
                'created_notification_count' => $result['created_notification_count'] ?? 0,
                'status' => $result['log']->status,
            ],
        ]);
    }

    public function logs(Request $request): JsonResponse
    {
        $limit = min(50, max(1, (int) $request->query('limit', 20)));

        $logs = SonaeJmaFetchLog::query()
            ->orderByDesc('started_at')
            ->orderByDesc('id')
            ->limit($limit)
            ->get()
            ->map(fn (SonaeJmaFetchLog $log) => [
                'id' => $log->id,
                'fetch_type' => $log->fetch_type,
                'status' => $log->status,
                'started_at' => $log->started_at?->toIso8601String(),
                'finished_at' => $log->finished_at?->toIso8601String(),
                'fetched_count' => $log->fetched_count,
                'created_event_count' => $log->created_event_count,
                'skipped_duplicate_count' => $log->skipped_duplicate_count,
                'error_message' => $log->error_message,
            ]);

        return response()->json(['data' => $logs]);
    }
}
