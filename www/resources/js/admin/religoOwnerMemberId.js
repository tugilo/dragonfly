/**
 * Religo 管理画面: 現在ユーザーに紐づく owner_member_id（GET /api/users/me）.
 * 未設定時は null。一覧・Create の既定に使う。BO-AUDIT-P3: サーバ側「現在ユーザー」は auth 優先・無認証時は users 先頭 id（従来の単一管理者運用）。
 *
 * BO-AUDIT-P4: `default_workspace_id`（DB）と `workspace_id`（解決済み・me と BO 監査と同一順）は `fetchReligoMe()` で取得可。Dashboard 以外では当面 owner のみ使用。
 */
export async function fetchReligoMe() {
    try {
        const res = await fetch('/api/users/me', { headers: { Accept: 'application/json' } });
        if (!res.ok) return null;
        return await res.json();
    } catch {
        return null;
    }
}

export async function fetchReligoOwnerMemberId() {
    const data = await fetchReligoMe();
    if (!data) return null;
    return data.owner_member_id != null ? Number(data.owner_member_id) : null;
}

/** me が未設定のときの一覧フィルタ・統計用フォールバック（従来互換） */
export function ownerMemberIdFallback(id) {
    return id != null && id !== '' ? Number(id) : 1;
}
