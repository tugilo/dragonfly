import React from 'react';
import { Box, Typography } from '@mui/material';

/**
 * 1 to 1 一覧プレースホルダー。Phase11B で独立一覧・作成を実装予定。
 * 1 to 1 は Meeting と独立した関係づくりログである。
 */
export function OneToOnesPlaceholder() {
    return (
        <Box sx={{ p: 2 }}>
            <Typography variant="h6">1 to 1（予定・履歴）</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                1 to 1 は Meeting と独立した関係づくりログです。一覧・登録画面は Phase11B で実装予定です。Board の「1 to 1 登録」からも登録できます。
            </Typography>
        </Box>
    );
}
