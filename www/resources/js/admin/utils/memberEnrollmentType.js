/**
 * members.type の BNI 在籍判定（API is_bni_member / target_member_type と同系）。
 * SSOT: MemberEnrollmentType.php · MemberOneToOneLeadService
 */

export const BNI_MEMBER_TYPES = ['active', 'member', 'inactive'];

/** @param {string|null|undefined} type */
export function isBniMemberType(type) {
    if (type == null || String(type).trim() === '') {
        return true;
    }
    return BNI_MEMBER_TYPES.includes(String(type));
}

/**
 * 1to1 履歴 Chip 用。BNI 在籍なら null。
 * @param {string|null|undefined} type
 */
export function memberNonBniHistoryChipLabel(type) {
    if (isBniMemberType(type)) {
        return null;
    }
    if (type === 'visitor') {
        return 'ビジター（BNI会員以外）';
    }
    if (type === 'guest') {
        return 'ゲスト（BNI会員以外）';
    }
    return 'BNI会員以外';
}

/**
 * API 1to1 行から非 BNI Chip ラベルを解決（API フィールド優先）。
 * @param {{ is_bni_member?: boolean, target_member_type?: string|null, target_non_bni_label?: string|null }} record
 */
export function oneToOneNonBniChipLabel(record) {
    if (record?.target_non_bni_label) {
        return record.target_non_bni_label;
    }
    if (record?.is_bni_member === false) {
        return memberNonBniHistoryChipLabel(record?.target_member_type);
    }
    return memberNonBniHistoryChipLabel(record?.target_member_type);
}
