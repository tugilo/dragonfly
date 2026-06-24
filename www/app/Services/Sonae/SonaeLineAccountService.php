<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeLineAccount;
use Illuminate\Support\Facades\URL;

/**
 * SPEC-017 §10.2: チャプター LINE 公式アカウント設定。
 */
class SonaeLineAccountService
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(SonaeLineAccount $account, SonaeChapter $chapter): array
    {
        return [
            'id' => $account->id,
            'chapter_id' => $account->chapter_id,
            'channel_id' => $account->channel_id,
            'channel_secret_set' => $account->encryptedAttributeStored('channel_secret_encrypted'),
            'access_token_set' => $account->encryptedAttributeStored('messaging_api_access_token_encrypted'),
            'webhook_url' => $this->webhookUrl($chapter),
            'friend_add_url' => $account->friend_add_url,
            'status' => $account->status,
            'has_usable_credentials' => $account->hasUsableCredentials(),
        ];
    }

    public function webhookUrl(SonaeChapter $chapter): string
    {
        return URL::to('/sonae/line/webhook/'.$chapter->chapter_key);
    }

    /**
     * @param  array<string, mixed>  $input
     */
    public function update(SonaeChapter $chapter, array $input): SonaeLineAccount
    {
        $account = SonaeLineAccount::query()->firstOrCreate(
            ['chapter_id' => $chapter->id],
            [
                'channel_id' => '',
                'status' => SonaeConstants::STATUS_INACTIVE,
            ]
        );

        if (array_key_exists('channel_id', $input)) {
            $account->channel_id = (string) $input['channel_id'];
        }
        if (array_key_exists('channel_secret', $input) && $input['channel_secret'] !== null && $input['channel_secret'] !== '') {
            $account->channel_secret_encrypted = (string) $input['channel_secret'];
        }
        if (array_key_exists('messaging_api_access_token', $input) && $input['messaging_api_access_token'] !== null && $input['messaging_api_access_token'] !== '') {
            $account->messaging_api_access_token_encrypted = (string) $input['messaging_api_access_token'];
        }
        if (array_key_exists('friend_add_url', $input)) {
            $account->friend_add_url = $input['friend_add_url'];
        }
        if (array_key_exists('status', $input)) {
            $account->status = (string) $input['status'];
        }

        $account->webhook_url = $this->webhookUrl($chapter);
        $account->save();

        return $account->fresh();
    }
}
