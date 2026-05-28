<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken;
use Symfony\Component\HttpFoundation\Response;

/**
 * Authorization Bearer が付いているのに PAT として解決できない場合は 401。
 * 無効・失効トークンで従来の「先頭ユーザー」フォールバックに落ちるのを防ぐ。
 */
class RejectInvalidSanctumBearerToken
{
    public function handle(Request $request, Closure $next): Response
    {
        $plain = $request->bearerToken();
        if ($plain === null || $plain === '') {
            return $next($request);
        }

        if (PersonalAccessToken::findToken($plain) === null) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        return $next($request);
    }
}
