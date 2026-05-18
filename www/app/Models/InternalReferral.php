<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Religo 内部リファーラル（TYFCB）。SSOT: docs/SSOT/DATA_MODEL.md §4.14.
 */
class InternalReferral extends Model
{
    protected $fillable = [
        'workspace_id',
        'owner_member_id',
        'buyer_member_id',
        'seller_member_id',
        'summary',
        'closed_on',
        'amount_yen',
        'notes',
    ];

    protected function casts(): array
    {
        return [
            'closed_on' => 'date',
        ];
    }

    public function ownerMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'owner_member_id');
    }

    public function buyerMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'buyer_member_id');
    }

    public function sellerMember(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'seller_member_id');
    }

    public function workspace(): BelongsTo
    {
        return $this->belongsTo(Workspace::class, 'workspace_id');
    }
}
