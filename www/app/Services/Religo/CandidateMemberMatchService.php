<?php

namespace App\Services\Religo;

use App\Models\Member;

/**
 * M7-P4: 候補（candidates）に member 照合結果を付与する。
 * M7-P5: 手動マッチ（match_source=manual, matched_member_id）を優先し、なければ名前完全一致で auto 照合。
 */
class CandidateMemberMatchService
{
    /**
     * 候補配列に照合結果を付与し、集計を返す。
     * 手動マッチ済み（match_source=manual, matched_member_id あり）はそのまま matched として集計。
     *
     * @param  array<int, array>  $candidates
     * @return array{candidates: array<int, array>, matched_count: int, new_count: int, total_count: int}
     */
    public function enrichCandidates(array $candidates): array
    {
        $matchedCount = 0;
        $newCount = 0;
        $enriched = [];

        foreach ($candidates as $c) {
            $name = isset($c['name']) ? trim((string) $c['name']) : '';
            $row = array_merge($c, [
                'match_status' => 'new',
                'matched_member_id' => null,
                'matched_member_name' => null,
                'match_source' => null,
            ]);

            if ($name === '') {
                $enriched[] = $row;
                continue;
            }

            $manualId = isset($c['matched_member_id']) ? (int) $c['matched_member_id'] : null;
            $isManual = ($c['match_source'] ?? '') === 'manual' && $manualId > 0;

            if ($isManual) {
                $member = Member::find($manualId);
                if ($member !== null) {
                    $row['match_status'] = 'matched';
                    $row['matched_member_id'] = $member->id;
                    $row['matched_member_name'] = $member->name;
                    $row['match_source'] = 'manual';
                    $matchedCount++;
                } else {
                    $row['match_source'] = null;
                    $row['matched_member_id'] = null;
                    $row['matched_member_name'] = null;
                    $member = Member::where('name', $name)->first();
                    if ($member !== null) {
                        $row['match_status'] = 'matched';
                        $row['matched_member_id'] = $member->id;
                        $row['matched_member_name'] = $member->name;
                        $row['match_source'] = 'auto';
                        $matchedCount++;
                    } else {
                        $newCount++;
                    }
                }
            } else {
                $member = Member::where('name', $name)->first();
                if ($member !== null) {
                    $row['match_status'] = 'matched';
                    $row['matched_member_id'] = $member->id;
                    $row['matched_member_name'] = $member->name;
                    $row['match_source'] = 'auto';
                    $matchedCount++;
                } else {
                    $newCount++;
                }
            }

            $enriched[] = $row;
        }

        $totalCount = $matchedCount + $newCount;

        return [
            'candidates' => $enriched,
            'matched_count' => $matchedCount,
            'new_count' => $newCount,
            'total_count' => $totalCount,
        ];
    }
}
