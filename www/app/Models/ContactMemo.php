<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Religo 接触メモ. SSOT: docs/SSOT/DATA_MODEL.md §4.8.
 */
class ContactMemo extends Model
{
    protected $table = 'contact_memos';

    protected $fillable = [
        'workspace_id',
        'owner_member_id',
        'target_member_id',
        'meeting_id',
        'one_to_one_id',
        'memo_type',
        'body',
    ];

    public function ownerMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'owner_member_id');
    }

    public function targetMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'target_member_id');
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }
}
