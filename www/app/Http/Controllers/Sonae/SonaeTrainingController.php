<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeAlertNotification;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeTrainingEvent;
use App\Services\Sonae\SonaeAggregationService;
use App\Services\Sonae\SonaeTrainingDispatchService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SonaeTrainingController extends Controller
{
    public function dispatch(
        Request $request,
        SonaeChapter $chapter,
        SonaeTrainingDispatchService $dispatch
    ): JsonResponse {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'title' => ['sometimes', 'nullable', 'string', 'max:255'],
            'body' => ['sometimes', 'nullable', 'string', 'max:2000'],
        ]);

        try {
            // PoC: Religo Sanctum users は sonae_users と未連携のため null（Phase 242 PLAN）。
            $result = $dispatch->dispatch($chapter, $validated, null);
        } catch (\RuntimeException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        return response()->json([
            'data' => [
                'training_event_id' => $result['training_event']->id,
                'notification_id' => $result['notification']->id,
                'sent' => $result['sent'],
                'failed' => $result['failed'],
            ],
        ], 201);
    }

    public function index(SonaeChapter $chapter, SonaeAggregationService $aggregation): JsonResponse
    {
        $trainings = SonaeTrainingEvent::query()
            ->where('chapter_id', $chapter->id)
            ->orderByDesc('executed_at')
            ->orderByDesc('id')
            ->get()
            ->map(function (SonaeTrainingEvent $training) use ($aggregation, $chapter) {
                return [
                    'id' => $training->id,
                    'name' => $training->name,
                    'executed_at' => $training->executed_at?->toIso8601String(),
                    'response_rate' => $aggregation->responseRateForTraining($training),
                    'comparison' => $aggregation->previousTrainingComparison($chapter, $training),
                ];
            });

        return response()->json(['data' => $trainings]);
    }

    public function summary(
        SonaeChapter $chapter,
        SonaeAlertNotification $notification,
        SonaeAggregationService $aggregation
    ): JsonResponse {
        if ($notification->chapter_id !== $chapter->id) {
            abort(404);
        }

        return response()->json([
            'data' => [
                'summary' => $aggregation->summarizeNotification($notification),
                'unanswered' => $aggregation->listUnanswered($notification),
            ],
        ]);
    }
}
