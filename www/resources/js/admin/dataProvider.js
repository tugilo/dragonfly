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
    create: () => Promise.reject(new Error('create not implemented')),
    delete: () => Promise.reject(new Error('delete not implemented')),
    deleteMany: () => Promise.resolve({ data: [] }),
    updateMany: () => Promise.resolve({ data: [] }),
};
