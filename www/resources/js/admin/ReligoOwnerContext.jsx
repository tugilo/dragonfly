import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { religoOwnerStore } from './religoOwnerStore';

const ReligoOwnerContext = createContext(null);

async function fetchJson(url, options = {}) {
    const res = await fetch(url, { headers: { Accept: 'application/json', ...options.headers }, ...options });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

export function ReligoOwnerProvider({ children }) {
    const [ownerMemberId, setOwnerMemberId] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [members, setMembers] = useState([]);
    const [savingOwner, setSavingOwner] = useState(false);
    const [resolvedWorkspaceId, setResolvedWorkspaceId] = useState(null);
    const [resolvedWorkspaceName, setResolvedWorkspaceName] = useState(null);

    const applyWorkspaceLabel = useCallback(async (workspaceId) => {
        if (workspaceId == null) {
            setResolvedWorkspaceName(null);
            return;
        }
        try {
            const wss = await fetchJson('/api/workspaces');
            const arr = Array.isArray(wss) ? wss : [];
            const row = arr.find((w) => Number(w.id) === Number(workspaceId));
            setResolvedWorkspaceName(row?.name ?? `Workspace #${workspaceId}`);
        } catch {
            setResolvedWorkspaceName(null);
        }
    }, []);

    const loadMe = useCallback(async () => {
        setError(null);
        try {
            const data = await fetchJson('/api/users/me');
            const id = data.owner_member_id != null ? Number(data.owner_member_id) : null;
            setOwnerMemberId(Number.isNaN(id) ? null : id);
            const wid = data.workspace_id != null ? Number(data.workspace_id) : null;
            setResolvedWorkspaceId(wid);
            await applyWorkspaceLabel(wid);
            return Number.isNaN(id) ? null : id;
        } catch (e) {
            setOwnerMemberId(null);
            setResolvedWorkspaceId(null);
            setResolvedWorkspaceName(null);
            setError(e instanceof Error ? e : new Error('Failed to load user'));
            return null;
        }
    }, [applyWorkspaceLabel]);

    const loadMembers = useCallback(async () => {
        try {
            const data = await fetchJson('/api/dragonfly/members');
            setMembers(Array.isArray(data) ? data : []);
        } catch {
            setMembers([]);
        }
    }, []);

    useEffect(() => {
        let cancelled = false;
        (async () => {
            setLoading(true);
            religoOwnerStore.sync({ ownerMemberId: null, loading: true, error: null });
            await loadMe();
            if (cancelled) return;
            await loadMembers();
            if (cancelled) return;
            setLoading(false);
        })();
        return () => {
            cancelled = true;
        };
    }, [loadMe, loadMembers]);

    useEffect(() => {
        religoOwnerStore.sync({ ownerMemberId, loading, error });
    }, [ownerMemberId, loading, error]);

    useEffect(() => {
        const onWs = () => {
            loadMe();
        };
        window.addEventListener('religo-workspace-changed', onWs);
        return () => window.removeEventListener('religo-workspace-changed', onWs);
    }, [loadMe]);

    const refreshMe = useCallback(async () => {
        setLoading(true);
        await loadMe();
        await loadMembers();
        setLoading(false);
    }, [loadMe, loadMembers]);

    const patchOwner = useCallback(async (memberId) => {
        setSavingOwner(true);
        setError(null);
        try {
            const res = await fetch('/api/users/me', {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify({ owner_member_id: memberId }),
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                throw new Error(data.message || '保存に失敗しました');
            }
            const id = data.owner_member_id != null ? Number(data.owner_member_id) : null;
            setOwnerMemberId(Number.isNaN(id) ? null : id);
            await loadMembers();
            try {
                window.dispatchEvent(new CustomEvent('religo-owner-changed', { detail: { owner_member_id: id } }));
            } catch {
                /* ignore */
            }
        } catch (e) {
            setError(e instanceof Error ? e : new Error('PATCH owner failed'));
        } finally {
            setSavingOwner(false);
        }
    }, [loadMembers]);

    const value = useMemo(
        () => ({
            ownerMemberId,
            loading,
            error,
            members,
            savingOwner,
            resolvedWorkspaceId,
            resolvedWorkspaceName,
            patchOwner,
            refreshMe,
            loadMembers,
        }),
        [
            ownerMemberId,
            loading,
            error,
            members,
            savingOwner,
            resolvedWorkspaceId,
            resolvedWorkspaceName,
            patchOwner,
            refreshMe,
            loadMembers,
        ]
    );

    return <ReligoOwnerContext.Provider value={value}>{children}</ReligoOwnerContext.Provider>;
}

export function useReligoOwner() {
    const ctx = useContext(ReligoOwnerContext);
    if (!ctx) {
        throw new Error('useReligoOwner must be used within ReligoOwnerProvider');
    }
    return ctx;
}
