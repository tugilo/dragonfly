import React from 'react';
import { Box, Card, CardContent, Typography, Button } from '@mui/material';
import { Link } from 'react-router-dom';
import { DASHBOARD_CARD_SX } from './dashboardConstants';

/** よく使う画面への導線。遷移先は変更しない（P7-1）。 */
export default function DashboardShortcutsPanel() {
    return (
        <Card variant="outlined" sx={{ ...DASHBOARD_CARD_SX, mb: 1.75 }}>
            <CardContent>
                <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 0.25 }}>🔗 クイックショートカット</Typography>
                <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.25 }}>
                    会の地図・メンバー・1 to 1・例会へすぐ移動できます。
                </Typography>
                <Box sx={{ display: 'flex', gap: 1.25, flexWrap: 'wrap' }}>
                    <Button component={Link} to="/connections" variant="contained" size="small">
                        🗺 Connections
                    </Button>
                    <Button component={Link} to="/members" variant="outlined" size="small">
                        👥 Members一覧
                    </Button>
                    <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">
                        ＋ 1to1を追加
                    </Button>
                    <Button component={Link} to="/meetings" variant="outlined" size="small" color="inherit">
                        📋 例会一覧
                    </Button>
                </Box>
            </CardContent>
        </Card>
    );
}
