<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeLineAccount;
use App\Services\Sonae\SonaeLineWebhookService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SonaeLineWebhookController extends Controller
{
    public function handle(Request $request, SonaeLineWebhookService $webhookService): JsonResponse
    {
        /** @var SonaeChapter $chapter */
        $chapter = $request->attributes->get('sonae_chapter');
        /** @var SonaeLineAccount $lineAccount */
        $lineAccount = $request->attributes->get('sonae_line_account');

        $payload = $request->json()->all();
        $webhookService->handle($chapter, $lineAccount, $payload);

        return response()->json(['received' => true]);
    }
}
