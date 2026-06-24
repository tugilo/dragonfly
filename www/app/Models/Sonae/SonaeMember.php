<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SonaeMember extends Model
{
    protected $table = 'sonae_members';

    protected $fillable = [
        'chapter_id',
        'name',
        'name_kana',
        'email',
        'phone',
        'category',
        'role_label',
        'source_system',
        'external_id',
        'invite_token_hash',
        'status',
    ];

    public function chapter(): BelongsTo
    {
        return $this->belongsTo(SonaeChapter::class, 'chapter_id');
    }

    public function contacts(): HasMany
    {
        return $this->hasMany(SonaeMemberContact::class, 'member_id');
    }

    public function lineUserLinks(): HasMany
    {
        return $this->hasMany(SonaeLineUserLink::class, 'member_id');
    }

    public function notificationTargets(): HasMany
    {
        return $this->hasMany(SonaeNotificationTarget::class, 'member_id');
    }

    public function isActive(): bool
    {
        return $this->status === SonaeConstants::STATUS_ACTIVE;
    }
}
