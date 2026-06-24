<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SonaeJmaFetchSetting extends Model
{
    protected $table = 'sonae_jma_fetch_settings';

    protected $fillable = [
        'is_enabled',
        'interval_minutes',
        'last_fetched_at',
        'next_fetch_at',
    ];

    protected function casts(): array
    {
        return [
            'is_enabled' => 'boolean',
            'interval_minutes' => 'integer',
            'last_fetched_at' => 'datetime',
            'next_fetch_at' => 'datetime',
        ];
    }

    public function logs(): HasMany
    {
        return $this->hasMany(SonaeJmaFetchLog::class, 'jma_fetch_setting_id');
    }
}
