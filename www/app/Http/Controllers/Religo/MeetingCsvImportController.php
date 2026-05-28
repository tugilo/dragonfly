<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Meeting;
use App\Models\MeetingCsvApplyLog;
use App\Models\MeetingCsvImport;
use App\Models\MeetingCsvImportResolution;
use App\Models\Member;
use App\Models\Role;
use App\Services\Religo\ApplyMeetingCsvImportService;
use App\Services\Religo\ApplyMeetingCsvMemberDiffService;
use App\Services\Religo\ApplyMeetingCsvRoleDiffService;
use App\Services\Religo\MeetingCsvApplyLogWriter;
use App\Services\Religo\MeetingCsvDiffPreviewService;
use App\Services\Religo\MeetingCsvMemberDiffPreviewService;
use App\Services\Religo\MeetingCsvMemberResolver;
use App\Services\Religo\MeetingCsvPreviewService;
use App\Services\Religo\MeetingCsvRoleDiffPreviewService;
use App\Services\Religo\CsvResolutionSuggestionService;
use App\Services\Religo\MeetingCsvUnresolvedSummaryService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

/**
 * M7-C1: 参加者CSVを Meeting に紐づけてアップロード・保存する。パース・反映は行わない。
 * M7-C2: 保存済みCSVのプレビューを返す。
 */
class MeetingCsvImportController extends Controller
{
    private const DISK = 'local';

    private const DIRECTORY = 'meeting_csv_imports';

    /** 参加者CSVの「種別」が有効な行（プレビュー行への同名警告付与に使用） */
    private const CSV_PARTICIPANT_TYPE_ROWS = [
        'メンバー' => true,
        'ビジター' => true,
        'ゲスト' => true,
        '代理出席' => true,
    ];

    /**
     * POST /api/meetings/{meetingId}/csv-import
     * CSV をアップロードし、meeting_csv_imports に保存する。
     */
    public function store(Request $request, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $request->validate([
            'csv' => ['required', 'file', 'mimes:csv,txt', 'mimetypes:text/csv,text/plain', 'max:5120'],
        ], [
            'csv.required' => 'CSVファイルを選択してください。',
            'csv.mimes' => 'CSVまたはテキストファイルのみアップロードできます。',
            'csv.max' => 'ファイルサイズは5MB以内にしてください。',
        ]);

        $file = $request->file('csv');
        $originalName = $file->getClientOriginalName();
        $safeName = preg_replace('/[^\p{L}\p{N}\s._-]/u', '_', $originalName) ?: 'import.csv';
        $timestamp = now()->format('YmdHis');
        $path = $file->storeAs(
            self::DIRECTORY . '/' . $meetingId,
            $timestamp . '_' . $safeName,
            self::DISK
        );

        $import = MeetingCsvImport::create([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'file_name' => $originalName,
            'uploaded_at' => now(),
        ]);

        return response()->json([
            'id' => $import->id,
            'file_name' => $originalName,
            'uploaded_at' => $import->uploaded_at->toIso8601String(),
        ], 201);
    }

    /**
     * GET /api/meetings/{meetingId}/csv-import/preview
     * 紐づく最新CSVを読み込み、プレビュー用の headers / rows / row_count を返す。
     */
    public function preview(
        MeetingCsvPreviewService $previewService,
        MeetingCsvMemberResolver $memberResolver,
        int $meetingId
    ): JsonResponse {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        $fullPath = Storage::disk(self::DISK)->path($import->file_path);
        if (! is_readable($fullPath)) {
            return response()->json(['message' => 'CSVファイルが見つかりません。'], 404);
        }

        try {
            $result = $previewService->preview($fullPath);
            $rows = $result['rows'] ?? [];
            foreach ($rows as $i => $row) {
                $name = isset($row['name']) ? trim((string) $row['name']) : '';
                $typeRaw = isset($row['type']) ? trim((string) $row['type']) : '';
                if ($name === '' || ! isset(self::CSV_PARTICIPANT_TYPE_ROWS[$typeRaw])) {
                    $rows[$i]['duplicate_name_warning'] = false;
                    $rows[$i]['duplicate_count'] = 0;
                    $rows[$i]['duplicate_candidates'] = [];
                    continue;
                }
                $meta = $memberResolver->resolveExistingWithMeta($import->id, $name);
                $rows[$i]['duplicate_name_warning'] = (bool) $meta['duplicate_name_warning'];
                $rows[$i]['duplicate_count'] = (int) $meta['exact_name_match_count'];
                $rows[$i]['duplicate_candidates'] = $meta['duplicate_candidates'];
            }
            $result['rows'] = $rows;

            return response()->json($result);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404 || $code === 422) {
                return response()->json(['message' => $e->getMessage()], $code);
            }
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /**
     * GET /api/meetings/{meetingId}/csv-import/diff-preview
     * 紐づく最新CSVと既存 participants の差分を返す。名前解決 → member_id ベース。No は識別に使わない。
     */
    public function diffPreview(MeetingCsvDiffPreviewService $diffService, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        try {
            $result = $diffService->diffPreview($meeting, $import);
            return response()->json($result);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404) {
                return response()->json(['message' => $e->getMessage()], 404);
            }
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /**
     * GET /api/meetings/{meetingId}/csv-import/member-diff-preview
     * 最新 CSV と既存 members の基本情報（名前・よみがな・カテゴリー）差分候補を返す。更新は行わない。
     */
    public function memberDiffPreview(MeetingCsvMemberDiffPreviewService $memberDiffService, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        try {
            $result = $memberDiffService->memberDiffPreview($meeting, $import);
            return response()->json($result);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404) {
                return response()->json(['message' => $e->getMessage()], 404);
            }
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /**
     * GET /api/meetings/{meetingId}/csv-import/role-diff-preview
     * CSV 役職列と current role（member_roles 由来）の差分候補を返す。Role History は更新しない。
     */
    public function roleDiffPreview(MeetingCsvRoleDiffPreviewService $roleDiffService, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        try {
            $result = $roleDiffService->roleDiffPreview($meeting, $import);
            return response()->json($result);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404) {
                return response()->json(['message' => $e->getMessage()], 404);
            }
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /**
     * GET /api/meetings/{meetingId}/csv-import/unresolved
     * M7-M7: 最新 import に紐づく member / category / role の未解決・解決済み一覧。
     */
    public function unresolved(MeetingCsvUnresolvedSummaryService $summaryService, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        try {
            $data = $summaryService->summarize($meeting, $import);

            return response()->json([
                'unresolved_member' => $data['members'],
                'unresolved_category' => $data['categories'],
                'unresolved_role' => $data['roles'],
            ]);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404) {
                return response()->json(['message' => $e->getMessage()], 404);
            }

            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /**
     * GET /api/meetings/{meetingId}/csv-import/unresolved-suggestions
     * M8: 未解決（open）の member / category / role ごとに、既存マスタの候補（スコア降順・自動確定なし）。
     */
    public function unresolvedSuggestions(
        MeetingCsvUnresolvedSummaryService $summaryService,
        CsvResolutionSuggestionService $suggestionService,
        MeetingCsvMemberResolver $memberResolver,
        int $meetingId
    ): JsonResponse {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        try {
            $data = $summaryService->summarize($meeting, $import);

            $memberPayload = [];
            foreach ($data['members'] as $row) {
                if (($row['status'] ?? '') !== 'open') {
                    continue;
                }
                $csvKana = isset($row['csv_kana']) && is_string($row['csv_kana']) && trim($row['csv_kana']) !== ''
                    ? trim($row['csv_kana'])
                    : null;
                $csvName = (string) ($row['csv_name'] ?? $row['source_value']);
                $meta = $memberResolver->resolveExistingWithMeta($import->id, $csvName);
                $memberPayload[] = [
                    'source_value' => (string) $row['source_value'],
                    'suggestions' => $suggestionService->suggestMembers($csvName, $csvKana),
                    'duplicate_name_warning' => (bool) $meta['duplicate_name_warning'],
                    'duplicate_count' => (int) $meta['exact_name_match_count'],
                    'duplicate_candidates' => $meta['duplicate_candidates'],
                ];
            }

            $categoryPayload = [];
            foreach ($data['categories'] as $row) {
                if (($row['status'] ?? '') !== 'open') {
                    continue;
                }
                $categoryPayload[] = [
                    'source_value' => (string) $row['source_value'],
                    'suggestions' => $suggestionService->suggestCategories((string) $row['source_value']),
                ];
            }

            $rolePayload = [];
            foreach ($data['roles'] as $row) {
                if (($row['status'] ?? '') !== 'open') {
                    continue;
                }
                $rolePayload[] = [
                    'source_value' => (string) $row['source_value'],
                    'suggestions' => $suggestionService->suggestRoles((string) $row['source_value']),
                ];
            }

            return response()->json([
                'unresolved_member' => $memberPayload,
                'unresolved_category' => $categoryPayload,
                'unresolved_role' => $rolePayload,
            ]);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404) {
                return response()->json(['message' => $e->getMessage()], 404);
            }

            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /**
     * POST /api/meetings/{meetingId}/csv-import/resolutions
     * M7-M7: 既存マスタへのマッピング（mapped / created いずれも可）。
     */
    public function storeResolution(Request $request, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        $v = $request->validate([
            'resolution_type' => ['required', 'in:member,category,role'],
            'source_value' => ['required', 'string', 'max:512'],
            'resolved_id' => ['required', 'integer', 'min:1'],
            'action_type' => ['required', 'in:mapped,created'],
        ]);

        $source = trim($v['source_value']);
        if ($source === '') {
            return response()->json(['message' => 'source_value が空です。'], 422);
        }

        $type = $v['resolution_type'];
        $id = (int) $v['resolved_id'];
        $label = $this->resolvedLabelForType($type, $id);
        if ($label === null) {
            return response()->json(['message' => $this->missingMasterMessageForResolutionType($type)], 422);
        }

        $row = MeetingCsvImportResolution::updateOrCreate(
            [
                'meeting_csv_import_id' => $import->id,
                'resolution_type' => $type,
                'source_value' => $source,
            ],
            [
                'resolved_id' => $id,
                'resolved_label' => $label,
                'action_type' => $v['action_type'],
            ]
        );

        return response()->json([
            'id' => $row->id,
            'resolution_type' => $row->resolution_type,
            'source_value' => $row->source_value,
            'resolved_id' => $row->resolved_id,
            'resolved_label' => $row->resolved_label,
            'action_type' => $row->action_type,
        ]);
    }

    /**
     * GET /api/meetings/{meetingId}/csv-import/resolutions
     * M9: 最新 import に紐づく resolutions 一覧。
     */
    public function listResolutions(int $meetingId): JsonResponse
    {
        $import = $this->latestImportOr404Response($meetingId);
        if ($import instanceof JsonResponse) {
            return $import;
        }

        $rows = MeetingCsvImportResolution::query()
            ->where('meeting_csv_import_id', $import->id)
            ->orderBy('resolution_type')
            ->orderBy('id')
            ->get();

        return response()->json([
            'resolutions' => $rows->map(function (MeetingCsvImportResolution $r) {
                return [
                    'id' => $r->id,
                    'resolution_type' => $r->resolution_type,
                    'source_value' => $r->source_value,
                    'resolved_id' => (int) $r->resolved_id,
                    'resolved_label' => $r->resolved_label,
                    'action_type' => $r->action_type,
                    'created_at' => $r->created_at?->toIso8601String(),
                    'updated_at' => $r->updated_at?->toIso8601String(),
                ];
            })->values()->all(),
        ]);
    }

    /**
     * PUT /api/meetings/{meetingId}/csv-import/resolutions/{resolutionId}
     * M9: 同一 resolution_type 内で resolved 先のみ変更（source_value / type は不変）。
     */
    public function updateResolution(Request $request, int $meetingId, int $resolutionId): JsonResponse
    {
        $import = $this->latestImportOr404Response($meetingId);
        if ($import instanceof JsonResponse) {
            return $import;
        }

        $row = MeetingCsvImportResolution::query()
            ->whereKey($resolutionId)
            ->where('meeting_csv_import_id', $import->id)
            ->first();

        if ($row === null) {
            return response()->json(['message' => 'Resolution not found.'], 404);
        }

        $v = $request->validate([
            'resolved_id' => ['required', 'integer', 'min:1'],
            'action_type' => ['required', 'in:mapped,created'],
        ]);

        $id = (int) $v['resolved_id'];
        $label = $this->resolvedLabelForType($row->resolution_type, $id);
        if ($label === null) {
            return response()->json(['message' => $this->missingMasterMessageForResolutionType($row->resolution_type)], 422);
        }

        $row->resolved_id = $id;
        $row->resolved_label = $label;
        $row->action_type = $v['action_type'];
        $row->save();

        return response()->json([
            'id' => $row->id,
            'resolution_type' => $row->resolution_type,
            'source_value' => $row->source_value,
            'resolved_id' => $row->resolved_id,
            'resolved_label' => $row->resolved_label,
            'action_type' => $row->action_type,
            'created_at' => $row->created_at?->toIso8601String(),
            'updated_at' => $row->updated_at?->toIso8601String(),
        ]);
    }

    /**
     * DELETE /api/meetings/{meetingId}/csv-import/resolutions/{resolutionId}
     * M9: resolution 行のみ削除（マスタは削除しない）。
     */
    public function destroyResolution(int $meetingId, int $resolutionId): JsonResponse
    {
        $import = $this->latestImportOr404Response($meetingId);
        if ($import instanceof JsonResponse) {
            return $import;
        }

        $row = MeetingCsvImportResolution::query()
            ->whereKey($resolutionId)
            ->where('meeting_csv_import_id', $import->id)
            ->first();

        if ($row === null) {
            return response()->json(['message' => 'Resolution not found.'], 404);
        }

        $row->delete();

        return response()->json(['message' => 'Resolution deleted.']);
    }

    /**
     * POST /api/meetings/{meetingId}/csv-import/resolutions/create-member
     */
    public function createResolutionMember(Request $request, int $meetingId): JsonResponse
    {
        $import = $this->latestImportOr404Response($meetingId);
        if ($import instanceof JsonResponse) {
            return $import;
        }
        /** @var MeetingCsvImport $import */

        $v = $request->validate([
            'source_value' => ['required', 'string', 'max:512'],
            'name' => ['required', 'string', 'max:255'],
            'name_kana' => ['nullable', 'string', 'max:255'],
            'type' => ['nullable', 'string', 'in:regular,visitor,guest,proxy'],
        ]);

        $source = trim($v['source_value']);
        if ($source === '') {
            return response()->json(['message' => 'source_value が空です。'], 422);
        }

        $member = Member::create([
            'name' => $v['name'],
            'name_kana' => $v['name_kana'] ?? null,
            'category_id' => null,
            'type' => $v['type'] ?? 'regular',
            'display_no' => null,
            'introducer_member_id' => null,
            'attendant_member_id' => null,
        ]);

        $row = MeetingCsvImportResolution::updateOrCreate(
            [
                'meeting_csv_import_id' => $import->id,
                'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
                'source_value' => $source,
            ],
            [
                'resolved_id' => $member->id,
                'resolved_label' => $member->name,
                'action_type' => MeetingCsvImportResolution::ACTION_CREATED,
            ]
        );

        return response()->json([
            'member' => ['id' => $member->id, 'name' => $member->name],
            'resolution' => [
                'id' => $row->id,
                'resolution_type' => $row->resolution_type,
                'source_value' => $row->source_value,
                'resolved_id' => $row->resolved_id,
                'resolved_label' => $row->resolved_label,
                'action_type' => $row->action_type,
            ],
        ], 201);
    }

    /**
     * POST /api/meetings/{meetingId}/csv-import/resolutions/create-category
     */
    public function createResolutionCategory(Request $request, int $meetingId): JsonResponse
    {
        $import = $this->latestImportOr404Response($meetingId);
        if ($import instanceof JsonResponse) {
            return $import;
        }
        /** @var MeetingCsvImport $import */

        $v = $request->validate([
            'source_value' => ['required', 'string', 'max:512'],
            'group_name' => ['required', 'string', 'max:255'],
            'name' => ['required', 'string', 'max:255'],
        ]);

        $source = trim($v['source_value']);
        if ($source === '') {
            return response()->json(['message' => 'source_value が空です。'], 422);
        }

        $category = Category::create([
            'group_name' => $v['group_name'],
            'name' => $v['name'],
        ]);

        $label = $category->group_name === $category->name
            ? $category->name
            : ($category->group_name.' / '.$category->name);

        $row = MeetingCsvImportResolution::updateOrCreate(
            [
                'meeting_csv_import_id' => $import->id,
                'resolution_type' => MeetingCsvImportResolution::TYPE_CATEGORY,
                'source_value' => $source,
            ],
            [
                'resolved_id' => $category->id,
                'resolved_label' => $label,
                'action_type' => MeetingCsvImportResolution::ACTION_CREATED,
            ]
        );

        return response()->json([
            'category' => ['id' => $category->id, 'group_name' => $category->group_name, 'name' => $category->name],
            'resolution' => [
                'id' => $row->id,
                'resolution_type' => $row->resolution_type,
                'source_value' => $row->source_value,
                'resolved_id' => $row->resolved_id,
                'resolved_label' => $row->resolved_label,
                'action_type' => $row->action_type,
            ],
        ], 201);
    }

    /**
     * POST /api/meetings/{meetingId}/csv-import/resolutions/create-role
     */
    public function createResolutionRole(Request $request, int $meetingId): JsonResponse
    {
        $import = $this->latestImportOr404Response($meetingId);
        if ($import instanceof JsonResponse) {
            return $import;
        }
        /** @var MeetingCsvImport $import */

        $v = $request->validate([
            'source_value' => ['required', 'string', 'max:512'],
            'name' => ['required', 'string', 'max:255'],
        ]);

        $source = trim($v['source_value']);
        if ($source === '') {
            return response()->json(['message' => 'source_value が空です。'], 422);
        }

        $role = Role::create([
            'name' => $v['name'],
            'description' => null,
        ]);

        $row = MeetingCsvImportResolution::updateOrCreate(
            [
                'meeting_csv_import_id' => $import->id,
                'resolution_type' => MeetingCsvImportResolution::TYPE_ROLE,
                'source_value' => $source,
            ],
            [
                'resolved_id' => $role->id,
                'resolved_label' => $role->name,
                'action_type' => MeetingCsvImportResolution::ACTION_CREATED,
            ]
        );

        return response()->json([
            'role' => ['id' => $role->id, 'name' => $role->name],
            'resolution' => [
                'id' => $row->id,
                'resolution_type' => $row->resolution_type,
                'source_value' => $row->source_value,
                'resolved_id' => $row->resolved_id,
                'resolved_label' => $row->resolved_label,
                'action_type' => $row->action_type,
            ],
        ], 201);
    }

    private function resolvedLabelForType(string $type, int $id): ?string
    {
        switch ($type) {
            case MeetingCsvImportResolution::TYPE_MEMBER:
                $m = Member::find($id);

                return $m?->name;
            case MeetingCsvImportResolution::TYPE_CATEGORY:
                $c = Category::find($id);
                if ($c === null) {
                    return null;
                }

                return $c->group_name === $c->name ? $c->name : ($c->group_name.' / '.$c->name);
            case MeetingCsvImportResolution::TYPE_ROLE:
                $r = Role::find($id);

                return $r?->name;
            default:
                return null;
        }
    }

    private function missingMasterMessageForResolutionType(string $type): string
    {
        return match ($type) {
            MeetingCsvImportResolution::TYPE_MEMBER => '指定の Member が見つかりません。',
            MeetingCsvImportResolution::TYPE_CATEGORY => '指定の Category が見つかりません。',
            MeetingCsvImportResolution::TYPE_ROLE => '指定の Role が見つかりません。',
            default => '指定のマスタが見つかりません。',
        };
    }

    /**
     * @return MeetingCsvImport|JsonResponse
     */
    private function latestImportOr404Response(int $meetingId): MeetingCsvImport|JsonResponse
    {
        if (! Meeting::whereKey($meetingId)->exists()) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        return $import;
    }

    /**
     * POST /api/meetings/{meetingId}/csv-import/role-apply
     * M4 の差分のうち、マスタ解決済みの changed / csv_only と current_only を member_roles に反映する。roles 自動作成なし。
     */
    public function roleApply(Request $request, ApplyMeetingCsvRoleDiffService $roleApplyService, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        $validated = $request->validate([
            'effective_date' => ['sometimes', 'nullable', 'date'],
        ]);
        $effectiveDateInput = $validated['effective_date'] ?? null;

        try {
            $result = $roleApplyService->apply($meeting, $import, ['effective_date' => $effectiveDateInput]);
            MeetingCsvApplyLogWriter::roles($meeting, $import, $result);
            return response()->json([
                'changed_role_applied_count' => $result['changed_role_applied_count'],
                'csv_role_only_applied_count' => $result['csv_role_only_applied_count'],
                'current_role_only_closed_count' => $result['current_role_only_closed_count'],
                'skipped_unresolved_role_count' => $result['skipped_unresolved_role_count'],
                'effective_date' => $result['effective_date'],
                'effective_date_source' => $result['effective_date_source'],
                'message' => 'Role History を更新しました',
            ]);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404) {
                return response()->json(['message' => $e->getMessage()], 404);
            }
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /**
     * GET /api/meetings/{meetingId}/csv-import/apply-logs
     * 当該 Meeting の CSV 反映監査ログ（新しい順）。
     */
    public function applyLogs(Request $request, int $meetingId): JsonResponse
    {
        if (! Meeting::whereKey($meetingId)->exists()) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $limit = min(50, max(1, (int) $request->query('limit', 20)));
        $logs = MeetingCsvApplyLog::query()
            ->where('meeting_id', $meetingId)
            ->orderByDesc('executed_at')
            ->limit($limit)
            ->get()
            ->map(fn (MeetingCsvApplyLog $log) => $log->toApiArray())
            ->values()
            ->all();

        return response()->json(['logs' => $logs]);
    }

    /**
     * POST /api/meetings/{meetingId}/csv-import/member-apply
     * M2 で出した差分のうち、名前・よみがな・マスタ解決済み category_id のみ members に反映する。
     */
    public function memberApply(ApplyMeetingCsvMemberDiffService $memberApplyService, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        try {
            $result = $memberApplyService->apply($meeting, $import);
            MeetingCsvApplyLogWriter::members($meeting, $import, $result);
            return response()->json([
                'updated_member_basic_count' => $result['updated_member_basic_count'],
                'updated_category_count' => $result['updated_category_count'],
                'skipped_unresolved_count' => $result['skipped_unresolved_member_count'],
                'skipped_unresolved_category_count' => $result['skipped_unresolved_category_count'],
                'message' => 'members の基本情報を更新しました',
            ]);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404) {
                return response()->json(['message' => $e->getMessage()], 404);
            }
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /**
     * POST /api/meetings/{meetingId}/csv-import/apply
     * 紐づく最新CSVを participants に差分更新で反映する。
     * delete_missing=true のとき、CSVにない既存 participant のうち BO なしのみ削除。BO ありは保護。
     */
    public function apply(Request $request, ApplyMeetingCsvImportService $applyService, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = MeetingCsvImport::where('meeting_id', $meetingId)
            ->orderByDesc('uploaded_at')
            ->first();

        if (! $import) {
            return response()->json(['message' => 'CSVが登録されていません。'], 404);
        }

        $deleteMissing = filter_var($request->input('delete_missing', false), FILTER_VALIDATE_BOOLEAN);

        try {
            $result = $applyService->apply($meeting, $import, ['delete_missing' => $deleteMissing]);
            MeetingCsvApplyLogWriter::participants($meeting, $import, $result, ['delete_missing' => $deleteMissing]);
            return response()->json([
                'added_count' => $result['added_count'],
                'updated_count' => $result['updated_count'],
                'missing_count' => $result['missing_count'],
                'deleted_count' => $result['deleted_count'],
                'protected_count' => $result['protected_count'],
                'applied_count' => $result['applied_count'],
                'message' => 'participants を差分更新しました',
            ]);
        } catch (\RuntimeException $e) {
            $code = (int) $e->getCode();
            if ($code === 404) {
                return response()->json(['message' => $e->getMessage()], 404);
            }
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }
}
