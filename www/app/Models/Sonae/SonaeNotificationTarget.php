<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class SonaeNotificationTarget extends Model
{
    protected $table = 'sonae_notification_targets';

    protected $fillable = [
        'alert_notification_id',
        'member_id',
        'line_user_link_id',
        'response_token_hash',
        'send_status',
        'sent_at',
        'responded_at',
        'error_message',
    ];

    protected function casts(): array
    {
        return [
            'sent_at' => 'datetime',
            'responded_at' => 'datetime',
        ];
    }

    public function notification(): BelongsTo
    {
        return $this->belongsTo(SonaeAlertNotification::class, 'alert_notification_id');
    }

    public function member(): BelongsTo
    {
        return $this->belongsTo(SonaeMember::class, 'member_id');
    }

    public function lineUserLink(): BelongsTo
    {
        return $this->belongsTo(SonaeLineUserLink::class, 'line_user_link_id');
    }

    public function safetyResponse(): HasOne
    {
        return $this->hasOne(SonaeSafetyResponse::class, 'notification_target_id');
    }
}
