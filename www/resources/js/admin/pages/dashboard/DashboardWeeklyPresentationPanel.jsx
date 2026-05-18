import React, { useState, useCallback } from 'react';
import { Box, Button, Card, CardContent, Snackbar, Tab, Tabs, Typography } from '@mui/material';
import { DASHBOARD_CARD_SX } from './dashboardConstants';

/**
 * ウィークリープレゼン原稿（SPEC-004）. Owner 未設定時は親が描画しない。
 * prominent: ヘッダー直下で目立たせる（Dashboard 先頭表示用）。
 */
export default function DashboardWeeklyPresentationPanel({ loading, body, startDashBody, loadError, prominent = false }) {
    const [activeTab, setActiveTab] = useState('weekly');
    const [snack, setSnack] = useState('');

    const activeBody = activeTab === 'startDash' ? startDashBody : body;
    const activeLabel = activeTab === 'startDash' ? 'スタートダッシュプレゼン原稿' : 'ウィークリープレゼン原稿';

    const handleCopy = useCallback(async () => {
        if (activeBody == null || activeBody === '') return;
        try {
            await navigator.clipboard.writeText(activeBody);
            setSnack('コピーしました');
        } catch {
            setSnack('コピーに失敗しました');
        }
    }, [activeBody]);

    const showEmpty = !loadError && !loading && activeBody == null;
    const showBody = !loadError && !loading && activeBody != null && activeBody !== '';

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
                        プレゼン原稿
                    </Typography>
                    <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: prominent ? 1.25 : 1 }}>
                        例会で話す確定文案です（グローバル Owner に紐づくメンバー）。
                    </Typography>

                    <Tabs
                        value={activeTab}
                        onChange={(_, value) => setActiveTab(value)}
                        variant="scrollable"
                        allowScrollButtonsMobile
                        sx={{ minHeight: 36, mb: 1 }}
                        aria-label="プレゼン原稿の種類"
                    >
                        <Tab
                            value="weekly"
                            label="ウィークリープレゼン"
                            sx={{ minHeight: 36, py: 0.5, px: 1.25, fontSize: 13 }}
                        />
                        <Tab
                            value="startDash"
                            label="スタートダッシュ"
                            sx={{ minHeight: 36, py: 0.5, px: 1.25, fontSize: 13 }}
                        />
                    </Tabs>

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
                            {activeLabel}が未登録です。
                        </Typography>
                    )}

                    {!loading && showBody && (
                        <>
                            <Box
                                sx={{
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
                                {activeBody}
                            </Box>
                            <Box sx={{ mt: 1.25 }}>
                                <Button
                                    variant="outlined"
                                    size="small"
                                    onClick={handleCopy}
                                    aria-label={`${activeLabel}を全文コピー`}
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
