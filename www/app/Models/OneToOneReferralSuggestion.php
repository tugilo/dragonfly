<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class OneToOneReferralSuggestion extends Model
{
    public const STATUS_PENDING = 'pending';

    public const STATUS_ACCEPTED = 'accepted';

    public const STATUS_DISMISSED = 'dismissed';

    public const STATUS_DEFERRED = 'deferred';

    protected $fillable = [
        'run_id',
        'one_to_one_id',
        'direction',
        'summary',
        'rationale',
        'quality_notes',
        'suggested_from_member_id',
        'suggested_to_member_id',
        'suggested_to_label',
        'confidence',
        'status',
        'introduction_id',
        'accepted_at',
        'dismissed_at',
        'edited_snapshot',
    ];

    protected function casts(): array
    {
        return [
            'accepted_at' => 'datetime',
            'dismissed_at' => 'datetime',
            'edited_snapshot' => 'array',
        ];
    }

    public function run(): BelongsTo
    {
        return $this->belongsTo(OneToOneReferralSuggestionRun::class, 'run_id');
    }

    public function oneToOne(): BelongsTo
    {
        return $this->belongsTo(OneToOne::class, 'one_to_one_id');
    }
}
