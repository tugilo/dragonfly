<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class MeetingReferralSuggestionRun extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'meeting_id',
        'meeting_minute_id',
        'owner_member_id',
        'workspace_id',
        'body_digest',
        'body_char_count',
        'generator',
        'model',
        'raw_response',
        'created_at',
    ];

    protected function casts(): array
    {
        return [
            'created_at' => 'datetime',
        ];
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function suggestions(): HasMany
    {
        return $this->hasMany(MeetingReferralSuggestion::class, 'run_id');
    }
}
