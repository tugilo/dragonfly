<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingCsvImport;
use App\Models\Participant;
use Illuminate\Support\Facades\Storage;

/**
 * D2: CSV 反映前の差分プレビュー。member 解決（M8.5: resolution → 名前一致）→ member_id ベースで追加・更新・未掲載を算出する。
 * No は表示用のみで識別には使わない。
 */
class MeetingCsvDiffPreviewService
{
    private const DISK = 'local';

    /** CSV 種別 → participants.type（CLI / Apply と同一） */
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
     * 最新 CSV と既存 participants の差分を返す。Member は作成せず既存のみ名前解決する。
     *
     * @return array{summary: array{added_count: int, updated_count: int, unchanged_count: int, missing_count: int}, added: array, updated: array, missing: array}
     */
    public function diffPreview(Meeting $meeting, MeetingCsvImport $import): array
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

        $existing = Participant::where('meeting_id', $meeting->id)
            ->with(['member', 'breakoutRooms'])
            ->get();
        $existingByMemberId = $existing->keyBy('member_id');
        $csvEntries = $this->resolveRowsToCsvEntries($import, $rows);
        $csvMemberIds = array_keys($csvEntries);

        $added = [];
        $updated = [];
        $unchangedCount = 0;

        foreach ($csvEntries as $memberId => $entry) {
            $participant = $existingByMemberId->get($memberId);
            $participantType = $entry['type'];
            if ($participant === null) {
                $added[] = [
                    'name' => $entry['name'],
                    'type' => $participantType,
                    'member_id' => $memberId,
                    'source_no' => $entry['source_no'],
                    'duplicate_name_warning' => $entry['duplicate_name_warning'] ?? false,
                    'duplicate_count' => $entry['duplicate_count'] ?? 0,
                ];
            } elseif ($participant->type !== $participantType) {
                $updated[] = [
                    'name' => $entry['name'],
                    'member_id' => $memberId,
                    'current_type' => $participant->type,
                    'new_type' => $participantType,
                    'source_no' => $entry['source_no'],
                    'duplicate_name_warning' => $entry['duplicate_name_warning'] ?? false,
                    'duplicate_count' => $entry['duplicate_count'] ?? 0,
                ];
            } else {
                $unchangedCount++;
            }
        }

        $addedNamesForNewMember = [];
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
                if (! isset($addedNamesForNewMember[$name])) {
                    $addedNamesForNewMember[$name] = true;
                    $added[] = [
                        'name' => $name,
                        'type' => self::TYPE_MAP[$typeRaw],
                        'member_id' => null,
                        'source_no' => isset($row['no']) && trim((string) $row['no']) !== '' ? trim((string) $row['no']) : null,
                        'duplicate_name_warning' => false,
                        'duplicate_count' => 0,
                    ];
                }
            }
        }

        $missing = [];
        foreach ($existing as $p) {
            if (in_array($p->member_id, $csvMemberIds, true)) {
                continue;
            }
            $hasBreakout = $p->relationLoaded('breakoutRooms')
                ? $p->breakoutRooms->isNotEmpty()
                : $p->breakoutRooms()->exists();
            $missing[] = [
                'name' => $p->member->name ?? '',
                'member_id' => $p->member_id,
                'current_type' => $p->type,
                'has_breakout' => $hasBreakout,
                'deletable' => ! $hasBreakout,
                'reason' => $hasBreakout ? 'breakout_attached' : null,
            ];
        }

        return [
            'summary' => [
                'added_count' => count($added),
                'updated_count' => count($updated),
                'unchanged_count' => $unchangedCount,
                'missing_count' => count($missing),
            ],
            'added' => $added,
            'updated' => $updated,
            'missing' => $missing,
        ];
    }

    /**
     * 有効な CSV 行を名前解決し、member が存在するものだけ member_id => [type, source_no, name] を返す。
     * 同一 member_id は最後の行で上書き（No は識別に使わない）。
     *
     * @param  array<int, array<string, string|null>>  $rows
     * @return array<int, array{type: string, source_no: string|null, name: string}>
     */
    private function resolveRowsToCsvEntries(MeetingCsvImport $import, array $rows): array
    {
        $out = [];
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
                continue;
            }
            $out[$member->id] = [
                'type' => self::TYPE_MAP[$typeRaw],
                'source_no' => isset($row['no']) && trim((string) $row['no']) !== '' ? trim((string) $row['no']) : null,
                'name' => $member->name,
                'duplicate_name_warning' => (bool) $meta['duplicate_name_warning'],
                'duplicate_count' => (int) $meta['exact_name_match_count'],
            ];
        }
        return $out;
    }
}
