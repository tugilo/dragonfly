<?php

namespace App\Http\Controllers\Zoom;

use App\Http\Controllers\Controller;
use App\Http\Requests\Zoom\ApplyZoomImportRequest;
use App\Http\Requests\Zoom\CreateZoomImportMemberRequest;
use App\Http\Requests\Zoom\UpdateZoomImportRequest;
use App\Http\Requests\Zoom\ZoomSyncRequest;
use App\Models\Member;
use App\Models\OneToOne;
use App\Models\ZoomAccount;
use App\Models\ZoomMeetingImport;
use App\Services\Religo\ReligoActorContext;
use App\Services\Zoom\ZoomImportApplyService;
use App\Services\Zoom\ZoomMeetingSyncService;
use App\Services\Zoom\ZoomSummaryService;
use Illuminate\Http\JsonResponse;

/**
 * Zoom 取り込み（SPEC-012 Phase B）。一覧表示・複数選択・相手正規化・一括登録。
 * すべて religo.chapter_admin ゲート配下。
 */
class ZoomImportController extends Controller
{
    public function __construct(
        private ZoomMeetingSyncService $syncService,
        private ZoomImportApplyService $applyService,
        private ZoomSummaryService $summaryService,
    ) {}

    /**
     * POST /api/zoom/sync — Zoom から予定・実施を取得しステージングへ。
     */
    public function sync(ZoomSyncRequest $request): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }
        $account = ZoomAccount::where('user_id', $user->id)->first();
        if ($account === null) {
            return response()->json(['message' => 'Zoom 未連携です。先に連携してください。'], 422);
        }

        $validated = $request->validated();
        $result = $this->syncService->sync(
            $user,
            $account,
            (int) ($validated['past_days'] ?? 30),
            (int) ($validated['upcoming_days'] ?? 14),
        );

        return response()->json($result);
    }

    /**
     * GET /api/zoom/imports — 取り込み候補一覧（current user）。
     */
    public function index(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $rows = ZoomMeetingImport::with('matchedMember:id,name')
            ->where('user_id', $user->id)
            ->orderByDesc('start_time')
            ->orderByDesc('id')
            ->get();

        $data = $rows->map(fn (ZoomMeetingImport $r) => $this->formatRow($r))->values()->all();

        return response()->json($data);
    }

    /**
     * PUT /api/zoom/imports/{import} — 選択・相手確定/保留の更新。
     */
    public function update(UpdateZoomImportRequest $request, ZoomMeetingImport $import): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null || $import->user_id !== $user->id) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }
        if ($import->status === ZoomMeetingImport::STATUS_IMPORTED) {
            return response()->json(['message' => '取り込み済みのため編集できません。'], 422);
        }

        $validated = $request->validated();
        if (array_key_exists('selected', $validated)) {
            $import->selected = (bool) $validated['selected'];
        }
        if (array_key_exists('matched_member_id', $validated)) {
            $import->matched_member_id = $validated['matched_member_id'];
            $import->match_status = $validated['matched_member_id'] !== null ? 'matched' : 'unmatched';
        }
        if (array_key_exists('match_status', $validated)) {
            $import->match_status = $validated['match_status'];
        }
        if (array_key_exists('status', $validated)) {
            $import->status = $validated['status'];
        }
        $import->save();
        $import->load('matchedMember:id,name');

        return response()->json($this->formatRow($import));
    }

    /**
     * POST /api/zoom/imports/{import}/create-member — 未登録相手をその場で members 新規作成し紐付ける。
     * 同名が存在する場合は force=false なら作成せず候補を返す（重複防止・SPEC-008）。
     */
    public function createMember(CreateZoomImportMemberRequest $request, ZoomMeetingImport $import): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null || $import->user_id !== $user->id) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }
        if ($import->status === ZoomMeetingImport::STATUS_IMPORTED) {
            return response()->json(['message' => '取り込み済みのため変更できません。'], 422);
        }

        $v = $request->validated();
        $name = trim($v['name']);
        $force = (bool) ($v['force'] ?? false);

        if (! $force) {
            $dups = Member::query()
                ->where('name', $name)
                ->orderBy('id')
                ->limit(10)
                ->get(['id', 'name', 'name_kana', 'type', 'workspace_id']);
            if ($dups->isNotEmpty()) {
                return response()->json([
                    'created' => false,
                    'duplicates' => $dups->map(fn (Member $m) => [
                        'id' => $m->id,
                        'name' => $m->name,
                        'name_kana' => $m->name_kana,
                        'type' => $m->type,
                        'workspace_id' => $m->workspace_id,
                    ])->all(),
                    'message' => '同名のメンバーが存在します。既存を使うか、新規作成を確定してください。',
                ], 200);
            }
        }

        $member = Member::create([
            'name' => $name,
            'name_kana' => $v['name_kana'] ?? null,
            'type' => $v['type'] ?? 'guest',
            'workspace_id' => $v['workspace_id'] ?? null,
            'category_id' => null,
            'display_no' => null,
            'introducer_member_id' => null,
            'attendant_member_id' => null,
        ]);

        $import->matched_member_id = $member->id;
        $import->match_status = 'matched';
        $import->selected = true;
        $import->save();
        $import->load('matchedMember:id,name');

        return response()->json([
            'created' => true,
            'member' => ['id' => $member->id, 'name' => $member->name],
            'import' => $this->formatRow($import),
        ], 201);
    }

    /**
     * POST /api/zoom/imports/apply — 選択分を一括で one_to_ones に登録。
     */
    public function apply(ApplyZoomImportRequest $request): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $ids = array_map('intval', $request->validated()['ids']);
        $result = $this->applyService->apply($user, $ids);

        return response()->json($result);
    }

    /**
     * POST /api/zoom/imports/{import}/summary — 要約/文字起こしを取得し、
     * 取り込み済み 1to1 の notes に下書きとして反映する（R2・Phase C）。
     */
    public function summary(ZoomMeetingImport $import): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null || $import->user_id !== $user->id) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }
        $account = ZoomAccount::where('user_id', $user->id)->first();
        if ($account === null) {
            return response()->json(['message' => 'Zoom 未連携です。'], 422);
        }

        $text = $this->summaryService->fetchSummaryText($account, $import);
        if ($text === null) {
            return response()->json([
                'available' => false,
                'message' => '要約・文字起こしを取得できませんでした（Zoom プラン・録画/AI Companion 設定に依存）。手動で議事録を記録してください。',
            ], 200);
        }

        $oneToOne = $import->oneToOne;
        if ($oneToOne !== null) {
            $existing = trim((string) $oneToOne->notes);
            $oneToOne->notes = $existing === '' ? $text : $existing."\n\n---\n".$text;
            $oneToOne->save();
        }

        return response()->json([
            'available' => true,
            'summary' => $text,
            'one_to_one_id' => $oneToOne?->id,
            'applied_to_notes' => $oneToOne !== null,
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    private function formatRow(ZoomMeetingImport $r): array
    {
        $alreadyImported = $r->status === ZoomMeetingImport::STATUS_IMPORTED;
        if (! $alreadyImported && $r->zoom_meeting_uuid) {
            $alreadyImported = OneToOne::where('zoom_meeting_uuid', $r->zoom_meeting_uuid)->exists();
        }

        return [
            'id' => $r->id,
            'kind' => $r->kind,
            'topic' => $r->topic,
            'start_time' => $r->start_time?->toIso8601String(),
            'end_time' => $r->end_time?->toIso8601String(),
            'duration_minutes' => $r->duration_minutes,
            'participants_count' => $r->participants_count,
            'is_one_to_one_candidate' => (bool) $r->is_one_to_one_candidate,
            'confidence' => $r->confidence,
            'counterpart_name' => $r->counterpart_name,
            'counterpart_email' => $r->counterpart_email,
            'matched_member_id' => $r->matched_member_id,
            'matched_member_name' => $r->matchedMember?->name,
            'match_status' => $r->match_status,
            'selected' => (bool) $r->selected,
            'status' => $r->status,
            'one_to_one_id' => $r->one_to_one_id,
            'already_imported' => $alreadyImported,
            'import_status_label' => $this->statusLabel($r->status),
        ];
    }

    private function statusLabel(string $status): string
    {
        return match ($status) {
            ZoomMeetingImport::STATUS_IMPORTED => '登録済み',
            ZoomMeetingImport::STATUS_HELD => '保留',
            ZoomMeetingImport::STATUS_SKIPPED => 'スキップ',
            default => '未処理',
        };
    }
}
