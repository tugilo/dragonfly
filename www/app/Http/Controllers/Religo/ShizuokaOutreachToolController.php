<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\File;

/**
 * 静岡合同懇親会 お礼・121案内ツール（本人専用・認証必須）。
 */
class ShizuokaOutreachToolController extends Controller
{
    public function show(): Response
    {
        $user = ReligoActorContext::actingUser();
        if (! $user) {
            return response('Unauthorized', 401);
        }

        $allowedOwnerId = (int) config('religo.shizuoka_outreach_owner_member_id', 37);
        $ownerId = $user->owner_member_id !== null ? (int) $user->owner_member_id : null;
        if ($ownerId !== $allowedOwnerId) {
            return response('Forbidden', 403);
        }

        $path = resource_path('private/tools/bni-shizuoka-joint-social-outreach.html');
        if (! File::isFile($path)) {
            return response('Not found', 404);
        }

        return response(File::get($path), 200, [
            'Content-Type' => 'text/html; charset=UTF-8',
            'Cache-Control' => 'no-store',
        ]);
    }
}
