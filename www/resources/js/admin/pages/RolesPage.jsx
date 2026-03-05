import React from 'react';
import {
    Box,
    Container,
    Paper,
    Stack,
    Typography,
    Button,
    Chip,
} from '@mui/material';

/**
 * Settings — Roles. SSOT: religo-admin-mock.html (pg-settings-roles).
 * UI のみ。API 接続は次 Phase。
 */
const STUB_ROLES = [
    { id: 1, name: 'プレジ', desc: 'チャプター代表。例会進行・外部対応全般', count: 1 },
    { id: 2, name: 'バイス', desc: '副代表。プレジのサポート・メンター管理', count: 1 },
    { id: 3, name: '書記', desc: '会議録・連絡調整・書類管理', count: 1 },
    { id: 4, name: '会計', desc: '会費管理・経費精算・財務報告', count: 1 },
    { id: 5, name: 'メンター', desc: '新メンバーのオンボーディング支援', count: 1 },
    { id: 6, name: 'エドコ', desc: '例会の教育コンテンツ作成・配布', count: 1 },
    { id: 7, name: 'メンバー', desc: '一般メンバー', count: 9 },
];

export default function RolesPage() {
    return (
        <Container maxWidth="lg" sx={{ py: 2 }}>
            <Stack direction="row" justifyContent="space-between" alignItems="flex-start" spacing={2} sx={{ mb: 2 }}>
                <Box>
                    <Typography variant="h5" fontWeight={700}>Settings — Roles</Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                        役職マスタの管理
                    </Typography>
                </Box>
                <Button variant="contained" size="small" disabled>＋ 役職追加（Coming soon）</Button>
            </Stack>

            <Paper variant="outlined" sx={{ overflow: 'hidden' }}>
                <Box sx={{ px: 2, py: 1.5, borderBottom: 1, borderColor: 'divider', display: 'flex', alignItems: 'center' }}>
                    <Typography variant="caption" fontWeight={700} color="text.secondary" textTransform="uppercase">役職一覧</Typography>
                    <Typography variant="caption" color="text.secondary" sx={{ ml: 'auto' }}>{STUB_ROLES.length}件</Typography>
                </Box>
                <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                    <thead>
                        <tr style={{ backgroundColor: 'var(--mui-palette-grey-100)' }}>
                            <th style={{ textAlign: 'left', padding: '9px 12px', fontSize: 11, fontWeight: 700, color: 'var(--mui-palette-text-secondary)' }}>役職名</th>
                            <th style={{ textAlign: 'left', padding: '9px 12px', fontSize: 11, fontWeight: 700, color: 'var(--mui-palette-text-secondary)' }}>説明</th>
                            <th style={{ textAlign: 'center', padding: '9px 12px', fontSize: 11, fontWeight: 700, color: 'var(--mui-palette-text-secondary)' }}>現在の担当者数</th>
                            <th style={{ textAlign: 'left', padding: '9px 12px', fontSize: 11, fontWeight: 700, color: 'var(--mui-palette-text-secondary)' }}>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {STUB_ROLES.map((row) => (
                            <tr key={row.id} style={{ borderBottom: '1px solid var(--mui-palette-divider)' }}>
                                <td style={{ padding: '9px 12px' }}><Chip label={row.name} size="small" variant="outlined" /></td>
                                <td style={{ padding: '9px 12px', fontSize: 12, color: 'var(--mui-palette-text-secondary)' }}>{row.desc}</td>
                                <td style={{ padding: '9px 12px', textAlign: 'center' }}><Chip label={row.count} size="small" color="primary" /></td>
                                <td style={{ padding: '9px 12px' }}>
                                    <Button size="small" variant="outlined" disabled>✏️ 編集</Button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </Paper>
        </Container>
    );
}
