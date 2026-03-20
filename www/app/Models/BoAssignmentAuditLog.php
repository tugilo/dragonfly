<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * BO（breakout）割当保存の監査。SSOT: docs/SSOT/BO_AUDIT_LOG_DESIGN.md
 */
class BoAssignmentAuditLog extends Model
{
    public const SOURCE_CONNECTIONS_BREAKOUTS = 'connections_breakouts';

    public const SOURCE_BREAKOUT_ROUNDS = 'breakout_rounds';

    protected $fillable = [
        'meeting_id',
        'actor_user_id',
        'actor_owner_member_id',
        'workspace_id',
        'source',
        'payload',
        'occurred_at',
    ];

    protected function casts(): array
    {
        return [
            'payload' => 'array',
            'occurred_at' => 'datetime',
        ];
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function actorUser(): BelongsTo
    {
        return $this->belongsTo(User::class, 'actor_user_id');
    }
}
