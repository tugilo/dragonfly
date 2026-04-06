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
            if (f.owner_member_id != null && String(f.owner_member_id).trim() !== '') {
                q.set('owner_member_id', String(f.owner_member_id).trim());
            }
            if (f.status) q.set('status', f.status);
            if (f.from) q.set('from', f.from);
            if (f.to) q.set('to', f.to);
            if (f.workspace_id != null) q.set('workspace_id', String(f.workspace_id));
            if (f.target_member_id != null && String(f.target_member_id).trim() !== '') {
                q.set('target_member_id', String(f.target_member_id).trim());
            }
            if (f.exclude_canceled !== undefined && f.exclude_canceled !== null && f.exclude_canceled !== '') {
                q.set('exclude_canceled', f.exclude_canceled ? '1' : '0');
            }
            const qText = f.q != null ? String(f.q).trim() : '';
            if (qText !== '') q.set('q', qText);
            const url = `/api/one-to-ones${q.toString() ? `?${q.toString()}` : ''}`;
            const data = await request(url);
            const arr = Array.isArray(data) ? data : [];
            return { data: arr, total: arr.length };
        }
        if (resource === 'members') {
            const owner = getOwnerMemberId(params);
            const q = new URLSearchParams();
            q.set('owner_member_id', String(owner));
            q.set('with_summary', '1');
            const f = params?.filter ?? {};
            if (f.q != null && String(f.q).trim() !== '') q.set('q', String(f.q).trim());
            if (f.category_id != null) q.set('category_id', String(f.category_id));
            if (f.group_name != null && String(f.group_name).trim() !== '') q.set('group_name', String(f.group_name).trim());
            if (f.role_id != null) q.set('role_id', String(f.role_id));
            if (f.interested === true || f.interested === 'true' || f.interested === 1) q.set('interested', '1');
            if (f.want_1on1 === true || f.want_1on1 === 'true' || f.want_1on1 === 1) q.set('want_1on1', '1');
            const sortField = params?.sort?.field ?? 'id';
            const sortOrder = params?.sort?.order === 'DESC' ? 'desc' : 'asc';
            q.set('sort', sortField);
            q.set('order', sortOrder);
            const url = `/api/dragonfly/members?${q.toString()}`;
            const data = await request(url);
            const arr = Array.isArray(data) ? data : [];
            return { data: arr, total: arr.length };
        }
        if (resource === 'meetings') {
            const f = params?.filter ?? {};
            const q = new URLSearchParams();
            if (f.q != null && String(f.q).trim() !== '') q.set('q', String(f.q).trim());
            if (f.has_memo === true || f.has_memo === '1') q.set('has_memo', '1');
            else if (f.has_memo === false || f.has_memo === '0') q.set('has_memo', '0');
            if (f.has_participant_pdf === true || f.has_participant_pdf === '1') q.set('has_participant_pdf', '1');
            else if (f.has_participant_pdf === false || f.has_participant_pdf === '0') q.set('has_participant_pdf', '0');
            const url = `/api/meetings${q.toString() ? `?${q.toString()}` : ''}`;
            const data = await request(url);
            const arr = Array.isArray(data) ? data : [];
            return { data: arr, total: arr.length };
        }
        if (resource === 'categories') {
            const data = await request('/api/categories');
            const arr = Array.isArray(data) ? data : [];
            return { data: arr, total: arr.length };
        }
        if (resource === 'roles') {
            const data = await request('/api/roles');
            const arr = Array.isArray(data) ? data : [];
            return { data: arr, total: arr.length };
        }
        if (resource === 'role-history') {
            const q = new URLSearchParams();
            const f = params?.filter ?? {};
            if (f.role_id != null) q.set('role_id', String(f.role_id));
            if (f.member_id != null) q.set('member_id', String(f.member_id));
            if (f.from) q.set('from', f.from);
            if (f.to) q.set('to', f.to);
            const url = `/api/member-roles${q.toString() ? `?${q.toString()}` : ''}`;
            const data = await request(url);
            const arr = Array.isArray(data) ? data : [];
            const withCurrent = arr.map((row) => ({
                ...row,
                member: row.member_name,
                role: row.role_name,
                start: row.term_start,
                end: row.term_end,
                current: row.term_end == null,
            }));
            return { data: withCurrent, total: withCurrent.length };
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
        if (resource === 'members') {
            const data = await request(`/api/dragonfly/members/${params.id}`);
            return { data };
        }
        if (resource === 'categories') {
            const data = await request(`/api/categories/${params.id}`);
            return { data };
        }
        if (resource === 'roles') {
            const data = await request(`/api/roles/${params.id}`);
            return { data };
        }
        if (resource === 'one-to-ones') {
            const data = await request(`/api/one-to-ones/${params.id}`);
            return { data };
        }
        if (resource === 'meetings') {
            const j = await request(`/api/meetings/${params.id}`);
            const m = j.meeting;
            if (!m?.id) {
                throw new Error('Meeting not found');
            }
            return {
                data: {
                    id: m.id,
                    number: m.number,
                    held_on: m.held_on,
                    name: m.name ?? null,
                },
            };
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
        if (resource === 'categories') {
            const data = await request(`/api/categories/${params.id}`, {
                method: 'PUT',
                body: JSON.stringify(params.data),
            });
            return { data };
        }
        if (resource === 'roles') {
            const data = await request(`/api/roles/${params.id}`, {
                method: 'PUT',
                body: JSON.stringify(params.data),
            });
            return { data };
        }
        if (resource === 'meetings') {
            const res = await fetch(`${API_BASE}/api/meetings/${params.id}`, {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify({
                    number: params.data?.number,
                    held_on: params.data?.held_on,
                    name: params.data?.name,
                }),
            });
            const j = await res.json().catch(() => ({}));
            if (!res.ok) {
                const fromErrors = j.errors && typeof j.errors === 'object'
                    ? Object.values(j.errors).flat().filter(Boolean).join(' ')
                    : '';
                throw new Error(fromErrors || j.message || `PATCH meetings ${res.status}`);
            }
            return { data: j };
        }
        if (resource === 'one-to-ones') {
            const body = {
                owner_member_id: params.data?.owner_member_id,
                target_member_id: params.data?.target_member_id,
                meeting_id: params.data?.meeting_id ?? null,
                status: params.data?.status,
                scheduled_at: params.data?.scheduled_at,
                started_at: params.data?.started_at,
                ended_at: params.data?.ended_at,
                notes: params.data?.notes ?? null,
            };
            const data = await request(`/api/one-to-ones/${params.id}`, {
                method: 'PATCH',
                body: JSON.stringify(body),
            });
            return { data };
        }
        if (resource === 'members') {
            const data = await request(`/api/dragonfly/members/${params.id}`, {
                method: 'PUT',
                body: JSON.stringify(params.data),
            });
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
        if (resource === 'meetings') {
            const res = await fetch(`${API_BASE}/api/meetings`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify({
                    number: params.data?.number,
                    held_on: params.data?.held_on,
                    name: params.data?.name,
                }),
            });
            const j = await res.json().catch(() => ({}));
            if (!res.ok) {
                const fromErrors = j.errors && typeof j.errors === 'object'
                    ? Object.values(j.errors).flat().filter(Boolean).join(' ')
                    : '';
                throw new Error(fromErrors || j.message || `POST meetings ${res.status}`);
            }
            return { data: j };
        }
        if (resource === 'categories') {
            const data = await request('/api/categories', {
                method: 'POST',
                body: JSON.stringify(params.data),
            });
            return { data: { ...params.data, id: data.id } };
        }
        if (resource === 'roles') {
            const data = await request('/api/roles', {
                method: 'POST',
                body: JSON.stringify(params.data),
            });
            return { data: { ...params.data, id: data.id } };
        }
        throw new Error(`create not implemented for ${resource}`);
    },
    delete: async (resource, params) => {
        if (resource === 'categories') {
            const res = await fetch(`${API_BASE}/api/categories/${params.id}`, {
                method: 'DELETE',
                headers: { Accept: 'application/json' },
            });
            if (!res.ok) {
                const j = await res.json().catch(() => ({}));
                throw new Error(j.message || `DELETE category ${res.status}`);
            }
            return { data: params.previousData };
        }
        if (resource === 'roles') {
            const res = await fetch(`${API_BASE}/api/roles/${params.id}`, {
                method: 'DELETE',
                headers: { Accept: 'application/json' },
            });
            if (!res.ok) {
                const j = await res.json().catch(() => ({}));
                throw new Error(j.message || `DELETE role ${res.status}`);
            }
            return { data: params.previousData };
        }
        return Promise.reject(new Error('delete not implemented'));
    },
    deleteMany: () => Promise.resolve({ data: [] }),
    updateMany: () => Promise.resolve({ data: [] }),
};
