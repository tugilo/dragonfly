import React from 'react';
import InfoOutlinedIcon from '@mui/icons-material/InfoOutlined';
import { Box, Card, CardContent, Typography, Skeleton } from '@mui/material';
import { ACTIVITY_ICONS, DASHBOARD_CARD_SX, DASHBOARD_MSG } from './dashboardConstants';

/** 最近の活動。P7-3: ローディング・オーナー未設定・空を区別。 */
export default function DashboardActivityPanel({ items, loading, ownerConfigured }) {
    return (
        <Card variant="outlined" sx={DASHBOARD_CARD_SX}>
            <CardContent>
                <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 0.25 }}>🕐 最近の活動</Typography>
                <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.25 }}>
                    メモ・1 to 1・つながりフラグの更新を新しい順に表示しています。
                </Typography>
                {loading ? (
                    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                        {[1, 2, 3, 4].map((k) => (
                            <Box key={k} sx={{ display: 'flex', gap: 1.5, py: 1.25 }}>
                                <Skeleton variant="circular" width={28} height={28} />
                                <Box sx={{ flex: 1 }}>
                                    <Skeleton variant="text" width="75%" height={18} />
                                    <Skeleton variant="text" width="50%" height={14} />
                                </Box>
                            </Box>
                        ))}
                    </Box>
                ) : !ownerConfigured ? (
                    <Box sx={{ display: 'flex', alignItems: 'flex-start', gap: 1, py: 0.5 }}>
                        <InfoOutlinedIcon color="action" sx={{ fontSize: 20, mt: 0.25 }} />
                        <Typography variant="body2" color="text.secondary">
                            {DASHBOARD_MSG.ACTIVITY_NEED_OWNER}
                        </Typography>
                    </Box>
                ) : items.length === 0 ? (
                    <Box sx={{ display: 'flex', alignItems: 'flex-start', gap: 1, py: 0.5 }}>
                        <InfoOutlinedIcon color="action" sx={{ fontSize: 20, mt: 0.25 }} />
                        <Typography variant="body2" color="text.secondary">
                            {DASHBOARD_MSG.ACTIVITY_EMPTY}
                        </Typography>
                    </Box>
                ) : (
                    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                        {items.map((item, i) => (
                            <Box
                                key={item.id || i}
                                sx={{
                                    display: 'flex',
                                    gap: 1.5,
                                    py: 1.25,
                                    borderBottom: i < items.length - 1 ? '1px solid #f5f5f5' : 'none',
                                }}
                            >
                                <Box
                                    sx={{
                                        width: 28,
                                        height: 28,
                                        borderRadius: '50%',
                                        bgcolor: 'grey.200',
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        fontSize: 13,
                                        flexShrink: 0,
                                    }}
                                >
                                    {ACTIVITY_ICONS[item.kind] || '✏️'}
                                </Box>
                                <Box sx={{ minWidth: 0 }}>
                                    <Typography sx={{ fontSize: 13, fontWeight: 600 }}>{item.title}</Typography>
                                    <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>
                                        {item.meta || ''}
                                    </Typography>
                                </Box>
                            </Box>
                        ))}
                    </Box>
                )}
            </CardContent>
        </Card>
    );
}
