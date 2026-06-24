import { religoFetch } from '../religoApiFetch';

async function parseJson(res) {
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        const msg = typeof data.message === 'string' ? data.message : `HTTP ${res.status}`;
        throw new Error(msg);
    }
    return data;
}

export async function fetchSonaeContext() {
    const res = await religoFetch('/api/sonae/context', {
        headers: { Accept: 'application/json' },
    });
    const data = await parseJson(res);
    return data.data;
}

export async function bootstrapSonaeChapter(body = {}) {
    const res = await religoFetch('/api/sonae/chapters/bootstrap', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(body),
    });
    const data = await parseJson(res);
    return data.data;
}

export async function resolveSonaeChapter(workspaceId) {
    const q = new URLSearchParams({ workspace_id: String(workspaceId) });
    const res = await religoFetch(`/api/sonae/chapters/resolve?${q.toString()}`, {
        headers: { Accept: 'application/json' },
    });
    const data = await parseJson(res);
    return data.data;
}

export async function fetchSonaeChapter(chapterId) {
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}`, {
        headers: { Accept: 'application/json' },
    });
    const data = await parseJson(res);
    return data.data;
}

export async function fetchSonaeMembers(chapterId, page = 1, perPage = 50) {
    const q = new URLSearchParams({ page: String(page), per_page: String(perPage) });
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/members?${q.toString()}`, {
        headers: { Accept: 'application/json' },
    });
    return parseJson(res);
}

export async function fetchSonaeUnlinkedMembers(chapterId) {
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/members/unlinked`, {
        headers: { Accept: 'application/json' },
    });
    const data = await parseJson(res);
    return data.data ?? [];
}

export async function syncSonaeMembers(chapterId) {
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/members/sync`, {
        method: 'POST',
        headers: { Accept: 'application/json' },
    });
    const data = await parseJson(res);
    return data.data;
}

export async function importSonaeCsv(chapterId, file, preview = false) {
    const form = new FormData();
    form.append('csv', file);
    if (preview) form.append('preview', '1');
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/members/import-csv`, {
        method: 'POST',
        body: form,
    });
    return parseJson(res);
}

export async function fetchSonaeLineAccount(chapterId) {
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/line-account`, {
        headers: { Accept: 'application/json' },
    });
    const data = await parseJson(res);
    return data.data;
}

export async function updateSonaeLineAccount(chapterId, body) {
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/line-account`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(body),
    });
    const data = await parseJson(res);
    return data.data;
}

export async function issueSonaeLineInvite(chapterId, memberId) {
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/members/${memberId}/line-invite`, {
        method: 'POST',
        headers: { Accept: 'application/json' },
    });
    const data = await parseJson(res);
    return data.data;
}

export async function fetchSonaeTrainings(chapterId) {
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/training-events`, {
        headers: { Accept: 'application/json' },
    });
    const data = await parseJson(res);
    return data.data ?? [];
}

export async function dispatchSonaeTraining(chapterId, body) {
    const res = await religoFetch(`/api/sonae/chapters/${chapterId}/training-events/dispatch`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(body),
    });
    const data = await parseJson(res);
    return data.data;
}

export async function fetchSonaeNotificationSummary(chapterId, notificationId) {
    const res = await religoFetch(
        `/api/sonae/chapters/${chapterId}/notifications/${notificationId}/summary`,
        { headers: { Accept: 'application/json' } }
    );
    return parseJson(res);
}

export function formatRate(rate) {
    if (rate == null) return '—';
    return `${Math.round(Number(rate) * 1000) / 10}%`;
}
