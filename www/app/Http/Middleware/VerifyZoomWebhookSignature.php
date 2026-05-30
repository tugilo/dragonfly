<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Zoom Webhook の署名検証（SPEC-012 Phase D）。
 *
 * Zoom は x-zm-signature = "v0=" + HMAC-SHA256(secret, "v0:{timestamp}:{rawBody}") を送る。
 * ZOOM_WEBHOOK_SECRET_TOKEN 未設定時は 503（誤って公開しないため）。
 */
class VerifyZoomWebhookSignature
{
    public function handle(Request $request, Closure $next): Response
    {
        $secret = (string) config('services.zoom.webhook_secret_token');
        if ($secret === '') {
            return response()->json(['message' => 'Zoom webhook secret not configured.'], 503);
        }

        $timestamp = (string) $request->header('x-zm-request-timestamp', '');
        $signature = (string) $request->header('x-zm-signature', '');
        if ($timestamp === '' || $signature === '') {
            return response()->json(['message' => 'Missing Zoom signature headers.'], 401);
        }

        $message = 'v0:'.$timestamp.':'.$request->getContent();
        $expected = 'v0='.hash_hmac('sha256', $message, $secret);

        if (! hash_equals($expected, $signature)) {
            return response()->json(['message' => 'Invalid Zoom signature.'], 401);
        }

        return $next($request);
    }
}
