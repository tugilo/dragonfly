import React, { useEffect, useState } from 'react';
import { Box, CircularProgress, Typography } from '@mui/material';
import { useReligoOwner } from '../ReligoOwnerContext';
import { religoFetch } from '../religoApiFetch';

const ALLOWED_OWNER_MEMBER_ID = 37;

export default function ShizuokaOutreachTool() {
    const { ownerMemberId, loading } = useReligoOwner();
    const [html, setHtml] = useState('');
    const [fetching, setFetching] = useState(false);
    const [error, setError] = useState('');

    const allowed = Number(ownerMemberId) === ALLOWED_OWNER_MEMBER_ID;

    useEffect(() => {
        if (loading || !allowed) {
            return undefined;
        }

        let cancelled = false;
        (async () => {
            setFetching(true);
            setError('');
            try {
                const res = await religoFetch('/api/tools/shizuoka-outreach', {
                    headers: { Accept: 'text/html' },
                });
                if (!res.ok) {
                    const message = res.status === 403
                        ? 'このツールへのアクセス権がありません。'
                        : `読み込みに失敗しました（${res.status}）`;
                    throw new Error(message);
                }
                const text = await res.text();
                if (!cancelled) {
                    setHtml(text);
                }
            } catch (e) {
                if (!cancelled) {
                    setError(e instanceof Error ? e.message : '読み込みに失敗しました');
                }
            } finally {
                if (!cancelled) {
                    setFetching(false);
                }
            }
        })();

        return () => {
            cancelled = true;
        };
    }, [loading, allowed]);

    if (loading || fetching) {
        return (
            <Box sx={{ p: 3, display: 'flex', justifyContent: 'center' }}>
                <CircularProgress />
            </Box>
        );
    }

    if (!allowed) {
        return (
            <Box sx={{ p: 3 }}>
                <Typography color="error">このツールは本人専用です。</Typography>
            </Box>
        );
    }

    if (error) {
        return (
            <Box sx={{ p: 3 }}>
                <Typography color="error">{error}</Typography>
            </Box>
        );
    }

    return (
        <Box sx={{ height: 'calc(100vh - 56px)', m: -2 }}>
            <iframe
                title="静岡合同懇親会 お礼・121案内"
                srcDoc={html}
                sandbox="allow-scripts allow-same-origin allow-forms allow-popups"
                style={{ width: '100%', height: '100%', border: 'none' }}
            />
        </Box>
    );
}
