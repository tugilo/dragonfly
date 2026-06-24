import React, { useCallback, useEffect, useMemo, useState } from 'react';
import {
    Alert,
    Box,
    Button,
    Container,
    FormControlLabel,
    MenuItem,
    Paper,
    Select,
    Snackbar,
    Stack,
    Switch,
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableRow,
    TextField,
    Typography,
} from '@mui/material';
import { useSonaeChapter } from '../../sonae/SonaeChapterContext';
import { fetchSonaeAlertSettings, updateSonaeAlertSettings } from '../../sonae/sonaeApi';

function toPrefectureText(value) {
    if (!Array.isArray(value)) return '';
    return value.filter((v) => typeof v === 'string' && v.trim() !== '').join(', ');
}

export default function SonaeAlertSettingsPage({ embedded = false }) {
    const { chapterId } = useSonaeChapter();
    const [rows, setRows] = useState([]);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'info' });

    const notify = (message, severity = 'info') => setSnack({ open: true, message, severity });

    const load = useCallback(async () => {
        if (chapterId == null) return;
        setLoading(true);
        try {
            const data = await fetchSonaeAlertSettings(chapterId);
            const normalized = (Array.isArray(data) ? data : []).map((row) => ({
                ...row,
                target_prefectures_text: toPrefectureText(row.target_prefectures),
            }));
            setRows(normalized);
        } catch (e) {
            notify(e instanceof Error ? e.message : '発報条件の取得に失敗しました', 'error');
        } finally {
            setLoading(false);
        }
    }, [chapterId]);

    useEffect(() => {
        load();
    }, [load]);

    const save = async () => {
        if (chapterId == null) return;
        setSaving(true);
        try {
            const payload = rows.map((row) => ({
                alert_type_code: row.alert_type_code,
                is_enabled: Boolean(row.is_enabled),
                threshold_code: row.threshold_code || null,
                target_prefectures: String(row.target_prefectures_text || '')
                    .split(',')
                    .map((v) => v.trim())
                    .filter((v) => v !== ''),
            }));
            const updated = await updateSonaeAlertSettings(chapterId, payload);
            setRows(
                (Array.isArray(updated) ? updated : []).map((row) => ({
                    ...row,
                    target_prefectures_text: toPrefectureText(row.target_prefectures),
                }))
            );
            notify('発報条件を保存しました', 'success');
        } catch (e) {
            notify(e instanceof Error ? e.message : '保存に失敗しました', 'error');
        } finally {
            setSaving(false);
        }
    };

    const content = useMemo(() => {
        if (loading) {
            return <Typography>読み込み中…</Typography>;
        }

        if (rows.length === 0) {
            return <Alert severity="warning">利用可能なアラート種別がありません。</Alert>;
        }

        return (
            <Stack spacing={2}>
                <Table size="small">
                    <TableHead>
                        <TableRow>
                            <TableCell>種別</TableCell>
                            <TableCell>有効化</TableCell>
                            <TableCell>閾値</TableCell>
                            <TableCell>対象都道府県（カンマ区切り）</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map((row, idx) => (
                            <TableRow key={row.alert_type_code}>
                                <TableCell>{row.alert_type_name}</TableCell>
                                <TableCell>
                                    <FormControlLabel
                                        control={
                                            <Switch
                                                checked={Boolean(row.is_enabled)}
                                                onChange={(e) =>
                                                    setRows((prev) =>
                                                        prev.map((x, i) =>
                                                            i === idx ? { ...x, is_enabled: e.target.checked } : x
                                                        )
                                                    )
                                                }
                                            />
                                        }
                                        label={row.is_enabled ? 'ON' : 'OFF'}
                                    />
                                </TableCell>
                                <TableCell>
                                    <Select
                                        size="small"
                                        value={row.threshold_code ?? ''}
                                        onChange={(e) =>
                                            setRows((prev) =>
                                                prev.map((x, i) =>
                                                    i === idx ? { ...x, threshold_code: e.target.value || null } : x
                                                )
                                            )
                                        }
                                        sx={{ minWidth: 220 }}
                                    >
                                        <MenuItem value="">未指定（全件）</MenuItem>
                                        {(row.threshold_options ?? []).map((opt) => (
                                            <MenuItem key={opt.code} value={opt.code}>
                                                {opt.label}
                                            </MenuItem>
                                        ))}
                                    </Select>
                                </TableCell>
                                <TableCell>
                                    <TextField
                                        size="small"
                                        fullWidth
                                        value={row.target_prefectures_text ?? ''}
                                        onChange={(e) =>
                                            setRows((prev) =>
                                                prev.map((x, i) =>
                                                    i === idx
                                                        ? { ...x, target_prefectures_text: e.target.value }
                                                        : x
                                                )
                                            )
                                        }
                                        placeholder="例: 静岡県, 神奈川県"
                                    />
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
                <Box>
                    <Button variant="contained" onClick={save} disabled={saving}>
                        保存
                    </Button>
                </Box>
            </Stack>
        );
    }, [loading, rows, save, saving]);

    if (embedded) {
        return (
            <>
                <Typography variant="h6" gutterBottom>
                    発報条件設定
                </Typography>
                {content}
                <Snackbar
                    open={snack.open}
                    autoHideDuration={5000}
                    onClose={() => setSnack((s) => ({ ...s, open: false }))}
                >
                    <Alert severity={snack.severity}>{snack.message}</Alert>
                </Snackbar>
            </>
        );
    }

    return (
        <Container maxWidth="lg" sx={{ py: 3 }}>
            <Typography variant="h5" gutterBottom>
                SONAE 発報条件設定
            </Typography>
            <Paper variant="outlined" sx={{ p: 2 }}>
                {content}
            </Paper>
            <Snackbar
                open={snack.open}
                autoHideDuration={5000}
                onClose={() => setSnack((s) => ({ ...s, open: false }))}
            >
                <Alert severity={snack.severity}>{snack.message}</Alert>
            </Snackbar>
        </Container>
    );
}
