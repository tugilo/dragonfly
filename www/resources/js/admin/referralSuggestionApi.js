import { religoFetch } from './religoApiFetch';

export const ONE_TO_ONE_DIRECTION_LABELS = {
    owner_to_target: '自分→相手向け',
    target_to_owner: '相手→自分向け',
    mutual: '相互',
    unclear: '不明',
};

export const MEETING_DIRECTION_LABELS = {
    subject_seeks_intros: '登壇者が紹介希望',
    owner_introduces_to_subject: 'owner→登壇者へ紹介',
    owner_introduces_subject: 'ownerが登壇者を紹介',
    mutual: '相互',
    unclear: '不明',
};

export const MEETING_SECTION_LABELS = {
    main_presentation: 'メインプレ',
    weekly_presentation: 'ウィークリー',
    visitor_intro: 'ビジター紹介',
    share_story: 'シェアストーリー',
    education: '教育コーナー',
    other: 'その他',
};

export const SUGGESTION_STATUS_LABELS = {
    pending: '未処理',
    accepted: '採用',
    dismissed: '却下',
    deferred: 'あとで',
};

export const CONFIDENCE_LABELS = {
    high: '高',
    medium: '中',
    low: '低',
};

export async function fetchAiCredentialsSummary() {
    const res = await religoFetch('/api/ai/credentials', { headers: { Accept: 'application/json' } });
    if (!res.ok) {
        return { ai_enabled: false, has_api_key: false };
    }
    const data = await res.json();
    return {
        ai_enabled: Boolean(data.ai_enabled),
        has_api_key: Boolean(data.has_api_key),
    };
}

export function isAiReady(creds) {
    return Boolean(creds?.ai_enabled && creds?.has_api_key);
}

export async function fetchOneToOneReferralSuggestions(oneToOneId, runId) {
    const qs = runId != null ? `?run_id=${encodeURIComponent(runId)}` : '';
    const res = await religoFetch(`/api/one-to-ones/${oneToOneId}/referral-suggestions${qs}`, {
        headers: { Accept: 'application/json' },
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `提案の取得に失敗しました (${res.status})`);
    }
    return data;
}

export async function generateOneToOneReferralSuggestions(oneToOneId) {
    const res = await religoFetch(`/api/one-to-ones/${oneToOneId}/referral-suggestions/generate`, {
        method: 'POST',
        headers: { Accept: 'application/json' },
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `提案の生成に失敗しました (${res.status})`);
    }
    return data;
}

export async function fetchMeetingReferralSuggestions(meetingId, runId) {
    const qs = runId != null ? `?run_id=${encodeURIComponent(runId)}` : '';
    const res = await religoFetch(`/api/meetings/${meetingId}/referral-suggestions${qs}`, {
        headers: { Accept: 'application/json' },
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `提案の取得に失敗しました (${res.status})`);
    }
    return data;
}

export async function generateMeetingReferralSuggestions(meetingId) {
    const res = await religoFetch(`/api/meetings/${meetingId}/referral-suggestions/generate`, {
        method: 'POST',
        headers: { Accept: 'application/json' },
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `提案の生成に失敗しました (${res.status})`);
    }
    return data;
}

export async function patchReferralSuggestion(kind, suggestionId, body) {
    const path =
        kind === 'meeting'
            ? `/api/meeting-referral-suggestions/${suggestionId}`
            : `/api/one-to-one-referral-suggestions/${suggestionId}`;
    const res = await religoFetch(path, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(body),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `更新に失敗しました (${res.status})`);
    }
    return data;
}

export function canOpenOneToOneReferral(record) {
    return record?.status === 'completed' && Boolean(String(record?.notes ?? '').trim());
}

export function oneToOneReferralDisabledReason(record) {
    if (!record) return 'レコードがありません';
    if (record.status !== 'completed') return '実施済みの 1 to 1 のみ利用できます';
    if (!String(record.notes ?? '').trim()) return 'メモ（議事録）が空のため提案できません';
    return null;
}

export function canOpenMeetingReferral(record) {
    return Boolean(record?.has_minutes);
}

export function meetingReferralDisabledReason(record) {
    if (!record) return 'レコードがありません';
    if (!record.has_minutes) return '議事録が未取り込みのため提案できません';
    return null;
}
