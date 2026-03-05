import React from 'react';
import { Menu, useResourceDefinitions } from 'react-admin';
import { Link, useLocation } from 'react-router-dom';
import { Divider, ListSubheader, MenuItem } from '@mui/material';

/**
 * Religo 管理画面メニュー。SSOT: www/public/mock/religo-admin-mock.html
 * 並び: Dashboard → Connections → Members → Meetings → 1 to 1 → Role History → Settings(Categories, Roles)
 */
export const ReligoMenu = () => {
    const resources = useResourceDefinitions();
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
            <Divider sx={{ my: 1 }} />
            <ListSubheader sx={{ lineHeight: 2, fontSize: '0.75rem', color: 'text.secondary' }}>
                SETTINGS
            </ListSubheader>
            <MenuItem
                component={Link}
                to="/settings/categories"
                selected={isActive('/settings/categories')}
                sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
            >
                Categories
            </MenuItem>
            <MenuItem
                component={Link}
                to="/settings/roles"
                selected={isActive('/settings/roles')}
                sx={{ pl: 3, '&.Mui-selected': { borderLeft: '3px solid', borderLeftColor: 'primary.main', borderRadius: 0 } }}
            >
                Roles
            </MenuItem>
        </Menu>
    );
};
