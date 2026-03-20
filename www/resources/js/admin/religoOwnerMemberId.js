/**
 * Religo 管理画面: 現在ユーザーに紐づく owner_member_id（GET /api/users/me）.
 * 未設定時は null。一覧・Create の既定に使う。BO-AUDIT-P3: サーバ側「現在ユーザー」は auth 優先・無認証時は users 先頭 id（従来の単一管理者運用）。
 */
export async function fetchReligoOwnerMemberId() {
    try {
        const res = await fetch('/api/users/me', { headers: { Accept: 'application/json' } });
        if (!res.ok) return null;
        const data = await res.json();
        return data.owner_member_id != null ? Number(data.owner_member_id) : null;
    } catch {
        return null;
    }
}

/** me が未設定のときの一覧フィルタ・統計用フォールバック（従来互換） */
export function ownerMemberIdFallback(id) {
    return id != null && id !== '' ? Number(id) : 1;
}
