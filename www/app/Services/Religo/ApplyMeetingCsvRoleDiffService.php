<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingCsvImport;
use App\Models\MeetingCsvImportResolution;
use App\Models\Member;
use App\Models\MemberRole;
use App\Models\Role;
use Illuminate\Support\Facades\DB;

/**
 * M7-M5: M4 の role-diff-preview に基づき member_roles のみを更新する。roles 自動作成なし。participants / members は触れない。
 */
class ApplyMeetingCsvRoleDiffService
{
    public function __construct(
        private MeetingCsvRoleDiffPreviewService $roleDiffPreviewService
    ) {}

    /**
     * 基準日: リクエスト effective_date があればそれを採用。なければ meeting.held_on。それも無ければ今日（held_on は通常 NOT NULL のためフォールバック）。
     *
     * @param  array{effective_date?: string|null}  $options
     * @return array{
     *     changed_role_applied_count: int,
     *     csv_role_only_applied_count: int,
     *     current_role_only_closed_count: int,
     *     skipped_unresolved_role_count: int,
     *     effective_date: string,
     *     effective_date_source: string
     * }
     */
    public function apply(Meeting $meeting, MeetingCsvImport $import, array $options = []): array
    {
        $preview = $this->roleDiffPreviewService->roleDiffPreview($meeting, $import);

        $maps = MeetingCsvImportResolution::mapsForImport($import->id);

        $resolved = $this->resolveEffectiveDate($options['effective_date'] ?? null, $meeting);
        $effectiveDate = $resolved['date'];
        $effectiveDateSource = $resolved['source'];

        $skippedUnresolved = 0;
        foreach ($preview['changed_role'] as $row) {
            if (empty($row['role_master_resolved'])) {
                $skippedUnresolved++;
            }
        }
        foreach ($preview['csv_role_only'] as $row) {
            if (empty($row['role_master_resolved'])) {
                $skippedUnresolved++;
            }
        }

        $toChange = array_values(array_filter(
            $preview['changed_role'],
            static fn (array $r): bool => ! empty($r['role_master_resolved'])
        ));
        $toCsvOnly = array_values(array_filter(
            $preview['csv_role_only'],
            static fn (array $r): bool => ! empty($r['role_master_resolved'])
        ));
        $toCurrentOnly = $preview['current_role_only'];

        if ($toChange === [] && $toCsvOnly === [] && $toCurrentOnly === []) {
            throw new \RuntimeException('反映対象の Role History 差分がありません。', 422);
        }

        $changedApplied = 0;
        $csvOnlyApplied = 0;
        $currentClosed = 0;

        DB::transaction(function () use ($toChange, $toCsvOnly, $toCurrentOnly, $effectiveDate, $maps, &$changedApplied, &$csvOnlyApplied, &$currentClosed): void {
            foreach ($toChange as $row) {
                $member = Member::find((int) $row['member_id']);
                if ($member === null) {
                    continue;
                }
                $csvRoleName = (string) $row['csv_role'];
                $role = $this->resolveRoleForCsv($csvRoleName, $maps);
                if ($role === null) {
                    continue;
                }
                $this->closeCurrentOpenMemberRole($member, $effectiveDate);
                $this->startMemberRole($member->id, $role->id, $effectiveDate);
                $changedApplied++;
            }

            foreach ($toCsvOnly as $row) {
                $member = Member::find((int) $row['member_id']);
                if ($member === null) {
                    continue;
                }
                $csvRoleName = (string) $row['csv_role'];
                $role = $this->resolveRoleForCsv($csvRoleName, $maps);
                if ($role === null) {
                    continue;
                }
                $this->closeCurrentOpenMemberRole($member, $effectiveDate);
                $this->startMemberRole($member->id, $role->id, $effectiveDate);
                $csvOnlyApplied++;
            }

            foreach ($toCurrentOnly as $row) {
                $member = Member::find((int) $row['member_id']);
                if ($member === null) {
                    continue;
                }
                if ($this->closeCurrentOpenMemberRole($member, $effectiveDate)) {
                    $currentClosed++;
                }
            }
        });

        return [
            'changed_role_applied_count' => $changedApplied,
            'csv_role_only_applied_count' => $csvOnlyApplied,
            'current_role_only_closed_count' => $currentClosed,
            'skipped_unresolved_role_count' => $skippedUnresolved,
            'effective_date' => $effectiveDate,
            'effective_date_source' => $effectiveDateSource,
        ];
    }

    /**
     * @return array{date: string, source: string}  source: request | held_on | today
     */
    private function resolveEffectiveDate(?string $requested, Meeting $meeting): array
    {
        if ($requested !== null && $requested !== '') {
            try {
                $date = \Carbon\Carbon::parse($requested)->toDateString();
            } catch (\Throwable) {
                throw new \RuntimeException('基準日の形式が正しくありません。', 422);
            }

            return ['date' => $date, 'source' => 'request'];
        }

        if ($meeting->held_on !== null) {
            return [
                'date' => $meeting->held_on->toDateString(),
                'source' => 'held_on',
            ];
        }

        return ['date' => now()->toDateString(), 'source' => 'today'];
    }

    /**
     * @param  array{member: array, category: array, role: array}  $maps
     */
    private function resolveRoleForCsv(string $csvRoleName, array $maps): ?Role
    {
        $role = Role::where('name', $csvRoleName)->first();
        if ($role !== null) {
            return $role;
        }
        $me = $maps[MeetingCsvImportResolution::TYPE_ROLE][$csvRoleName] ?? null;
        if ($me === null) {
            return null;
        }

        return Role::find($me['id']);
    }

    /**
     * currentRole() と同じ条件で「いま効いている」open な member_role を1件閉じる。
     */
    private function closeCurrentOpenMemberRole(Member $member, string $effectiveDate): bool
    {
        $mr = $this->currentOpenMemberRole($member, $effectiveDate);
        if ($mr === null) {
            return false;
        }
        $mr->term_end = $effectiveDate;
        $mr->save();

        return true;
    }

    private function currentOpenMemberRole(Member $member, string $effectiveDate): ?MemberRole
    {
        return $member->memberRoles()
            ->whereNull('term_end')
            ->where('term_start', '<=', $effectiveDate)
            ->orderByDesc('term_start')
            ->first();
    }

    private function startMemberRole(int $memberId, int $roleId, string $effectiveDate): void
    {
        MemberRole::create([
            'member_id' => $memberId,
            'role_id' => $roleId,
            'term_start' => $effectiveDate,
            'term_end' => null,
        ]);
    }
}
