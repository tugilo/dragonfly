import React from 'react';
import { Box, Typography } from '@mui/material';

/**
 * メンバー一覧プレースホルダー。Phase11A ではメニュー導線のみ。会の地図（Board）からもメンバーを利用可能。
 */
export function MembersPlaceholder() {
    return (
        <Box sx={{ p: 2 }}>
            <Typography variant="h6">Members（メンバー）</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                メンバー一覧は会の地図（Board）のメンバー選択から利用できます。独立した一覧画面は将来追加予定です。
            </Typography>
        </Box>
    );
}
