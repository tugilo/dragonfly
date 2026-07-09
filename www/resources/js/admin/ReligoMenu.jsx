import React from 'react';
import { Menu, useResourceDefinitions, usePermissions } from 'react-admin';
import { Link, useLocation } from 'react-router-dom';
import { Divider, ListSubheader, MenuItem } from '@mui/material';

/**
 * Religo 管理画面メニュー。SSOT: www/public/mock/religo-admin-mock.html
 * 並び: Dashboard → … → 1 to 1 → Role History → 設定 → Zoom 取り込み →（admin）マスタ管理
 * SPEC-020 Phase D（順位 6/10）: 一般 member には管理系（Member merge / SONAE / Categories / Roles）を出さない。
 */
export const ReligoMenu = () => {
    const resources = useResourceDefinitions();
    const { permissions } = usePermissions();
    const isAdmin = permissions === 'chapter_admin';
    const location = useLocation();
    const path = location.pathname;

    const isActive = (href) => path === href || (href !== '/' && path.startsWith(href));

    return (
        <Menu>
            <MenuItem
                component={Link}
                to="/"
                selected={path === '/'}
                sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
            >
                <span style={{ marginRight: 8 }}>📊</span>
                Dashboard
            </MenuItem>
            {resources.connections && (
                <MenuItem
                    component={Link}
                    to="/connections"
                    selected={isActive('/connections')}
                    sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    <span style={{ marginRight: 8 }}>🗺</span>
                    Connections
                </MenuItem>
            )}
            {resources.members && (
                <MenuItem
                    component={Link}
                    to="/members"
                    selected={isActive('/members')}
                    sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    <span style={{ marginRight: 8 }}>👥</span>
                    Members
                </MenuItem>
            )}
            {resources.meetings && (
                <MenuItem
                    component={Link}
                    to="/meetings"
                    selected={isActive('/meetings')}
                    sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    <span style={{ marginRight: 8 }}>📋</span>
                    Meetings
                </MenuItem>
            )}
            {resources['one-to-ones'] && (
                <MenuItem
                    component={Link}
                    to="/one-to-ones"
                    selected={isActive('/one-to-ones')}
                    sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    <span style={{ marginRight: 8 }}>🤝</span>
                    1 to 1
                </MenuItem>
            )}
            {resources['role-history'] && (
                <MenuItem
                    component={Link}
                    to="/role-history"
                    selected={isActive('/role-history')}
                    sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    <span style={{ marginRight: 8 }}>🏅</span>
                    Role History
                </MenuItem>
            )}
            <MenuItem
                component={Link}
                to="/settings"
                selected={isActive('/settings')}
                sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
            >
                <span style={{ marginRight: 8 }}>⚙️</span>
                設定
            </MenuItem>
            <Divider
                sx={{
                    my: 1,
                    borderColor: 'rgba(255,255,255,0.12)',
                    backgroundColor: 'transparent',
                }}
            />
            {isAdmin && (
                <MenuItem
                    component={Link}
                    to="/member-merge"
                    selected={isActive('/member-merge')}
                    sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    <span style={{ marginRight: 8 }}>🔀</span>
                    Member merge
                </MenuItem>
            )}
            <MenuItem
                component={Link}
                to="/zoom-import"
                selected={isActive('/zoom-import')}
                sx={{ '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
            >
                <span style={{ marginRight: 8 }}>🎥</span>
                Zoom 取り込み
            </MenuItem>
            {isAdmin && (
                <Divider
                    sx={{
                        my: 1,
                        borderColor: 'rgba(255,255,255,0.12)',
                        backgroundColor: 'transparent',
                    }}
                />
            )}
            {isAdmin && (
                <ListSubheader
                    disableSticky
                    sx={{
                        lineHeight: 2,
                        fontSize: '0.75rem',
                        backgroundColor: 'transparent',
                        color: 'rgba(255,255,255,0.45)',
                    }}
                >
                    SONAE
                </ListSubheader>
            )}
            {isAdmin && (
                <MenuItem
                    component={Link}
                    to="/sonae"
                    selected={path === '/sonae'}
                    sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    ダッシュボード
                </MenuItem>
            )}
            {isAdmin && (
                <MenuItem
                    component={Link}
                    to="/sonae/members"
                    selected={isActive('/sonae/members')}
                    sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    メンバー
                </MenuItem>
            )}
            {isAdmin && (
                <MenuItem
                    component={Link}
                    to="/sonae/line"
                    selected={isActive('/sonae/line')}
                    sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    LINE 設定
                </MenuItem>
            )}
            {isAdmin && (
                <MenuItem
                    component={Link}
                    to="/sonae/training"
                    selected={isActive('/sonae/training')}
                    sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    訓練・集計
                </MenuItem>
            )}
            {isAdmin && (
                <MenuItem
                    component={Link}
                    to="/sonae/jma"
                    selected={isActive('/sonae/jma')}
                    sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    気象庁連携
                </MenuItem>
            )}
            {isAdmin && (
                <MenuItem
                    component={Link}
                    to="/sonae/alert-settings"
                    selected={isActive('/sonae/alert-settings')}
                    sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                >
                    発報条件
                </MenuItem>
            )}
            {isAdmin && (
                <>
                    <ListSubheader
                        disableSticky
                        sx={{
                            lineHeight: 2,
                            fontSize: '0.75rem',
                            backgroundColor: 'transparent',
                            color: 'rgba(255,255,255,0.45)',
                        }}
                    >
                        マスタ管理
                    </ListSubheader>
                    <MenuItem
                        component={Link}
                        to="/categories"
                        selected={isActive('/categories')}
                        sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                    >
                        Categories
                    </MenuItem>
                    <MenuItem
                        component={Link}
                        to="/roles"
                        selected={isActive('/roles')}
                        sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
                    >
                        Roles
                    </MenuItem>
                </>
            )}
        </Menu>
    );
};
