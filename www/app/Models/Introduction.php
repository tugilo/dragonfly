<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Religo 外部リファーラル（紹介の矢印）。SSOT: docs/SSOT/DATA_MODEL.md §4.13.
 *
 * 物理カラム `note` は歴史的名称（SSOT の notes 表記と非一致）。
 */
class Introduction extends Model
{
    protected $fillable = [
        'workspace_id',
        'owner_member_id',
        'from_member_id',
        'to_member_id',
        'referral_kind',
        'meeting_id',
        'introduced_at',
        'note',
    ];

    protected function casts(): array
    {
        return [
            'introduced_at' => 'date',
        ];
    }

    public function ownerMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'owner_member_id');
    }

    public function fromMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'from_member_id');
    }

    public function toMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'to_member_id');
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function workspace(): BelongsTo
    {
        return $this->belongsTo(Workspace::class, 'workspace_id');
    }
}
