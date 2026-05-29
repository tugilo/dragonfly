<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Zoom 取り込みステージング（SPEC-012 Phase B）。
 * Zoom から取得した候補を保持し、確定時に one_to_ones へ反映する。
 */
class ZoomMeetingImport extends Model
{
    protected $table = 'zoom_meeting_imports';

    public const STATUS_PENDING = 'pending';

    public const STATUS_IMPORTED = 'imported';

    public const STATUS_SKIPPED = 'skipped';

    public const STATUS_HELD = 'held';

    public const KIND_SCHEDULED = 'scheduled';

    public const KIND_PAST = 'past';

    protected $fillable = [
        'user_id',
        'owner_member_id',
        'workspace_id',
        'zoom_meeting_id',
        'zoom_meeting_uuid',
        'kind',
        'topic',
        'start_time',
        'end_time',
        'duration_minutes',
        'participants_count',
        'is_one_to_one_candidate',
        'confidence',
        'matched_member_id',
        'match_status',
        'counterpart_name',
        'counterpart_email',
        'selected',
        'status',
        'one_to_one_id',
        'raw',
    ];

    protected function casts(): array
    {
        return [
            'start_time' => 'datetime',
            'end_time' => 'datetime',
            'is_one_to_one_candidate' => 'boolean',
            'selected' => 'boolean',
            'raw' => 'array',
        ];
    }

    public function matchedMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'matched_member_id');
    }

    public function oneToOne(): BelongsTo
    {
        return $this->belongsTo(OneToOne::class, 'one_to_one_id');
    }
}
