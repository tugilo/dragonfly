import React from 'react';
import {
    Box,
    Card,
    CardContent,
    Container,
    Grid,
    Stack,
    Typography,
    Button,
    Chip,
} from '@mui/material';
import { Link } from 'react-router-dom';

/**
 * Religo Dashboard. SSOT: religo-admin-mock.html (pg-dashboard)
 * 今日の活動・未アクション・KPI とクイックショートカット。
 */
export default function Dashboard() {
    return (
        <Container maxWidth="lg" sx={{ py: 2 }}>
            <Stack direction={{ xs: 'column', sm: 'row' }} justifyContent="space-between" alignItems="flex-start" spacing={2} sx={{ mb: 2 }}>
                <Box>
                    <Typography variant="h5" fontWeight={700}>Dashboard</Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                        今日の活動・未アクション・KPI
                    </Typography>
                    <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mt: 0.5 }}>
                        表示は静的です（実データ連携は今後の Phase で対応）
                    </Typography>
                </Box>
                <Stack direction="row" spacing={1} flexWrap="wrap">
                    <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connectionsへ</Button>
                    <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">＋ 1to1追加</Button>
                </Stack>
            </Stack>

            <Grid container spacing={1.5} sx={{ mb: 2 }}>
                <Grid item xs={12} sm={6} md={3}>
                    <Card variant="outlined" sx={{ height: '100%' }}>
                        <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                            <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'error.light', color: 'error.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>⚠️</Box>
                            <Box>
                                <Typography variant="caption" color="text.secondary" fontWeight={600}>未接触（30日以上）</Typography>
                                <Typography variant="h6" fontWeight={700} color="warning.main">4</Typography>
                                <Typography variant="caption" color="text.secondary">要フォロー</Typography>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <Card variant="outlined" sx={{ height: '100%' }}>
                        <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                            <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'primary.light', color: 'primary.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>🤝</Box>
                            <Box>
                                <Typography variant="caption" color="text.secondary" fontWeight={600}>今月の1to1回数</Typography>
                                <Typography variant="h6" fontWeight={700}>7</Typography>
                                <Typography variant="caption" color="text.secondary">先月比 +2</Typography>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <Card variant="outlined" sx={{ height: '100%' }}>
                        <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                            <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'success.light', color: 'success.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>📝</Box>
                            <Box>
                                <Typography variant="caption" color="text.secondary" fontWeight={600}>紹介メモ数（今月）</Typography>
                                <Typography variant="h6" fontWeight={700}>12</Typography>
                                <Typography variant="caption" color="text.secondary">BO含む</Typography>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <Card variant="outlined" sx={{ height: '100%' }}>
                        <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                            <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'secondary.light', color: 'secondary.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>📋</Box>
                            <Box>
                                <Typography variant="caption" color="text.secondary" fontWeight={600}>例会メモ数（今月）</Typography>
                                <Typography variant="h6" fontWeight={700}>31</Typography>
                                <Typography variant="caption" color="text.secondary">例会#247 含む</Typography>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>

            <Grid container spacing={2}>
                <Grid item xs={12} md={8}>
                    <Card variant="outlined" sx={{ mb: 2 }}>
                        <CardContent>
                            <Typography variant="subtitle1" fontWeight={700} sx={{ mb: 1.5 }}>⚡ 今日やること（Tasks）</Typography>
                            <Stack spacing={1}>
                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, p: 1.5, bgcolor: 'warning.light', borderRadius: 1, borderLeft: 3, borderColor: 'warning.main' }}>
                                    <span>⏰</span>
                                    <Box flex={1}>
                                        <Typography variant="body2" fontWeight={600} color="warning.dark">伊藤 勇樹</Typography>
                                        <Typography variant="caption" color="text.secondary">55日間未接触 — 1to1を検討</Typography>
                                    </Box>
                                    <Button size="small" variant="outlined" color="warning" component={Link} to="/connections">1to1予定</Button>
                                </Box>
                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, p: 1.5, bgcolor: 'primary.light', borderRadius: 1, borderLeft: 3, borderColor: 'primary.main' }}>
                                    <span>📅</span>
                                    <Box flex={1}>
                                        <Typography variant="body2" fontWeight={600}>田中 誠一 との1to1</Typography>
                                        <Typography variant="caption" color="text.secondary">本日 12:00 — CRM導入フォロー</Typography>
                                    </Box>
                                    <Chip label="予定" size="small" color="warning" variant="outlined" />
                                </Box>
                            </Stack>
                        </CardContent>
                    </Card>
                    <Card variant="outlined">
                        <CardContent>
                            <Typography variant="subtitle1" fontWeight={700} sx={{ mb: 1.5 }}>🔗 クイックショートカット</Typography>
                            <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap>
                                <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connections（会の地図）</Button>
                                <Button component={Link} to="/members" variant="outlined" size="small">👥 Members一覧</Button>
                                <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">＋ 1to1を追加</Button>
                                <Button component={Link} to="/meetings" variant="outlined" size="small" color="inherit">📋 例会一覧</Button>
                            </Stack>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} md={4}>
                    <Card variant="outlined">
                        <CardContent>
                            <Typography variant="subtitle1" fontWeight={700} sx={{ mb: 1.5 }}>🕐 最近の活動</Typography>
                            <Stack spacing={0} divider={<Box sx={{ borderBottom: 1, borderColor: 'divider' }} />}>
                                <Box sx={{ display: 'flex', gap: 1.5, py: 1.25 }}>
                                    <Box sx={{ width: 28, height: 28, borderRadius: '50%', bgcolor: 'grey.200', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 13 }}>✏️</Box>
                                    <Box>
                                        <Typography variant="body2" fontWeight={500}>佐藤 美咲 にメモ追加</Typography>
                                        <Typography variant="caption" color="text.secondary">セミナー案件・1to1メモ — 2分前</Typography>
                                    </Box>
                                </Box>
                                <Box sx={{ display: 'flex', gap: 1.5, py: 1.25 }}>
                                    <Box sx={{ width: 28, height: 28, borderRadius: '50%', bgcolor: 'grey.200', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 13 }}>📅</Box>
                                    <Box>
                                        <Typography variant="body2" fontWeight={500}>田中 誠一 1to1を登録</Typography>
                                        <Typography variant="caption" color="text.secondary">planned — 本日 12:00 — 3時間前</Typography>
                                    </Box>
                                </Box>
                                <Box sx={{ display: 'flex', gap: 1.5, py: 1.25 }}>
                                    <Box sx={{ width: 28, height: 28, borderRadius: '50%', bgcolor: 'grey.200', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 13 }}>📋</Box>
                                    <Box>
                                        <Typography variant="body2" fontWeight={500}>例会 #247 BO割当を保存</Typography>
                                        <Typography variant="caption" color="text.secondary">BO4件 — 2025-07-08 — 昨日</Typography>
                                    </Box>
                                </Box>
                            </Stack>
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>
        </Container>
    );
}
