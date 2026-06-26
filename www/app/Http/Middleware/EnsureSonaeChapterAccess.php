<?php

namespace App\Http\Middleware;

use App\Models\Sonae\SonaeChapter;
use App\Services\Religo\ReligoActorContext;
use App\Services\Sonae\SonaeChapterResolver;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * SPEC-017 Phase 248: 認証ユーザーの workspace に紐づく SONAE chapter のみ許可。
 */
class EnsureSonaeChapterAccess
{
    public function __construct(
        private readonly SonaeChapterResolver $resolver,
    ) {}

    public function handle(Request $request, Closure $next): Response
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $workspaceId = $this->resolver->resolveWorkspaceIdForUser($user);
        if ($workspaceId === null) {
            return response()->json(['message' => 'Workspace is not configured for this user.'], 422);
        }

        $expectedChapter = $this->resolver->findByWorkspaceId($workspaceId);
        if ($expectedChapter === null) {
            return response()->json([
                'message' => 'SONAE chapter is not bootstrapped for this workspace.',
                'bootstrap_required' => true,
            ], 404);
        }

        /** @var SonaeChapter|null $routeChapter */
        $routeChapter = $request->route('chapter');
        if ($routeChapter instanceof SonaeChapter && $routeChapter->id !== $expectedChapter->id) {
            return response()->json(['message' => 'Forbidden chapter access.'], 403);
        }

        $request->attributes->set('sonae_chapter', $expectedChapter);
        $request->attributes->set('sonae_workspace_id', $workspaceId);

        return $next($request);
    }
}
