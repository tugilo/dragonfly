<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeMember;
use App\Models\Workspace;
use App\Services\Sonae\SonaeCsvImportService;
use App\Services\Sonae\SonaeMemberService;
use App\Services\Sonae\SonaeMemberSyncService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use InvalidArgumentException;

class SonaeMemberController extends Controller
{
    public function index(SonaeChapter $chapter, SonaeMemberService $members, Request $request): JsonResponse
    {
        $paginator = $members->listMembers($chapter, (int) $request->query('per_page', 50));

        return response()->json([
            'data' => collect($paginator->items())
                ->map(fn (SonaeMember $member) => $members->memberToArray($member))
                ->values(),
            'meta' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ],
        ]);
    }

    public function unlinked(SonaeChapter $chapter, SonaeMemberService $members): JsonResponse
    {
        $rows = $members->listUnlinkedMembers($chapter)
            ->map(fn (SonaeMember $member) => $members->memberToArray($member))
            ->values();

        return response()->json(['data' => $rows]);
    }

    public function update(
        Request $request,
        SonaeChapter $chapter,
        SonaeMember $member,
        SonaeMemberService $members
    ): JsonResponse {
        $this->assertMemberBelongsToChapter($chapter, $member);

        $validated = $request->validate([
            'name' => ['sometimes', 'string', 'max:255'],
            'name_kana' => ['sometimes', 'nullable', 'string', 'max:255'],
            'email' => ['sometimes', 'nullable', 'email', 'max:255'],
            'phone' => ['sometimes', 'nullable', 'string', 'max:50'],
            'category' => ['sometimes', 'nullable', 'string', 'max:255'],
            'role_label' => ['sometimes', 'nullable', 'string', 'max:255'],
            'status' => ['sometimes', 'string', 'in:active,inactive'],
        ]);

        $updated = $members->updateMember($member, $validated);

        return response()->json(['data' => $members->memberToArray($updated)]);
    }

    public function sync(SonaeChapter $chapter, SonaeMemberSyncService $sync): JsonResponse
    {
        if (! $chapter->isReligoLinked()) {
            return response()->json([
                'message' => 'This chapter is not linked to Religo.',
            ], 422);
        }

        $workspace = Workspace::query()->find($chapter->external_id);
        if ($workspace === null) {
            return response()->json([
                'message' => 'Religo workspace not found for this chapter.',
            ], 422);
        }

        $result = $sync->syncChapterFromReligo($chapter, $workspace);

        return response()->json(['data' => $result]);
    }

    public function importCsv(
        Request $request,
        SonaeChapter $chapter,
        SonaeCsvImportService $csvImport,
        SonaeMemberService $members
    ): JsonResponse {
        $request->validate([
            'csv' => ['required', 'file', 'max:2048'],
        ]);

        $content = (string) file_get_contents($request->file('csv')->getRealPath());

        try {
            $rows = $csvImport->parse($content);
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        $validation = $csvImport->validateRows($rows);

        if ($request->boolean('preview')) {
            return response()->json([
                'preview' => true,
                'valid_rows' => $validation['valid'],
                'errors' => $validation['errors'],
                'kpi' => $members->chapterKpi($chapter),
            ]);
        }

        $result = $csvImport->importValidRows($chapter, $validation['valid']);

        return response()->json([
            'preview' => false,
            'imported' => $result['imported'],
            'updated' => $result['updated'],
            'errors' => $validation['errors'],
            'kpi' => $members->chapterKpi($chapter),
        ]);
    }

    private function assertMemberBelongsToChapter(SonaeChapter $chapter, SonaeMember $member): void
    {
        if ($member->chapter_id !== $chapter->id) {
            abort(404);
        }
    }
}
