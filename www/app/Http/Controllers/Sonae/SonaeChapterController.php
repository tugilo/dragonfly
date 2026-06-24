<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeChapter;
use App\Services\Sonae\SonaeMemberService;
use Illuminate\Http\JsonResponse;

class SonaeChapterController extends Controller
{
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
