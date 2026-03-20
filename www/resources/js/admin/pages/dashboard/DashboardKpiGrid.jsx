import React from 'react';
import { Box, Card, CardContent, Typography } from '@mui/material';
import { STATS_DEFAULT, DASHBOARD_CARD_SX } from './dashboardConstants';

/**
 * KPI 4 枚。`stats.subtexts` は P7-2 で API 差し替え前提。ここでは表示のみ。
 */
export default function DashboardKpiGrid({ stats }) {
    const subtexts = stats.subtexts || STATS_DEFAULT.subtexts;

    const items = [
        {
            key: 'stale',
            icon: '⚠️',
            iconBg: '#ffebee',
            label: '未接触（30日以上）',
            value: stats.stale_contacts_count,
            valueColor: 'warning.main',
            sub: subtexts.stale,
        },
        {
            key: 'o2o',
            icon: '🤝',
            iconBg: 'primary.light',
            iconColor: 'primary.contrastText',
            label: '今月の1to1回数',
            value: stats.monthly_one_to_one_count,
            sub: subtexts.one_to_one,
        },
        {
            key: 'intro',
            icon: '📝',
            iconBg: 'success.light',
            iconColor: 'success.contrastText',
            label: '紹介メモ数（今月）',
            value: stats.monthly_intro_memo_count,
            sub: subtexts.intro,
        },
        {
            key: 'meeting',
            icon: '📋',
            iconBg: 'secondary.light',
            iconColor: 'secondary.contrastText',
            label: '例会メモ数（今月）',
            value: stats.monthly_meeting_memo_count,
            sub: subtexts.meeting,
        },
    ];

    return (
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
            {items.map((it) => (
                <Card key={it.key} variant="outlined" sx={DASHBOARD_CARD_SX}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box
                            sx={{
                                width: 40,
                                height: 40,
                                borderRadius: 1,
                                bgcolor: it.iconBg,
                                color: it.iconColor,
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                fontSize: 18,
                            }}
                        >
                            {it.icon}
                        </Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>
                                {it.label}
                            </Typography>
                            <Typography
                                sx={{
                                    fontSize: 20,
                                    fontWeight: 700,
                                    ...(it.valueColor ? { color: it.valueColor } : {}),
                                }}
                            >
                                {it.value}
                            </Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>
                                {it.sub}
                            </Typography>
                        </Box>
                    </CardContent>
                </Card>
            ))}
        </Box>
    );
}
