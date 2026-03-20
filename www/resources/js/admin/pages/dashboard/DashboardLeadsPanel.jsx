import React from 'react';
import { Box, Card, CardContent, Typography, Button, Chip, Skeleton } from '@mui/material';
import { Link } from 'react-router-dom';
import {
    religoOneToOneLeadStatusLabel,
    RELIGO_DASHBOARD_LEADS_TITLE,
    RELIGO_DASHBOARD_LEADS_HELPER,
    RELIGO_DASHBOARD_LEADS_EMPTY,
    RELIGO_ONE_TO_ONE_LEAD_LAST_DATE_PREFIX,
    RELIGO_ONE_TO_ONE_LEAD_NO_COMPLETED,
    DASHBOARD_LEADS_DISPLAY_LIMIT,
} from '../../religoOneToOneLeadLabels';
import { DASHBOARD_CARD_SX } from './dashboardConstants';

/**
 * 次の 1 to 1 候補（P5/P6）。右サイド補助。オーナー未設定時は説明のみ。
 */
export default function DashboardLeadsPanel({ hasOwner, oneToOneLeads, loading }) {
    return (
        <Card
            variant="outlined"
            sx={{
                ...DASHBOARD_CARD_SX,
                borderColor: 'divider',
                alignSelf: { md: 'flex-start' },
                position: { md: 'sticky' },
                top: { md: 16 },
            }}
        >
            <CardContent>
                <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 0.25 }}>{RELIGO_DASHBOARD_LEADS_TITLE}</Typography>
                <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.25 }}>
                    {RELIGO_DASHBOARD_LEADS_HELPER}
                </Typography>

                {!hasOwner ? (
                    <Typography variant="body2" color="text.secondary" sx={{ py: 0.5 }}>
                        オーナーを設定すると、各メンバーとの 1 to 1 状況がここに表示されます。
                    </Typography>
                ) : loading ? (
                    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1, py: 0.5 }}>
                        <Skeleton variant="text" width="60%" height={20} />
                        <Skeleton variant="rounded" height={72} sx={{ borderRadius: 1 }} />
                        <Skeleton variant="rounded" height={72} sx={{ borderRadius: 1 }} />
                    </Box>
                ) : oneToOneLeads.length === 0 ? (
                    <Typography variant="body2" color="text.secondary" sx={{ py: 0.5 }}>
                        {RELIGO_DASHBOARD_LEADS_EMPTY}
                    </Typography>
                ) : (
                    <Box
                        sx={{
                            display: 'flex',
                            flexDirection: 'column',
                            gap: 0.75,
                            maxHeight: { md: 'min(480px, calc(100vh - 220px))' },
                            overflowY: 'auto',
                            pr: 0.5,
                        }}
                    >
                        {oneToOneLeads.slice(0, DASHBOARD_LEADS_DISPLAY_LIMIT).map((row) => {
                            const chipColor =
                                row.one_to_one_status === 'needs_action'
                                    ? 'warning'
                                    : row.one_to_one_status === 'ok'
                                      ? 'success'
                                      : 'default';
                            return (
                                <Box
                                    key={row.member_id}
                                    sx={{
                                        display: 'flex',
                                        flexDirection: 'column',
                                        alignItems: 'stretch',
                                        gap: 0.75,
                                        py: 1,
                                        px: 1.25,
                                        borderRadius: 1,
                                        bgcolor: row.want_1on1 ? 'secondary.light' : 'grey.50',
                                        borderLeft: row.want_1on1 ? 3 : 0,
                                        borderColor: 'secondary.main',
                                    }}
                                >
                                    <Box sx={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: 0.75 }}>
                                        <Typography sx={{ fontSize: 13, fontWeight: 600, flex: '1 1 120px', minWidth: 0 }}>
                                            {row.want_1on1 ? '★ ' : ''}
                                            {row.name}
                                        </Typography>
                                        <Chip
                                            size="small"
                                            label={religoOneToOneLeadStatusLabel(row.one_to_one_status)}
                                            color={chipColor}
                                            sx={{ height: 24 }}
                                        />
                                    </Box>
                                    <Typography variant="caption" color="text.secondary" sx={{ display: 'block' }}>
                                        {row.last_one_to_one_at
                                            ? `${RELIGO_ONE_TO_ONE_LEAD_LAST_DATE_PREFIX} ${row.last_one_to_one_at}`
                                            : RELIGO_ONE_TO_ONE_LEAD_NO_COMPLETED}
                                    </Typography>
                                    <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.75, alignItems: 'center' }}>
                                        {row.want_1on1 && (
                                            <Chip
                                                size="small"
                                                label="want 1on1"
                                                color="secondary"
                                                variant="outlined"
                                                sx={{ height: 22 }}
                                            />
                                        )}
                                        <Button
                                            component={Link}
                                            size="small"
                                            variant="contained"
                                            color="secondary"
                                            to={`/one-to-ones/create?target_member_id=${row.member_id}`}
                                            sx={{ flexShrink: 0 }}
                                        >
                                            1to1作成
                                        </Button>
                                    </Box>
                                </Box>
                            );
                        })}
                    </Box>
                )}
            </CardContent>
        </Card>
    );
}
