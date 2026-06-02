<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MeetingMinute extends Model
{
    use HasFactory;

    protected $fillable = [
        'meeting_id',
        'body_markdown',
        'source_path',
        'doc_type',
        'session_date',
        'session_time_jst',
        'session_time_note',
        'format',
        'source',
        'front_matter',
        'imported_at',
    ];

    protected function casts(): array
    {
        return [
            'session_date' => 'date',
            'front_matter' => 'array',
            'imported_at' => 'datetime',
        ];
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }
}
