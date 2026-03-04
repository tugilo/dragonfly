<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class BreakoutRoom extends Model
{
    use HasFactory;

    protected $table = 'breakout_rooms';

    protected $fillable = [
        'meeting_id',
        'breakout_round_id',
        'room_label',
        'sort_order',
        'notes',
    ];

    public function breakoutRound(): BelongsTo
    {
        return $this->belongsTo(BreakoutRound::class);
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function participants(): BelongsToMany
    {
        return $this->belongsToMany(Participant::class, 'participant_breakout')
            ->withTimestamps();
    }

    public function breakoutMemos(): HasMany
    {
        return $this->hasMany(BreakoutMemo::class, 'breakout_room_id');
    }
}
