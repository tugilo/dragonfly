<?php

namespace App\Http\Middleware;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeLineAccount;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * SPEC-017 §10.3: LINE Webhook 署名検証（chapter_key 単位）。
 */
class VerifySonaeLineWebhookSignature
{
    public function handle(Request $request, Closure $next): Response
    {
        $chapterKey = (string) $request->route('chapter_key');
        $chapter = SonaeChapter::query()->where('chapter_key', $chapterKey)->first();
        if ($chapter === null) {
            return response()->json(['message' => 'Chapter not found.'], 404);
        }

        $lineAccount = SonaeLineAccount::query()->where('chapter_id', $chapter->id)->first();
        if ($lineAccount === null) {
            return response()->json(['message' => 'LINE account not configured.'], 404);
        }

        $secret = $lineAccount->readEncryptedAttribute('channel_secret_encrypted');
        if ($secret === null || $secret === '') {
            return response()->json(['message' => 'Channel secret not configured.'], 422);
        }

        $signature = (string) $request->header('X-Line-Signature', '');
        $body = (string) $request->getContent();
        $expected = base64_encode(hash_hmac('sha256', $body, $secret, true));

        if ($signature === '' || ! hash_equals($expected, $signature)) {
            return response()->json(['message' => 'Invalid signature.'], 403);
        }

        $request->attributes->set('sonae_chapter', $chapter);
        $request->attributes->set('sonae_line_account', $lineAccount);

        return $next($request);
    }
}
