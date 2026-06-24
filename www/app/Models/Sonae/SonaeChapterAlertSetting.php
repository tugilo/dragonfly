<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeChapterAlertSetting extends Model
{
    protected $table = 'sonae_chapter_alert_settings';

    protected $fillable = [
        'chapter_id',
        'alert_type_id',
        'is_enabled',
        'target_prefectures',
        'target_municipalities',
        'threshold_code',
    ];

    protected function casts(): array
    {
        return [
            'is_enabled' => 'boolean',
            'target_prefectures' => 'array',
            'target_municipalities' => 'array',
        ];
    }

    public function chapter(): BelongsTo
    {
        return $this->belongsTo(SonaeChapter::class, 'chapter_id');
    }

    public function alertType(): BelongsTo
    {
        return $this->belongsTo(SonaeAlertType::class, 'alert_type_id');
    }
}
