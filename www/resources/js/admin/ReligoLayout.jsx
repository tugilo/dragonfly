import React from 'react';
import { Layout } from 'react-admin';
import { useLocation } from 'react-router-dom';
import { Box, CircularProgress, CssBaseline, Typography } from '@mui/material';
import { ReligoMenu } from './ReligoMenu';
import { CustomSidebar } from './CustomSidebar';
import { CustomAppBar } from './CustomAppBar';
import { useReligoOwner } from './ReligoOwnerContext';

/**
 * Religo 管理画面レイアウト。カスタムサイドバー・AppBar（モック v2 準拠）とカスタムメニューを使用。
 * Theme は app.jsx の Admin theme で一箇所のみ適用。CssBaseline でベースラインを統一。
 * SSOT: ADMIN_GLOBAL_OWNER_SELECTION §4.4（未設定時はメインを出さない。/settings のみ例外）
 */
export function ReligoLayout(props) {
    const { loading, ownerMemberId } = useReligoOwner();
    const { pathname } = useLocation();

    if (loading) {
        return (
            <>
                <CssBaseline />
                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: '100vh' }}>
                    <CircularProgress />
                </Box>
            </>
        );
    }

    const settingsBypass = pathname === '/settings' || pathname === '/member-merge';

    const main =
        settingsBypass || ownerMemberId != null ? (
            props.children
        ) : (
            <Box sx={{ p: 3, maxWidth: 720, mx: 'auto', mt: 4 }}>
                <Typography variant="h6" component="p">
                    Ownerを選択してください
                </Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    画面上部の Owner で「自分」に該当するメンバーを選ぶと、各画面のデータが表示されます。
                </Typography>
            </Box>
        );

    return (
        <>
            <CssBaseline />
            <Layout
                menu={ReligoMenu}
                sidebar={CustomSidebar}
                appBar={CustomAppBar}
                sx={{ '& .RaLayout-appFrame': { marginTop: '56px' } }}
                {...props}
                children={main}
            />
        </>
    );
}
