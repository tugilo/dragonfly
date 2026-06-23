<?php

namespace App\Models;

use App\Support\MeetingDisplay;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Meeting extends Model
{
    use HasFactory;

    protected $fillable = [
        'number',
        'meeting_type_id',
        'session_type',
        'team_id',
        'held_on',
        'name',
    ];

    protected function casts(): array
    {
        return [
            'held_on' => 'date',
        ];
    }

    protected static function booted(): void
    {
        static::creating(function (Meeting $meeting): void {
            if ($meeting->meeting_type_id === null) {
                $code = (string) ($meeting->session_type ?? MeetingDisplay::SESSION_CHAPTER_WEEKLY);
                $meeting->meeting_type_id = MeetingType::idForCode($code);
            }
            if ($meeting->team_id === null) {
                $meeting->team_id = '';
            }
        });
    }

    public function meetingType(): BelongsTo
    {
        return $this->belongsTo(MeetingType::class);
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

    public function meetingMinute(): HasOne
    {
        return $this->hasOne(MeetingMinute::class);
    }

    public function isNumberedChapterWeekly(): bool
    {
        return MeetingDisplay::isNumberedSession($this->session_type);
    }

    public function displayLabel(): string
    {
        return MeetingDisplay::displayLabel($this);
    }
}
