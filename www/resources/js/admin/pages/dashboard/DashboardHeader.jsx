import React from 'react';
import { Box, Typography, Button } from '@mui/material';
import { Link } from 'react-router-dom';

/**
 * タイトル・補助文・主要 CTA。Owner 選択はグローバル AppBar（ADMIN_GLOBAL_OWNER_SELECTION）。
 * BO-AUDIT-P5: 所属チャプター名表示（/settings で変更）。
 */
export default function DashboardHeader({
    resolvedWorkspaceId = null,
    resolvedWorkspaceName = null,
}) {
    return (
        <Box
            sx={{
                display: 'flex',
                alignItems: 'flex-start',
                justifyContent: 'space-between',
                flexWrap: 'wrap',
                gap: 2,
                mb: 2.25,
            }}
        >
            <Box>
                <Typography component="h1" sx={{ fontSize: 21, fontWeight: 700, letterSpacing: -0.3 }}>
                    Dashboard
                </Typography>
                <Typography sx={{ fontSize: 12, color: 'text.secondary', mt: 0.375 }}>
                    KPI で俯瞰し、優先アクションと直近の活動から次の一手を決める
                </Typography>
                {resolvedWorkspaceId != null && (
                    <Typography variant="caption" sx={{ display: 'block', color: 'text.secondary', mt: 0.25 }} component="span">
                        所属チャプター:{' '}
                        <Box component={Link} to="/settings" sx={{ color: 'primary.main', textDecoration: 'none', '&:hover': { textDecoration: 'underline' } }}>
                            {resolvedWorkspaceName ?? `#${resolvedWorkspaceId}`}
                        </Box>
                    </Typography>
                )}
            </Box>
            <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', alignItems: 'center' }}>
                <Button component={Link} to="/connections" variant="contained" size="small">
                    🗺 Connectionsへ
                </Button>
                <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">
                    ＋ 1to1追加
                </Button>
            </Box>
        </Box>
    );
}
