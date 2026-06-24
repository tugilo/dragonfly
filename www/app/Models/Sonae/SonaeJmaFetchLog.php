<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeJmaFetchLog extends Model
{
    protected $table = 'sonae_jma_fetch_logs';

    protected $fillable = [
        'jma_fetch_setting_id',
        'fetch_type',
        'status',
        'started_at',
        'finished_at',
        'fetched_count',
        'created_event_count',
        'skipped_duplicate_count',
        'error_message',
    ];

    protected function casts(): array
    {
        return [
            'started_at' => 'datetime',
            'finished_at' => 'datetime',
            'fetched_count' => 'integer',
            'created_event_count' => 'integer',
            'skipped_duplicate_count' => 'integer',
        ];
    }

    public function setting(): BelongsTo
    {
        return $this->belongsTo(SonaeJmaFetchSetting::class, 'jma_fetch_setting_id');
    }
}
