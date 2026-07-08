import { religoFetch } from './religoApiFetch';
import { meetingTypeCode, SESSION_TEAM_MEETING } from './utils/meetingTypeUi';

export const ONE_TO_ONE_DIRECTION_LABELS = {
    owner_to_target: '自分→相手向け',
    target_to_owner: '相手→自分向け',
    mutual: '相互',
    unclear: '不明',
    subject_should_meet: '主役が会うべきメンバー',
    via_connector: 'つなぎ手経由（社外）',
};

export const CORPUS_SOURCE_LABELS = {
    self: '自分の議事録',
    member_network: '他メンバーのネットワーク',
};

export const MEETING_DIRECTION_LABELS = {
    subject_seeks_intros: '登壇者が紹介希望',
    owner_introduces_to_subject: 'owner→登壇者へ紹介',
    owner_introduces_subject: 'ownerが登壇者を紹介',
    mutual: '相互',
    unclear: '不明',
    subject_should_meet: '主役が会うべきメンバー',
    via_connector: 'つなぎ手経由（社外）',
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

export async function fetchReferralCorpusSettings() {
    const res = await religoFetch('/api/referral-corpus-settings', { headers: { Accept: 'application/json' } });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `設定の取得に失敗しました (${res.status})`);
    }
    return data;
}

export async function patchReferralCorpusSettings(payload) {
    const res = await religoFetch('/api/referral-corpus-settings', {
        method: 'PATCH',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `設定の更新に失敗しました (${res.status})`);
    }
    return data;
}

export async function generateOneToOneReferralSuggestions(oneToOneId, contextMode = 'relationship', force = false) {
    const res = await religoFetch(`/api/one-to-ones/${oneToOneId}/referral-suggestions/generate`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify({ context_mode: contextMode, force: Boolean(force) }),
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

export async function generateMeetingReferralSuggestions(meetingId, contextMode = 'relationship', force = false) {
    const res = await religoFetch(`/api/meetings/${meetingId}/referral-suggestions/generate`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify({ context_mode: contextMode, force: Boolean(force) }),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `提案の生成に失敗しました (${res.status})`);
    }
    return data;
}

export async function registerReferralIntroduction(kind, suggestionId, body) {
    const path =
        kind === 'meeting'
            ? `/api/meeting-referral-suggestions/${suggestionId}/register-introduction`
            : `/api/one-to-one-referral-suggestions/${suggestionId}/register-introduction`;
    const res = await religoFetch(path, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(body),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `紹介登録に失敗しました (${res.status})`);
    }
    return data;
}

export function buildDefaultIntroductionNote(suggestion) {
    const parts = [String(suggestion?.summary ?? '').trim()];
    if (suggestion?.rationale?.trim()) {
        parts.push(`根拠: ${suggestion.rationale.trim()}`);
    }
    if (suggestion?.suggested_to_label?.trim()) {
        parts.push(`紹介先候補: ${suggestion.suggested_to_label.trim()}`);
    }
    return parts.filter(Boolean).join('\n\n');
}

/**
 * relationship run の corpus_meta を表示用に整形。
 */
export function formatCorpusMetaSummary(meta, contextMode) {
    if (!meta || contextMode !== 'relationship') return null;
    const parts = [];
    if (meta.consented_owner_count != null) {
        parts.push(`横断共有 ON: ${meta.consented_owner_count} 名`);
    }
    if (meta.o2o_excerpt_count != null && meta.o2o_excerpt_count > 0) {
        parts.push(`121 抜粋: ${meta.o2o_excerpt_count} 件`);
    }
    if (meta.meeting_count != null && meta.meeting_count > 0) {
        parts.push(`関連定例会: ${meta.meeting_count} 回`);
    }
    if (meta.introduction_count != null && meta.introduction_count > 0) {
        parts.push(`紹介履歴: ${meta.introduction_count} 件`);
    }
    if (parts.length === 0) {
        return '横断コーパスは主役の当該議事録のみ（他者共有 OFF または記録少）';
    }
    return `参照コーパス — ${parts.join(' · ')}`;
}

export function canRegisterIntroduction(suggestion) {
    if (!suggestion || suggestion.introduction_id) return false;
    if (suggestion.status !== 'pending' && suggestion.status !== 'deferred') return false;
    return Boolean(suggestion.suggested_to_member_id);
}

/**
 * SPEC-022: 提案行からパーティ A/B 初期値（案2 — UI 初期値のみ）。
 * PHP ReferralConnectCopyPartyDefaults と同じロジック。
 */
export function deriveDefaultParties(suggestion, ownerMemberId) {
    if (!suggestion) {
        return { party_a_member_id: ownerMemberId ?? null, party_b_member_id: null, party_b_label: null };
    }
    const direction = suggestion.direction ?? '';
    const fromId = suggestion.suggested_from_member_id ?? null;
    const toId = suggestion.suggested_to_member_id ?? null;
    const toLabel = suggestion.suggested_to_label?.trim() || null;
    const contactLabel = suggestion.suggested_contact_label?.trim() || null;
    const subjectId = suggestion.subject_member_id ?? null;

    let partyA = null;
    let partyB = null;
    let partyBLabel = null;

    if (direction === 'via_connector') {
        partyA = ownerMemberId ?? null;
        partyB = fromId;
        if (partyB == null && contactLabel) {
            partyBLabel = contactLabel;
        }
    } else if (direction === 'subject_should_meet') {
        partyA = subjectId ?? ownerMemberId ?? null;
        partyB = toId;
    } else if (direction === 'target_to_owner') {
        partyA = fromId ?? subjectId ?? ownerMemberId ?? null;
        partyB = ownerMemberId ?? null;
    } else {
        partyA = fromId ?? ownerMemberId ?? null;
        partyB = toId;
        if (partyB == null && toLabel) {
            partyBLabel = toLabel;
        }
    }

    if (partyA == null) {
        partyA = ownerMemberId ?? null;
    }
    if (partyB == null && partyBLabel == null) {
        partyBLabel = contactLabel ?? toLabel;
    }

    return {
        party_a_member_id: partyA,
        party_b_member_id: partyB,
        party_b_label: partyBLabel,
    };
}

export async function generateConnectCopy(kind, suggestionId, body) {
    const path =
        kind === 'meeting'
            ? `/api/meeting-referral-suggestions/${suggestionId}/generate-connect-copy`
            : `/api/one-to-one-referral-suggestions/${suggestionId}/generate-connect-copy`;
    const res = await religoFetch(path, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(body),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `文案の生成に失敗しました (${res.status})`);
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
    if (record?.supports_referral_suggestions === false) {
        return false;
    }
    if (meetingTypeCode(record) === SESSION_TEAM_MEETING) {
        return false;
    }

    return Boolean(record?.has_minutes);
}

export function meetingReferralDisabledReason(record) {
    if (!record) return 'レコードがありません';
    if (record.supports_referral_suggestions === false || meetingTypeCode(record) === SESSION_TEAM_MEETING) {
        return 'この種別の集会ではリファーラル提案は利用できません';
    }
    if (!record.has_minutes) return '議事録が未取り込みのため提案できません';
    return null;
}
