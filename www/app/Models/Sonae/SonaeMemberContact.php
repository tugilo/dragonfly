<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeMemberContact extends Model
{
    protected $table = 'sonae_member_contacts';

    protected $fillable = [
        'member_id',
        'contact_type',
        'value',
        'is_primary',
        'verified_at',
    ];

    protected function casts(): array
    {
        return [
            'is_primary' => 'boolean',
            'verified_at' => 'datetime',
        ];
    }

    public function member(): BelongsTo
    {
        return $this->belongsTo(SonaeMember::class, 'member_id');
    }
}
