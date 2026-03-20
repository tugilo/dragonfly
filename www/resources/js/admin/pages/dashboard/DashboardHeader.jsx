import React from 'react';
import { Box, Typography, Button, Select, MenuItem, FormControl, InputLabel } from '@mui/material';
import { Link } from 'react-router-dom';

/**
 * タイトル・補助文・Owner 切替・主要 CTA。E-4 owner 文脈は右側を薄く占有。
 */
export default function DashboardHeader({
    ownerMemberId,
    members,
    savingOwner,
    onOwnerChange,
    showOwnerSelect,
    resolvedWorkspaceId = null,
}) {
    return (
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
                {resolvedWorkspaceId != null && (
                    <Typography variant="caption" sx={{ display: 'block', color: 'text.disabled', mt: 0.25 }} component="span">
                        解析用 workspace_id: {resolvedWorkspaceId}
                    </Typography>
                )}
            </Box>
            <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', alignItems: 'center' }}>
                {showOwnerSelect && (
                    <FormControl size="small" sx={{ minWidth: 140 }}>
                        <InputLabel id="dashboard-owner-label">Owner</InputLabel>
                        <Select
                            labelId="dashboard-owner-label"
                            label="Owner"
                            value={String(ownerMemberId)}
                            onChange={onOwnerChange}
                            disabled={savingOwner}
                        >
                            {members.map((m) => (
                                <MenuItem key={m.id} value={String(m.id)}>{m.name}</MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                )}
                <Button component={Link} to="/connections" variant="contained" size="small">
                    🗺 Connectionsへ
                </Button>
                <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">
                    ＋ 1to1追加
                </Button>
            </Box>
        </Box>
    );
}
