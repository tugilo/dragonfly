<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MeetingReferralSuggestion extends Model
{
    public const STATUS_PENDING = 'pending';

    public const STATUS_ACCEPTED = 'accepted';

    public const STATUS_DISMISSED = 'dismissed';

    public const STATUS_DEFERRED = 'deferred';

    protected $fillable = [
        'run_id',
        'meeting_id',
        'source_section',
        'subject_member_id',
        'direction',
        'corpus_source',
        'summary',
        'rationale',
        'quality_notes',
        'suggested_from_member_id',
        'suggested_to_member_id',
        'suggested_to_label',
        'suggested_contact_label',
        'source_one_to_one_id',
        'source_meeting_id',
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
        return $this->belongsTo(MeetingReferralSuggestionRun::class, 'run_id');
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }
}
