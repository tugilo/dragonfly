import React from 'react';
import {
    Box,
    Card,
    Container,
    Paper,
    Stack,
    Typography,
    Button,
    Chip,
} from '@mui/material';
import { Link } from 'react-router-dom';

/**
 * Settings — Categories. SSOT: religo-admin-mock.html (pg-settings-categories).
 * UI のみ。API 接続は次 Phase。
 */
const STUB_CATS = [
    { id: 1, group: 'IT', name: 'システム開発', count: 1 },
    { id: 2, group: 'IT', name: 'Web制作', count: 1 },
    { id: 3, group: '士業', name: '税理士', count: 1 },
    { id: 4, group: '士業', name: '社労士', count: 1 },
    { id: 5, group: '医療', name: '歯科', count: 1 },
    { id: 6, group: '建設', name: '塗装', count: 1 },
];

export default function CategoriesPage() {
    return (
        <Container maxWidth="lg" sx={{ py: 2 }}>
            <Stack direction="row" justifyContent="space-between" alignItems="flex-start" spacing={2} sx={{ mb: 2 }}>
                <Box>
                    <Typography variant="h5" fontWeight={700}>Settings — Categories</Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                        大カテゴリ（group）と実カテゴリの管理
                    </Typography>
                </Box>
                <Button variant="contained" size="small" disabled>＋ カテゴリ追加（Coming soon）</Button>
            </Stack>

            <Box sx={{ mb: 2, p: 1.5, bgcolor: 'warning.light', border: 1, borderColor: 'warning.main', borderRadius: 1 }}>
                <Typography variant="body2" color="warning.dark">
                    ⚠️ カテゴリの削除は、所属メンバーがいる場合は不可です。メンバーを別カテゴリへ移動してから削除してください。
                </Typography>
            </Box>

            <Paper variant="outlined" sx={{ overflow: 'hidden' }}>
                <Box sx={{ px: 2, py: 1.5, borderBottom: 1, borderColor: 'divider', display: 'flex', alignItems: 'center' }}>
                    <Typography variant="caption" fontWeight={700} color="text.secondary" textTransform="uppercase">カテゴリ一覧</Typography>
                    <Typography variant="caption" color="text.secondary" sx={{ ml: 'auto' }}>{STUB_CATS.length}件</Typography>
                </Box>
                <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                    <thead>
                        <tr style={{ backgroundColor: 'var(--mui-palette-grey-100)' }}>
                            <th style={{ textAlign: 'left', padding: '9px 12px', fontSize: 11, fontWeight: 700, color: 'var(--mui-palette-text-secondary)' }}>大カテゴリ (group)</th>
                            <th style={{ textAlign: 'left', padding: '9px 12px', fontSize: 11, fontWeight: 700, color: 'var(--mui-palette-text-secondary)' }}>実カテゴリ (name)</th>
                            <th style={{ textAlign: 'center', padding: '9px 12px', fontSize: 11, fontWeight: 700, color: 'var(--mui-palette-text-secondary)' }}>メンバー数</th>
                            <th style={{ textAlign: 'left', padding: '9px 12px', fontSize: 11, fontWeight: 700, color: 'var(--mui-palette-text-secondary)' }}>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {STUB_CATS.map((row) => (
                            <tr key={row.id} style={{ borderBottom: '1px solid var(--mui-palette-divider)' }}>
                                <td style={{ padding: '9px 12px' }}><Chip label={row.group} size="small" variant="outlined" sx={{ bgcolor: 'grey.100' }} /></td>
                                <td style={{ padding: '9px 12px' }}><Chip label={row.name} size="small" color="primary" variant="outlined" /></td>
                                <td style={{ padding: '9px 12px', textAlign: 'center' }}><Chip label={row.count} size="small" color="primary" /></td>
                                <td style={{ padding: '9px 12px' }}>
                                    <Button size="small" variant="outlined" disabled>✏️ 編集</Button>
                                    <Button size="small" color="error" variant="outlined" disabled sx={{ ml: 0.5 }}>🗑 削除</Button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </Paper>
        </Container>
    );
}
