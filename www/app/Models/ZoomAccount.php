<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Zoom 連携（SPEC-012）: ユーザー（Owner）単位の OAuth 接続。
 * トークンは encrypted キャストで DB に暗号化保存する（APP_KEY を使用）。
 */
class ZoomAccount extends Model
{
    protected $table = 'zoom_accounts';

    protected $fillable = [
        'user_id',
        'zoom_user_id',
        'zoom_account_id',
        'zoom_email',
        'access_token',
        'refresh_token',
        'token_expires_at',
        'scopes',
    ];

    protected $hidden = [
        'access_token',
        'refresh_token',
    ];

    protected function casts(): array
    {
        return [
            'access_token' => 'encrypted',
            'refresh_token' => 'encrypted',
            'token_expires_at' => 'datetime',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /** トークンが期限切れ（または 60 秒以内に切れる）か。 */
    public function isExpired(): bool
    {
        if ($this->token_expires_at === null) {
            return true;
        }

        return $this->token_expires_at->subSeconds(60)->isPast();
    }
}
