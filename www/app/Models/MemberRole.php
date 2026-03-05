<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MemberRole extends Model
{
    protected $fillable = [
        'member_id',
        'role_id',
        'term_start',
        'term_end',
    ];

    protected $casts = [
        'term_start' => 'date',
        'term_end' => 'date',
    ];

    public function member(): BelongsTo
    {
        return $this->belongsTo(Member::class);
    }

    public function role(): BelongsTo
    {
        return $this->belongsTo(Role::class);
    }
}
