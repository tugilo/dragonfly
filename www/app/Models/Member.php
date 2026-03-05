<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

class Member extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'name_kana',
        'category_id',
        'type',
        'display_no',
        'introducer_member_id',
        'attendant_member_id',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function memberRoles(): HasMany
    {
        return $this->hasMany(MemberRole::class);
    }

    /** 役職履歴（member_roles 経由で roles に至る）. */
    public function roles(): HasManyThrough
    {
        return $this->hasManyThrough(Role::class, MemberRole::class, 'member_id', 'id', 'id', 'role_id');
    }

    /** 現在の役職（term_end が null かつ term_start <= today の先頭1件の role name）. */
    public function currentRole(): ?Role
    {
        $today = now()->toDateString();
        $mr = $this->memberRoles()
            ->whereNull('term_end')
            ->where('term_start', '<=', $today)
            ->with('role')
            ->orderByDesc('term_start')
            ->first();

        return $mr?->role;
    }

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
