<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * RELIGO_MEMBER_MERGE_TOKEN と X-Religo-Member-Merge-Token ヘッダを照合。
 * トークン未設定時は 404（エンドポイント非公開）。
 */
final class VerifyReligoMemberMergeToken
{
    public function handle(Request $request, Closure $next): Response
    {
        $configured = config('religo.member_merge_token');
        if (! is_string($configured) || $configured === '') {
            abort(404);
        }

        $sent = $request->header('X-Religo-Member-Merge-Token', '');
        if (! is_string($sent) || ! hash_equals($configured, $sent)) {
            abort(403, 'Invalid or missing member merge token.');
        }

        return $next($request);
    }
}
