<?php

namespace App\Support;

/**
 * members.type の BNI 在籍メンバー判定（1to1 履歴表示・リード除外と同系）。
 *
 * @see MemberOneToOneLeadService::EXCLUDED_LEAD_TARGET_TYPES
 */
final class MemberEnrollmentType
{
    /** BNI チャプター在籍メンバーとして扱う type */
    private const BNI_MEMBER_TYPES = ['active', 'member', 'inactive'];

    /** リード一覧から除外する非在籍 type */
    private const NON_BNI_MEMBER_TYPES = ['guest', 'visitor'];

    public static function isBniMember(?string $type): bool
    {
        if ($type === null || trim($type) === '') {
            return true;
        }

        return in_array($type, self::BNI_MEMBER_TYPES, true);
    }

    /**
     * 1to1 履歴などで表示する Chip 用ラベル。BNI 在籍メンバーなら null。
     */
    public static function nonBniHistoryChipLabel(?string $type): ?string
    {
        if (self::isBniMember($type)) {
            return null;
        }

        if ($type === 'visitor') {
            return 'ビジター（BNI会員以外）';
        }
        if ($type === 'guest') {
            return 'ゲスト（BNI会員以外）';
        }

        return 'BNI会員以外';
    }

    /**
     * @return list<string>
     */
    public static function nonBniTypes(): array
    {
        return self::NON_BNI_MEMBER_TYPES;
    }
}
