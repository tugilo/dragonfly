import React from 'react';
import { Box, Typography } from '@mui/material';

/**
 * 例会一覧プレースホルダー。Phase11A ではメニュー導線のみ。BO は Meeting または Board 内で操作。
 */
export function MeetingsPlaceholder() {
    return (
        <Box sx={{ p: 2 }}>
            <Typography variant="h6">Meetings（例会）</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                例会・BO 割当は会の地図（Board）の Meeting 選択から利用できます。独立した例会一覧画面は将来追加予定です。
            </Typography>
        </Box>
    );
}
