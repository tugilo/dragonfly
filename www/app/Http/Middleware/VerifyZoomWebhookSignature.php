<?php

namespace App\Http\Middleware;

use App\Services\Zoom\ZoomWebhookSecretResolver;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Zoom Webhook の署名検証（SPEC-012 Phase D）。
 *
 * Zoom は x-zm-signature = "v0=" + HMAC-SHA256(secret, "v0:{timestamp}:{rawBody}") を送る。
 * secret は .env フォールバック + 全ユーザーの webhook_secret_token を順に試行する。
 * 一致した secret は request attribute `zoom_webhook_secret` に保存する。
 */
class VerifyZoomWebhookSignature
{
    public function __construct(private ZoomWebhookSecretResolver $secrets) {}

    public function handle(Request $request, Closure $next): Response
    {
        if (! $this->secrets->hasAnySecret()) {
            return response()->json(['message' => 'Zoom webhook secret not configured.'], 503);
        }

        $timestamp = (string) $request->header('x-zm-request-timestamp', '');
        $signature = (string) $request->header('x-zm-signature', '');
        if ($timestamp === '' || $signature === '') {
            return response()->json(['message' => 'Missing Zoom signature headers.'], 401);
        }

        $matched = $this->secrets->matchSecret($timestamp, $signature, $request->getContent());
        if ($matched === null) {
            return response()->json(['message' => 'Invalid Zoom signature.'], 401);
        }

        $request->attributes->set('zoom_webhook_secret', $matched);

        return $next($request);
    }
}
