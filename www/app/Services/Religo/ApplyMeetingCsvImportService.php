<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingCsvImport;
use App\Models\Member;
use App\Models\Participant;
use Illuminate\Support\Facades\Storage;

/**
 * M7-C3 + M1 + D3: 保存済み参加者CSVを participants に反映する。
 * M1: 差分更新（追加・更新。削除はオプション）。
 * D3: delete_missing=true のとき、BO なしの missing participant のみ削除。BO ありは保護。
 */
class ApplyMeetingCsvImportService
{
    private const DISK = 'local';

    /** CSV 種別 → [members.type, participants.type]（CLI TYPE_MAP に合わせる） */
    private const TYPE_MAP = [
        'メンバー' => ['member', 'regular'],
        'ビジター' => ['visitor', 'visitor'],
        'ゲスト' => ['guest', 'guest'],
        '代理出席' => ['guest', 'proxy'],
    ];

    public function __construct(
        private MeetingCsvPreviewService $previewService,
        private MeetingCsvMemberResolver $memberResolver
    ) {}

    /**
     * 対象 Meeting の最新 CSV import を差分更新で反映する。
     * delete_missing=true のとき、CSV にない既存 participant のうち has_breakout=false のみ削除。BO ありは削除しない。
     *
     * @param  array{delete_missing?: bool}  $options  delete_missing: true で missing のうち BO なしを削除
     * @return array{added_count: int, updated_count: int, missing_count: int, deleted_count: int, protected_count: int, applied_count: int}
     */
    public function apply(Meeting $meeting, MeetingCsvImport $import, array $options = []): array
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

        $csvMemberIdToType = $this->resolveCsvRowsToMembers($import, $rows);
        $diff = $this->buildParticipantDiff($meeting, $csvMemberIdToType);
        $this->applyParticipantDiff($meeting, $diff);

        $deleteMissing = ! empty($options['delete_missing']);
        $deletedCount = 0;
        $protectedCount = 0;
        if ($deleteMissing && count($diff['missing']) > 0) {
            $deleteResult = $this->deleteMissingParticipants($diff['missing']);
            $deletedCount = $deleteResult['deleted_count'];
            $protectedCount = $deleteResult['protected_count'];
        }

        $appliedCount = $diff['added_count'] + $diff['updated_count'] + $deletedCount;
        $import->update([
            'imported_at' => now(),
            'applied_count' => $appliedCount,
        ]);

        return [
            'added_count' => $diff['added_count'],
            'updated_count' => $diff['updated_count'],
            'missing_count' => $diff['missing_count'],
            'deleted_count' => $deletedCount,
            'protected_count' => $protectedCount,
            'applied_count' => $appliedCount,
        ];
    }

    /**
     * CSV 行をパースし、有効な行について member を解決して [member_id => participant_type] を返す。
     *
     * @param  array<int, array<string, string|null>>  $rows  preview の rows（type, name, kana 等）
     * @return array<int, string>  member_id => participants.type
     */
    private function resolveCsvRowsToMembers(MeetingCsvImport $import, array $rows): array
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
            [$memberType, $participantType] = self::TYPE_MAP[$typeRaw];
            $member = $this->resolveOrCreateMember($import, $row, $name, $memberType);
            $out[$member->id] = $participantType;
        }

        return $out;
    }

    /**
     * CSV 由来の member_id => type と既存 participants を比較し、追加・更新・未掲載を分類する。
     * missing は削除候補判定用に participant_id と has_breakout を含む。
     *
     * @param  array<int, string>  $csvMemberIdToType  member_id => participants.type
     * @return array{added: array<int, string>, updated: array<int, array{participant_id: int, type: string}>, missing: array<int, array{participant_id: int, has_breakout: bool}>, missing_count: int, added_count: int, updated_count: int}
     */
    private function buildParticipantDiff(Meeting $meeting, array $csvMemberIdToType): array
    {
        $existing = Participant::where('meeting_id', $meeting->id)->with('breakoutRooms')->get();
        $existingByMemberId = $existing->keyBy('member_id');

        $added = [];
        $updated = [];

        foreach ($csvMemberIdToType as $memberId => $participantType) {
            $participant = $existingByMemberId->get($memberId);
            if ($participant === null) {
                $added[$memberId] = $participantType;
            } else {
                if ($participant->type !== $participantType) {
                    $updated[$memberId] = [
                        'participant_id' => $participant->id,
                        'type' => $participantType,
                    ];
                }
            }
        }

        $missing = [];
        foreach ($existing as $p) {
            if (isset($csvMemberIdToType[$p->member_id])) {
                continue;
            }
            $hasBreakout = $p->relationLoaded('breakoutRooms')
                ? $p->breakoutRooms->isNotEmpty()
                : $p->breakoutRooms()->exists();
            $missing[] = [
                'participant_id' => $p->id,
                'has_breakout' => $hasBreakout,
            ];
        }

        return [
            'added' => $added,
            'updated' => $updated,
            'missing' => $missing,
            'missing_count' => count($missing),
            'added_count' => count($added),
            'updated_count' => count($updated),
        ];
    }

    /**
     * 差分に従い participant を追加・更新する。削除は行わない。
     *
     * @param  array{added: array<int, string>, updated: array<int, array{participant_id: int, type: string}>}  $diff
     */
    private function applyParticipantDiff(Meeting $meeting, array $diff): void
    {
        foreach ($diff['added'] as $memberId => $participantType) {
            Participant::create([
                'meeting_id' => $meeting->id,
                'member_id' => $memberId,
                'type' => $participantType,
                'introducer_member_id' => null,
                'attendant_member_id' => null,
            ]);
        }

        foreach ($diff['updated'] as $update) {
            Participant::where('id', $update['participant_id'])->update([
                'type' => $update['type'],
            ]);
        }
    }

    /**
     * 削除候補のうち has_breakout=false のみ削除する。BO ありは保護。
     *
     * @param  array<int, array{participant_id: int, has_breakout: bool}>  $missing  buildParticipantDiff の missing
     * @return array{deleted_count: int, protected_count: int}
     */
    private function deleteMissingParticipants(array $missing): array
    {
        $toDelete = array_filter($missing, fn ($m) => ! $m['has_breakout']);
        $protectedCount = count($missing) - count($toDelete);
        foreach ($toDelete as $m) {
            Participant::where('id', $m['participant_id'])->delete();
        }

        return [
            'deleted_count' => count($toDelete),
            'protected_count' => $protectedCount,
        ];
    }

    private function resolveOrCreateMember(MeetingCsvImport $import, array $row, string $name, string $memberType): Member
    {
        $member = $this->memberResolver->resolveExistingForCsvName($import->id, $name);
        if ($member !== null) {
            return $member;
        }

        $nameKana = isset($row['kana']) && trim((string) $row['kana']) !== '' ? trim((string) $row['kana']) : null;

        return Member::create([
            'name' => $name,
            'name_kana' => $nameKana,
            'category_id' => null,
            'type' => $memberType,
            'display_no' => null,
            'introducer_member_id' => null,
            'attendant_member_id' => null,
        ]);
    }
}
