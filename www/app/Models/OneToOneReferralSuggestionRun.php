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
        'context_mode',
        'context_digest',
        'subject_member_id',
        'corpus_meta',
        'generator',
        'model',
        'raw_response',
        'created_at',
    ];

    protected function casts(): array
    {
        return [
            'created_at' => 'datetime',
            'corpus_meta' => 'array',
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
