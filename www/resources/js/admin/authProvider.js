import { loginReligo, logoutReligo, hasReligoAccessToken, religoFetch } from './religoApiFetch';

/**
 * react-admin 用 authProvider（Sanctum PAT / localStorage, SPEC-010）。
 * getPermissions は /api/users/me の religo_role を返す（SPEC-020 Phase D / UI 分離）。
 */

let cachedRolePromise = null;

function clearRoleCache() {
    cachedRolePromise = null;
}

if (typeof window !== 'undefined') {
    window.addEventListener('religo-auth-changed', clearRoleCache);
}

async function fetchReligoRole() {
    if (!hasReligoAccessToken()) {
        return null;
    }
    try {
        const res = await religoFetch('/api/users/me');
        if (!res.ok) {
            return 'member';
        }
        const data = await res.json().catch(() => ({}));
        return typeof data.religo_role === 'string' && data.religo_role !== ''
            ? data.religo_role
            : 'member';
    } catch {
        return 'member';
    }
}

export const religoAuthProvider = {
    login: ({ username, password }) =>
        loginReligo(username, password).then(() => {
            clearRoleCache();
            return undefined;
        }),
    logout: () =>
        logoutReligo().then(() => {
            clearRoleCache();
            return undefined;
        }),
    checkAuth: () => (hasReligoAccessToken() ? Promise.resolve() : Promise.reject()),
    checkError: (error) => {
        const status = error?.status ?? error?.response?.status;
        return status === 401 || status === 403 ? Promise.reject() : Promise.resolve();
    },
    getIdentity: () => Promise.resolve({ id: 'religo', fullName: 'Religo' }),
    getPermissions: () => {
        if (!cachedRolePromise) {
            cachedRolePromise = fetchReligoRole();
        }
        return cachedRolePromise;
    },
};
