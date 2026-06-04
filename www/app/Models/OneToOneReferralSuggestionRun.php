<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class OneToOneReferralSuggestionRun extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'one_to_one_id',
        'owner_member_id',
        'workspace_id',
        'notes_digest',
        'notes_char_count',
        'generator',
        'model',
        'raw_response',
        'created_at',
    ];

    protected function casts(): array
    {
        return [
            'created_at' => 'datetime',
        ];
    }

    public function oneToOne(): BelongsTo
    {
        return $this->belongsTo(OneToOne::class, 'one_to_one_id');
    }

    public function suggestions(): HasMany
    {
        return $this->hasMany(OneToOneReferralSuggestion::class, 'run_id');
    }
}
