<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Religo ワークスペース（会／チャプター単位）. SSOT: docs/SSOT/DATA_MODEL.md §4.1.
 * 上位に Region / Country を持ちうる（ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1）。
 */
class Workspace extends Model
{
    protected $table = 'workspaces';

    protected $fillable = ['name', 'slug', 'region_id'];

    public function region(): BelongsTo
    {
        return $this->belongsTo(Region::class);
    }

    /** 所属メンバー（members.workspace_id） */
    public function members(): HasMany
    {
        return $this->hasMany(Member::class, 'workspace_id');
    }
}
