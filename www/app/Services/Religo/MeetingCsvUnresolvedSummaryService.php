<?php

namespace App\Services\Religo;

use App\Models\Category;
use App\Models\Meeting;
use App\Models\MeetingCsvImport;
use App\Models\MeetingCsvImportResolution;
use App\Models\Role;
use Illuminate\Support\Facades\Storage;

/**
 * M7-M7: 未解決 member / category / role の一覧（解決済みは status で区別）。
 */
class MeetingCsvUnresolvedSummaryService
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
     *     members: array<int, array<string, mixed>>,
     *     categories: array<int, array<string, mixed>>,
     *     roles: array<int, array<string, mixed>>
     * }
     */
    public function summarize(Meeting $meeting, MeetingCsvImport $import): array
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

        $membersOut = [];
        $seenNames = [];
        foreach ($rows as $row) {
            $name = isset($row['name']) ? trim((string) $row['name']) : '';
            if ($name === '') {
                continue;
            }
            $typeRaw = isset($row['type']) ? trim((string) $row['type']) : '';
            if (! array_key_exists($typeRaw, self::TYPE_MAP)) {
                continue;
            }
            if (isset($seenNames[$name])) {
                continue;
            }
            $seenNames[$name] = true;

            $meta = $this->memberResolver->resolveExistingWithMeta($import->id, $name);
            $m = $meta['member'];
            if ($m !== null) {
                $mapEntry = $maps[MeetingCsvImportResolution::TYPE_MEMBER][$name] ?? null;
                $fromResolution = $mapEntry !== null && (int) $mapEntry['id'] === (int) $m->id;
                $membersOut[] = [
                    'source_value' => $name,
                    'csv_name' => $name,
                    'csv_kana' => isset($row['kana']) ? trim((string) $row['kana']) : '',
                    'csv_category' => $this->csvCategoryLabel($row),
                    'status' => 'resolved',
                    'resolved_member_id' => $m->id,
                    'resolved_name' => $m->name,
                    'action_type' => $fromResolution ? $this->resolutionActionType($import->id, MeetingCsvImportResolution::TYPE_MEMBER, $name) : null,
                    'duplicate_name_warning' => (bool) $meta['duplicate_name_warning'],
                    'duplicate_count' => (int) $meta['exact_name_match_count'],
                    'duplicate_candidates' => $meta['duplicate_candidates'],
                ];
            } else {
                $membersOut[] = [
                    'source_value' => $name,
                    'csv_name' => $name,
                    'csv_kana' => isset($row['kana']) ? trim((string) $row['kana']) : '',
                    'csv_category' => $this->csvCategoryLabel($row),
                    'status' => 'open',
                    'resolved_member_id' => null,
                    'resolved_name' => null,
                    'action_type' => null,
                    'duplicate_name_warning' => false,
                    'duplicate_count' => (int) $meta['exact_name_match_count'],
                    'duplicate_candidates' => [],
                ];
            }
        }

        $categoryLabels = [];
        foreach ($rows as $row) {
            $name = isset($row['name']) ? trim((string) $row['name']) : '';
            if ($name === '') {
                continue;
            }
            $typeRaw = isset($row['type']) ? trim((string) $row['type']) : '';
            if (! array_key_exists($typeRaw, self::TYPE_MAP)) {
                continue;
            }
            $g = isset($row['category_group']) ? trim((string) $row['category_group']) : '';
            $n = isset($row['category']) ? trim((string) $row['category']) : '';
            if ($g === '' && $n === '') {
                continue;
            }
            $label = $this->csvCategoryLabelFromParts($g, $n);
            if ($label === null || $label === '') {
                continue;
            }
            $categoryLabels[$label] = ['group' => $g, 'name' => $n];
        }

        $categoriesOut = [];
        foreach ($categoryLabels as $label => $parts) {
            $catId = $this->resolveCategoryIdReadOnly($parts['group'] !== '' ? $parts['group'] : null, $parts['name'] !== '' ? $parts['name'] : null);
            $mapEntry = $maps[MeetingCsvImportResolution::TYPE_CATEGORY][$label] ?? null;
            if ($mapEntry !== null && Category::whereKey($mapEntry['id'])->exists()) {
                $catId = (int) $mapEntry['id'];
            }
            if ($catId !== null) {
                $c = Category::find($catId);
                $categoriesOut[] = [
                    'source_value' => $label,
                    'display_label' => $label,
                    'status' => 'resolved',
                    'resolved_category_id' => $catId,
                    'resolved_label' => $c ? ($c->group_name === $c->name ? $c->name : $c->group_name.' / '.$c->name) : null,
                    'action_type' => $mapEntry !== null ? $this->resolutionActionType($import->id, MeetingCsvImportResolution::TYPE_CATEGORY, $label) : null,
                ];
            } else {
                $categoriesOut[] = [
                    'source_value' => $label,
                    'display_label' => $label,
                    'status' => 'open',
                    'resolved_category_id' => null,
                    'resolved_label' => null,
                    'action_type' => null,
                ];
            }
        }

        $roleTexts = [];
        foreach ($rows as $row) {
            $name = isset($row['name']) ? trim((string) $row['name']) : '';
            if ($name === '') {
                continue;
            }
            $typeRaw = isset($row['type']) ? trim((string) $row['type']) : '';
            if (! array_key_exists($typeRaw, self::TYPE_MAP)) {
                continue;
            }
            $roleRaw = isset($row['role']) ? trim((string) $row['role']) : '';
            if ($roleRaw === '') {
                continue;
            }
            $roleTexts[$roleRaw] = true;
        }

        $rolesOut = [];
        foreach (array_keys($roleTexts) as $roleText) {
            $role = Role::where('name', $roleText)->first();
            $mapEntry = $maps[MeetingCsvImportResolution::TYPE_ROLE][$roleText] ?? null;
            if ($role === null && $mapEntry !== null) {
                $role = Role::find($mapEntry['id']);
            }
            if ($role !== null) {
                $rolesOut[] = [
                    'source_value' => $roleText,
                    'status' => 'resolved',
                    'resolved_role_id' => $role->id,
                    'resolved_name' => $role->name,
                    'action_type' => ($mapEntry !== null) ? $this->resolutionActionType($import->id, MeetingCsvImportResolution::TYPE_ROLE, $roleText) : null,
                ];
            } else {
                $rolesOut[] = [
                    'source_value' => $roleText,
                    'status' => 'open',
                    'resolved_role_id' => null,
                    'resolved_name' => null,
                    'action_type' => null,
                ];
            }
        }

        return [
            'members' => $membersOut,
            'categories' => $categoriesOut,
            'roles' => $rolesOut,
        ];
    }

    private function resolutionActionType(int $importId, string $type, string $source): ?string
    {
        $r = MeetingCsvImportResolution::query()
            ->where('meeting_csv_import_id', $importId)
            ->where('resolution_type', $type)
            ->where('source_value', $source)
            ->first();

        return $r?->action_type;
    }

    private function resolveCategoryIdReadOnly(?string $groupName, ?string $categoryName): ?int
    {
        $g = $groupName !== null && trim($groupName) !== '' ? trim($groupName) : null;
        $n = $categoryName !== null && trim($categoryName) !== '' ? trim($categoryName) : null;
        if ($g === null && $n === null) {
            return null;
        }
        $group = $g ?? $n;
        $name = $n ?? $g;
        $cat = Category::where('group_name', $group)->where('name', $name)->first();

        return $cat?->id;
    }

    /**
     * @param  array<string, string|null>  $row
     */
    private function csvCategoryLabel(array $row): ?string
    {
        $g = isset($row['category_group']) ? trim((string) $row['category_group']) : '';
        $n = isset($row['category']) ? trim((string) $row['category']) : '';

        return $this->csvCategoryLabelFromParts($g, $n);
    }

    private function csvCategoryLabelFromParts(string $group, string $name): ?string
    {
        if ($group === '' && $name === '') {
            return null;
        }
        if ($group !== '' && $name !== '' && $group !== $name) {
            return $group.' / '.$name;
        }

        return $group !== '' ? $group : $name;
    }
}
