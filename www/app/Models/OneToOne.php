<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Religo 1 to 1. SSOT: docs/SSOT/DATA_MODEL.md §4.9.
 */
class OneToOne extends Model
{
    protected $table = 'one_to_ones';

    protected $fillable = [
        'workspace_id',
        'owner_member_id',
        'target_member_id',
        'meeting_id',
        'status',
        'scheduled_at',
        'started_at',
        'ended_at',
        'notes',
    ];

    protected function casts(): array
    {
        return [
            'scheduled_at' => 'datetime',
            'started_at' => 'datetime',
            'ended_at' => 'datetime',
        ];
    }

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
