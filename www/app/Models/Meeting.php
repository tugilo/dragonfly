<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Meeting extends Model
{
    use HasFactory;

    protected $fillable = [
        'number',
        'held_on',
        'name',
    ];

    protected function casts(): array
    {
        return [
            'held_on' => 'date',
        ];
    }

    public function participantImport(): HasOne
    {
        return $this->hasOne(MeetingParticipantImport::class);
    }

    public function csvImports(): HasMany
    {
        return $this->hasMany(MeetingCsvImport::class);
    }

    public function csvApplyLogs(): HasMany
    {
        return $this->hasMany(MeetingCsvApplyLog::class);
    }

    public function participants(): HasMany
    {
        return $this->hasMany(Participant::class);
    }

    public function breakoutRooms(): HasMany
    {
        return $this->hasMany(BreakoutRoom::class);
    }

    public function breakoutRounds(): HasMany
    {
        return $this->hasMany(BreakoutRound::class);
    }

    public function breakoutMemos(): HasMany
    {
        return $this->hasMany(BreakoutMemo::class);
    }
}
