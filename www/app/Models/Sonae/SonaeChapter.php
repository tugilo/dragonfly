<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class SonaeChapter extends Model
{
    protected $table = 'sonae_chapters';

    protected $fillable = [
        'organization_id',
        'name',
        'code',
        'chapter_key',
        'source_system',
        'external_id',
        'prefecture',
        'municipalities',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'municipalities' => 'array',
        ];
    }

    public function organization(): BelongsTo
    {
        return $this->belongsTo(SonaeOrganization::class, 'organization_id');
    }

    public function members(): HasMany
    {
        return $this->hasMany(SonaeMember::class, 'chapter_id');
    }

    public function lineAccount(): HasOne
    {
        return $this->hasOne(SonaeLineAccount::class, 'chapter_id');
    }

    public function alertSettings(): HasMany
    {
        return $this->hasMany(SonaeChapterAlertSetting::class, 'chapter_id');
    }

    public function alertNotifications(): HasMany
    {
        return $this->hasMany(SonaeAlertNotification::class, 'chapter_id');
    }

    public function trainingEvents(): HasMany
    {
        return $this->hasMany(SonaeTrainingEvent::class, 'chapter_id');
    }

    public function isReligoLinked(): bool
    {
        return $this->source_system === SonaeConstants::SOURCE_RELIGO
            && $this->external_id !== null;
    }
}
