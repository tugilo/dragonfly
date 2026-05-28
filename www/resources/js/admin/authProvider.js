import { loginReligo, logoutReligo, hasReligoAccessToken } from './religoApiFetch';

/**
 * react-admin 用 authProvider（Sanctum PAT / localStorage, SPEC-010）。
 */
export const religoAuthProvider = {
    login: ({ username, password }) => loginReligo(username, password).then(() => undefined),
    logout: () => logoutReligo().then(() => undefined),
    checkAuth: () => (hasReligoAccessToken() ? Promise.resolve() : Promise.reject()),
    checkError: (error) => {
        const status = error?.status ?? error?.response?.status;
        return status === 401 || status === 403 ? Promise.reject() : Promise.resolve();
    },
    getIdentity: () => Promise.resolve({ id: 'religo', fullName: 'Religo' }),
    getPermissions: () => Promise.resolve(),
};
