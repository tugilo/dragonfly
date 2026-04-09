import React, { useState, useCallback } from 'react';
import { Box, Button, Card, CardContent, Snackbar, Typography } from '@mui/material';
import { DASHBOARD_CARD_SX } from './dashboardConstants';

/**
 * ウィークリープレゼン原稿（SPEC-004）. Owner 未設定時は親が描画しない。
 * prominent: ヘッダー直下で目立たせる（Dashboard 先頭表示用）。
 */
export default function DashboardWeeklyPresentationPanel({ loading, body, loadError, prominent = false }) {
    const [snack, setSnack] = useState('');

    const handleCopy = useCallback(async () => {
        if (body == null || body === '') return;
        try {
            await navigator.clipboard.writeText(body);
            setSnack('コピーしました');
        } catch {
            setSnack('コピーに失敗しました');
        }
    }, [body]);

    const showEmpty = !loadError && !loading && body == null;
    const showBody = !loadError && !loading && body != null && body !== '';

    const cardSx = prominent
        ? {
              ...DASHBOARD_CARD_SX,
              mb: 2.25,
              borderWidth: 2,
              borderColor: 'primary.main',
              bgcolor: (theme) =>
                  theme.palette.mode === 'dark' ? 'rgba(25, 118, 210, 0.12)' : 'rgba(25, 118, 210, 0.06)',
              boxShadow: (theme) =>
                  theme.palette.mode === 'dark'
                      ? '0 2px 12px rgba(25, 118, 210, 0.25)'
                      : '0 2px 12px rgba(25, 118, 210, 0.18)',
          }
        : { ...DASHBOARD_CARD_SX, mb: 1.75 };

    const bodyMaxHeight = prominent
        ? { xs: 'min(52vh, 320px)', sm: 'min(45vh, 340px)' }
        : { xs: 220, sm: 240 };

    return (
        <>
            <Card variant="outlined" sx={cardSx}>
                <CardContent sx={prominent ? { py: 2, '&:last-child': { pb: 2 } } : undefined}>
                    <Typography
                        sx={{
                            fontSize: prominent ? 16 : 13,
                            fontWeight: 800,
                            mb: 0.25,
                            color: prominent ? 'primary.main' : 'inherit',
                        }}
                    >
                        ウィークリープレゼン原稿
                    </Typography>
                    <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: prominent ? 1.25 : 1 }}>
                        例会の25秒などで話す確定文案です（グローバル Owner に紐づくメンバー）。
                    </Typography>

                    {loading && (
                        <Typography variant="body2" color="text.secondary">
                            読み込み中…
                        </Typography>
                    )}

                    {!loading && loadError && (
                        <Typography variant="body2" color="error">
                            原稿を読み込めませんでした。画面を再読み込みしてください。
                        </Typography>
                    )}

                    {!loading && showEmpty && (
                        <Typography variant="body2" color="text.secondary">
                            原稿が未登録です。
                        </Typography>
                    )}

                    {!loading && showBody && (
                        <>
                            <Box
                                sx={{
                                    maxHeight: bodyMaxHeight,
                                    overflow: 'auto',
                                    p: 1.25,
                                    borderRadius: 1,
                                    bgcolor: prominent ? 'background.paper' : 'action.hover',
                                    border: prominent ? 1 : 0,
                                    borderColor: 'divider',
                                    whiteSpace: 'pre-wrap',
                                    wordBreak: 'break-word',
                                    fontSize: prominent ? 15 : 14,
                                    lineHeight: 1.65,
                                }}
                            >
                                {body}
                            </Box>
                            <Box sx={{ mt: 1.25 }}>
                                <Button
                                    variant="outlined"
                                    size="small"
                                    onClick={handleCopy}
                                    aria-label="ウィークリープレゼン原稿を全文コピー"
                                >
                                    全文をコピー
                                </Button>
                            </Box>
                        </>
                    )}
                </CardContent>
            </Card>
            <Snackbar
                open={Boolean(snack)}
                autoHideDuration={2500}
                onClose={() => setSnack('')}
                message={snack}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
            />
        </>
    );
}
