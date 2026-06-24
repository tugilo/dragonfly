import React, { useCallback, useEffect, useState } from 'react';
import {
    Alert,
    Box,
    Button,
    Card,
    CardContent,
    Container,
    FormControlLabel,
    Paper,
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
import {
    fetchSonaeJmaLogs,
    fetchSonaeJmaSettings,
    runSonaeJmaFetch,
    updateSonaeJmaSettings,
} from '../../sonae/sonaeApi';
import SonaeAlertSettingsPage from './SonaeAlertSettingsPage';

function formatTs(value) {
    if (!value) return '—';
    try {
        return new Date(value).toLocaleString('ja-JP');
    } catch {
        return '—';
    }
}

export default function SonaeJmaPage() {
    const [settings, setSettings] = useState(null);
    const [logs, setLogs] = useState([]);
    const [intervalMinutes, setIntervalMinutes] = useState('5');
    const [isEnabled, setIsEnabled] = useState(false);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [fetching, setFetching] = useState(false);
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'info' });

    const notify = (message, severity = 'info') => setSnack({ open: true, message, severity });

    const load = useCallback(async () => {
        setLoading(true);
        try {
            const [settingsData, logsData] = await Promise.all([
                fetchSonaeJmaSettings(),
                fetchSonaeJmaLogs(20),
            ]);
            setSettings(settingsData);
            setIntervalMinutes(String(settingsData?.interval_minutes ?? 5));
            setIsEnabled(Boolean(settingsData?.is_enabled));
            setLogs(Array.isArray(logsData) ? logsData : []);
        } catch (e) {
            notify(e instanceof Error ? e.message : 'JMA 設定の取得に失敗しました', 'error');
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        load();
    }, [load]);

    const saveSettings = async () => {
        setSaving(true);
        try {
            const data = await updateSonaeJmaSettings({
                is_enabled: isEnabled,
                interval_minutes: Number(intervalMinutes),
            });
            setSettings(data);
            setIntervalMinutes(String(data?.interval_minutes ?? 5));
            notify('JMA 取得設定を保存しました', 'success');
        } catch (e) {
            notify(e instanceof Error ? e.message : '保存に失敗しました', 'error');
        } finally {
            setSaving(false);
        }
    };

    const runFetch = async () => {
        setFetching(true);
        try {
            const result = await runSonaeJmaFetch();
            notify(
                `取得完了: 取得 ${result.fetched_count ?? 0} / 新規 ${result.created_event_count ?? 0} / 重複 ${result.skipped_duplicate_count ?? 0}`,
                'success'
            );
            await load();
        } catch (e) {
            notify(e instanceof Error ? e.message : '手動取得に失敗しました', 'error');
        } finally {
            setFetching(false);
        }
    };

    if (loading) {
        return (
            <Container sx={{ py: 3 }}>
                <Typography>読み込み中…</Typography>
            </Container>
        );
    }

    return (
        <Container maxWidth="lg" sx={{ py: 3 }}>
            <Typography variant="h5" gutterBottom>
                SONAE JMA 連携
            </Typography>

            <Card variant="outlined" sx={{ mb: 2 }}>
                <CardContent>
                    <Typography variant="h6" gutterBottom>
                        取得設定
                    </Typography>
                    <Stack spacing={2} direction={{ xs: 'column', sm: 'row' }} alignItems={{ sm: 'center' }}>
                        <FormControlLabel
                            control={<Switch checked={isEnabled} onChange={(e) => setIsEnabled(e.target.checked)} />}
                            label={isEnabled ? '定期取得 ON' : '定期取得 OFF'}
                        />
                        <TextField
                            label="取得間隔（分）"
                            type="number"
                            value={intervalMinutes}
                            onChange={(e) => setIntervalMinutes(e.target.value)}
                            inputProps={{ min: 1, max: 60 }}
                            sx={{ width: 180 }}
                        />
                        <Box>
                            <Button variant="contained" onClick={saveSettings} disabled={saving}>
                                保存
                            </Button>
                        </Box>
                    </Stack>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                        最終取得: {formatTs(settings?.last_fetched_at)} / 次回予定: {formatTs(settings?.next_fetch_at)}
                    </Typography>
                </CardContent>
            </Card>

            <Paper variant="outlined" sx={{ p: 2, mb: 2 }}>
                <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2} alignItems={{ sm: 'center' }}>
                    <Typography variant="h6" sx={{ flexGrow: 1 }}>
                        手動取得
                    </Typography>
                    <Button variant="contained" onClick={runFetch} disabled={fetching}>
                        今すぐ取得
                    </Button>
                </Stack>
            </Paper>

            <Paper variant="outlined" sx={{ p: 2, mb: 2 }}>
                <Typography variant="h6" gutterBottom>
                    取得ログ
                </Typography>
                <Table size="small">
                    <TableHead>
                        <TableRow>
                            <TableCell>開始</TableCell>
                            <TableCell>状態</TableCell>
                            <TableCell>取得</TableCell>
                            <TableCell>新規イベント</TableCell>
                            <TableCell>重複スキップ</TableCell>
                            <TableCell>エラー</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {logs.length === 0 ? (
                            <TableRow>
                                <TableCell colSpan={6}>ログがありません</TableCell>
                            </TableRow>
                        ) : (
                            logs.map((log) => (
                                <TableRow key={log.id}>
                                    <TableCell>{formatTs(log.started_at)}</TableCell>
                                    <TableCell>{log.status}</TableCell>
                                    <TableCell>{log.fetched_count ?? 0}</TableCell>
                                    <TableCell>{log.created_event_count ?? 0}</TableCell>
                                    <TableCell>{log.skipped_duplicate_count ?? 0}</TableCell>
                                    <TableCell>{log.error_message || '—'}</TableCell>
                                </TableRow>
                            ))
                        )}
                    </TableBody>
                </Table>
            </Paper>

            <Paper variant="outlined" sx={{ p: 2 }}>
                <SonaeAlertSettingsPage embedded />
            </Paper>

            <Snackbar open={snack.open} autoHideDuration={6000} onClose={() => setSnack((s) => ({ ...s, open: false }))}>
                <Alert severity={snack.severity}>{snack.message}</Alert>
            </Snackbar>
        </Container>
    );
}
