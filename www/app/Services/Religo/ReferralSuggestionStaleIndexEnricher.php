<?php

namespace App\Services\Religo;

use App\Models\MeetingMinute;
use App\Models\MeetingReferralSuggestionRun;
use App\Models\OneToOneReferralSuggestionRun;
use Illuminate\Support\Collection;

/**
 * 一覧 API に referral_suggestion_stale を付与（N+1 回避のバッチ取得）。
 */
class ReferralSuggestionStaleIndexEnricher
{
    /**
     * @param  array<int, array<string, mixed>>  $rows
     * @return array<int, array<string, mixed>>
     */
    public function enrichOneToOnes(array $rows, int $ownerMemberId): array
    {
        if ($ownerMemberId <= 0 || $rows === []) {
            return $rows;
        }

        $ids = array_values(array_unique(array_map(fn ($r) => (int) $r['id'], $rows)));
        $latestByO2o = $this->latestOneToOneRuns($ids, $ownerMemberId);

        return array_map(function (array $row) use ($latestByO2o) {
            $notes = trim((string) ($row['notes'] ?? ''));
            $run = $latestByO2o->get((int) $row['id']);
            $row['referral_suggestion_stale'] = $notes !== ''
                && $run !== null
                && ReferralSuggestionDigest::digest($notes) !== $run->notes_digest;

            return $row;
        }, $rows);
    }

    /**
     * @param  array<int, array<string, mixed>>  $rows
     * @return array<int, array<string, mixed>>
     */
    public function enrichMeetings(array $rows, int $ownerMemberId): array
    {
        if ($ownerMemberId <= 0 || $rows === []) {
            return $rows;
        }

        $withMinutes = array_values(array_filter(
            $rows,
            fn ($r) => ! empty($r['has_minutes']),
        ));
        if ($withMinutes === []) {
            return array_map(function (array $row) {
                $row['referral_suggestion_stale'] = false;

                return $row;
            }, $rows);
        }

        $ids = array_values(array_unique(array_map(fn ($r) => (int) $r['id'], $withMinutes)));
        $minutes = MeetingMinute::query()
            ->whereIn('meeting_id', $ids)
            ->get()
            ->keyBy('meeting_id');
        $latestByMeeting = $this->latestMeetingRuns($ids, $ownerMemberId);

        return array_map(function (array $row) use ($minutes, $latestByMeeting) {
            if (empty($row['has_minutes'])) {
                $row['referral_suggestion_stale'] = false;

                return $row;
            }
            $minute = $minutes->get((int) $row['id']);
            $body = $minute !== null ? trim((string) $minute->body_markdown) : '';
            $run = $latestByMeeting->get((int) $row['id']);
            $row['referral_suggestion_stale'] = $body !== ''
                && $run !== null
                && ReferralSuggestionDigest::digest($body) !== $run->body_digest;

            return $row;
        }, $rows);
    }

    /**
     * @param  array<int, int>  $oneToOneIds
     * @return Collection<int, OneToOneReferralSuggestionRun>
     */
    private function latestOneToOneRuns(array $oneToOneIds, int $ownerMemberId): Collection
    {
        if ($oneToOneIds === []) {
            return collect();
        }

        $runs = OneToOneReferralSuggestionRun::query()
            ->whereIn('one_to_one_id', $oneToOneIds)
            ->where('owner_member_id', $ownerMemberId)
            ->orderByDesc('id')
            ->get();

        return $runs->groupBy('one_to_one_id')->map(fn ($group) => $group->first());
    }

    /**
     * @param  array<int, int>  $meetingIds
     * @return Collection<int, MeetingReferralSuggestionRun>
     */
    private function latestMeetingRuns(array $meetingIds, int $ownerMemberId): Collection
    {
        if ($meetingIds === []) {
            return collect();
        }

        $runs = MeetingReferralSuggestionRun::query()
            ->whereIn('meeting_id', $meetingIds)
            ->where('owner_member_id', $ownerMemberId)
            ->orderByDesc('id')
            ->get();

        return $runs->groupBy('meeting_id')->map(fn ($group) => $group->first());
    }
}
