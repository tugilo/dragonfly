import React from 'react';
import InfoOutlinedIcon from '@mui/icons-material/InfoOutlined';
import { Box, Card, CardContent, Typography, Skeleton } from '@mui/material';
import { STATS_DEFAULT, DASHBOARD_CARD_SX, DASHBOARD_MSG } from './dashboardConstants';

/**
 * KPI 4 枚。P7-3: ローディング Skeleton・オーナー未設定・API 失敗を区別。
 */
export default function DashboardKpiGrid({ stats, loading, ownerConfigured }) {
    if (loading) {
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
                {[1, 2, 3, 4].map((k) => (
                    <Card key={k} variant="outlined" sx={DASHBOARD_CARD_SX}>
                        <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                            <Skeleton variant="rounded" width={40} height={40} />
                            <Box sx={{ flex: 1 }}>
                                <Skeleton variant="text" width="70%" height={14} sx={{ mb: 0.5 }} />
                                <Skeleton variant="text" width={48} height={28} sx={{ mb: 0.5 }} />
                                <Skeleton variant="text" width="90%" height={12} />
                            </Box>
                        </CardContent>
                    </Card>
                ))}
            </Box>
        );
    }

    if (!ownerConfigured) {
        return (
            <Card variant="outlined" sx={{ ...DASHBOARD_CARD_SX, mb: 2, bgcolor: 'grey.50' }}>
                <CardContent sx={{ display: 'flex', alignItems: 'flex-start', gap: 1 }}>
                    <InfoOutlinedIcon color="action" sx={{ fontSize: 20, mt: 0.25 }} />
                    <Typography variant="body2" color="text.secondary">
                        {DASHBOARD_MSG.KPI_NEED_OWNER}
                    </Typography>
                </CardContent>
            </Card>
        );
    }

    if (stats == null) {
        return (
            <Card variant="outlined" sx={{ ...DASHBOARD_CARD_SX, mb: 2, borderColor: 'warning.light' }}>
                <CardContent sx={{ display: 'flex', alignItems: 'flex-start', gap: 1 }}>
                    <InfoOutlinedIcon color="warning" sx={{ fontSize: 20, mt: 0.25 }} />
                    <Typography variant="body2" color="text.secondary">
                        {DASHBOARD_MSG.KPI_LOAD_ERROR}
                    </Typography>
                </CardContent>
            </Card>
        );
    }

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
