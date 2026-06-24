<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SonaeTrainingEvent extends Model
{
    protected $table = 'sonae_training_events';

    protected $fillable = [
        'chapter_id',
        'name',
        'scenario',
        'scheduled_at',
        'executed_at',
        'created_by_user_id',
    ];

    protected function casts(): array
    {
        return [
            'scheduled_at' => 'datetime',
            'executed_at' => 'datetime',
        ];
    }

    public function chapter(): BelongsTo
    {
        return $this->belongsTo(SonaeChapter::class, 'chapter_id');
    }

    public function notifications(): HasMany
    {
        return $this->hasMany(SonaeAlertNotification::class, 'training_event_id');
    }
}
