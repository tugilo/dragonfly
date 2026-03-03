<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Member extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'name_kana',
        'category',
        'role_notes',
        'type',
        'display_no',
        'introducer_member_id',
        'attendant_member_id',
    ];

    public function participants(): HasMany
    {
        return $this->hasMany(Participant::class);
    }

    public function introducedParticipants(): HasMany
    {
        return $this->hasMany(Participant::class, 'introducer_member_id');
    }

    public function attendedParticipants(): HasMany
    {
        return $this->hasMany(Participant::class, 'attendant_member_id');
    }

    public function introducer(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'introducer_member_id');
    }

    public function attendant(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'attendant_member_id');
    }
}
