import React from 'react';
import { Menu } from 'react-admin';
import { Divider } from '@mui/material';

/**
 * Religo IA: Board → Members | Meetings | 1 to 1.
 * 1 to 1 は Meeting と独立であることをメニュー構成で明示する。
 */
export const ReligoMenu = () => (
    <Menu>
        <Menu.DashboardItem primaryText="Board（会の地図）" />
        <Menu.ResourceItem name="members" />
        <Divider sx={{ my: 1 }} />
        <Menu.ResourceItem name="meetings" />
        <Divider sx={{ my: 1 }} />
        <Menu.ResourceItem name="one-to-ones" />
    </Menu>
);
