<?php

namespace App\Services\Zoom;

use App\Models\OneToOne;
use App\Models\User;
use App\Models\ZoomImportApplyLog;
use App\Models\ZoomMeetingImport;
use App\Services\Religo\OneToOneService;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

/**
 * 選択された Zoom 取り込み候補を one_to_ones に反映する（SPEC-012 Phase B / R3・R4・R6・R7）。
 *
 * - past（実績あり）→ status=completed（started_at/ended_at）
 * - scheduled → status=planned（scheduled_at）
 * - 相手未確定（matched でない）→ 登録せず held として残す（target_member_id は NOT NULL のため）
 * - 重複防止（ZOOM_IMPORT_DEDUP_REQUIREMENTS R1/R2）:
 *     1) zoom_meeting_uuid / zoom_meeting_id 一致 → 既存に紐付け skip
 *     2) 同一 owner+target+同日の既存（手動含む）→ Zoom 実時刻・uuid を既存へバックフィルし skip
 */
class ZoomImportApplyService
{
    public function __construct(private OneToOneService $oneToOneService) {}

    /**
     * @param  array<int, int>  $importIds
     * @return array{imported: int, held: int, skipped: int, details: array<int, array<string, mixed>>}
     */
    public function apply(User $user, array $importIds): array
    {
        $imported = 0;
        $held = 0;
        $skipped = 0;
        $details = [];

        $rows = ZoomMeetingImport::where('user_id', $user->id)
            ->whereIn('id', $importIds)
            ->get();

        foreach ($rows as $row) {
            $result = DB::transaction(fn () => $this->applyOne($user, $row));
            $details[] = ['import_id' => $row->id, 'result' => $result];
            match ($result) {
                'imported' => $imported++,
                'held' => $held++,
                default => $skipped++,
            };
        }

        ZoomImportApplyLog::create([
            'user_id' => $user->id,
            'executed_at' => Carbon::now(),
            'action' => 'apply',
            'imported_count' => $imported,
            'held_count' => $held,
            'skipped_count' => $skipped,
            'meta' => ['import_ids' => $importIds, 'details' => $details],
        ]);

        return ['imported' => $imported, 'held' => $held, 'skipped' => $skipped, 'details' => $details];
    }

    /**
     * @return string imported / held / skipped
     */
    private function applyOne(User $user, ZoomMeetingImport $row): string
    {
        if ($row->status === ZoomMeetingImport::STATUS_IMPORTED) {
            return 'skipped';
        }

        // 二重登録防止: 既に one_to_ones に同じ Zoom ミーティングがあれば紐付けてスキップ。
        $existing = $this->findExistingOneToOne($row);
        if ($existing !== null) {
            $row->status = ZoomMeetingImport::STATUS_IMPORTED;
            $row->one_to_one_id = $existing->id;
            $row->save();

            return 'skipped';
        }

        // 相手未確定 or owner 未設定は登録できない → 保留。
        if ($row->matched_member_id === null || $user->owner_member_id === null) {
            $row->status = ZoomMeetingImport::STATUS_HELD;
            $row->save();

            return 'held';
        }
        if ((int) $row->matched_member_id === (int) $user->owner_member_id) {
            // 相手＝自分は不正。保留にする。
            $row->status = ZoomMeetingImport::STATUS_HELD;
            $row->save();

            return 'held';
        }

        // R1/R2: 同一 owner+target+同日の既存（手動登録含む）があれば新規作成せず、
        // Zoom の実時刻・突合キーを既存へバックフィルして紐付ける（二重登録防止）。
        $sameDay = $this->findExistingByOwnerTargetDate($user, $row);
        if ($sameDay !== null) {
            $this->backfillFromZoom($sameDay, $row);
            $row->status = ZoomMeetingImport::STATUS_IMPORTED;
            $row->one_to_one_id = $sameDay->id;
            $row->save();

            return 'skipped';
        }

        $isCompleted = $row->kind === ZoomMeetingImport::KIND_PAST && $row->start_time !== null;

        $o2o = $this->oneToOneService->store([
            'workspace_id' => $row->workspace_id,
            'owner_member_id' => $user->owner_member_id,
            'target_member_id' => $row->matched_member_id,
            'meeting_id' => null,
            'zoom_meeting_id' => $row->zoom_meeting_id,
            'zoom_meeting_uuid' => $row->zoom_meeting_uuid,
            'external_source' => 'zoom',
            'status' => $isCompleted ? 'completed' : 'planned',
            'scheduled_at' => $row->start_time,
            'started_at' => $isCompleted ? $row->start_time : null,
            'ended_at' => $isCompleted ? $row->end_time : null,
            'notes' => null,
        ]);

        $row->status = ZoomMeetingImport::STATUS_IMPORTED;
        $row->one_to_one_id = $o2o->id;
        $row->save();

        return 'imported';
    }

    private function findExistingOneToOne(ZoomMeetingImport $row): ?OneToOne
    {
        if ($row->zoom_meeting_uuid !== null && $row->zoom_meeting_uuid !== '') {
            $found = OneToOne::where('zoom_meeting_uuid', $row->zoom_meeting_uuid)->first();
            if ($found !== null) {
                return $found;
            }
        }
        if ($row->kind === ZoomMeetingImport::KIND_SCHEDULED && $row->zoom_meeting_id !== null && $row->zoom_meeting_id !== '') {
            return OneToOne::where('zoom_meeting_id', $row->zoom_meeting_id)
                ->whereNull('zoom_meeting_uuid')
                ->first();
        }

        return null;
    }

    /**
     * 同一 owner+target で、Zoom 開始日と同日の既存 1to1 を探す（external_source 問わず）。
     */
    private function findExistingByOwnerTargetDate(User $user, ZoomMeetingImport $row): ?OneToOne
    {
        if ($row->start_time === null || $row->matched_member_id === null) {
            return null;
        }
        $date = Carbon::parse($row->start_time)->toDateString();

        return OneToOne::where('owner_member_id', $user->owner_member_id)
            ->where('target_member_id', $row->matched_member_id)
            ->where(function ($q) use ($date) {
                $q->whereDate('started_at', $date)
                    ->orWhere(function ($q2) use ($date) {
                        $q2->whereNull('started_at')->whereDate('scheduled_at', $date);
                    });
            })
            ->orderBy('id')
            ->first();
    }

    /**
     * 既存 1to1 に Zoom の実時刻・突合キーを補完（空のときだけ・既存 notes は保持）。
     */
    private function backfillFromZoom(OneToOne $existing, ZoomMeetingImport $row): void
    {
        $changed = false;
        if (empty($existing->started_at) && ! empty($row->start_time)) {
            $existing->started_at = $row->start_time;
            $changed = true;
        }
        if (empty($existing->ended_at) && ! empty($row->end_time)) {
            $existing->ended_at = $row->end_time;
            $changed = true;
        }
        if (empty($existing->zoom_meeting_id) && ! empty($row->zoom_meeting_id)) {
            $existing->zoom_meeting_id = $row->zoom_meeting_id;
            $changed = true;
        }
        if (empty($existing->zoom_meeting_uuid) && ! empty($row->zoom_meeting_uuid)) {
            $existing->zoom_meeting_uuid = $row->zoom_meeting_uuid;
            $changed = true;
        }
        if ($changed) {
            $existing->save();
        }
    }
}
