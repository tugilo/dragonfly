import React, { useState, useCallback } from 'react';
import { Box, Button, Card, CardContent, Chip, Snackbar, Tab, Tabs, Typography } from '@mui/material';
import { DASHBOARD_CARD_SX } from './dashboardConstants';

/**
 * ウィークリープレゼン原稿（SPEC-004 / Phase 307）. Owner 未設定時は親が描画しない。
 * prominent: ヘッダー直下で目立たせる（Dashboard 先頭表示用）。
 */
export default function DashboardWeeklyPresentationPanel({
    loading,
    body,
    startDashBody,
    patterns = [],
    activeId = null,
    usages = [],
    onSelectPattern,
    onRecordUsage,
    loadError,
    prominent = false,
}) {
    const [activeTab, setActiveTab] = useState('weekly');
    const [snack, setSnack] = useState('');
    const [selecting, setSelecting] = useState(false);
    const [recording, setRecording] = useState(false);

    const weeklyPatterns = Array.isArray(patterns) ? patterns : [];
    const weeklyUsages = Array.isArray(usages) ? usages : [];
    const selectedPattern = weeklyPatterns.find((row) => row.id === activeId);
    const weeklyBody = selectedPattern?.body ?? body;
    const activeBody = activeTab === 'startDash' ? startDashBody : weeklyBody;
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

    const handleSelectPattern = useCallback(
        async (patternId) => {
            if (!onSelectPattern || selecting) {
                return;
            }
            setSelecting(true);
            try {
                await onSelectPattern(patternId);
                setSnack('表示を切り替えました');
            } catch (error) {
                setSnack(error instanceof Error ? error.message : 'パターンの切替に失敗しました');
            } finally {
                setSelecting(false);
            }
        },
        [onSelectPattern, selecting]
    );

    const todayJst = new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Tokyo' }).format(new Date());
    const recordedToday = weeklyUsages.some((row) => row.pattern_id === activeId && row.used_on === todayJst);

    const handleRecordUsage = useCallback(async () => {
        if (!onRecordUsage || !activeId || recording || selecting) {
            return;
        }
        setRecording(true);
        try {
            await onRecordUsage(activeId);
            setSnack('この週に使った記録を残しました');
        } catch (error) {
            setSnack(error instanceof Error ? error.message : '利用記録に失敗しました');
        } finally {
            setRecording(false);
        }
    }, [onRecordUsage, activeId, recording, selecting]);

    const showEmpty = !loadError && !loading && (activeBody == null || activeBody === '');
    const showBody = !loadError && !loading && activeBody != null && activeBody !== '';
    const showPatterns = activeTab === 'weekly' && weeklyPatterns.length > 0 && !loading && !loadError;

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

                    {showPatterns && (
                        <Box sx={{ mb: 1.25 }}>
                            <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 0.75 }}>
                                話す稿を選ぶ（選んだだけでは利用記録は残りません）
                            </Typography>
                            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.75 }}>
                                {weeklyPatterns.map((pattern) => {
                                    const selected = pattern.id === activeId;
                                    return (
                                        <Chip
                                            key={pattern.id}
                                            label={`${pattern.id} ${pattern.label}`}
                                            color={selected ? 'primary' : 'default'}
                                            variant={selected ? 'filled' : 'outlined'}
                                            size="small"
                                            disabled={selecting || recording}
                                            onClick={() => handleSelectPattern(pattern.id)}
                                            aria-pressed={selected}
                                        />
                                    );
                                })}
                            </Box>
                            {weeklyUsages.length > 0 && (
                                <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mt: 0.75 }}>
                                    最近の利用:{' '}
                                    {weeklyUsages
                                        .slice(0, 4)
                                        .map((row) => `${row.used_on} ${row.label}`)
                                        .join(' · ')}
                                </Typography>
                            )}
                        </Box>
                    )}

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
                            <Box sx={{ mt: 1.25, display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                                <Button
                                    variant="outlined"
                                    size="small"
                                    onClick={handleCopy}
                                    aria-label={`${activeLabel}を全文コピー`}
                                >
                                    全文をコピー
                                </Button>
                                {activeTab === 'weekly' && weeklyPatterns.length > 0 && onRecordUsage && activeId && (
                                    <Button
                                        variant="contained"
                                        size="small"
                                        onClick={handleRecordUsage}
                                        disabled={recording || selecting}
                                        aria-label="この週に使った記録を残す"
                                    >
                                        {recordedToday ? 'この週に使った（記録済み）' : 'この週に使った'}
                                    </Button>
                                )}
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
