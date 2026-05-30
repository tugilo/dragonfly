<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Zoom 取り込み実行の監査ログ（SPEC-012 Phase B）。
 */
class ZoomImportApplyLog extends Model
{
    protected $table = 'zoom_import_apply_logs';

    protected $fillable = [
        'user_id',
        'executed_at',
        'action',
        'imported_count',
        'held_count',
        'skipped_count',
        'meta',
    ];

    protected function casts(): array
    {
        return [
            'executed_at' => 'datetime',
            'meta' => 'array',
        ];
    }
}
