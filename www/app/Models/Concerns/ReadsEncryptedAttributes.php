<?php

namespace App\Models\Concerns;

use Illuminate\Contracts\Encryption\DecryptException;

/**
 * encrypted キャスト属性の安全な読み取り（APP_KEY 不一致時の MAC エラー回避）。
 */
trait ReadsEncryptedAttributes
{
    public function readEncryptedAttribute(string $attribute): ?string
    {
        if (! $this->exists) {
            return null;
        }

        try {
            $value = $this->getAttribute($attribute);
        } catch (DecryptException) {
            return null;
        }

        if (! is_string($value) || $value === '') {
            return null;
        }

        return $value;
    }

    public function encryptedAttributeStored(string $attribute): bool
    {
        if (! $this->exists) {
            return false;
        }

        $raw = $this->getRawOriginal($attribute);

        return $raw !== null && $raw !== '';
    }

    public function encryptedAttributeUnreadable(string $attribute): bool
    {
        return $this->encryptedAttributeStored($attribute)
            && $this->readEncryptedAttribute($attribute) === null;
    }
}
