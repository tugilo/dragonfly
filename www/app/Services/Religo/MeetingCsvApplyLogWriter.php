<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingCsvApplyLog;
use App\Models\MeetingCsvImport;

/**
 * M7-M6: CSV 反映成功時に meeting_csv_apply_logs へ1行追記する。
 */
final class MeetingCsvApplyLogWriter
{
    /**
     * @param  array{added_count: int, updated_count: int, missing_count: int, deleted_count: int, protected_count: int, applied_count: int}  $result
     * @param  array{delete_missing?: bool}  $metaExtra
     */
    public static function participants(Meeting $meeting, MeetingCsvImport $import, array $result, array $metaExtra = []): void
    {
        MeetingCsvApplyLog::create([
            'meeting_id' => $meeting->id,
            'meeting_csv_import_id' => $import->id,
            'apply_type' => MeetingCsvApplyLog::TYPE_PARTICIPANTS,
            'applied_on' => now()->toDateString(),
            'executed_at' => now(),
            'applied_count' => $result['applied_count'],
            'added_count' => $result['added_count'],
            'updated_count' => $result['updated_count'],
            'deleted_count' => $result['deleted_count'],
            'protected_count' => $result['protected_count'],
            'skipped_count' => null,
            'meta' => array_merge([
                'missing_count' => $result['missing_count'],
                'delete_missing' => (bool) ($metaExtra['delete_missing'] ?? false),
            ], $metaExtra),
            'executed_by_member_id' => null,
        ]);
    }

    /**
     * @param  array{updated_member_basic_count: int, updated_category_count: int, skipped_unresolved_member_count: int, skipped_unresolved_category_count: int}  $result
     */
    public static function members(Meeting $meeting, MeetingCsvImport $import, array $result): void
    {
        $applied = $result['updated_member_basic_count'] + $result['updated_category_count'];
        $skipped = $result['skipped_unresolved_member_count'] + $result['skipped_unresolved_category_count'];

        MeetingCsvApplyLog::create([
            'meeting_id' => $meeting->id,
            'meeting_csv_import_id' => $import->id,
            'apply_type' => MeetingCsvApplyLog::TYPE_MEMBERS,
            'applied_on' => now()->toDateString(),
            'executed_at' => now(),
            'applied_count' => $applied,
            'added_count' => null,
            'updated_count' => $applied,
            'deleted_count' => null,
            'protected_count' => null,
            'skipped_count' => $skipped > 0 ? $skipped : null,
            'meta' => [
                'updated_member_basic_count' => $result['updated_member_basic_count'],
                'updated_category_count' => $result['updated_category_count'],
                'skipped_unresolved_member_count' => $result['skipped_unresolved_member_count'],
                'skipped_unresolved_category_count' => $result['skipped_unresolved_category_count'],
            ],
            'executed_by_member_id' => null,
        ]);
    }

    /**
     * @param  array{changed_role_applied_count: int, csv_role_only_applied_count: int, current_role_only_closed_count: int, skipped_unresolved_role_count: int, effective_date: string, effective_date_source: string}  $result
     */
    public static function roles(Meeting $meeting, MeetingCsvImport $import, array $result): void
    {
        $applied = $result['changed_role_applied_count']
            + $result['csv_role_only_applied_count']
            + $result['current_role_only_closed_count'];
        $skipped = $result['skipped_unresolved_role_count'];

        MeetingCsvApplyLog::create([
            'meeting_id' => $meeting->id,
            'meeting_csv_import_id' => $import->id,
            'apply_type' => MeetingCsvApplyLog::TYPE_ROLES,
            'applied_on' => $result['effective_date'],
            'executed_at' => now(),
            'applied_count' => $applied,
            'added_count' => null,
            'updated_count' => null,
            'deleted_count' => null,
            'protected_count' => null,
            'skipped_count' => $skipped > 0 ? $skipped : null,
            'meta' => [
                'changed_role_applied_count' => $result['changed_role_applied_count'],
                'csv_role_only_applied_count' => $result['csv_role_only_applied_count'],
                'current_role_only_closed_count' => $result['current_role_only_closed_count'],
                'skipped_unresolved_role_count' => $result['skipped_unresolved_role_count'],
                'effective_date' => $result['effective_date'],
                'effective_date_source' => $result['effective_date_source'],
            ],
            'executed_by_member_id' => null,
        ]);
    }
}
