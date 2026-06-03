/** 1 to 1 キャンセル理由（Phase 186 / SSOT: ONETOONES_CANCEL_FIT_AND_GAP §10.1） */

export const ONE_TO_ONE_CANCEL_REASONS = [
    { id: 'owner_convenience', name: 'こちら都合' },
    { id: 'target_convenience', name: '相手都合' },
    { id: 'other', name: 'その他' },
];

const CANCEL_REASON_LABELS = Object.fromEntries(
    ONE_TO_ONE_CANCEL_REASONS.map((c) => [c.id, c.name])
);

export function cancelReasonLabel(reason) {
    if (reason == null || reason === '') {
        return null;
    }
    return CANCEL_REASON_LABELS[reason] ?? String(reason);
}

/** Edit 用: canceled は POST cancel のみ */
export const ONE_TO_ONE_STATUS_CHOICES_EDIT = [
    { id: 'planned', name: '予定' },
    { id: 'completed', name: '実施済み' },
];
