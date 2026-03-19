<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingCsvImport;
use App\Models\MeetingCsvImportResolution;
use App\Models\Member;
use App\Models\Role;
use Illuminate\Support\Facades\Storage;

/**
 * M7-M4: CSV の役職列と Member の現在役職（member_roles 由来）を比較し、候補のみ返す。Role History は更新しない。
 */
class MeetingCsvRoleDiffPreviewService
{
    private const DISK = 'local';

    private const TYPE_MAP = [
        'メンバー' => 'regular',
        'ビジター' => 'visitor',
        'ゲスト' => 'guest',
        '代理出席' => 'proxy',
    ];

    public function __construct(
        private MeetingCsvPreviewService $previewService,
        private MeetingCsvMemberResolver $memberResolver
    ) {}

    /**
     * @return array{
     *     summary: array{
     *         changed_role_count: int,
     *         csv_role_only_count: int,
     *         current_role_only_count: int,
     *         unchanged_role_count: int,
     *         unresolved_member_count: int
     *     },
     *     changed_role: array<int, array<string, mixed>>,
     *     csv_role_only: array<int, array<string, mixed>>,
     *     current_role_only: array<int, array<string, mixed>>,
     *     unresolved_member: array<int, array{csv_name: string, csv_category: string|null}>
     * }
     */
    public function roleDiffPreview(Meeting $meeting, MeetingCsvImport $import): array
    {
        $fullPath = Storage::disk(self::DISK)->path($import->file_path);
        if (! is_readable($fullPath)) {
            throw new \RuntimeException('CSVファイルを読み込めませんでした。', 404);
        }

        $result = $this->previewService->preview($fullPath);
        $rows = $result['rows'] ?? [];
        if (count($rows) === 0) {
            throw new \RuntimeException('CSVにデータ行がありません。', 422);
        }

        $maps = MeetingCsvImportResolution::mapsForImport($import->id);

        $aggregated = [];
        $unresolvedByName = [];

        foreach ($rows as $row) {
            $name = isset($row['name']) ? trim((string) $row['name']) : '';
            if ($name === '') {
                continue;
            }
            $typeRaw = isset($row['type']) ? trim((string) $row['type']) : '';
            if (! array_key_exists($typeRaw, self::TYPE_MAP)) {
                continue;
            }

            $meta = $this->memberResolver->resolveExistingWithMeta($import->id, $name);
            $member = $meta['member'];
            if ($member === null) {
                $unresolvedByName[$name] = [
                    'csv_name' => $name,
                    'csv_category' => $this->csvCategoryLabel($row),
                ];
                continue;
            }

            $csvRole = $this->normalizeCsvRole($row['role'] ?? null);

            $aggregated[$member->id] = [
                'csv_name' => $name,
                'csv_role' => $csvRole,
                'duplicate_name_warning' => (bool) $meta['duplicate_name_warning'],
                'duplicate_count' => (int) $meta['exact_name_match_count'],
            ];
        }

        $changedRole = [];
        $csvRoleOnly = [];
        $currentRoleOnly = [];
        $unchangedCount = 0;

        foreach ($aggregated as $memberId => $data) {
            $member = Member::find($memberId);
            if ($member === null) {
                continue;
            }

            $dupWarn = (bool) ($data['duplicate_name_warning'] ?? false);
            $dupCount = (int) ($data['duplicate_count'] ?? 0);

            $currentRole = $member->currentRole();
            $currentName = $currentRole?->name;
            $csvRoleText = $data['csv_role'];

            $csvEmpty = $csvRoleText === null || $csvRoleText === '';
            $currentEmpty = $currentName === null || $currentName === '';

            $csvCanonicalRoleName = ! $csvEmpty
                ? $this->canonicalRoleNameForCsv($csvRoleText, $maps)
                : null;
            $roleMasterResolved = ! $csvEmpty && $csvCanonicalRoleName !== null;

            if ($csvEmpty && $currentEmpty) {
                $unchangedCount++;
                continue;
            }

            if ($csvEmpty && ! $currentEmpty) {
                $currentRoleOnly[] = [
                    'member_id' => $member->id,
                    'name' => $member->name,
                    'current_role' => $currentName,
                    'csv_role' => null,
                    'duplicate_name_warning' => $dupWarn,
                    'duplicate_count' => $dupCount,
                ];
                continue;
            }

            if (! $csvEmpty && $currentEmpty) {
                $csvRoleOnly[] = [
                    'member_id' => $member->id,
                    'name' => $member->name,
                    'current_role' => null,
                    'csv_role' => $csvRoleText,
                    'role_master_resolved' => $roleMasterResolved,
                    'duplicate_name_warning' => $dupWarn,
                    'duplicate_count' => $dupCount,
                ];
                continue;
            }

            if ($csvCanonicalRoleName !== null && $csvCanonicalRoleName === $currentName) {
                $unchangedCount++;
                continue;
            }

            $changedRole[] = [
                'member_id' => $member->id,
                'name' => $member->name,
                'current_role' => $currentName,
                'csv_role' => $csvRoleText,
                'role_master_resolved' => $roleMasterResolved,
                'duplicate_name_warning' => $dupWarn,
                'duplicate_count' => $dupCount,
            ];
        }

        $unresolved = array_values($unresolvedByName);

        $duplicateNameMemberCount = 0;
        foreach ($aggregated as $row) {
            if (! empty($row['duplicate_name_warning'])) {
                $duplicateNameMemberCount++;
            }
        }

        return [
            'summary' => [
                'changed_role_count' => count($changedRole),
                'csv_role_only_count' => count($csvRoleOnly),
                'current_role_only_count' => count($currentRoleOnly),
                'unchanged_role_count' => $unchangedCount,
                'unresolved_member_count' => count($unresolved),
                'duplicate_name_member_count' => $duplicateNameMemberCount,
            ],
            'changed_role' => $changedRole,
            'csv_role_only' => $csvRoleOnly,
            'current_role_only' => $currentRoleOnly,
            'unresolved_member' => $unresolved,
        ];
    }

    /**
     * CSV 上の役職文字列が指す roles.name（マスタまたは resolution 経由）。
     */
    private function canonicalRoleNameForCsv(string $csvRoleText, array $maps): ?string
    {
        $r = Role::where('name', $csvRoleText)->first();
        if ($r !== null) {
            return $r->name;
        }
        $me = $maps[MeetingCsvImportResolution::TYPE_ROLE][$csvRoleText] ?? null;
        if ($me === null) {
            return null;
        }
        $r2 = Role::find($me['id']);

        return $r2?->name;
    }

    private function normalizeCsvRole(mixed $v): ?string
    {
        if ($v === null) {
            return null;
        }
        $t = trim((string) $v);

        return $t === '' ? null : $t;
    }

    /**
     * @param  array<string, string|null>  $row
     */
    private function csvCategoryLabel(array $row): ?string
    {
        $g = isset($row['category_group']) ? trim((string) $row['category_group']) : '';
        $n = isset($row['category']) ? trim((string) $row['category']) : '';
        if ($g === '' && $n === '') {
            return null;
        }
        if ($g !== '' && $n !== '' && $g !== $n) {
            return $g.' / '.$n;
        }

        return $g !== '' ? $g : $n;
    }
}
