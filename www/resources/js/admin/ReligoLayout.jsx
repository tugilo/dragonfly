import React from 'react';
import { Layout } from 'react-admin';
import { ReligoMenu } from './ReligoMenu';

/**
 * Religo 管理画面レイアウト。IA に沿ったカスタムメニューを使用。
 */
export const ReligoLayout = (props) => (
    <Layout menu={ReligoMenu} {...props} />
);
