<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingCsvImport;
use App\Models\Member;

/**
 * M7-M3: CSV に基づく members 基本情報の確定反映。新規 member 作成・categories 作成・Role History には触れない。
 */
class ApplyMeetingCsvMemberDiffService
{
    public function __construct(
        private MeetingCsvMemberDiffPreviewService $memberDiffPreviewService
    ) {}

    /**
     * M2 と同じ差分を算出し、updated_member_basic と category_master_resolved=true の category_changed のみ DB に反映する。
     *
     * @return array{
     *     updated_member_basic_count: int,
     *     updated_category_count: int,
     *     skipped_unresolved_member_count: int,
     *     skipped_unresolved_category_count: int
     * }
     */
    public function apply(Meeting $meeting, MeetingCsvImport $import): array
    {
        $diff = $this->memberDiffPreviewService->memberDiffPreview($meeting, $import);

        $basicRows = $diff['updated_member_basic'];
        $categoryRows = array_values(array_filter(
            $diff['category_changed'],
            static fn (array $c): bool => ! empty($c['category_master_resolved']) && isset($c['resolved_category_id'])
        ));

        if (count($basicRows) === 0 && count($categoryRows) === 0) {
            throw new \RuntimeException('反映対象の差分がありません。', 422);
        }

        $basicCount = 0;
        foreach ($basicRows as $row) {
            $memberId = (int) $row['member_id'];
            $payload = [];
            if (isset($row['new_name'])) {
                $payload['name'] = $row['new_name'];
            }
            if (array_key_exists('new_name_kana', $row)) {
                $payload['name_kana'] = $row['new_name_kana'];
            }
            if ($payload === []) {
                continue;
            }
            $updated = Member::where('id', $memberId)->update($payload);
            if ($updated > 0) {
                $basicCount++;
            }
        }

        $categoryCount = 0;
        foreach ($categoryRows as $row) {
            $memberId = (int) $row['member_id'];
            $catId = (int) $row['resolved_category_id'];
            $updated = Member::where('id', $memberId)->update(['category_id' => $catId]);
            if ($updated > 0) {
                $categoryCount++;
            }
        }

        $skippedUnresolvedMember = count($diff['unresolved_member']);
        $skippedUnresolvedCategory = count(array_filter(
            $diff['category_changed'],
            static fn (array $c): bool => empty($c['category_master_resolved'])
        ));

        return [
            'updated_member_basic_count' => $basicCount,
            'updated_category_count' => $categoryCount,
            'skipped_unresolved_member_count' => $skippedUnresolvedMember,
            'skipped_unresolved_category_count' => $skippedUnresolvedCategory,
        ];
    }
}
