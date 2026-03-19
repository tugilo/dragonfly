<?php

namespace App\Services\Religo;

use App\Models\Category;
use App\Models\Meeting;
use App\Models\MeetingCsvImport;
use App\Models\MeetingCsvImportResolution;
use App\Models\Member;
use Illuminate\Support\Facades\Storage;

/**
 * M7-M2: CSV と既存 members の基本情報差分をプレビュー用に返す。更新は行わない。
 * No は識別に使わない。カテゴリーはマスタ照合のみ（新規作成しない）。
 */
class MeetingCsvMemberDiffPreviewService
{
    private const DISK = 'local';

    /** CSV 種別（MeetingCsvDiffPreviewService と同一。有効行のフィルタに使用） */
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
     * 最新 CSV から名前解決できた Member について、name / name_kana / category の差分候補を返す。
     *
     * @return array{
     *     summary: array{
     *         updated_member_basic_count: int,
     *         category_changed_count: int,
     *         unresolved_member_count: int,
     *         unchanged_member_count: int
     *     },
     *     updated_member_basic: array<int, array<string, mixed>>,
     *     category_changed: array<int, array<string, mixed>>,
     *     unresolved_member: array<int, array{csv_name: string, csv_category: string|null}>
     * }
     */
    public function memberDiffPreview(Meeting $meeting, MeetingCsvImport $import): array
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
                    'duplicate_name_warning' => false,
                    'duplicate_count' => 0,
                ];
                continue;
            }

            $aggregated[$member->id] = [
                'csv_name' => $name,
                'kana' => isset($row['kana']) ? trim((string) $row['kana']) : '',
                'category_group' => isset($row['category_group']) ? trim((string) $row['category_group']) : '',
                'category' => isset($row['category']) ? trim((string) $row['category']) : '',
                'duplicate_name_warning' => (bool) $meta['duplicate_name_warning'],
                'duplicate_count' => (int) $meta['exact_name_match_count'],
            ];
        }

        $updatedMemberBasic = [];
        $categoryChanged = [];
        $unchangedCount = 0;

        foreach ($aggregated as $memberId => $csv) {
            $member = Member::with('category')->find($memberId);
            if ($member === null) {
                continue;
            }

            $dupWarn = (bool) ($csv['duplicate_name_warning'] ?? false);
            $dupCount = (int) ($csv['duplicate_count'] ?? 0);

            $csvKanaNorm = $this->normalizeKana($csv['kana']);
            $memberKanaNorm = $this->normalizeKana($member->name_kana ?? '');

            $nameChanged = $csv['csv_name'] !== $member->name;

            $basicChanged = $nameChanged || $csvKanaNorm !== $memberKanaNorm;

            $csvHadCategory = $csv['category_group'] !== '' || $csv['category'] !== '';
            $resolvedCatId = $csvHadCategory
                ? $this->resolveCategoryIdWithResolutions(
                    $csv['category_group'] !== '' ? $csv['category_group'] : null,
                    $csv['category'] !== '' ? $csv['category'] : null,
                    $maps
                )
                : null;

            $catChanged = false;
            if ($csvHadCategory && $resolvedCatId !== null) {
                $catChanged = (int) $member->category_id !== (int) $resolvedCatId;
            } elseif ($csvHadCategory && $resolvedCatId === null) {
                $catChanged = true;
            }

            if ($basicChanged) {
                $entry = [
                    'member_id' => $member->id,
                    'name' => $member->name,
                    'duplicate_name_warning' => $dupWarn,
                    'duplicate_count' => $dupCount,
                ];
                if ($nameChanged) {
                    $entry['current_name'] = $member->name;
                    $entry['new_name'] = $csv['csv_name'];
                }
                if ($csvKanaNorm !== $memberKanaNorm) {
                    $entry['current_name_kana'] = $member->name_kana ?? '';
                    $entry['new_name_kana'] = $csv['kana'] !== '' ? $csv['kana'] : null;
                }
                $updatedMemberBasic[] = $entry;
            }

            if ($catChanged) {
                $entry = [
                    'member_id' => $member->id,
                    'name' => $member->name,
                    'current_category' => $this->memberCategoryLabel($member),
                    'new_category' => $resolvedCatId !== null
                        ? $this->categoryLabelById($resolvedCatId)
                        : $this->csvCategoryLabelFromParts($csv['category_group'], $csv['category']),
                    'category_master_resolved' => $resolvedCatId !== null,
                    'resolved_category_id' => $resolvedCatId,
                    'duplicate_name_warning' => $dupWarn,
                    'duplicate_count' => $dupCount,
                ];
                $categoryChanged[] = $entry;
            }

            if (! $basicChanged && ! $catChanged) {
                $unchangedCount++;
            }
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
                'updated_member_basic_count' => count($updatedMemberBasic),
                'category_changed_count' => count($categoryChanged),
                'unresolved_member_count' => count($unresolved),
                'unchanged_member_count' => $unchangedCount,
                'duplicate_name_member_count' => $duplicateNameMemberCount,
            ],
            'updated_member_basic' => $updatedMemberBasic,
            'category_changed' => $categoryChanged,
            'unresolved_member' => $unresolved,
        ];
    }

    /**
     * @param  array{member: array, category: array, role: array}  $maps
     */
    private function resolveCategoryIdWithResolutions(?string $groupName, ?string $categoryName, array $maps): ?int
    {
        $g = $groupName !== null && trim($groupName) !== '' ? trim($groupName) : null;
        $n = $categoryName !== null && trim($categoryName) !== '' ? trim($categoryName) : null;
        if ($g === null && $n === null) {
            return null;
        }
        $label = $this->csvCategoryLabelFromParts($g ?? '', $n ?? '');
        if ($label !== null && $label !== '') {
            $me = $maps[MeetingCsvImportResolution::TYPE_CATEGORY][$label] ?? null;
            if ($me !== null && Category::whereKey($me['id'])->exists()) {
                return (int) $me['id'];
            }
        }

        return $this->resolveCategoryIdReadOnly($groupName, $categoryName);
    }

    /**
     * firstOrCreate は使わず、既存 categories のみ照合する。
     */
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

    private function normalizeKana(?string $v): string
    {
        if ($v === null) {
            return '';
        }
        $t = trim($v);

        return $t === '' ? '' : $t;
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

    private function memberCategoryLabel(Member $member): string
    {
        if ($member->category_id === null) {
            return '';
        }
        if (! $member->relationLoaded('category')) {
            $member->load('category');
        }
        $c = $member->category;
        if ($c === null) {
            return '';
        }

        return $c->group_name === $c->name ? $c->name : ($c->group_name.' / '.$c->name);
    }

    private function categoryLabelById(int $id): string
    {
        $c = Category::find($id);
        if ($c === null) {
            return '';
        }

        return $c->group_name === $c->name ? $c->name : ($c->group_name.' / '.$c->name);
    }
}
