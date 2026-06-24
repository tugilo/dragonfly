<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SonaeLineUserLink extends Model
{
    protected $table = 'sonae_line_user_links';

    protected $fillable = [
        'line_account_id',
        'member_id',
        'line_user_id',
        'linked_at',
        'unlinked_at',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'linked_at' => 'datetime',
            'unlinked_at' => 'datetime',
        ];
    }

    public function lineAccount(): BelongsTo
    {
        return $this->belongsTo(SonaeLineAccount::class, 'line_account_id');
    }

    public function member(): BelongsTo
    {
        return $this->belongsTo(SonaeMember::class, 'member_id');
    }
}
