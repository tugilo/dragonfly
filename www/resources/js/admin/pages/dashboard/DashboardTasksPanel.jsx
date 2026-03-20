import React from 'react';
import { Box, Card, CardContent, Typography, Button, Chip, Tooltip } from '@mui/material';
import { Link } from 'react-router-dom';
import { DASHBOARD_CARD_SX } from './dashboardConstants';

/**
 * 今日やること。P7-2 で API の meta / href 拡張を受けやすいよう行レンダーを素直に保持。
 */
export default function DashboardTasksPanel({ tasks }) {
    return (
        <Card variant="outlined" sx={{ ...DASHBOARD_CARD_SX, mb: 1.75 }}>
            <CardContent>
                <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 0.25 }}>⚡ 今日やること（Tasks）</Typography>
                <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.25 }}>
                    未接触のフォロー・予定の 1 to 1・例会メモの整理など、いま手を付けるべきことです。
                </Typography>
                <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                    {tasks.map((task) => {
                        const isStale = task.kind === 'stale_follow';
                        const isO2o = task.kind === 'one_to_one_planned';
                        const bg = isStale ? '#fff3e0' : isO2o ? 'primary.light' : '#f8f9fa';
                        const borderColor = isStale ? 'warning.main' : isO2o ? 'primary.main' : '#ccc';
                        const icon = isStale ? '⏰' : isO2o ? '📅' : '📝';
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
                                <Tooltip title="メモ追加は Connections 等から。Dashboard 直導線は P7-2 以降で検討します。">
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
            </CardContent>
        </Card>
    );
}
