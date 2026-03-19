<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * M7-C1: Meeting に紐づく参加者CSVアップロード履歴。1 Meeting に複数件可。
 */
class MeetingCsvImport extends Model
{
    protected $fillable = [
        'meeting_id',
        'file_path',
        'file_name',
        'uploaded_at',
        'imported_at',
        'applied_count',
    ];

    protected function casts(): array
    {
        return [
            'uploaded_at' => 'datetime',
            'imported_at' => 'datetime',
        ];
    }

    public function meeting(): BelongsTo
    {
        return $this->belongsTo(Meeting::class);
    }

    public function resolutions(): HasMany
    {
        return $this->hasMany(MeetingCsvImportResolution::class, 'meeting_csv_import_id');
    }

    public function applyLogs(): HasMany
    {
        return $this->hasMany(MeetingCsvApplyLog::class, 'meeting_csv_import_id');
    }
}
