import React from 'react';
import { useLocation, Link } from 'react-router-dom';
import { AppBar, Toolbar, Box, IconButton, InputBase, FormControl, InputLabel, Select, MenuItem } from '@mui/material';
import { SidebarToggleButton } from 'react-admin';
import { useReligoOwner } from './ReligoOwnerContext';
import { formatMemberPrimaryLine } from './utils/memberDisplay';

const APPBAR_HEIGHT = 56;

/** pathname をパンくず用ラベルに変換。SSOT: FIT_AND_GAP_MENU_HEADER */
const PATH_TO_LABEL = {
    '/': 'Dashboard',
    '/connections': 'Connections',
    '/members': 'Members',
    '/meetings': 'Meetings',
    '/one-to-ones': '1 to 1',
    '/role-history': 'Role History',
    '/categories': 'Categories',
    '/roles': 'Roles',
    '/settings': '設定',
};

const getLabel = (pathname) => {
    if (PATH_TO_LABEL[pathname]) return PATH_TO_LABEL[pathname];
    if (pathname.startsWith('/members/')) return 'Member';
    if (pathname.startsWith('/categories/')) return 'Category';
    if (pathname.startsWith('/roles/')) return 'Role';
    if (pathname.startsWith('/one-to-ones/')) return '1 to 1';
    return pathname.split('/').filter(Boolean).pop() || 'Dashboard';
};

/**
 * Religo 管理画面用カスタム AppBar。モック v2 #appbar 準拠。
 * グローバル Owner Select — SSOT: ADMIN_GLOBAL_OWNER_SELECTION §4
 */
export const CustomAppBar = () => {
    const { pathname } = useLocation();
    const currentLabel = getLabel(pathname);
    const {
        ownerMemberId,
        members,
        savingOwner,
        patchOwner,
        resolvedWorkspaceId,
        resolvedWorkspaceName,
    } = useReligoOwner();

    const chapterLabel =
        resolvedWorkspaceId != null ? resolvedWorkspaceName ?? `Workspace #${resolvedWorkspaceId}` : null;

    const handleOwnerChange = (e) => {
        const v = e.target.value;
        if (v === '' || v == null) return;
        const n = Number(v);
        if (Number.isInteger(n)) patchOwner(n);
    };

    return (
        <AppBar
            position="fixed"
            sx={{
                height: APPBAR_HEIGHT,
                backgroundColor: '#fff',
                color: '#1a1f36',
                boxShadow: '0 1px 3px rgba(0,0,0,.07)',
                borderBottom: '1px solid #e0e0e0',
            }}
        >
            <Toolbar
                sx={{
                    minHeight: `${APPBAR_HEIGHT}px !important`,
                    paddingLeft: { xs: 1, sm: 2.5 },
                    paddingRight: { xs: 1, sm: 2.5 },
                    gap: 1.5,
                }}
            >
                <SidebarToggleButton />

                {/* パンくず .ab-bc */}
                <Box
                    sx={{
                        display: 'flex',
                        alignItems: 'center',
                        gap: 0.75,
                        flex: 1,
                        minWidth: 0,
                    }}
                >
                    <Box
                        component={Link}
                        to="/"
                        sx={{
                            color: '#637381',
                            fontSize: 13,
                            textDecoration: 'none',
                            '&:hover': { color: '#1976d2' },
                        }}
                    >
                        Religo
                    </Box>
                    <Box component="span" sx={{ color: '#bdbdbd', cursor: 'default' }}>
                        ›
                    </Box>
                    <Box component="span" sx={{ color: '#1a1f36', fontWeight: 500, fontSize: 13 }}>
                        {currentLabel}
                    </Box>
                </Box>

                {/* 検索 .ab-search（ダミー） */}
                <Box
                    sx={{
                        display: { xs: 'none', md: 'flex' },
                        alignItems: 'center',
                        gap: 0.875,
                        backgroundColor: '#f5f5f5',
                        border: '1px solid #e0e0e0',
                        borderRadius: '20px',
                        padding: '5px 14px',
                        width: 210,
                    }}
                >
                    <Box component="span" sx={{ color: '#bbb', fontSize: 14 }}>
                        🔍
                    </Box>
                    <InputBase
                        placeholder="検索…"
                        disabled
                        sx={{
                            fontSize: 12,
                            width: '100%',
                            '& .MuiInputBase-input': { py: 0 },
                        }}
                        inputProps={{ 'aria-label': '検索' }}
                    />
                </Box>

                <FormControl size="small" sx={{ minWidth: { xs: 120, sm: 160 } }}>
                    <InputLabel id="religo-global-owner-label">Owner</InputLabel>
                    <Select
                        labelId="religo-global-owner-label"
                        label="Owner"
                        value={ownerMemberId != null ? String(ownerMemberId) : ''}
                        onChange={handleOwnerChange}
                        disabled={savingOwner || members.length === 0}
                        displayEmpty
                    >
                        {ownerMemberId == null && (
                            <MenuItem value="">
                                <em>選択してください</em>
                            </MenuItem>
                        )}
                        {members.map((m) => (
                            <MenuItem key={m.id} value={String(m.id)}>
                                {formatMemberPrimaryLine(m)}
                            </MenuItem>
                        ))}
                    </Select>
                </FormControl>

                {chapterLabel && (
                    <Box
                        component={Link}
                        to="/settings"
                        sx={{
                            display: { xs: 'none', sm: 'block' },
                            maxWidth: 180,
                            overflow: 'hidden',
                            textOverflow: 'ellipsis',
                            whiteSpace: 'nowrap',
                            fontSize: 12,
                            color: '#637381',
                            textDecoration: 'none',
                            '&:hover': { color: '#1976d2' },
                        }}
                        title={chapterLabel}
                    >
                        所属: {chapterLabel}
                    </Box>
                )}

                {/* 通知 .ab-ico（ダミー） */}
                <IconButton
                    size="small"
                    sx={{
                        width: 34,
                        height: 34,
                        color: '#637381',
                        '&:hover': { backgroundColor: 'rgba(0,0,0,.06)' },
                    }}
                    aria-label="通知"
                >
                    🔔
                </IconButton>

                {/* ME アバター .av */}
                <Box
                    sx={{
                        width: 32,
                        height: 32,
                        borderRadius: '50%',
                        background: 'linear-gradient(135deg, #1976d2, #42a5f5)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        color: '#fff',
                        fontSize: 11,
                        fontWeight: 700,
                        cursor: 'pointer',
                    }}
                >
                    ME
                </Box>
            </Toolbar>
        </AppBar>
    );
};
