<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Services\Sonae\SonaeMemberService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SonaeChapterController extends Controller
{
    public function resolve(Request $request): JsonResponse
    {
        $workspaceId = $request->query('workspace_id');
        if ($workspaceId === null || $workspaceId === '') {
            return response()->json(['message' => 'workspace_id is required.'], 422);
        }

        $chapter = SonaeChapter::query()
            ->where('source_system', SonaeConstants::SOURCE_RELIGO)
            ->where('external_id', (string) $workspaceId)
            ->first();

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
}
