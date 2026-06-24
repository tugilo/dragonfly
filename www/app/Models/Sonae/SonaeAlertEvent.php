<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SonaeAlertEvent extends Model
{
    protected $table = 'sonae_alert_events';

    protected $fillable = [
        'alert_type_id',
        'source',
        'source_event_key',
        'payload_hash',
        'title',
        'severity',
        'occurred_at',
        'announced_at',
        'raw_payload',
    ];

    protected function casts(): array
    {
        return [
            'occurred_at' => 'datetime',
            'announced_at' => 'datetime',
            'raw_payload' => 'array',
        ];
    }

    public function alertType(): BelongsTo
    {
        return $this->belongsTo(SonaeAlertType::class, 'alert_type_id');
    }

    public function areas(): HasMany
    {
        return $this->hasMany(SonaeAlertEventArea::class, 'alert_event_id');
    }

    public function notifications(): HasMany
    {
        return $this->hasMany(SonaeAlertNotification::class, 'alert_event_id');
    }
}
