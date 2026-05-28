<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * リージョンマスタ（例: BNI 東京NEリージョン）。Country の下、Workspace の上。
 */
class Region extends Model
{
    protected $fillable = ['country_id', 'name'];

    public function country(): BelongsTo
    {
        return $this->belongsTo(Country::class);
    }

    public function workspaces(): HasMany
    {
        return $this->hasMany(Workspace::class);
    }
}
