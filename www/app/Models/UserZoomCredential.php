<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * SPEC-012 拡張: ユーザーごとの Zoom OAuth アプリ資格情報（BYO app credentials）。
 * client_secret / webhook_secret_token は encrypted キャスト（APP_KEY 由来）。API には平文を返さない。
 */
class UserZoomCredential extends Model
{
    protected $table = 'user_zoom_credentials';

    protected $fillable = [
        'user_id',
        'client_id',
        'client_secret',
        'webhook_secret_token',
        'is_active',
    ];

    protected $hidden = [
        'client_secret',
        'webhook_secret_token',
    ];

    protected function casts(): array
    {
        return [
            'client_secret' => 'encrypted',
            'webhook_secret_token' => 'encrypted',
            'is_active' => 'boolean',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function hasUsableOAuthCredentials(): bool
    {
        return $this->is_active
            && ! empty($this->client_id)
            && ! empty($this->client_secret);
    }

    public function hasWebhookSecret(): bool
    {
        return $this->is_active && ! empty($this->webhook_secret_token);
    }
}
