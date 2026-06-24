<?php

namespace App\Models\Sonae;

use App\Models\Concerns\ReadsEncryptedAttributes;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * SPEC-017 §10.2: チャプターごとの LINE 公式アカウント設定。
 */
class SonaeLineAccount extends Model
{
    use ReadsEncryptedAttributes;

    protected $table = 'sonae_line_accounts';

    protected $fillable = [
        'chapter_id',
        'channel_id',
        'channel_secret_encrypted',
        'messaging_api_access_token_encrypted',
        'webhook_url',
        'friend_add_url',
        'status',
    ];

    protected $hidden = [
        'channel_secret_encrypted',
        'messaging_api_access_token_encrypted',
    ];

    protected function casts(): array
    {
        return [
            'channel_secret_encrypted' => 'encrypted',
            'messaging_api_access_token_encrypted' => 'encrypted',
        ];
    }

    public function chapter(): BelongsTo
    {
        return $this->belongsTo(SonaeChapter::class, 'chapter_id');
    }

    public function userLinks(): HasMany
    {
        return $this->hasMany(SonaeLineUserLink::class, 'line_account_id');
    }

    public function hasUsableCredentials(): bool
    {
        return $this->status === SonaeConstants::STATUS_ACTIVE
            && ! empty($this->channel_id)
            && $this->readEncryptedAttribute('messaging_api_access_token_encrypted') !== null;
    }
}
