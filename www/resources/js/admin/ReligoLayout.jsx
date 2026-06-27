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
 * owner_member_id 未設定時はメインを出さない（/settings 等のみ例外）。Owner はログインユーザー固定。
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

    const settingsBypass =
        pathname === '/settings' ||
        pathname === '/member-merge' ||
        pathname.startsWith('/sonae');

    const main =
        settingsBypass || ownerMemberId != null ? (
            props.children
        ) : (
            <Box sx={{ p: 3, maxWidth: 720, mx: 'auto', mt: 4 }}>
                <Typography variant="h6" component="p">
                    メンバー紐付けが必要です
                </Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    ログインアカウントにメンバー（Owner）が紐付いていません。自己登録でメールが一致していない場合は、チャプター管理者に連絡してください。
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
