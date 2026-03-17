<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MeetingParticipantImport extends Model
{
    public const PARSE_STATUS_PENDING = 'pending';
    public const PARSE_STATUS_SUCCESS = 'success';
    public const PARSE_STATUS_FAILED = 'failed';

    protected $fillable = [
        'meeting_id',
        'file_path',
        'original_filename',
        'status',
        'parsed_at',
        'parse_status',
        'extracted_text',
        'extracted_result',
        'imported_at',
        'applied_count',
    ];

    protected function casts(): array
    {
        return [
            'parsed_at' => 'datetime',
            'extracted_result' => 'array',
            'imported_at' => 'datetime',
        ];
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }
}
