<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Services\Religo\ReligoActorContext;
use App\Services\Sonae\SonaeBootstrapService;
use App\Services\Sonae\SonaeChapterResolver;
use App\Services\Sonae\SonaeMemberService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SonaeChapterController extends Controller
{
    public function context(SonaeChapterResolver $resolver, SonaeMemberService $members): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        $workspaceId = $resolver->resolveWorkspaceIdForUser($user);
        $workspace = $resolver->workspaceForUser($user);
        $chapter = $resolver->resolveChapterForUser($user);

        $chapterPayload = null;
        if ($chapter !== null) {
            $chapterPayload = $this->chapterPayload($chapter, $members);
        }

        return response()->json([
            'data' => [
                'workspace_id' => $workspaceId,
                'workspace_name' => $workspace?->name,
                'chapter' => $chapterPayload,
                'bootstrap_required' => $workspaceId !== null && $chapter === null,
            ],
        ]);
    }

    public function bootstrap(Request $request, SonaeBootstrapService $bootstrap, SonaeChapterResolver $resolver, SonaeMemberService $members): JsonResponse
    {
        $workspace = $resolver->workspaceForUser(ReligoActorContext::actingUser());
        if ($workspace === null) {
            return response()->json(['message' => 'Workspace is not configured for this user.'], 422);
        }

        $validated = $request->validate([
            'prefecture' => ['sometimes', 'nullable', 'string', 'max:64'],
        ]);

        $result = $bootstrap->bootstrapFromWorkspace(
            $workspace,
            $validated['prefecture'] ?? null
        );

        return response()->json([
            'data' => [
                'chapter' => $this->chapterPayload($result['chapter'], $members),
                'members_synced' => $result['members_synced'],
            ],
        ], 201);
    }

    public function resolve(Request $request, SonaeChapterResolver $resolver): JsonResponse
    {
        $workspaceId = $request->query('workspace_id');
        if ($workspaceId === null || $workspaceId === '') {
            return response()->json(['message' => 'workspace_id is required.'], 422);
        }

        $chapter = $resolver->findByWorkspaceId((int) $workspaceId);

        if ($chapter === null) {
            return response()->json([
                'message' => 'SONAE chapter not found for this workspace. Run: php artisan sonae:bootstrap-dragonfly',
            ], 404);
        }

        return response()->json([
            'data' => [
                'id' => $chapter->id,
                'name' => $chapter->name,
                'chapter_key' => $chapter->chapter_key,
                'religo_linked' => $chapter->isReligoLinked(),
            ],
        ]);
    }

    public function show(SonaeChapter $chapter, SonaeMemberService $members): JsonResponse
    {
        $kpi = $members->chapterKpi($chapter);

        return response()->json([
            'data' => [
                'id' => $chapter->id,
                'name' => $chapter->name,
                'code' => $chapter->code,
                'chapter_key' => $chapter->chapter_key,
                'source_system' => $chapter->source_system,
                'external_id' => $chapter->external_id,
                'prefecture' => $chapter->prefecture,
                'status' => $chapter->status,
                'religo_linked' => $chapter->isReligoLinked(),
                'kpi' => $kpi,
            ],
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    private function chapterPayload(SonaeChapter $chapter, SonaeMemberService $members): array
    {
        return [
            'id' => $chapter->id,
            'name' => $chapter->name,
            'code' => $chapter->code,
            'chapter_key' => $chapter->chapter_key,
            'source_system' => $chapter->source_system,
            'external_id' => $chapter->external_id,
            'prefecture' => $chapter->prefecture,
            'status' => $chapter->status,
            'religo_linked' => $chapter->isReligoLinked(),
            'kpi' => $members->chapterKpi($chapter),
        ];
    }
}
