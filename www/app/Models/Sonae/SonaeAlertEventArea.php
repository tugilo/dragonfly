<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeAlertEventArea extends Model
{
    protected $table = 'sonae_alert_event_areas';

    protected $fillable = [
        'alert_event_id',
        'prefecture',
        'municipality',
        'area_code',
        'intensity',
        'warning_level',
    ];

    public function alertEvent(): BelongsTo
    {
        return $this->belongsTo(SonaeAlertEvent::class, 'alert_event_id');
    }
}
