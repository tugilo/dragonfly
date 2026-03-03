<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DragonflyContactEvent extends Model
{
    public $timestamps = false;

    public const CREATED_AT = 'created_at';

    protected $table = 'dragonfly_contact_events';

    protected $fillable = [
        'owner_member_id',
        'target_member_id',
        'meeting_id',
        'event_type',
        'reason',
        'meta',
    ];

    /** @var array<string, string> */
    protected $casts = [
        'meta' => 'array',
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
