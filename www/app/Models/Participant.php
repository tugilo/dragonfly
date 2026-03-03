<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Participant extends Model
{
    use HasFactory;

    protected $fillable = [
        'meeting_id',
        'member_id',
        'type',
        'introducer_member_id',
        'attendant_member_id',
    ];

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function member(): BelongsTo
    {
        return $this->belongsTo(Member::class);
    }

    public function introducer(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'introducer_member_id');
    }

    public function attendant(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'attendant_member_id');
    }

    public function breakoutRooms(): BelongsToMany
    {
        return $this->belongsToMany(BreakoutRoom::class, 'participant_breakout')
            ->withTimestamps();
    }

    public function writtenBreakoutMemos(): HasMany
    {
        return $this->hasMany(BreakoutMemo::class, 'participant_id');
    }

    public function receivedBreakoutMemos(): HasMany
    {
        return $this->hasMany(BreakoutMemo::class, 'target_participant_id');
    }
}
