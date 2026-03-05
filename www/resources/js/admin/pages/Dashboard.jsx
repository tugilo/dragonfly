import React from 'react';
import {
    Box,
    Card,
    CardContent,
    Container,
    Typography,
    Button,
    Chip,
} from '@mui/material';
import { Link } from 'react-router-dom';

/**
 * Religo Dashboard. SSOT: docs/SSOT/DASHBOARD_REQUIREMENTS.md, モック #pg-dashboard（行327〜384）
 * 静的表示でモック一致。値は PLAN 固定（3/5/8/4）。Tasks 4件、Activity 6件。
 */
export default function Dashboard() {
    return (
        <Container maxWidth="lg" sx={{ py: 0 }}>
            {/* Step1: ページヘッダー — 要件 §3.1 */}
            <Box
                sx={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    justifyContent: 'space-between',
                    flexWrap: 'wrap',
                    gap: 2,
                    mb: 2.25,
                }}
            >
                <Box>
                    <Typography component="h1" sx={{ fontSize: 21, fontWeight: 700, letterSpacing: -0.3 }}>
                        Dashboard
                    </Typography>
                    <Typography sx={{ fontSize: 12, color: 'text.secondary', mt: 0.375 }}>
                        今日の活動・未アクション・KPI
                    </Typography>
                </Box>
                <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', alignItems: 'center' }}>
                    <Button component={Link} to="/connections" variant="contained" size="small">
                        🗺 Connectionsへ
                    </Button>
                    <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">
                        ＋ 1to1追加
                    </Button>
                </Box>
            </Box>

            {/* Step2: 統計カード — 要件 §3.2、PLAN §7 ダミー値 3/5/8/4 */}
            <Box
                sx={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(4, 1fr)',
                    gap: 1.5,
                    mb: 2,
                    '@media (max-width: 900px)': { gridTemplateColumns: 'repeat(2, 1fr)' },
                    '@media (max-width: 600px)': { gridTemplateColumns: '1fr' },
                }}
            >
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: '#ffebee', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>
                            ⚠️
                        </Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>
                                未接触（30日以上）
                            </Typography>
                            <Typography sx={{ fontSize: 20, fontWeight: 700, color: 'warning.main' }}>3</Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>要フォロー</Typography>
                        </Box>
                    </CardContent>
                </Card>
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'primary.light', color: 'primary.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>
                            🤝
                        </Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>
                                今月の1to1回数
                            </Typography>
                            <Typography sx={{ fontSize: 20, fontWeight: 700 }}>5</Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>先月比 +2</Typography>
                        </Box>
                    </CardContent>
                </Card>
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'success.light', color: 'success.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>
                            📝
                        </Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>
                                紹介メモ数（今月）
                            </Typography>
                            <Typography sx={{ fontSize: 20, fontWeight: 700 }}>8</Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>BO含む</Typography>
                        </Box>
                    </CardContent>
                </Card>
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'secondary.light', color: 'secondary.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>
                            📋
                        </Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>
                                例会メモ数（今月）
                            </Typography>
                            <Typography sx={{ fontSize: 20, fontWeight: 700 }}>4</Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>例会#247 含む</Typography>
                        </Box>
                    </CardContent>
                </Card>
            </Box>

            {/* Step3: 2カラム 1fr / 340px, gap 14px, 1100px以下で1列 — 要件 §4 */}
            <Box
                sx={{
                    display: 'grid',
                    gridTemplateColumns: '1fr 340px',
                    gap: 1.75,
                    '@media (max-width: 1100px)': { gridTemplateColumns: '1fr' },
                }}
            >
                <Box>
                    {/* Step4: 今日やること 4件 — 要件 §3.3 */}
                    <Card variant="outlined" sx={{ mb: 1.75, boxShadow: 1 }}>
                        <CardContent>
                            <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 1.25 }}>⚡ 今日やること（Tasks）</Typography>
                            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.25, py: 1.125, px: 1.5, bgcolor: '#fff3e0', borderRadius: 1, borderLeft: 3, borderColor: 'warning.main' }}>
                                    <span style={{ fontSize: 16 }}>⏰</span>
                                    <Box sx={{ flex: 1 }}>
                                        <Typography sx={{ fontSize: 13, fontWeight: 600, color: '#bf360c' }}>伊藤 勇樹</Typography>
                                        <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>55日間未接触 — 1to1を検討</Typography>
                                    </Box>
                                    <Button size="small" variant="outlined" color="warning" component={Link} to="/one-to-ones/create">1to1予定</Button>
                                </Box>
                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.25, py: 1.125, px: 1.5, bgcolor: '#fff3e0', borderRadius: 1, borderLeft: 3, borderColor: 'warning.main' }}>
                                    <span style={{ fontSize: 16 }}>⏰</span>
                                    <Box sx={{ flex: 1 }}>
                                        <Typography sx={{ fontSize: 13, fontWeight: 600, color: '#bf360c' }}>水野 花菜</Typography>
                                        <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>66日間未接触 — フォローアップ要</Typography>
                                    </Box>
                                    <Button size="small" variant="outlined" color="warning" disabled>メモ追加</Button>
                                </Box>
                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.25, py: 1.125, px: 1.5, bgcolor: 'primary.light', borderRadius: 1, borderLeft: 3, borderColor: 'primary.main' }}>
                                    <span style={{ fontSize: 16 }}>📅</span>
                                    <Box sx={{ flex: 1 }}>
                                        <Typography sx={{ fontSize: 13, fontWeight: 600 }}>田中 誠一 との1to1</Typography>
                                        <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>本日 12:00 — CRM導入フォロー</Typography>
                                    </Box>
                                    <Chip label="予定" size="small" sx={{ bgcolor: '#fff3e0', color: '#e65100', border: '1px solid #ffcc80' }} />
                                </Box>
                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.25, py: 1.125, px: 1.5, bgcolor: '#f8f9fa', borderRadius: 1, borderLeft: 3, borderColor: '#ccc' }}>
                                    <span style={{ fontSize: 16 }}>📝</span>
                                    <Box sx={{ flex: 1 }}>
                                        <Typography sx={{ fontSize: 13, fontWeight: 600 }}>例会 #248 メモ未整理</Typography>
                                        <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>次回例会まであと5日</Typography>
                                    </Box>
                                    <Button size="small" variant="outlined" color="inherit" component={Link} to="/meetings">Meetingsへ</Button>
                                </Box>
                            </Box>
                        </CardContent>
                    </Card>

                    {/* Step5: クイックショートカット — 要件 §3.4 */}
                    <Card variant="outlined" sx={{ boxShadow: 1 }}>
                        <CardContent>
                            <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 1.25 }}>🔗 クイックショートカット</Typography>
                            <Box sx={{ display: 'flex', gap: 1.25, flexWrap: 'wrap' }}>
                                <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connections（会の地図）</Button>
                                <Button component={Link} to="/members" variant="outlined" size="small">👥 Members一覧</Button>
                                <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">＋ 1to1を追加</Button>
                                <Button component={Link} to="/meetings" variant="outlined" size="small" color="inherit">📋 例会一覧</Button>
                            </Box>
                        </CardContent>
                    </Card>
                </Box>

                {/* Step6: 最近の活動 6件 — 要件 §3.5 */}
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent>
                        <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 1.25 }}>🕐 最近の活動</Typography>
                        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                            {[
                                { icon: '✏️', title: '佐藤 美咲 にメモ追加', meta: 'セミナー案件・1to1メモ — 2分前' },
                                { icon: '📅', title: '田中 誠一 1to1を登録', meta: 'planned — 本日 12:00 — 3時間前' },
                                { icon: '📋', title: '例会 #247 BO割当を保存', meta: 'BO4件 — 2025-07-08 — 昨日' },
                                { icon: '🤝', title: '渡辺 彩香 1to1完了', meta: 'DX案件ヒアリング — 2025-07-09' },
                                { icon: '⭐', title: '森 友美 に interested フラグ', meta: 'スポーツ施術コラボ検討 — 2025-07-06' },
                                { icon: '✏️', title: '小林 陽子 にメモ追加', meta: '投資物件の情報提供依頼 — 2025-07-05' },
                            ].map((item, i) => (
                                <Box
                                    key={i}
                                    sx={{
                                        display: 'flex',
                                        gap: 1.5,
                                        py: 1.25,
                                        borderBottom: i < 5 ? '1px solid #f5f5f5' : 'none',
                                    }}
                                >
                                    <Box sx={{ width: 28, height: 28, borderRadius: '50%', bgcolor: 'grey.200', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 13, flexShrink: 0 }}>
                                        {item.icon}
                                    </Box>
                                    <Box sx={{ minWidth: 0 }}>
                                        <Typography sx={{ fontSize: 13, fontWeight: 600 }}>{item.title}</Typography>
                                        <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>{item.meta}</Typography>
                                    </Box>
                                </Box>
                            ))}
                        </Box>
                    </CardContent>
                </Card>
            </Box>
        </Container>
    );
}
