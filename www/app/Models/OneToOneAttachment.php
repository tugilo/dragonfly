<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * SPEC-013: 1to1 事前準備の相手プロフィール添付。
 */
class OneToOneAttachment extends Model
{
    public const SOURCE_PDF = 'pdf';

    public const SOURCE_URL = 'url';

    public const SOURCE_TEXT = 'text';

    protected $table = 'one_to_one_attachments';

    protected $fillable = [
        'one_to_one_id',
        'target_member_id',
        'uploaded_by_user_id',
        'source_type',
        'file_path',
        'source_url',
        'original_name',
        'extracted_text',
        'parsed_profile',
    ];

    protected function casts(): array
    {
        return [
            'parsed_profile' => 'array',
        ];
    }

    public function oneToOne(): BelongsTo
    {
        return $this->belongsTo(OneToOne::class, 'one_to_one_id');
    }
}
