/**
 * Religo 管理 SPA → Laravel API 用 fetch。
 * localStorage に Sanctum PAT を保存し、全リクエストに Bearer を付与（SPEC-010）。
 */

export const RELIGO_ACCESS_TOKEN_KEY = 'religo.access_token';

export function getReligoAccessToken() {
    try {
        return localStorage.getItem(RELIGO_ACCESS_TOKEN_KEY);
    } catch {
        return null;
    }
}

function dispatchAuthChanged() {
    try {
        window.dispatchEvent(new CustomEvent('religo-auth-changed'));
    } catch {
        /* ignore */
    }
}

export function clearReligoAccessToken() {
    try {
        localStorage.removeItem(RELIGO_ACCESS_TOKEN_KEY);
    } catch {
        /* ignore */
    }
    dispatchAuthChanged();
}

/**
 * @param {Record<string, string>} [headers]
 * @returns {Record<string, string>}
 */
export function mergeReligoAuthHeaders(headers = {}) {
    const token = getReligoAccessToken();
    const out = { Accept: 'application/json', ...headers };
    if (token) {
        out.Authorization = `Bearer ${token}`;
    }
    return out;
}

/**
 * fetch の薄いラッパー。Authorization を自動付与（トークンがあるときのみ）。
 * @param {RequestInfo | URL} input
 * @param {RequestInit} [init]
 */
export async function religoFetch(input, init = {}) {
    const raw = init.headers;
    let headers;
    if (raw instanceof Headers) {
        headers = new Headers(raw);
        const token = getReligoAccessToken();
        if (token) {
            headers.set('Authorization', `Bearer ${token}`);
        }
        if (!headers.has('Accept')) {
            headers.set('Accept', 'application/json');
        }
    } else {
        headers = mergeReligoAuthHeaders(raw && typeof raw === 'object' ? raw : {});
    }
    return fetch(input, { ...init, headers });
}

/**
 * @returns {Promise<{ token: string, token_type?: string, user?: object }>}
 */
export async function loginReligo(email, password) {
    const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({
            email: String(email).trim(),
            password: String(password),
            device_name: 'religo-admin',
        }),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        const msg = data.errors?.email?.[0] ?? data.message;
        throw new Error(typeof msg === 'string' && msg.trim() !== '' ? msg : 'ログインに失敗しました');
    }
    if (typeof data.token === 'string' && data.token !== '') {
        try {
            localStorage.setItem(RELIGO_ACCESS_TOKEN_KEY, data.token);
        } catch {
            /* ignore */
        }
        dispatchAuthChanged();
    }
    return data;
}

export async function logoutReligo() {
    const token = getReligoAccessToken();
    if (token) {
        await fetch('/api/auth/logout', {
            method: 'POST',
            headers: { Accept: 'application/json', Authorization: `Bearer ${token}` },
        }).catch(() => {});
    }
    clearReligoAccessToken();
}

export function hasReligoAccessToken() {
    return Boolean(getReligoAccessToken());
}

/**
 * @returns {Promise<{ message: string, debug_code?: string }>}
 */
export async function requestReligoRegistration(email) {
    const res = await fetch('/api/auth/register/request', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({ email: String(email).trim() }),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        const msg = data.errors?.email?.[0] ?? data.message;
        throw new Error(typeof msg === 'string' && msg.trim() !== '' ? msg : '確認コードの送信に失敗しました');
    }
    return data;
}

/**
 * @returns {Promise<{ message: string, user?: object }>}
 */
export async function completeReligoRegistration(email, code, password, passwordConfirmation) {
    const res = await fetch('/api/auth/register/complete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({
            email: String(email).trim(),
            code: String(code).trim(),
            password: String(password),
            password_confirmation: String(passwordConfirmation),
        }),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        const msg =
            data.errors?.code?.[0] ??
            data.errors?.email?.[0] ??
            data.errors?.password?.[0] ??
            data.message;
        throw new Error(typeof msg === 'string' && msg.trim() !== '' ? msg : 'アカウント作成に失敗しました');
    }
    return data;
}
