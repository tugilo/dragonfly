import React, { useCallback, useEffect, useState } from 'react';
import {
    Alert,
    Box,
    Button,
    Container,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Grid,
    Paper,
    Snackbar,
    Stack,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    TextField,
    Typography,
} from '@mui/material';
import { useSonaeChapter } from '../../sonae/SonaeChapterContext';
import {
    dispatchSonaeTraining,
    fetchSonaeNotificationSummary,
    fetchSonaeTrainings,
    formatRate,
} from '../../sonae/sonaeApi';

function SummaryDialog({ open, onClose, chapterId, notificationId }) {
    const [summary, setSummary] = useState(null);
    const [unanswered, setUnanswered] = useState([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    useEffect(() => {
        if (!open || chapterId == null || notificationId == null) return;
        let cancelled = false;
        (async () => {
            setLoading(true);
            setError(null);
            try {
                const res = await fetchSonaeNotificationSummary(chapterId, notificationId);
                if (!cancelled) {
                    setSummary(res.data?.summary ?? null);
                    setUnanswered(Array.isArray(res.data?.unanswered) ? res.data.unanswered : []);
                }
            } catch (e) {
                if (!cancelled) {
                    setError(e instanceof Error ? e.message : '集計の取得に失敗しました');
                }
            } finally {
                if (!cancelled) setLoading(false);
            }
        })();
        return () => {
            cancelled = true;
        };
    }, [open, chapterId, notificationId]);

    const s = summary;

    return (
        <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
            <DialogTitle>訓練 回答集計</DialogTitle>
            <DialogContent>
                {loading ? <Typography>読み込み中…</Typography> : null}
                {error ? <Alert severity="error">{error}</Alert> : null}
                {s ? (
                    <Grid container spacing={2} sx={{ mt: 0.5 }}>
                        <Grid item xs={6} sm={4}>
                            <Typography variant="caption" color="text.secondary">
                                回答率
                            </Typography>
                            <Typography variant="h6">{formatRate(s.response_rate)}</Typography>
                        </Grid>
                        <Grid item xs={6} sm={4}>
                            <Typography variant="caption" color="text.secondary">
                                回答済 / 対象
                            </Typography>
                            <Typography variant="h6">
                                {s.responded_count} / {s.target_count}
                            </Typography>
                        </Grid>
                        <Grid item xs={6} sm={4}>
                            <Typography variant="caption" color="text.secondary">
                                未回答
                            </Typography>
                            <Typography variant="h6">{s.unanswered_count}</Typography>
                        </Grid>
                        <Grid item xs={6} sm={4}>
                            <Typography variant="caption" color="text.secondary">
                                被害あり
                            </Typography>
                            <Typography variant="h6">{s.harmful_count}</Typography>
                        </Grid>
                        <Grid item xs={6} sm={4}>
                            <Typography variant="caption" color="text.secondary">
                                活動困難
                            </Typography>
                            <Typography variant="h6">{s.activity_difficult_count}</Typography>
                        </Grid>
                        <Grid item xs={6} sm={4}>
                            <Typography variant="caption" color="text.secondary">
                                例会参加不可
                            </Typography>
                            <Typography variant="h6">{s.meeting_cannot_attend_count}</Typography>
                        </Grid>
                    </Grid>
                ) : null}
                {unanswered.length > 0 ? (
                    <Box sx={{ mt: 3 }}>
                        <Typography variant="subtitle2" gutterBottom>
                            未回答者
                        </Typography>
                        <Stack spacing={0.5}>
                            {unanswered.map((u) => (
                                <Typography key={u.member_id} variant="body2">
                                    {u.member_name ?? `Member #${u.member_id}`}
                                </Typography>
                            ))}
                        </Stack>
                    </Box>
                ) : null}
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose}>閉じる</Button>
            </DialogActions>
        </Dialog>
    );
}

export default function SonaeTrainingPage() {
    const { chapterId } = useSonaeChapter();
    const [trainings, setTrainings] = useState([]);
    const [name, setName] = useState('');
    const [loading, setLoading] = useState(true);
    const [busy, setBusy] = useState(false);
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'info' });
    const [summaryTarget, setSummaryTarget] = useState(null);

    const notify = (message, severity = 'info') => setSnack({ open: true, message, severity });

    const load = useCallback(async () => {
        if (chapterId == null) return;
        setLoading(true);
        try {
            const rows = await fetchSonaeTrainings(chapterId);
            setTrainings(Array.isArray(rows) ? rows : []);
        } catch (e) {
            notify(e instanceof Error ? e.message : '読み込みに失敗しました', 'error');
        } finally {
            setLoading(false);
        }
    }, [chapterId]);

    useEffect(() => {
        load();
    }, [load]);

    const dispatch = async () => {
        const trimmed = name.trim();
        if (trimmed === '') {
            notify('訓練名を入力してください', 'warning');
            return;
        }
        setBusy(true);
        try {
            const result = await dispatchSonaeTraining(chapterId, { name: trimmed });
            notify(`訓練を発報しました（送信 ${result.sent ?? 0} / 失敗 ${result.failed ?? 0}）`, 'success');
            setName('');
            await load();
        } catch (e) {
            notify(e instanceof Error ? e.message : '発報に失敗しました', 'error');
        } finally {
            setBusy(false);
        }
    };

    return (
        <Container maxWidth="lg" sx={{ py: 3 }}>
            <Typography variant="h5" gutterBottom>
                SONAE 訓練・集計
            </Typography>

            <Paper variant="outlined" sx={{ p: 2, mb: 3 }}>
                <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2} alignItems={{ sm: 'flex-end' }}>
                    <TextField
                        label="訓練名"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        fullWidth
                        placeholder="例: 2026年6月 安否確認訓練"
                    />
                    <Button variant="contained" disabled={busy} onClick={dispatch} sx={{ flexShrink: 0 }}>
                        訓練を発報
                    </Button>
                </Stack>
            </Paper>

            <TableContainer component={Paper} variant="outlined">
                <Table size="small">
                    <TableHead>
                        <TableRow>
                            <TableCell>訓練名</TableCell>
                            <TableCell>実施日時</TableCell>
                            <TableCell>回答率</TableCell>
                            <TableCell>前回比</TableCell>
                            <TableCell align="right">集計</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {loading ? (
                            <TableRow>
                                <TableCell colSpan={5}>読み込み中…</TableCell>
                            </TableRow>
                        ) : trainings.length === 0 ? (
                            <TableRow>
                                <TableCell colSpan={5}>訓練履歴がありません</TableCell>
                            </TableRow>
                        ) : (
                            trainings.map((t) => (
                                <TableRow key={t.id}>
                                    <TableCell>{t.name}</TableCell>
                                    <TableCell>
                                        {t.executed_at ? new Date(t.executed_at).toLocaleString('ja-JP') : '—'}
                                    </TableCell>
                                    <TableCell>{formatRate(t.response_rate)}</TableCell>
                                    <TableCell>
                                        {t.comparison?.delta != null
                                            ? `${t.comparison.delta > 0 ? '+' : ''}${Math.round(t.comparison.delta * 1000) / 10}pt`
                                            : '—'}
                                    </TableCell>
                                    <TableCell align="right">
                                        {t.notification_id ? (
                                            <Button
                                                size="small"
                                                onClick={() =>
                                                    setSummaryTarget({
                                                        notificationId: t.notification_id,
                                                    })
                                                }
                                            >
                                                詳細
                                            </Button>
                                        ) : null}
                                    </TableCell>
                                </TableRow>
                            ))
                        )}
                    </TableBody>
                </Table>
            </TableContainer>

            <SummaryDialog
                open={summaryTarget != null}
                onClose={() => setSummaryTarget(null)}
                chapterId={chapterId}
                notificationId={summaryTarget?.notificationId}
            />

            <Snackbar open={snack.open} autoHideDuration={6000} onClose={() => setSnack((s) => ({ ...s, open: false }))}>
                <Alert severity={snack.severity}>{snack.message}</Alert>
            </Snackbar>
        </Container>
    );
}
