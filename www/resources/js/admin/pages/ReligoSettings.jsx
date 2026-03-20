import React, { useState, useEffect, useCallback } from 'react';
import {
    Button,
    Card,
    CardContent,
    Container,
    FormControl,
    InputLabel,
    MenuItem,
    Select,
    Snackbar,
    Alert,
    Typography,
    CircularProgress,
} from '@mui/material';

const RELIGO_WORKSPACE_CHANGED = 'religo-workspace-changed';

async function fetchJson(url, options = {}) {
    const res = await fetch(url, { headers: { Accept: 'application/json', ...options.headers }, ...options });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

/**
 * 所属チャプター（workspace）設定。BO-AUDIT-P5. SSOT: default_workspace_id = 所属.
 * GET /api/workspaces + GET/PATCH /api/users/me
 */
export default function ReligoSettings() {
    const [loading, setLoading] = useState(true);
    const [workspaces, setWorkspaces] = useState([]);
    const [selectedId, setSelectedId] = useState('');
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState('');
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'success' });

    const load = useCallback(async () => {
        setLoading(true);
        setError('');
        try {
            const [me, rows] = await Promise.all([
                fetchJson('/api/users/me'),
                fetchJson('/api/workspaces'),
            ]);
            const list = Array.isArray(rows) ? rows : [];
            setWorkspaces(list);
            const initial = me.workspace_id != null ? String(me.workspace_id) : '';
            setSelectedId(initial);
        } catch (e) {
            setError('設定の読み込みに失敗しました。');
            setWorkspaces([]);
            setSelectedId('');
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        load();
    }, [load]);

    const handleSave = async () => {
        const id = selectedId === '' ? null : Number(selectedId);
        if (id == null || !Number.isInteger(id)) {
            setSnack({ open: true, message: 'チャプターを選択してください。', severity: 'warning' });
            return;
        }
        setSaving(true);
        setError('');
        try {
            const res = await fetch('/api/users/me', {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify({ default_workspace_id: id }),
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                setSnack({ open: true, message: data.message || '保存に失敗しました', severity: 'error' });
                return;
            }
            if (data.workspace_id != null) {
                setSelectedId(String(data.workspace_id));
            }
            window.dispatchEvent(new CustomEvent(RELIGO_WORKSPACE_CHANGED));
            setSnack({ open: true, message: '所属チャプターを保存しました。', severity: 'success' });
        } catch {
            setSnack({ open: true, message: '保存に失敗しました', severity: 'error' });
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <Container maxWidth="sm" sx={{ py: 4, display: 'flex', justifyContent: 'center' }}>
                <CircularProgress size={28} />
            </Container>
        );
    }

    return (
        <Container maxWidth="sm" sx={{ py: 2 }}>
            <Typography component="h1" sx={{ fontSize: 21, fontWeight: 700, mb: 2 }}>
                設定
            </Typography>
            <Card variant="outlined" sx={{ borderRadius: '10px' }}>
                <CardContent>
                    <Typography sx={{ fontWeight: 600, mb: 0.5 }}>所属チャプター</Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                        BNI の所属チャプターに相当する workspace を選択します（SSOT: 1 user = 1 workspace）。
                    </Typography>
                    {workspaces.length === 0 ? (
                        <Typography color="error" variant="body2">
                            登録されている workspace がありません。管理者に連絡してください。
                        </Typography>
                    ) : (
                        <>
                            <FormControl fullWidth size="small" sx={{ mb: 2 }}>
                                <InputLabel id="chapter-select-label">チャプター</InputLabel>
                                <Select
                                    labelId="chapter-select-label"
                                    label="チャプター"
                                    value={selectedId}
                                    onChange={(e) => setSelectedId(String(e.target.value))}
                                    disabled={saving}
                                    required
                                    displayEmpty
                                >
                                    <MenuItem value="" disabled>
                                        <em>選択してください</em>
                                    </MenuItem>
                                    {workspaces.map((w) => (
                                        <MenuItem key={w.id} value={String(w.id)}>
                                            {w.name}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                            {error && (
                                <Typography color="error" variant="body2" sx={{ mb: 1 }}>
                                    {error}
                                </Typography>
                            )}
                            <Button
                                variant="contained"
                                size="medium"
                                onClick={handleSave}
                                disabled={saving || selectedId === ''}
                            >
                                {saving ? '保存中…' : '保存'}
                            </Button>
                        </>
                    )}
                </CardContent>
            </Card>
            <Snackbar
                open={snack.open}
                autoHideDuration={4000}
                onClose={() => setSnack((s) => ({ ...s, open: false }))}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
            >
                <Alert severity={snack.severity} onClose={() => setSnack((s) => ({ ...s, open: false }))} variant="filled">
                    {snack.message}
                </Alert>
            </Snackbar>
        </Container>
    );
}
