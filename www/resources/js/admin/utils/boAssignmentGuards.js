/**
 * Connections / BO 割当のクライアント側ガード（保存前の防ぎ）。
 * API（MeetingBreakoutService）が最終防衛線。SPEC-007 整合。
 */

/**
 * @param {object|undefined} member - GET /api/dragonfly/members?meeting_id= の1行
 * @returns {boolean}
 */
export function isBoAssignableMember(member) {
    if (!member || typeof member !== 'object') return false;
    return member.bo_assignable !== false;
}

/**
 * BO に追加できない理由（1行）。追加可能なら null。
 * @param {object|undefined} member
 * @param {number} memberId
 * @returns {string|null}
 */
export function getBoAssignBlockReason(member, memberId) {
    if (!member) {
        return `メンバーID ${memberId} はこの例会の参加者として一覧にいません。CSV等で参加者登録後に割り当ててください。`;
    }
    if (member.bo_assignable === false) {
        const name = member.name?.trim() || '該当者';
        if (member.participant_type === 'proxy') {
            return `${name}は代理出席のためBOに入れません。`;
        }
        return `${name}はこの出席区分ではBOに入れません。`;
    }
    return null;
}

/**
 * 保存直前の rooms ペイロードを検証。エラー文言の配列（空なら OK）。
 * @param {Array<{ member_ids?: number[] }>} rooms
 * @param {Map<number, object>} membersById
 * @returns {string[]}
 */
export function collectBoSaveValidationErrors(rooms, membersById) {
    const allIds = new Set();
    for (const room of rooms || []) {
        for (const id of room.member_ids ?? []) {
            allIds.add(Number(id));
        }
    }
    const errors = [];
    const seenMsg = new Set();
    for (const id of allIds) {
        const m = membersById.get(id);
        const reason = getBoAssignBlockReason(m, id);
        if (reason && !seenMsg.has(reason)) {
            seenMsg.add(reason);
            errors.push(reason);
        }
    }
    return errors;
}

/**
 * BO1→BO2 コピーなど、割当可能な member_id のみ残す。
 * @param {number[]} memberIds
 * @param {Map<number, object>} membersById
 * @returns {number[]}
 */
export function filterBoAssignableMemberIds(memberIds, membersById) {
    return (memberIds || []).filter((id) => {
        const m = membersById.get(Number(id));
        return isBoAssignableMember(m);
    });
}
