import React from 'react';
import { Box, Card, CardContent, Typography } from '@mui/material';
import { ACTIVITY_ICONS, DASHBOARD_CARD_SX } from './dashboardConstants';

/** 最近の活動。データは親が供給（contact_memos / one_to_ones 混在）。P7-2 で kind 拡張しやすい。 */
export default function DashboardActivityPanel({ items }) {
    return (
        <Card variant="outlined" sx={DASHBOARD_CARD_SX}>
            <CardContent>
                <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 0.25 }}>🕐 最近の活動</Typography>
                <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.25 }}>
                    メモ・1 to 1・つながりフラグの更新を新しい順に表示しています。
                </Typography>
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
            </CardContent>
        </Card>
    );
}
