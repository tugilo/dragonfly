<?php

namespace App\Services\Religo;

use App\Models\MeetingCsvImportResolution;
use App\Models\Member;

/**
 * M8.5: CSV 行の「名前」文字列から Member を解決する単一情報源。
 * M9: 同名 member の件数・警告・候補（最大件数）を resolveExistingWithMeta で返す。
 *
 * 順序（preview / apply / unresolved 共通）:
 * 1. meeting_csv_import_resolutions（resolution_type=member, source_value=CSV名）→ resolved_id
 * 2. Member::where('name', CSV名)->first()
 *
 * ApplyMeetingCsvImportService のみ 3 として Member::create（resolver は 1→2 のみ）。
 */
final class MeetingCsvMemberResolver
{
    private const DUPLICATE_CANDIDATE_LIMIT = 15;

    /**
     * プレビュー系: 上記 1→2 のみ。ヒットしなければ null（新規作成しない）。
     */
    public function resolveExistingForCsvName(int $meetingCsvImportId, string $csvName): ?Member
    {
        return $this->resolveExistingWithMeta($meetingCsvImportId, $csvName)['member'];
    }

    /**
     * @return array{
     *     member: Member|null,
     *     resolved_via: 'resolution'|'name'|'none',
     *     exact_name_match_count: int,
     *     duplicate_name_warning: bool,
     *     duplicate_candidates: list<array{id: int, name: string}>
     * }
     */
    public function resolveExistingWithMeta(int $meetingCsvImportId, string $csvName): array
    {
        $empty = [
            'member' => null,
            'resolved_via' => 'none',
            'exact_name_match_count' => 0,
            'duplicate_name_warning' => false,
            'duplicate_candidates' => [],
        ];

        $name = trim($csvName);
        if ($name === '') {
            return $empty;
        }

        $maps = MeetingCsvImportResolution::mapsForImport($meetingCsvImportId);
        $mapMid = $maps[MeetingCsvImportResolution::TYPE_MEMBER][$name]['id'] ?? null;
        if ($mapMid !== null) {
            $mapped = Member::find($mapMid);
            if ($mapped !== null) {
                return [
                    'member' => $mapped,
                    'resolved_via' => 'resolution',
                    'exact_name_match_count' => (int) Member::where('name', $name)->count(),
                    'duplicate_name_warning' => false,
                    'duplicate_candidates' => [],
                ];
            }
        }

        $count = (int) Member::where('name', $name)->count();
        if ($count === 0) {
            return $empty;
        }

        $candidates = Member::query()
            ->where('name', $name)
            ->orderBy('id')
            ->limit(self::DUPLICATE_CANDIDATE_LIMIT)
            ->get(['id', 'name']);

        $member = $candidates->first();
        $dupWarning = $count > 1;

        return [
            'member' => $member,
            'resolved_via' => 'name',
            'exact_name_match_count' => $count,
            'duplicate_name_warning' => $dupWarning,
            'duplicate_candidates' => $dupWarning
                ? $candidates->map(fn (Member $m) => ['id' => (int) $m->id, 'name' => (string) $m->name])->values()->all()
                : [],
        ];
    }
}
