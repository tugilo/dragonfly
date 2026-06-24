<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeLineAccount;
use App\Models\Sonae\SonaeLineUserLink;
use App\Models\Sonae\SonaeMember;
use Illuminate\Support\Str;

/**
 * SPEC-017 §10.4: LINE 友だち登録・メンバー紐付け。
 */
class SonaeLineLinkService
{
    public const LINK_MESSAGE_PREFIX = 'SONAE-LINK:';

    /**
     * @return array{token: string, message: string}
     */
    public function issueInviteToken(SonaeMember $member): array
    {
        $plain = Str::random(32);
        $member->invite_token_hash = hash('sha256', $plain);
        $member->save();

        $message = self::LINK_MESSAGE_PREFIX.$plain;

        return [
            'token' => $plain,
            'message' => $message,
        ];
    }

    public function linkMember(
        SonaeChapter $chapter,
        SonaeMember $member,
        SonaeLineAccount $lineAccount,
        string $lineUserId
    ): SonaeLineUserLink {
        $this->assertMemberInChapter($chapter, $member);

        SonaeLineUserLink::query()
            ->where('line_account_id', $lineAccount->id)
            ->where('line_user_id', $lineUserId)
            ->where('status', SonaeConstants::LINE_LINK_ACTIVE)
            ->where('member_id', '!=', $member->id)
            ->update([
                'status' => SonaeConstants::LINE_LINK_UNLINKED,
                'unlinked_at' => now(),
            ]);

        return SonaeLineUserLink::query()->updateOrCreate(
            [
                'line_account_id' => $lineAccount->id,
                'member_id' => $member->id,
            ],
            [
                'line_user_id' => $lineUserId,
                'linked_at' => now(),
                'unlinked_at' => null,
                'status' => SonaeConstants::LINE_LINK_ACTIVE,
            ]
        );
    }

    public function linkByInviteMessage(
        SonaeChapter $chapter,
        SonaeLineAccount $lineAccount,
        string $lineUserId,
        string $messageText
    ): ?SonaeLineUserLink {
        $token = $this->extractTokenFromMessage($messageText);
        if ($token === null) {
            return null;
        }

        $member = SonaeMember::query()
            ->where('chapter_id', $chapter->id)
            ->where('invite_token_hash', hash('sha256', $token))
            ->where('status', SonaeConstants::STATUS_ACTIVE)
            ->first();

        if ($member === null) {
            return null;
        }

        return $this->linkMember($chapter, $member, $lineAccount, $lineUserId);
    }

    public function unlinkLineUser(SonaeLineAccount $lineAccount, string $lineUserId): void
    {
        SonaeLineUserLink::query()
            ->where('line_account_id', $lineAccount->id)
            ->where('line_user_id', $lineUserId)
            ->where('status', SonaeConstants::LINE_LINK_ACTIVE)
            ->update([
                'status' => SonaeConstants::LINE_LINK_UNLINKED,
                'unlinked_at' => now(),
            ]);
    }

    private function extractTokenFromMessage(string $messageText): ?string
    {
        $trimmed = trim($messageText);
        if (! str_starts_with($trimmed, self::LINK_MESSAGE_PREFIX)) {
            return null;
        }

        $token = trim(substr($trimmed, strlen(self::LINK_MESSAGE_PREFIX)));
        if ($token === '') {
            return null;
        }

        return $token;
    }

    private function assertMemberInChapter(SonaeChapter $chapter, SonaeMember $member): void
    {
        if ($member->chapter_id !== $chapter->id) {
            throw new \InvalidArgumentException('Member does not belong to chapter.');
        }
    }
}
