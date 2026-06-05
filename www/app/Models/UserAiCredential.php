<?php

namespace App\Models;

use App\Models\Concerns\ReadsEncryptedAttributes;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * SPEC-013: ユーザーごとの AI 資格情報（BYO key）。
 * api_key は encrypted キャストで暗号化保存（APP_KEY 由来）。API には平文を返さない。
 */
class UserAiCredential extends Model
{
    use ReadsEncryptedAttributes;

    public const PROVIDER_OPENAI = 'openai';

    public const PROVIDER_ANTHROPIC = 'anthropic';

    public const PROVIDER_GOOGLE = 'google';

    public const PROVIDERS = [
        self::PROVIDER_OPENAI,
        self::PROVIDER_ANTHROPIC,
        self::PROVIDER_GOOGLE,
    ];

    protected $table = 'user_ai_credentials';

    protected $fillable = [
        'user_id',
        'ai_enabled',
        'provider',
        'api_key',
        'model',
        'is_active',
    ];

    protected $hidden = [
        'api_key',
    ];

    protected function casts(): array
    {
        return [
            'ai_enabled' => 'boolean',
            'is_active' => 'boolean',
            'api_key' => 'encrypted',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function hasUsableKey(): bool
    {
        return $this->ai_enabled
            && $this->is_active
            && ! empty($this->provider)
            && $this->readEncryptedAttribute('api_key') !== null;
    }

    public function apiKeyDecryptFailed(): bool
    {
        return $this->encryptedAttributeUnreadable('api_key');
    }
}
