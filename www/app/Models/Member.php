<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
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
        'workspace_id',
        'type',
        'display_no',
        'ncast_profile_url',
        'weekly_presentation_body',
        'introducer_member_id',
        'attendant_member_id',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    /** 所属チャプター（BNI 前提では 1 member = 1 workspace）. SSOT: MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md */
    public function workspace(): BelongsTo
    {
        return $this->belongsTo(Workspace::class, 'workspace_id');
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

    /**
     * 会員番号（display_no）を数値として並べ替え。NULL は常に末尾。
     * 文字列ソートだと 1,10,11,2… になるため CAST。SQLite（テスト）/ MySQL 対応。
     */
    public function scopeOrderByDisplayNoNumeric(Builder $query, string $direction = 'asc'): Builder
    {
        $dir = strtolower($direction) === 'desc' ? 'DESC' : 'ASC';
        $query->orderByRaw('display_no IS NULL ASC');
        $driver = $query->getConnection()->getDriverName();
        if ($driver === 'sqlite') {
            $query->orderByRaw('CAST(display_no AS INTEGER) '.$dir);
        } else {
            $query->orderByRaw('CAST(display_no AS UNSIGNED) '.$dir);
        }

        return $query->orderBy('id', $dir);
    }
}
