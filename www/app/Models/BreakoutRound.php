<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Phase10R: Breakout Round（回）. 1 meeting に複数 round 可. SSOT: PHASE10R PLAN.
 */
class BreakoutRound extends Model
{
    use HasFactory;

    protected $table = 'breakout_rounds';

    protected $fillable = ['meeting_id', 'round_no', 'label'];

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function breakoutRooms(): HasMany
    {
        return $this->hasMany(BreakoutRoom::class, 'breakout_round_id');
    }
}
