<?php

namespace App\Services\Religo;

use App\Models\BoAssignmentAuditLog;
use App\Models\ContactMemo;
use App\Models\DragonflyContactEvent;
use App\Models\DragonflyContactFlag;
use App\Models\MeetingCsvImportResolution;
use App\Models\Member;
use App\Models\MemberRole;
use App\Models\OneToOne;
use App\Models\Participant;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;
use RuntimeException;

/**
 * 管理者向け member マージ（手動・トークン保護）。SPEC-008 / MEMBERS-MERGE-ASSIST-P1。
 *
 * 同一人物の visitor/guest/member 分裂を 1 つの canonical member_id に寄せる。
 * 自動同一人物判定は行わない。
 */
final class MemberMergeService
{
    /**
     * @return array{
     *   canonical: array{id:int,name:string,type:?string,display_no:?string},
     *   merge: array{id:int,name:string,type:?string,display_no:?string},
     *   blocked: bool,
     *   block_reasons: list<string>,
     *   counts: array<string,int>,
     *   participant_meeting_overlap: list<int>,
     *   contact_flag_conflicts: int
     * }
     */
    public function preview(int $canonicalId, int $mergeId): array
    {
        $this->assertDistinctIds($canonicalId, $mergeId);
        $canonical = Member::find($canonicalId);
        $merge = Member::find($mergeId);
        if ($canonical === null || $merge === null) {
            throw new InvalidArgumentException('canonical_id または merge_id の member が存在しません。');
        }

        $overlap = $this->participantMeetingOverlap($canonicalId, $mergeId);
        $flagConflicts = $this->countContactFlagConflicts($canonicalId, $mergeId);

        $blocked = $overlap !== [];
        $blockReasons = [];
        if ($overlap !== []) {
            $blockReasons[] = '両方の member が同じ meeting_id の participants を持つため、このマージは自動実行できません。どちらかの participant 行を手動で整理してから再試行してください。重複 meeting_id: '.implode(', ', array_map(fn (int $id) => (string) $id, $overlap));
        }

        $warnings = [];
        if ($flagConflicts > 0) {
            $warnings[] = "dragonfly_contact_flags で移行後に (owner,target) の一意制約に衝突しうる行が {$flagConflicts} 件あります。実行時は重複行を削除します。必要なら事前にバックアップしてください。";
        }

        return [
            'canonical' => $this->memberSnapshot($canonical),
            'merge' => $this->memberSnapshot($merge),
            'blocked' => $blocked,
            'block_reasons' => $blockReasons,
            'warnings' => $warnings,
            'counts' => $this->referenceCounts($mergeId),
            'participant_meeting_overlap' => $overlap,
            'contact_flag_conflicts' => $flagConflicts,
        ];
    }

    /**
     * @param  string  $confirmPhrase  正確に "MERGE {mergeId} INTO {canonicalId}"
     */
    public function execute(int $canonicalId, int $mergeId, string $confirmPhrase): void
    {
        $expected = "MERGE {$mergeId} INTO {$canonicalId}";
        if (! hash_equals($expected, $confirmPhrase)) {
            throw new InvalidArgumentException('確認フレーズが一致しません。'.$expected.' をそのまま送信してください。');
        }

        $this->assertDistinctIds($canonicalId, $mergeId);
        $preview = $this->preview($canonicalId, $mergeId);
        if ($preview['blocked']) {
            throw new RuntimeException(implode(' ', $preview['block_reasons']));
        }

        $canonical = Member::findOrFail($canonicalId);
        Member::findOrFail($mergeId);

        DB::transaction(function () use ($canonicalId, $mergeId): void {
            // 1) 他テーブルの member への参照（members 自身の FK）
            Member::query()->where('introducer_member_id', $mergeId)->update(['introducer_member_id' => $canonicalId]);
            Member::query()->where('attendant_member_id', $mergeId)->update(['attendant_member_id' => $canonicalId]);

            // 2) participants の紹介・アテンド
            Participant::query()->where('introducer_member_id', $mergeId)->update(['introducer_member_id' => $canonicalId]);
            Participant::query()->where('attendant_member_id', $mergeId)->update(['attendant_member_id' => $canonicalId]);

            // 3) 接触・1to1・メモ・イベント
            ContactMemo::query()->where('owner_member_id', $mergeId)->update(['owner_member_id' => $canonicalId]);
            ContactMemo::query()->where('target_member_id', $mergeId)->update(['target_member_id' => $canonicalId]);

            OneToOne::query()->where('owner_member_id', $mergeId)->update(['owner_member_id' => $canonicalId]);
            OneToOne::query()->where('target_member_id', $mergeId)->update(['target_member_id' => $canonicalId]);

            DragonflyContactEvent::query()->where('owner_member_id', $mergeId)->update(['owner_member_id' => $canonicalId]);
            DragonflyContactEvent::query()->where('target_member_id', $mergeId)->update(['target_member_id' => $canonicalId]);

            $this->repointContactFlags($canonicalId, $mergeId);

            // 4) participant 本体（重複 meeting なしのみ preview 通過）
            Participant::query()->where('member_id', $mergeId)->update(['member_id' => $canonicalId]);

            // 5) 役職履歴
            MemberRole::query()->where('member_id', $mergeId)->update(['member_id' => $canonicalId]);

            // 6) CSV resolutions（member マップ）
            MeetingCsvImportResolution::query()
                ->where('resolution_type', MeetingCsvImportResolution::TYPE_MEMBER)
                ->where('resolved_id', $mergeId)
                ->update(['resolved_id' => $canonicalId]);

            // 7) users / 監査 / apply ログ
            User::query()->where('owner_member_id', $mergeId)->update(['owner_member_id' => $canonicalId]);
            BoAssignmentAuditLog::query()->where('actor_owner_member_id', $mergeId)->update(['actor_owner_member_id' => $canonicalId]);
            DB::table('meeting_csv_apply_logs')->where('executed_by_member_id', $mergeId)->update(['executed_by_member_id' => $canonicalId]);

            // 8) introductions（モデル未整備のため DB）
            foreach (['owner_member_id', 'from_member_id', 'to_member_id'] as $col) {
                DB::table('introductions')->where($col, $mergeId)->update([$col => $canonicalId]);
            }

            // 9) 負け member 削除（restrict 参照は上で解消済み）
            Member::query()->where('id', $mergeId)->delete();
        });

        $canonical->touch();
    }

    private function assertDistinctIds(int $canonicalId, int $mergeId): void
    {
        if ($canonicalId === $mergeId) {
            throw new InvalidArgumentException('canonical_id と merge_id は異なる必要があります。');
        }
    }

    /**
     * @return list<int>
     */
    private function participantMeetingOverlap(int $canonicalId, int $mergeId): array
    {
        $a = Participant::query()->where('member_id', $canonicalId)->pluck('meeting_id');
        $b = Participant::query()->where('member_id', $mergeId)->pluck('meeting_id');

        return $a->intersect($b)->unique()->values()->map(fn ($id) => (int) $id)->all();
    }

    private function countContactFlagConflicts(int $canonicalId, int $mergeId): int
    {
        $n = 0;
        $flags = DragonflyContactFlag::query()
            ->where(function ($q) use ($mergeId) {
                $q->where('owner_member_id', $mergeId)->orWhere('target_member_id', $mergeId);
            })
            ->get();

        foreach ($flags as $f) {
            $newOwner = $f->owner_member_id === $mergeId ? $canonicalId : $f->owner_member_id;
            $newTarget = $f->target_member_id === $mergeId ? $canonicalId : $f->target_member_id;
            if ($newOwner === $newTarget) {
                continue;
            }
            $exists = DragonflyContactFlag::query()
                ->where('owner_member_id', $newOwner)
                ->where('target_member_id', $newTarget)
                ->where('id', '!=', $f->id)
                ->exists();
            if ($exists) {
                $n++;
            }
        }

        return $n;
    }

    /**
     * flags を付け替え。重複する場合は当該行を削除。
     */
    private function repointContactFlags(int $canonicalId, int $mergeId): void
    {
        $ids = DragonflyContactFlag::query()
            ->where(function ($q) use ($mergeId) {
                $q->where('owner_member_id', $mergeId)->orWhere('target_member_id', $mergeId);
            })
            ->orderBy('id')
            ->pluck('id')
            ->all();

        foreach ($ids as $flagId) {
            $f = DragonflyContactFlag::query()->find($flagId);
            if ($f === null) {
                continue;
            }
            $newOwner = $f->owner_member_id === $mergeId ? $canonicalId : $f->owner_member_id;
            $newTarget = $f->target_member_id === $mergeId ? $canonicalId : $f->target_member_id;

            if ($newOwner === $newTarget) {
                $f->delete();

                continue;
            }

            $dup = DragonflyContactFlag::query()
                ->where('owner_member_id', $newOwner)
                ->where('target_member_id', $newTarget)
                ->where('id', '!=', $f->id)
                ->first();

            if ($dup !== null) {
                $f->delete();

                continue;
            }

            $f->update([
                'owner_member_id' => $newOwner,
                'target_member_id' => $newTarget,
            ]);
        }
    }

    /**
     * @return array<string, int>
     */
    private function referenceCounts(int $mergeId): array
    {
        return [
            'participants_as_member' => Participant::query()->where('member_id', $mergeId)->count(),
            'participants_introducer' => Participant::query()->where('introducer_member_id', $mergeId)->count(),
            'participants_attendant' => Participant::query()->where('attendant_member_id', $mergeId)->count(),
            'contact_memos_owner' => ContactMemo::query()->where('owner_member_id', $mergeId)->count(),
            'contact_memos_target' => ContactMemo::query()->where('target_member_id', $mergeId)->count(),
            'contact_flags' => DragonflyContactFlag::query()
                ->where(function ($q) use ($mergeId) {
                    $q->where('owner_member_id', $mergeId)->orWhere('target_member_id', $mergeId);
                })
                ->count(),
            'contact_events_owner' => DragonflyContactEvent::query()->where('owner_member_id', $mergeId)->count(),
            'contact_events_target' => DragonflyContactEvent::query()->where('target_member_id', $mergeId)->count(),
            'one_to_ones_owner' => OneToOne::query()->where('owner_member_id', $mergeId)->count(),
            'one_to_ones_target' => OneToOne::query()->where('target_member_id', $mergeId)->count(),
            'member_roles' => MemberRole::query()->where('member_id', $mergeId)->count(),
            'members_introducer_fk' => Member::query()->where('introducer_member_id', $mergeId)->count(),
            'members_attendant_fk' => Member::query()->where('attendant_member_id', $mergeId)->count(),
            'csv_resolutions_member' => MeetingCsvImportResolution::query()
                ->where('resolution_type', MeetingCsvImportResolution::TYPE_MEMBER)
                ->where('resolved_id', $mergeId)
                ->count(),
            'users_owner' => User::query()->where('owner_member_id', $mergeId)->count(),
            'bo_audit_actor' => BoAssignmentAuditLog::query()->where('actor_owner_member_id', $mergeId)->count(),
            'csv_apply_logs_executor' => (int) DB::table('meeting_csv_apply_logs')->where('executed_by_member_id', $mergeId)->count(),
            'introductions_refs' => (int) DB::table('introductions')
                ->where(function ($q) use ($mergeId) {
                    $q->where('owner_member_id', $mergeId)
                        ->orWhere('from_member_id', $mergeId)
                        ->orWhere('to_member_id', $mergeId);
                })
                ->count(),
        ];
    }

    /**
     * @return array{id:int,name:string,type:?string,display_no:?string}
     */
    private function memberSnapshot(Member $m): array
    {
        return [
            'id' => (int) $m->id,
            'name' => (string) $m->name,
            'type' => $m->type,
            'display_no' => $m->display_no,
        ];
    }
}
