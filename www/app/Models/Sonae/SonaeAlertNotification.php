<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SonaeAlertNotification extends Model
{
    protected $table = 'sonae_alert_notifications';

    protected $fillable = [
        'chapter_id',
        'alert_event_id',
        'training_event_id',
        'notification_type',
        'title',
        'body',
        'status',
        'sent_at',
        'created_by_user_id',
    ];

    protected function casts(): array
    {
        return [
            'sent_at' => 'datetime',
        ];
    }

    public function chapter(): BelongsTo
    {
        return $this->belongsTo(SonaeChapter::class, 'chapter_id');
    }

    public function alertEvent(): BelongsTo
    {
        return $this->belongsTo(SonaeAlertEvent::class, 'alert_event_id');
    }

    public function trainingEvent(): BelongsTo
    {
        return $this->belongsTo(SonaeTrainingEvent::class, 'training_event_id');
    }

    public function targets(): HasMany
    {
        return $this->hasMany(SonaeNotificationTarget::class, 'alert_notification_id');
    }
}
