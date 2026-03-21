<?php

namespace App\Services\Religo;

use App\Models\ContactMemo;
use App\Models\DragonflyContactFlag;
use App\Models\OneToOne;
use Illuminate\Support\Facades\DB;

/**
 * members.workspace_id の初期 backfill（MEMBERS-WORKSPACE-BACKFILL-P1）.
 * SSOT: docs/SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md
 */
final class MemberWorkspaceBackfillService
{
    /**
     * 説明可能な順で null の members.workspace_id を埋める。冪等に近い（同一データで再実行しても上書きは強い根拠優先）。
     */
    public function run(): void
    {
        $this->backfillFromUserDefaultWorkspace();
        $this->backfillFromOwnerArtifacts();
        $this->backfillWhenSingleWorkspaceOnly();
    }

    /**
     * users.owner_member_id と users.default_workspace_id から所属を写す（最優先）。
     */
    public function backfillFromUserDefaultWorkspace(): void
    {
        $rows = DB::table('users')
            ->whereNotNull('owner_member_id')
            ->whereNotNull('default_workspace_id')
            ->get(['owner_member_id', 'default_workspace_id']);

        foreach ($rows as $row) {
            DB::table('members')
                ->where('id', (int) $row->owner_member_id)
                ->update(['workspace_id' => (int) $row->default_workspace_id]);
        }
    }

    /**
     * ReligoActorContext::resolveWorkspaceIdFromOwnerMemberArtifacts と同順（flags → o2o → memos）。
     */
    public function backfillFromOwnerArtifacts(): void
    {
        $ids = DB::table('members')->whereNull('workspace_id')->pluck('id');
        foreach ($ids as $mid) {
            $wid = $this->resolveWorkspaceFromOwnerArtifacts((int) $mid);
            if ($wid !== null) {
                DB::table('members')->where('id', (int) $mid)->update(['workspace_id' => $wid]);
            }
        }
    }

    /**
     * workspaces が 1 件のみの環境（単一チャプター）では、根拠のない member もその 1 件に寄せる。
     * 複数 workspace がある場合は曖昧なため適用しない。
     */
    public function backfillWhenSingleWorkspaceOnly(): void
    {
        if ((int) DB::table('workspaces')->count() !== 1) {
            return;
        }
        $onlyId = (int) DB::table('workspaces')->orderBy('id')->value('id');
        DB::table('members')->whereNull('workspace_id')->update(['workspace_id' => $onlyId]);
    }

    private function resolveWorkspaceFromOwnerArtifacts(int $ownerMemberId): ?int
    {
        $fromFlag = DragonflyContactFlag::query()
            ->where('owner_member_id', $ownerMemberId)
            ->whereNotNull('workspace_id')
            ->orderBy('id')
            ->value('workspace_id');
        if ($fromFlag !== null) {
            return (int) $fromFlag;
        }
        $fromO2o = OneToOne::query()
            ->where('owner_member_id', $ownerMemberId)
            ->whereNotNull('workspace_id')
            ->orderBy('id')
            ->value('workspace_id');
        if ($fromO2o !== null) {
            return (int) $fromO2o;
        }
        $fromMemo = ContactMemo::query()
            ->where('owner_member_id', $ownerMemberId)
            ->whereNotNull('workspace_id')
            ->orderBy('id')
            ->value('workspace_id');
        if ($fromMemo !== null) {
            return (int) $fromMemo;
        }

        return null;
    }
}
