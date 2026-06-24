import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { bootstrapSonaeChapter, fetchSonaeContext, syncSonaeMembers } from './sonaeApi';

const SonaeChapterContext = createContext(null);

export function SonaeChapterProvider({ children }) {
    const [chapterId, setChapterId] = useState(null);
    const [chapterMeta, setChapterMeta] = useState(null);
    const [chapterDetail, setChapterDetail] = useState(null);
    const [workspaceId, setWorkspaceId] = useState(null);
    const [workspaceName, setWorkspaceName] = useState(null);
    const [bootstrapRequired, setBootstrapRequired] = useState(false);
    const [loading, setLoading] = useState(true);
    const [bootstrapping, setBootstrapping] = useState(false);
    const [syncing, setSyncing] = useState(false);
    const [error, setError] = useState(null);

    const applyContext = useCallback((ctx) => {
        setWorkspaceId(ctx.workspace_id ?? null);
        setWorkspaceName(ctx.workspace_name ?? null);
        setBootstrapRequired(Boolean(ctx.bootstrap_required));
        const chapter = ctx.chapter ?? null;
        if (chapter) {
            setChapterId(chapter.id);
            setChapterMeta({
                id: chapter.id,
                name: chapter.name,
                chapter_key: chapter.chapter_key,
                religo_linked: chapter.religo_linked,
            });
            setChapterDetail(chapter);
        } else {
            setChapterId(null);
            setChapterMeta(null);
            setChapterDetail(null);
        }
    }, []);

    const reload = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            const ctx = await fetchSonaeContext();
            applyContext(ctx);
            if (ctx.workspace_id == null) {
                setError(new Error('ワークスペースが未設定です。上部のチャプター（所属）を確認してください。'));
            }
        } catch (e) {
            setChapterId(null);
            setChapterMeta(null);
            setChapterDetail(null);
            setError(e instanceof Error ? e : new Error('SONAE context の取得に失敗しました'));
        } finally {
            setLoading(false);
        }
    }, [applyContext]);

    useEffect(() => {
        reload();
    }, [reload]);

    useEffect(() => {
        const onWs = () => reload();
        window.addEventListener('religo-workspace-changed', onWs);
        return () => window.removeEventListener('religo-workspace-changed', onWs);
    }, [reload]);

    const bootstrap = useCallback(async () => {
        setBootstrapping(true);
        setError(null);
        try {
            const result = await bootstrapSonaeChapter();
            if (result.chapter) {
                applyContext({
                    workspace_id: workspaceId,
                    workspace_name: workspaceName,
                    bootstrap_required: false,
                    chapter: result.chapter,
                });
            } else {
                await reload();
            }
        } catch (e) {
            setError(e instanceof Error ? e : new Error('SONAE bootstrap に失敗しました'));
        } finally {
            setBootstrapping(false);
        }
    }, [applyContext, reload, workspaceId, workspaceName]);

    const syncFromReligo = useCallback(async () => {
        if (chapterId == null) return null;
        setSyncing(true);
        try {
            const result = await syncSonaeMembers(chapterId);
            await reload();
            return result;
        } finally {
            setSyncing(false);
        }
    }, [chapterId, reload]);

    const value = useMemo(
        () => ({
            chapterId,
            chapterMeta,
            chapterDetail,
            workspaceId,
            workspaceName,
            bootstrapRequired,
            loading,
            bootstrapping,
            syncing,
            error,
            reload,
            bootstrap,
            syncFromReligo,
            refreshDetail: reload,
        }),
        [
            chapterId,
            chapterMeta,
            chapterDetail,
            workspaceId,
            workspaceName,
            bootstrapRequired,
            loading,
            bootstrapping,
            syncing,
            error,
            reload,
            bootstrap,
            syncFromReligo,
        ]
    );

    return <SonaeChapterContext.Provider value={value}>{children}</SonaeChapterContext.Provider>;
}

export function useSonaeChapter() {
    const ctx = useContext(SonaeChapterContext);
    if (!ctx) {
        throw new Error('useSonaeChapter must be used within SonaeChapterProvider');
    }
    return ctx;
}
