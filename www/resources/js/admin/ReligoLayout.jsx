import React from 'react';
import { Layout } from 'react-admin';
import { CssBaseline } from '@mui/material';
import { ReligoMenu } from './ReligoMenu';
import { CustomSidebar } from './CustomSidebar';
import { CustomAppBar } from './CustomAppBar';

/**
 * Religo 管理画面レイアウト。カスタムサイドバー・AppBar（モック v2 準拠）とカスタムメニューを使用。
 * Theme は app.jsx の Admin theme で一箇所のみ適用。CssBaseline でベースラインを統一。
 */
export const ReligoLayout = (props) => (
    <>
        <CssBaseline />
        <Layout
            menu={ReligoMenu}
            sidebar={CustomSidebar}
            appBar={CustomAppBar}
            sx={{ '& .RaLayout-appFrame': { marginTop: '56px' } }}
            {...props}
        />
    </>
);
