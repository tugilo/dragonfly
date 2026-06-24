import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { useReligoOwner } from '../ReligoOwnerContext';
import { fetchSonaeChapter, resolveSonaeChapter } from './sonaeApi';

const SonaeChapterContext = createContext(null);

export function SonaeChapterProvider({ children }) {
    const { resolvedWorkspaceId } = useReligoOwner();
    const [chapterId, setChapterId] = useState(null);
    const [chapterMeta, setChapterMeta] = useState(null);
    const [chapterDetail, setChapterDetail] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const reload = useCallback(async () => {
        if (resolvedWorkspaceId == null) {
            setChapterId(null);
            setChapterMeta(null);
            setChapterDetail(null);
            setError(new Error('ワークスペースが未設定です。上部のチャプターを確認してください。'));
            setLoading(false);
            return;
        }
        setLoading(true);
        setError(null);
        try {
            const resolved = await resolveSonaeChapter(resolvedWorkspaceId);
            setChapterId(resolved.id);
            setChapterMeta(resolved);
            const detail = await fetchSonaeChapter(resolved.id);
            setChapterDetail(detail);
        } catch (e) {
            setChapterId(null);
            setChapterMeta(null);
            setChapterDetail(null);
            setError(e instanceof Error ? e : new Error('SONAE chapter の取得に失敗しました'));
        } finally {
            setLoading(false);
        }
    }, [resolvedWorkspaceId]);

    useEffect(() => {
        reload();
    }, [reload]);

    useEffect(() => {
        const onWs = () => reload();
        window.addEventListener('religo-workspace-changed', onWs);
        return () => window.removeEventListener('religo-workspace-changed', onWs);
    }, [reload]);

    const value = useMemo(
        () => ({
            chapterId,
            chapterMeta,
            chapterDetail,
            loading,
            error,
            reload,
            refreshDetail: async () => {
                if (chapterId == null) return;
                const detail = await fetchSonaeChapter(chapterId);
                setChapterDetail(detail);
            },
        }),
        [chapterId, chapterMeta, chapterDetail, loading, error, reload]
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
