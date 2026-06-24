<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeSafetyResponse extends Model
{
    protected $table = 'sonae_safety_responses';

    protected $fillable = [
        'notification_target_id',
        'member_id',
        'safety_status',
        'activity_status',
        'meeting_attendance_status',
        'comment',
        'submitted_at',
    ];

    protected function casts(): array
    {
        return [
            'submitted_at' => 'datetime',
        ];
    }

    public function notificationTarget(): BelongsTo
    {
        return $this->belongsTo(SonaeNotificationTarget::class, 'notification_target_id');
    }

    public function member(): BelongsTo
    {
        return $this->belongsTo(SonaeMember::class, 'member_id');
    }
}
