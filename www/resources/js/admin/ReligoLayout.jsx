import React from 'react';
import { Layout } from 'react-admin';
import { CssBaseline } from '@mui/material';
import { ReligoMenu } from './ReligoMenu';

/**
 * Religo 管理画面レイアウト。IA に沿ったカスタムメニューを使用。
 * Theme は app.jsx の Admin theme で一箇所のみ適用。CssBaseline でベースラインを統一。
 */
export const ReligoLayout = (props) => (
    <>
        <CssBaseline />
        <Layout menu={ReligoMenu} {...props} />
    </>
);
