import React, { useEffect, useState } from 'react';
import { Link as RouterLink } from 'react-router-dom';
import {
    Alert,
    Box,
    Button,
    Card,
    CardContent,
    Container,
    Grid,
    Snackbar,
    Stack,
    Typography,
} from '@mui/material';
import { useSonaeChapter } from '../../sonae/SonaeChapterContext';
import { fetchSonaeTrainings, formatRate } from '../../sonae/sonaeApi';

function KpiCard({ label, value, sub }) {
    return (
        <Card variant="outlined">
            <CardContent>
                <Typography variant="body2" color="text.secondary">
                    {label}
                </Typography>
                <Typography variant="h4" sx={{ mt: 0.5 }}>
                    {value}
                </Typography>
                {sub ? (
                    <Typography variant="caption" color="text.secondary">
                        {sub}
                    </Typography>
                ) : null}
            </CardContent>
        </Card>
    );
}

export default function SonaeDashboard() {
    const { chapterMeta, chapterDetail, syncing, syncFromReligo } = useSonaeChapter();
    const [trainings, setTrainings] = useState([]);
    const [trainingsError, setTrainingsError] = useState(null);
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'info' });

    const chapterId = chapterDetail?.id ?? chapterMeta?.id;
    const kpi = chapterDetail?.kpi;
    const religoLinked = chapterDetail?.religo_linked;

    useEffect(() => {
        if (chapterId == null) return;
        let cancelled = false;
        (async () => {
            try {
                const rows = await fetchSonaeTrainings(chapterId);
                if (!cancelled) {
                    setTrainings(Array.isArray(rows) ? rows.slice(0, 3) : []);
                    setTrainingsError(null);
                }
            } catch (e) {
                if (!cancelled) {
                    setTrainings([]);
                    setTrainingsError(e instanceof Error ? e.message : '訓練履歴の取得に失敗しました');
                }
            }
        })();
        return () => {
            cancelled = true;
        };
    }, [chapterId]);

    return (
        <Container maxWidth="lg" sx={{ py: 3 }}>
            <Stack direction="row" justifyContent="space-between" alignItems="center" sx={{ mb: 3 }}>
                <Box>
                    <Typography variant="h5">SONAE ダッシュボード</Typography>
                    <Typography variant="body2" color="text.secondary">
                        {chapterDetail?.name ?? chapterMeta?.name}
                    </Typography>
                </Box>
                <Stack direction="row" spacing={1}>
                    {religoLinked ? (
                        <Button
                            variant="outlined"
                            disabled={syncing}
                            onClick={async () => {
                                try {
                                    const result = await syncFromReligo();
                                    setSnack({
                                        open: true,
                                        message: `Religo 同期完了: ${result?.synced ?? 0} 件`,
                                        severity: 'success',
                                    });
                                } catch (e) {
                                    setSnack({
                                        open: true,
                                        message: e instanceof Error ? e.message : '同期に失敗しました',
                                        severity: 'error',
                                    });
                                }
                            }}
                        >
                            Religo 同期
                        </Button>
                    ) : null}
                    <Button component={RouterLink} to="/sonae/training" variant="contained">
                        訓練を発報
                    </Button>
                    <Button component={RouterLink} to="/sonae/members" variant="outlined">
                        メンバー
                    </Button>
                </Stack>
            </Stack>

            {kpi ? (
                <Grid container spacing={2} sx={{ mb: 3 }}>
                    <Grid item xs={12} sm={6} md={3}>
                        <KpiCard label="名簿（active）" value={kpi.roster_count} />
                    </Grid>
                    <Grid item xs={12} sm={6} md={3}>
                        <KpiCard label="LINE 紐付け済み" value={kpi.linked_count} />
                    </Grid>
                    <Grid item xs={12} sm={6} md={3}>
                        <KpiCard label="未紐付け" value={kpi.unlinked_count} sub="訓練前に要対応" />
                    </Grid>
                    <Grid item xs={12} sm={6} md={3}>
                        <KpiCard label="紐付け率" value={formatRate(kpi.link_rate)} />
                    </Grid>
                </Grid>
            ) : null}

            <Card variant="outlined">
                <CardContent>
                    <Typography variant="h6" gutterBottom>
                        直近の訓練
                    </Typography>
                    {trainingsError ? <Alert severity="error">{trainingsError}</Alert> : null}
                    {trainings.length === 0 && !trainingsError ? (
                        <Typography variant="body2" color="text.secondary">
                            訓練履歴がありません。「訓練を発報」から手動訓練を実行してください。
                        </Typography>
                    ) : (
                        <Stack spacing={1}>
                            {trainings.map((t) => (
                                <Box
                                    key={t.id}
                                    sx={{
                                        display: 'flex',
                                        justifyContent: 'space-between',
                                        py: 1,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    <Box>
                                        <Typography variant="body1">{t.name}</Typography>
                                        <Typography variant="caption" color="text.secondary">
                                            {t.executed_at ? new Date(t.executed_at).toLocaleString('ja-JP') : '—'}
                                        </Typography>
                                    </Box>
                                    <Typography variant="body1">{formatRate(t.response_rate)}</Typography>
                                </Box>
                            ))}
                        </Stack>
                    )}
                    <Button component={RouterLink} to="/sonae/training" sx={{ mt: 2 }}>
                        訓練・集計を見る
                    </Button>
                </CardContent>
            </Card>

            <Snackbar open={snack.open} autoHideDuration={5000} onClose={() => setSnack((s) => ({ ...s, open: false }))}>
                <Alert severity={snack.severity}>{snack.message}</Alert>
            </Snackbar>
        </Container>
    );
}
