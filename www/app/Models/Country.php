<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * 国マスタ。Region / Workspace（チャプター）の上位階層。
 */
class Country extends Model
{
    protected $fillable = ['name'];

    public function regions(): HasMany
    {
        return $this->hasMany(Region::class);
    }
}
