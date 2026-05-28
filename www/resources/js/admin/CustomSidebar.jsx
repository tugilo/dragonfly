import React from 'react';
import { useSidebarState } from 'react-admin';
import { Drawer, Box, useMediaQuery } from '@mui/material';

const SIDEBAR_WIDTH = 240;
const SIDEBAR_CLOSED_WIDTH = 55;
const SIDEBAR_BG = '#1e2a3a';
const APPBAR_HEIGHT_PX = 56;

/**
 * Religo 管理画面用カスタムサイドバー。モック v2 #sidebar 準拠。
 * 上部ロゴ、中央にメニュー（children）、下部にユーザー表示。
 * SSOT: docs/SSOT/FIT_AND_GAP_MENU_HEADER.md
 */
export const CustomSidebar = ({ children, appBarAlwaysOn }) => {
    const [open, setOpen] = useSidebarState();
    const isSmall = useMediaQuery((theme) => theme.breakpoints.down('sm'));

    const drawerContent = (
        <Box
            sx={{
                display: 'flex',
                flexDirection: 'column',
                height: '100%',
                overflow: 'hidden',
            }}
        >
            {/* ロゴブロック .sb-logo */}
            <Box
                sx={{
                    padding: '16px 18px 12px',
                    display: 'flex',
                    alignItems: 'center',
                    gap: 1.25,
                    borderBottom: '1px solid rgba(255,255,255,.08)',
                    flexShrink: 0,
                }}
            >
                <Box
                    sx={{
                        width: 32,
                        height: 32,
                        borderRadius: 1,
                        background: 'linear-gradient(135deg, #1976d2, #42a5f5)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        color: '#fff',
                        fontSize: 13,
                        fontWeight: 700,
                    }}
                >
                    R
                </Box>
                <Box sx={{ minWidth: 0, opacity: open ? 1 : 0, transition: 'opacity .2s' }}>
                    <Box sx={{ color: '#fff', fontSize: 15, fontWeight: 700 }}>Religo</Box>
                    <Box sx={{ color: 'rgba(255,255,255,.38)', fontSize: 10, mt: 0.25 }}>
                        DragonFly Chapter
                    </Box>
                </Box>
            </Box>

            {/* メニュー（children = ReligoMenu） */}
            <Box
                sx={{
                    flex: 1,
                    overflowY: 'auto',
                    overflowX: 'hidden',
                    backgroundColor: SIDEBAR_BG,
                    '& .MuiList-root': { backgroundColor: 'transparent' },
                    '& .MuiMenuItem-root': { color: 'rgba(255,255,255,.62)' },
                    '& .MuiMenuItem-root:hover': { backgroundColor: 'rgba(255,255,255,.07)', color: '#fff' },
                    '& .Mui-selected': { backgroundColor: 'rgba(25,118,210,.22)', color: '#fff', fontWeight: 500 },
                    '& .MuiListSubheader-root': {
                        backgroundColor: 'transparent',
                        color: 'rgba(255,255,255,.45)',
                        fontSize: '0.75rem',
                    },
                    '& .MuiDivider-root': { borderColor: 'rgba(255,255,255,.12)' },
                }}
            >
                {children}
            </Box>

            {/* ユーザーブロック .sb-foot */}
            <Box
                sx={{
                    padding: '12px 18px',
                    borderTop: '1px solid rgba(255,255,255,.08)',
                    flexShrink: 0,
                }}
            >
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.125 }}>
                    <Box
                        sx={{
                            width: 30,
                            height: 30,
                            borderRadius: '50%',
                            background: 'linear-gradient(135deg, #1976d2, #42a5f5)',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            color: '#fff',
                            fontSize: 11,
                            fontWeight: 700,
                        }}
                    >
                        ME
                    </Box>
                    <Box sx={{ minWidth: 0, opacity: open ? 1 : 0, transition: 'opacity .2s' }}>
                        <Box sx={{ color: '#fff', fontSize: 12, fontWeight: 500 }}>
                            メンバー管理者
                        </Box>
                        <Box sx={{ color: 'rgba(255,255,255,.38)', fontSize: 10 }}>
                            admin@dragonfly
                        </Box>
                    </Box>
                </Box>
            </Box>
        </Box>
    );

    const paperSx = {
        boxSizing: 'border-box',
        backgroundColor: SIDEBAR_BG,
        borderRight: 'none',
        overflowX: 'hidden',
        marginTop: 0,
        height: isSmall ? '100vh' : `calc(100vh - ${APPBAR_HEIGHT_PX}px)`,
        top: isSmall ? 0 : APPBAR_HEIGHT_PX,
        transition: (theme) =>
            theme.transitions.create('width', {
                easing: theme.transitions.easing.sharp,
                duration: theme.transitions.duration.enteringScreen,
            }),
    };

    if (isSmall) {
        return (
            <Drawer
                variant="temporary"
                open={open}
                onClose={() => setOpen(false)}
                sx={{
                    '& .MuiDrawer-paper': {
                        width: SIDEBAR_WIDTH,
                        ...paperSx,
                    },
                }}
            >
                {drawerContent}
            </Drawer>
        );
    }

    return (
        <Drawer
            variant="permanent"
            open={open}
            sx={{
                width: open ? SIDEBAR_WIDTH : SIDEBAR_CLOSED_WIDTH,
                flexShrink: 0,
                '& .MuiDrawer-paper': {
                    width: open ? SIDEBAR_WIDTH : SIDEBAR_CLOSED_WIDTH,
                    ...paperSx,
                },
            }}
        >
            {drawerContent}
        </Drawer>
    );
};
