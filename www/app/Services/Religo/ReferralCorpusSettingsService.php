<?php

namespace App\Services\Religo;

use App\Models\MemberReferralCorpusSetting;
use App\Models\OneToOne;
use App\Models\User;

/**
 * Phase 195: 横断コーパス貢献設定（§0.7）。
 */
class ReferralCorpusSettingsService
{
    /**
     * @return array{allow_cross_corpus_contribution: bool, consented_peer_count: int, workspace_id: int|null}
     */
    public function showForUser(User $user, ?int $workspaceId): array
    {
        $ownerId = (int) $user->owner_member_id;
        $setting = $this->resolveOrCreate($ownerId, $workspaceId);

        return [
            'allow_cross_corpus_contribution' => (bool) $setting->allow_cross_corpus_contribution,
            'consented_peer_count' => $this->countConsentedPeers($workspaceId, $ownerId),
            'workspace_id' => $workspaceId,
        ];
    }

    /**
     * @param  array{allow_cross_corpus_contribution?: bool}  $data
     * @return array{allow_cross_corpus_contribution: bool, consented_peer_count: int, workspace_id: int|null}
     */
    public function updateForUser(User $user, ?int $workspaceId, array $data): array
    {
        $ownerId = (int) $user->owner_member_id;
        $setting = $this->resolveOrCreate($ownerId, $workspaceId);

        if (array_key_exists('allow_cross_corpus_contribution', $data)) {
            $setting->allow_cross_corpus_contribution = (bool) $data['allow_cross_corpus_contribution'];
            $setting->save();
        }

        return $this->showForUser($user, $workspaceId);
    }

    /**
     * @return list<int>
     */
    public function consentedOwnerMemberIds(?int $workspaceId, int $excludeMemberId): array
    {
        $query = MemberReferralCorpusSetting::query()
            ->where('allow_cross_corpus_contribution', true)
            ->where('member_id', '!=', $excludeMemberId);

        $this->applyWorkspaceScope($query, $workspaceId);

        return $query->pluck('member_id')->map(fn ($id) => (int) $id)->all();
    }

    public function countConsentedPeers(?int $workspaceId, int $excludeMemberId): int
    {
        return count($this->consentedOwnerMemberIds($workspaceId, $excludeMemberId));
    }

    private function resolveOrCreate(int $memberId, ?int $workspaceId): MemberReferralCorpusSetting
    {
        $setting = MemberReferralCorpusSetting::query()->where('member_id', $memberId)->first();
        if ($setting !== null) {
            return $setting;
        }

        return MemberReferralCorpusSetting::create([
            'member_id' => $memberId,
            'workspace_id' => $workspaceId,
            'allow_cross_corpus_contribution' => false,
        ]);
    }

    /**
     * @param  \Illuminate\Database\Eloquent\Builder<MemberReferralCorpusSetting>  $query
     */
    private function applyWorkspaceScope($query, ?int $workspaceId): void
    {
        if ($workspaceId === null) {
            return;
        }

        $query->where(function ($q) use ($workspaceId) {
            $q->where('workspace_id', $workspaceId)->orWhereNull('workspace_id');
        });
    }

    /**
     * @param  \Illuminate\Database\Eloquent\Builder<OneToOne>  $query
     */
    public function applyOneToOneWorkspaceScope($query, ?int $workspaceId): void
    {
        if ($workspaceId === null) {
            return;
        }

        $query->where(function ($q) use ($workspaceId) {
            $q->where('workspace_id', $workspaceId)->orWhereNull('workspace_id');
        });
    }
}
