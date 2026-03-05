const API_BASE = '';

function getOwnerMemberId(params) {
    return params?.filter?.owner_member_id ?? 1;
}

async function request(url, options = {}) {
    const res = await fetch(`${API_BASE}${url}`, {
        headers: { 'Content-Type': 'application/json', 'Accept': 'application/json', ...options.headers },
        ...options,
    });
    if (!res.ok) {
        const text = await res.text();
        throw new Error(`API ${res.status}: ${text}`);
    }
    return res.json();
}

export const dragonflyDataProvider = {
    getList: async (resource, params) => {
        if (resource === 'dragonflyFlags') {
            const owner = getOwnerMemberId(params);
            const url = `/api/dragonfly/flags?owner_member_id=${owner}`;
            console.log('[DataProvider] getList dragonflyFlags', url);
            const data = await request(url);
            const total = Array.isArray(data) ? data.length : 0;
            console.log('[DataProvider] getList result', { count: total, data });
            return { data: Array.isArray(data) ? data : [], total };
        }
        if (resource === 'one-to-ones') {
            const q = new URLSearchParams();
            const f = params?.filter ?? {};
            if (f.owner_member_id != null) q.set('owner_member_id', String(f.owner_member_id));
            if (f.status) q.set('status', f.status);
            if (f.from) q.set('from', f.from);
            if (f.to) q.set('to', f.to);
            if (f.workspace_id != null) q.set('workspace_id', String(f.workspace_id));
            const url = `/api/one-to-ones${q.toString() ? `?${q.toString()}` : ''}`;
            const data = await request(url);
            const arr = Array.isArray(data) ? data : [];
            return { data: arr, total: arr.length };
        }
        if (resource === 'members') {
            const owner = getOwnerMemberId(params);
            const url = `/api/dragonfly/members?owner_member_id=${owner}&with_summary=1`;
            const data = await request(url);
            const arr = Array.isArray(data) ? data : [];
            return { data: arr, total: arr.length };
        }
        if (resource === 'meetings') {
            const data = await request('/api/meetings');
            const arr = Array.isArray(data) ? data : [];
            return { data: arr, total: arr.length };
        }
        if (resource === 'role-history') {
            // UI only: stub for Role History until API is ready
            const stub = [
                { id: 1, member: '田中 誠一', role: 'プレジ', start: '2025-01-01', end: null, current: true },
                { id: 2, member: '鈴木 花子', role: 'バイス', start: '2025-01-01', end: null, current: true },
                { id: 3, member: '山田 大輔', role: '書記', start: '2025-01-01', end: null, current: true },
                { id: 4, member: '小林 陽子', role: '会計', start: '2025-01-01', end: null, current: true },
                { id: 5, member: '佐藤 美咲', role: 'メンター', start: '2025-01-01', end: null, current: true },
                { id: 6, member: '水野 花菜', role: 'エドコ', start: '2025-01-01', end: null, current: true },
                { id: 7, member: '渡辺 彩香', role: 'バイス', start: '2024-01-01', end: '2024-12-31', current: false },
            ];
            return { data: stub, total: stub.length };
        }
        return { data: [], total: 0 };
    },

    getOne: async (resource, params) => {
        if (resource === 'dragonflySummary') {
            const owner = getOwnerMemberId(params);
            const url = `/api/dragonfly/contacts/${params.id}/summary?owner_member_id=${owner}`;
            console.log('[DataProvider] getOne dragonflySummary', url);
            const data = await request(url);
            console.log('[DataProvider] getOne result', data);
            return { data };
        }
        throw new Error(`getOne not implemented for ${resource}`);
    },

    update: async (resource, params) => {
        if (resource === 'dragonflyFlags') {
            const owner = params.data?.owner_member_id ?? getOwnerMemberId(params);
            const url = `/api/dragonfly/flags/${params.id}?owner_member_id=${owner}`;
            console.log('[DataProvider] update dragonflyFlags', url, params.data);
            const data = await request(url, {
                method: 'PUT',
                body: JSON.stringify({
                    interested: params.data?.interested,
                    want_1on1: params.data?.want_1on1,
                    extra_status: params.data?.extra_status,
                    reason: params.data?.reason,
                    meeting_id: params.data?.meeting_id,
                    meeting_number: params.data?.meeting_number,
                }),
            });
            console.log('[DataProvider] update result', data);
            return { data };
        }
        throw new Error(`update not implemented for ${resource}`);
    },

    getMany: () => Promise.resolve({ data: [] }),
    getManyReference: () => Promise.resolve({ data: [], total: 0 }),
    create: async (resource, params) => {
        if (resource === 'one-to-ones') {
            const res = await fetch(`${API_BASE}/api/one-to-ones`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify(params.data),
            });
            if (!res.ok) {
                const j = await res.json().catch(() => ({}));
                throw new Error(j.message || `POST one-to-ones ${res.status}`);
            }
            const data = await res.json();
            return { data: { ...params.data, id: data.id } };
        }
        throw new Error(`create not implemented for ${resource}`);
    },
    delete: () => Promise.reject(new Error('delete not implemented')),
    deleteMany: () => Promise.resolve({ data: [] }),
    updateMany: () => Promise.resolve({ data: [] }),
};
