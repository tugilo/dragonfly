<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MemberReferralCorpusSetting extends Model
{
    protected $fillable = [
        'workspace_id',
        'member_id',
        'allow_cross_corpus_contribution',
    ];

    protected function casts(): array
    {
        return [
            'allow_cross_corpus_contribution' => 'boolean',
        ];
    }

    public function member(): BelongsTo
    {
        return $this->belongsTo(Member::class);
    }

    public function workspace(): BelongsTo
    {
        return $this->belongsTo(Workspace::class);
    }
}
