<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeErrorLog extends Model
{
    protected $table = 'sonae_error_logs';

    protected $fillable = [
        'chapter_id',
        'category',
        'severity',
        'message',
        'context',
        'occurred_at',
    ];

    protected function casts(): array
    {
        return [
            'context' => 'array',
            'occurred_at' => 'datetime',
        ];
    }

    public function chapter(): BelongsTo
    {
        return $this->belongsTo(SonaeChapter::class, 'chapter_id');
    }
}
