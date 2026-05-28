/**
 * dataProvider 等が同期的に参照する Owner 解決状態（ReligoOwnerProvider と同期）。
 * SSOT: ADMIN_GLOBAL_OWNER_SELECTION §5.1
 */
export const religoOwnerStore = {
    _ownerMemberId: null,
    _loading: true,
    _error: null,

    /**
     * @param {{ ownerMemberId: number | null, loading: boolean, error: Error | null }} s
     */
    sync(s) {
        this._ownerMemberId = s.ownerMemberId ?? null;
        this._loading = !!s.loading;
        this._error = s.error ?? null;
    },

    getOwnerMemberId() {
        return this._ownerMemberId;
    },

    isLoading() {
        return this._loading;
    },

    /** Owner スコープ API を叩いてよいか（me 取得済みかつ owner 確定） */
    isReadyForOwnerScopedApi() {
        return !this._loading && this._ownerMemberId != null;
    },
};
