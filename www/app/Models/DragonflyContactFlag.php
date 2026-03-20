<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DragonflyContactFlag extends Model
{
    protected $table = 'dragonfly_contact_flags';

    protected $fillable = [
        'workspace_id',
        'owner_member_id',
        'target_member_id',
        'interested',
        'want_1on1',
        'extra_status',
    ];

    /** @var array<string, string> */
    protected $casts = [
        'interested' => 'boolean',
        'want_1on1' => 'boolean',
        'extra_status' => 'array',
    ];

    public function ownerMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'owner_member_id');
    }

    public function targetMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'target_member_id');
    }
}
