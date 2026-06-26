<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeMember;
use App\Services\Sonae\SonaeLineAccountService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SonaeLineAccountController extends Controller
{
    public function show(SonaeChapter $chapter, SonaeLineAccountService $accounts): JsonResponse
    {
        $account = $chapter->lineAccount;
        if ($account === null) {
            return response()->json(['message' => 'LINE account not found.'], 404);
        }

        return response()->json([
            'data' => $accounts->toArray($account, $chapter),
        ]);
    }

    public function update(Request $request, SonaeChapter $chapter, SonaeLineAccountService $accounts): JsonResponse
    {
        $validated = $request->validate([
            'channel_id' => ['sometimes', 'string', 'max:255'],
            'channel_secret' => ['sometimes', 'nullable', 'string'],
            'messaging_api_access_token' => ['sometimes', 'nullable', 'string'],
            'friend_add_url' => ['sometimes', 'nullable', 'url', 'max:2048'],
            'status' => ['sometimes', 'string', 'in:active,inactive'],
        ]);

        $account = $accounts->update($chapter, $validated);

        return response()->json([
            'data' => $accounts->toArray($account, $chapter),
        ]);
    }
}
