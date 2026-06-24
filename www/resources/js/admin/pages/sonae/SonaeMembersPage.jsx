import React, { useCallback, useEffect, useState } from 'react';
import {
    Alert,
    Box,
    Button,
    Chip,
    Container,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Snackbar,
    Stack,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    Typography,
    Paper,
} from '@mui/material';
import { useSonaeChapter } from '../../sonae/SonaeChapterContext';
import {
    fetchSonaeMembers,
    fetchSonaeUnlinkedMembers,
    importSonaeCsv,
    issueSonaeLineInvite,
    syncSonaeMembers,
} from '../../sonae/sonaeApi';

export default function SonaeMembersPage() {
    const { chapterId, chapterDetail, refreshDetail } = useSonaeChapter();
    const [rows, setRows] = useState([]);
    const [meta, setMeta] = useState(null);
    const [loading, setLoading] = useState(true);
    const [showUnlinkedOnly, setShowUnlinkedOnly] = useState(false);
    const [busy, setBusy] = useState(false);
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'info' });
    const [inviteDialog, setInviteDialog] = useState(null);

    const notify = (message, severity = 'info') => setSnack({ open: true, message, severity });

    const load = useCallback(async () => {
        if (chapterId == null) return;
        setLoading(true);
        try {
            if (showUnlinkedOnly) {
                const unlinked = await fetchSonaeUnlinkedMembers(chapterId);
                setRows(unlinked);
                setMeta({ total: unlinked.length });
            } else {
                const res = await fetchSonaeMembers(chapterId, 1, 100);
                setRows(Array.isArray(res.data) ? res.data : []);
                setMeta(res.meta ?? null);
            }
        } catch (e) {
            notify(e instanceof Error ? e.message : '読み込みに失敗しました', 'error');
        } finally {
            setLoading(false);
        }
    }, [chapterId, showUnlinkedOnly]);

    useEffect(() => {
        load();
    }, [load]);

    const handleSync = async () => {
        setBusy(true);
        try {
            const result = await syncSonaeMembers(chapterId);
            notify(`同期完了: ${result.synced ?? 0} 件`, 'success');
            await refreshDetail();
            await load();
        } catch (e) {
            notify(e instanceof Error ? e.message : '同期に失敗しました', 'error');
        } finally {
            setBusy(false);
        }
    };

    const handleCsv = async (e) => {
        const file = e.target.files?.[0];
        e.target.value = '';
        if (!file) return;
        setBusy(true);
        try {
            const preview = await importSonaeCsv(chapterId, file, true);
            const valid = preview.valid_rows?.length ?? 0;
            const errors = preview.errors?.length ?? 0;
            if (valid === 0) {
                notify(`有効行がありません（エラー ${errors} 件）`, 'warning');
                return;
            }
            const result = await importSonaeCsv(chapterId, file, false);
            notify(`CSV 取込: ${result.imported ?? 0} 件`, 'success');
            await refreshDetail();
            await load();
        } catch (err) {
            notify(err instanceof Error ? err.message : 'CSV 取込に失敗しました', 'error');
        } finally {
            setBusy(false);
        }
    };

    const handleInvite = async (memberId) => {
        setBusy(true);
        try {
            const data = await issueSonaeLineInvite(chapterId, memberId);
            setInviteDialog(data);
        } catch (e) {
            notify(e instanceof Error ? e.message : '招待トークン発行に失敗しました', 'error');
        } finally {
            setBusy(false);
        }
    };

    const religoLinked = chapterDetail?.religo_linked;

    return (
        <Container maxWidth="lg" sx={{ py: 3 }}>
            <Stack direction="row" justifyContent="space-between" alignItems="center" sx={{ mb: 2 }}>
                <Typography variant="h5">SONAE メンバー</Typography>
                <Stack direction="row" spacing={1}>
                    <Button
                        variant={showUnlinkedOnly ? 'contained' : 'outlined'}
                        onClick={() => setShowUnlinkedOnly((v) => !v)}
                    >
                        未紐付けのみ
                    </Button>
                    {religoLinked ? (
                        <Button variant="outlined" disabled={busy} onClick={handleSync}>
                            Religo 同期
                        </Button>
                    ) : null}
                    <Button variant="outlined" component="label" disabled={busy}>
                        CSV 取込
                        <input type="file" accept=".csv,text/csv" hidden onChange={handleCsv} />
                    </Button>
                </Stack>
            </Stack>

            <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                通知対象は LINE 紐付け済み active メンバーのみです。
                {meta?.total != null ? ` 表示: ${rows.length} / ${meta.total}` : ''}
            </Typography>

            <TableContainer component={Paper} variant="outlined">
                <Table size="small">
                    <TableHead>
                        <TableRow>
                            <TableCell>名前</TableCell>
                            <TableCell>カテゴリ</TableCell>
                            <TableCell>LINE</TableCell>
                            <TableCell align="right">操作</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {loading ? (
                            <TableRow>
                                <TableCell colSpan={4}>読み込み中…</TableCell>
                            </TableRow>
                        ) : rows.length === 0 ? (
                            <TableRow>
                                <TableCell colSpan={4}>メンバーがありません</TableCell>
                            </TableRow>
                        ) : (
                            rows.map((m) => (
                                <TableRow key={m.id}>
                                    <TableCell>{m.name}</TableCell>
                                    <TableCell>{m.category ?? '—'}</TableCell>
                                    <TableCell>
                                        {m.line_linked ? (
                                            <Chip size="small" color="success" label="紐付け済" />
                                        ) : (
                                            <Chip size="small" label="未紐付け" />
                                        )}
                                    </TableCell>
                                    <TableCell align="right">
                                        {!m.line_linked ? (
                                            <Button size="small" disabled={busy} onClick={() => handleInvite(m.id)}>
                                                招待
                                            </Button>
                                        ) : null}
                                    </TableCell>
                                </TableRow>
                            ))
                        )}
                    </TableBody>
                </Table>
            </TableContainer>

            <Dialog open={inviteDialog != null} onClose={() => setInviteDialog(null)} maxWidth="sm" fullWidth>
                <DialogTitle>LINE 紐付け招待</DialogTitle>
                <DialogContent>
                    <Typography variant="body2" sx={{ mb: 2 }}>
                        メンバーが LINE で以下のメッセージを送信すると紐付けされます。
                    </Typography>
                    <Paper variant="outlined" sx={{ p: 2, fontFamily: 'monospace', whiteSpace: 'pre-wrap' }}>
                        {inviteDialog?.link_message}
                    </Paper>
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setInviteDialog(null)}>閉じる</Button>
                </DialogActions>
            </Dialog>

            <Snackbar open={snack.open} autoHideDuration={5000} onClose={() => setSnack((s) => ({ ...s, open: false }))}>
                <Alert severity={snack.severity} onClose={() => setSnack((s) => ({ ...s, open: false }))}>
                    {snack.message}
                </Alert>
            </Snackbar>
        </Container>
    );
}
