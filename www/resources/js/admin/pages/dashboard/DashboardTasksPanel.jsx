import React from 'react';
import InfoOutlinedIcon from '@mui/icons-material/InfoOutlined';
import { Box, Card, CardContent, Typography, Button, Chip, Tooltip, Skeleton } from '@mui/material';
import { Link } from 'react-router-dom';
import { DASHBOARD_CARD_SX, DASHBOARD_MSG } from './dashboardConstants';

/**
 * 優先アクション（Tasks）。P7-3: ローディング・オーナー未設定・空リストを区別。
 * DASHBOARD-TASKS-ALIGNMENT-P1: 「今日」限定ではなく owner にとっての優先行動のリスト（SSOT 参照）。
 */
export default function DashboardTasksPanel({ tasks, loading, ownerConfigured }) {
    return (
        <Card variant="outlined" sx={{ ...DASHBOARD_CARD_SX, mb: 1.75 }}>
            <CardContent>
                <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 0.25 }}>⚡ 優先アクション（Tasks）</Typography>
                <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.25 }}>
                    厳密には「今日の ToDo」ではなく、未接触フォロー・予定 1 to 1・次回/直近例会への動きなど、いま優先して進めるとよい行動です。
                </Typography>
                {loading ? (
                    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                        {[1, 2, 3].map((k) => (
                            <Skeleton key={k} variant="rounded" height={56} sx={{ borderRadius: 1 }} />
                        ))}
                    </Box>
                ) : !ownerConfigured ? (
                    <Box sx={{ display: 'flex', alignItems: 'flex-start', gap: 1, py: 0.5 }}>
                        <InfoOutlinedIcon color="action" sx={{ fontSize: 20, mt: 0.25 }} />
                        <Typography variant="body2" color="text.secondary">
                            {DASHBOARD_MSG.TASKS_NEED_OWNER}
                        </Typography>
                    </Box>
                ) : tasks.length === 0 ? (
                    <Box sx={{ display: 'flex', alignItems: 'flex-start', gap: 1, py: 0.5 }}>
                        <InfoOutlinedIcon color="action" sx={{ fontSize: 20, mt: 0.25 }} />
                        <Typography variant="body2" color="text.secondary">
                            {DASHBOARD_MSG.TASKS_EMPTY}
                        </Typography>
                    </Box>
                ) : (
                    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                        {tasks.map((task) => {
                            const isStale = task.kind === 'stale_follow';
                            const isO2o = task.kind === 'one_to_one_planned';
                            const isMeetingFollowUp = task.kind === 'meeting_follow_up';
                            const bg = isStale ? '#fff3e0' : isO2o ? 'primary.light' : '#f8f9fa';
                            const borderColor = isStale ? 'warning.main' : isO2o ? 'primary.main' : '#ccc';
                            const icon = isStale ? '⏰' : isO2o ? '📅' : isMeetingFollowUp ? '📋' : '📝';
                            const action = task.action || {};
                            const memoDisabled = isStale && action.label === 'メモ追加' && action.disabled;

                            let actionNode;
                            if (action.href) {
                                actionNode = (
                                    <Button
                                        size="small"
                                        variant="outlined"
                                        color={isStale ? 'warning' : 'inherit'}
                                        component={Link}
                                        to={action.href}
                                        disabled={action.disabled}
                                    >
                                        {action.label}
                                    </Button>
                                );
                            } else if (task.badge) {
                                actionNode = (
                                    <Chip
                                        label={task.badge}
                                        size="small"
                                        sx={{ bgcolor: '#fff3e0', color: '#e65100', border: '1px solid #ffcc80' }}
                                    />
                                );
                            } else {
                                const btn = (
                                    <Button size="small" variant="outlined" color="warning" disabled>
                                        {action.label}
                                    </Button>
                                );
                                actionNode = memoDisabled ? (
                                    <Tooltip title="メモ追加は Member 詳細または Connections から行えます。">
                                        <span>{btn}</span>
                                    </Tooltip>
                                ) : (
                                    btn
                                );
                            }

                            return (
                                <Box
                                    key={task.id}
                                    sx={{
                                        display: 'flex',
                                        alignItems: 'center',
                                        gap: 1.25,
                                        py: 1.125,
                                        px: 1.5,
                                        bgcolor: bg,
                                        borderRadius: 1,
                                        borderLeft: 3,
                                        borderColor,
                                    }}
                                >
                                    <span style={{ fontSize: 16 }}>{icon}</span>
                                    <Box sx={{ flex: 1, minWidth: 0 }}>
                                        <Typography sx={{ fontSize: 13, fontWeight: 600, color: isStale ? '#bf360c' : undefined }}>
                                            {task.title}
                                        </Typography>
                                        <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>
                                            {task.meta || ''}
                                        </Typography>
                                    </Box>
                                    {actionNode}
                                </Box>
                            );
                        })}
                    </Box>
                )}
            </CardContent>
        </Card>
    );
}
