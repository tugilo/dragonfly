<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeAlertType extends Model
{
    protected $table = 'sonae_alert_types';

    protected $fillable = [
        'code',
        'name',
        'sort_order',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'is_active' => 'boolean',
            'sort_order' => 'integer',
        ];
    }

    public function alertEvents(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(SonaeAlertEvent::class, 'alert_type_id');
    }
}
