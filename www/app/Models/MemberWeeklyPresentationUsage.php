<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * ウィークリー稿の利用日。SPEC-004 / Phase 307.
 */
class MemberWeeklyPresentationUsage extends Model
{
    protected $table = 'member_weekly_presentation_usages';

    protected $fillable = [
        'member_id',
        'pattern_id',
        'used_on',
        'used_at',
    ];

    protected function casts(): array
    {
        return [
            'used_on' => 'date',
            'used_at' => 'datetime',
        ];
    }

    public function member(): BelongsTo
    {
        return $this->belongsTo(Member::class);
    }
}
