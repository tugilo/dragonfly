<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class BreakoutMemo extends Model
{
    use HasFactory;

    protected $fillable = [
        'meeting_id',
        'participant_id',
        'target_participant_id',
        'breakout_room_id',
        'body',
    ];

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function participant(): BelongsTo
    {
        return $this->belongsTo(Participant::class, 'participant_id');
    }

    public function targetParticipant(): BelongsTo
    {
        return $this->belongsTo(Participant::class, 'target_participant_id');
    }

    public function breakoutRoom(): BelongsTo
    {
        return $this->belongsTo(BreakoutRoom::class, 'breakout_room_id');
    }
}
