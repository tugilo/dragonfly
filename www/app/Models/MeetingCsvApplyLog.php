<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * M7-M6: Meeting 参加者CSV の反映履歴（participants / members / roles）。
 */
class MeetingCsvApplyLog extends Model
{
    public const TYPE_PARTICIPANTS = 'participants';

    public const TYPE_MEMBERS = 'members';

    public const TYPE_ROLES = 'roles';

    protected $fillable = [
        'meeting_id',
        'meeting_csv_import_id',
        'apply_type',
        'applied_on',
        'executed_at',
        'applied_count',
        'added_count',
        'updated_count',
        'deleted_count',
        'protected_count',
        'skipped_count',
        'meta',
        'executed_by_member_id',
    ];

    protected function casts(): array
    {
        return [
            'applied_on' => 'date',
            'executed_at' => 'datetime',
            'meta' => 'array',
        ];
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function csvImport(): BelongsTo
    {
        return $this->belongsTo(MeetingCsvImport::class, 'meeting_csv_import_id');
    }

    /** API / UI 用の1行サマリ（日本語・短く）。 */
    public function summaryLabel(): string
    {
        return match ($this->apply_type) {
            self::TYPE_PARTICIPANTS => sprintf(
                '追加%d 更新%d 削除%d',
                (int) ($this->added_count ?? 0),
                (int) ($this->updated_count ?? 0),
                (int) ($this->deleted_count ?? 0)
            ),
            self::TYPE_MEMBERS => sprintf(
                '基本%d カテゴリ%d',
                (int) ($this->meta['updated_member_basic_count'] ?? 0),
                (int) ($this->meta['updated_category_count'] ?? 0)
            ),
            self::TYPE_ROLES => sprintf(
                '変更%d 追加%d 終了%d',
                (int) ($this->meta['changed_role_applied_count'] ?? 0),
                (int) ($this->meta['csv_role_only_applied_count'] ?? 0),
                (int) ($this->meta['current_role_only_closed_count'] ?? 0)
            ),
            default => "件数 {$this->applied_count}",
        };
    }

    /**
     * @return array<string, mixed>
     */
    public function toApiArray(): array
    {
        return [
            'id' => $this->id,
            'apply_type' => $this->apply_type,
            'applied_on' => $this->applied_on->format('Y-m-d'),
            'executed_at' => $this->executed_at->toIso8601String(),
            'applied_count' => $this->applied_count,
            'added_count' => $this->added_count,
            'updated_count' => $this->updated_count,
            'deleted_count' => $this->deleted_count,
            'protected_count' => $this->protected_count,
            'skipped_count' => $this->skipped_count,
            'summary' => $this->summaryLabel(),
            'meta' => $this->meta,
        ];
    }
}
