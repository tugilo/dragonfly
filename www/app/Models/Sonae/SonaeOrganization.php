<?php

namespace App\Models\Sonae;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SonaeOrganization extends Model
{
    protected $table = 'sonae_organizations';

    protected $fillable = [
        'name',
        'source_system',
        'external_id',
        'status',
    ];

    public function chapters(): HasMany
    {
        return $this->hasMany(SonaeChapter::class, 'organization_id');
    }
}
