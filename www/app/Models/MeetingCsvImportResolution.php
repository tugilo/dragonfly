<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * M7-M7: CSV 上の文字列（名前・カテゴリーラベル・役職名）をマスタ ID にマッピング。
 */
class MeetingCsvImportResolution extends Model
{
    public const TYPE_MEMBER = 'member';

    public const TYPE_CATEGORY = 'category';

    public const TYPE_ROLE = 'role';

    public const ACTION_MAPPED = 'mapped';

    public const ACTION_CREATED = 'created';

    protected $fillable = [
        'meeting_csv_import_id',
        'resolution_type',
        'source_value',
        'resolved_id',
        'resolved_label',
        'action_type',
    ];

    public function csvImport(): BelongsTo
    {
        return $this->belongsTo(MeetingCsvImport::class, 'meeting_csv_import_id');
    }

    /**
     * @return array{member: array<string, array{id: int, label: string|null}>, category: array<string, array{id: int, label: string|null}>, role: array<string, array{id: int, label: string|null}>}
     */
    public static function mapsForImport(int $meetingCsvImportId): array
    {
        $out = [
            self::TYPE_MEMBER => [],
            self::TYPE_CATEGORY => [],
            self::TYPE_ROLE => [],
        ];
        $rows = self::query()->where('meeting_csv_import_id', $meetingCsvImportId)->get();
        foreach ($rows as $row) {
            if (! isset($out[$row->resolution_type])) {
                continue;
            }
            $out[$row->resolution_type][$row->source_value] = [
                'id' => (int) $row->resolved_id,
                'label' => $row->resolved_label,
            ];
        }

        return $out;
    }
}
