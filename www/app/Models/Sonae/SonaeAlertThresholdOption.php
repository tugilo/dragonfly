<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeAlertThresholdOption extends Model
{
    protected $table = 'sonae_alert_threshold_options';

    protected $fillable = [
        'alert_type_id',
        'code',
        'label',
        'severity_rank',
        'sort_order',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'severity_rank' => 'integer',
            'sort_order' => 'integer',
            'is_active' => 'boolean',
        ];
    }

    public function alertType(): BelongsTo
    {
        return $this->belongsTo(SonaeAlertType::class, 'alert_type_id');
    }
}
