<?php

namespace App\Http\Middleware;

use App\Models\User;
use App\Services\Religo\ReligoActorContext;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * acting user の religo_role が chapter_admin のみ通す（SPEC-010 管理 API）。
 */
class EnsureReligoChapterAdmin
{
    public function handle(Request $request, Closure $next): Response
    {
        $actor = ReligoActorContext::actingUser();
        $role = $actor?->religo_role ?? User::RELIGO_ROLE_MEMBER;
        if ($role !== User::RELIGO_ROLE_CHAPTER_ADMIN) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        return $next($request);
    }
}
