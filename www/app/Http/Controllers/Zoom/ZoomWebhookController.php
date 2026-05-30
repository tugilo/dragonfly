<?php

namespace App\Http\Controllers\Zoom;

use App\Http\Controllers\Controller;
use App\Jobs\Zoom\FetchZoomSummaryJob;
use App\Jobs\Zoom\ProcessZoomMeetingEndedJob;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Zoom Webhook 受信（SPEC-012 Phase D）。署名は zoom.webhook ミドルウェアで検証済み。
 *
 * 対応イベント:
 * - endpoint.url_validation: 検証チャレンジに応答
 * - meeting.ended: 過去ミーティング候補を生成（ジョブ）
 * - recording.completed / meeting.summary_completed: 要約取得（ジョブ）
 */
class ZoomWebhookController extends Controller
{
    public function handle(Request $request): JsonResponse
    {
        $event = (string) $request->input('event', '');
        $payload = (array) $request->input('payload', []);
        $object = (array) ($payload['object'] ?? []);

        if ($event === 'endpoint.url_validation') {
            return $this->urlValidation($payload);
        }

        match ($event) {
            'meeting.ended' => ProcessZoomMeetingEndedJob::dispatch($object),
            'recording.completed', 'meeting.summary_completed' => FetchZoomSummaryJob::dispatch(
                isset($object['uuid']) ? (string) $object['uuid'] : null,
                isset($object['host_id']) ? (string) $object['host_id'] : null,
            ),
            default => null,
        };

        // 3 秒以内に 200/204 を返す（Zoom 要件）。
        return response()->json(['received' => true]);
    }

    /**
     * @param  array<string, mixed>  $payload
     */
    private function urlValidation(array $payload): JsonResponse
    {
        $plainToken = (string) ($payload['plainToken'] ?? '');
        $secret = (string) config('services.zoom.webhook_secret_token');
        $encryptedToken = hash_hmac('sha256', $plainToken, $secret);

        return response()->json([
            'plainToken' => $plainToken,
            'encryptedToken' => $encryptedToken,
        ]);
    }
}
