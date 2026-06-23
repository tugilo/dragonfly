<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class MeetingType extends Model
{
    protected $fillable = [
        'code',
        'name_ja',
        'is_numbered',
        'requires_team_id',
        'supports_participants',
        'supports_breakouts',
        'supports_referral_suggestions',
        'sort_order',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'is_numbered' => 'boolean',
            'requires_team_id' => 'boolean',
            'supports_participants' => 'boolean',
            'supports_breakouts' => 'boolean',
            'supports_referral_suggestions' => 'boolean',
            'is_active' => 'boolean',
        ];
    }

    public function meetings(): HasMany
    {
        return $this->hasMany(Meeting::class);
    }

    public static function idForCode(string $code): int
    {
        $id = self::query()->where('code', $code)->value('id');

        if ($id === null) {
            throw new \RuntimeException("Unknown meeting type code: {$code}");
        }

        return (int) $id;
    }
}
