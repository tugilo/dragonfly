import React, { useState } from 'react';
import {
    Alert,
    Box,
    Button,
    Chip,
    CircularProgress,
    Stack,
    Tooltip,
    Typography,
} from '@mui/material';
import {
    CONFIDENCE_LABELS,
    MEETING_DIRECTION_LABELS,
    MEETING_SECTION_LABELS,
    ONE_TO_ONE_DIRECTION_LABELS,
    SUGGESTION_STATUS_LABELS,
    patchReferralSuggestion,
} from '../referralSuggestionApi';

function directionLabel(kind, direction) {
    const map = kind === 'meeting' ? MEETING_DIRECTION_LABELS : ONE_TO_ONE_DIRECTION_LABELS;
    return map[direction] ?? direction ?? '—';
}

function SuggestionRow({ suggestion, kind, onUpdated, notify }) {
    const [patching, setPatching] = useState(false);
    const status = suggestion?.status ?? 'pending';
    const isPending = status === 'pending';

    const patchStatus = async (nextStatus) => {
        if (!suggestion?.id || patching) return;
        setPatching(true);
        try {
            const updated = await patchReferralSuggestion(kind, suggestion.id, { status: nextStatus });
            onUpdated?.(updated);
            notify?.(`ステータスを「${SUGGESTION_STATUS_LABELS[nextStatus] ?? nextStatus}」に更新しました`, { type: 'success' });
        } catch (e) {
            notify?.(e.message || '更新に失敗しました', { type: 'error' });
        } finally {
            setPatching(false);
        }
    };

    return (
        <Box
            sx={{
                border: '1px solid',
                borderColor: 'divider',
                borderRadius: 1,
                p: 1.5,
                bgcolor: status === 'pending' ? 'background.paper' : 'action.hover',
            }}
        >
            <Stack direction="row" spacing={0.75} flexWrap="wrap" useFlexGap alignItems="center" sx={{ mb: 0.75 }}>
                <Chip
                    size="small"
                    label={SUGGESTION_STATUS_LABELS[status] ?? status}
                    color={status === 'pending' ? 'warning' : status === 'dismissed' ? 'default' : 'primary'}
                    variant="outlined"
                    sx={{ height: 22, fontSize: '0.7rem' }}
                />
                <Chip
                    size="small"
                    label={directionLabel(kind, suggestion.direction)}
                    variant="outlined"
                    sx={{ height: 22, fontSize: '0.7rem' }}
                />
                {suggestion.confidence ? (
                    <Chip
                        size="small"
                        label={`確度: ${CONFIDENCE_LABELS[suggestion.confidence] ?? suggestion.confidence}`}
                        variant="outlined"
                        sx={{ height: 22, fontSize: '0.7rem' }}
                    />
                ) : null}
                {kind === 'meeting' && suggestion.source_section ? (
                    <Chip
                        size="small"
                        label={MEETING_SECTION_LABELS[suggestion.source_section] ?? suggestion.source_section}
                        variant="outlined"
                        sx={{ height: 22, fontSize: '0.7rem' }}
                    />
                ) : null}
            </Stack>
            <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 0.5 }}>
                {suggestion.summary || '（要約なし）'}
            </Typography>
            {suggestion.suggested_to_label ? (
                <Typography variant="body2" color="text.secondary" sx={{ mb: 0.5 }}>
                    紹介先候補: {suggestion.suggested_to_label}
                </Typography>
            ) : null}
            {suggestion.rationale ? (
                <Typography variant="body2" color="text.secondary" sx={{ mb: 1, whiteSpace: 'pre-wrap' }}>
                    根拠: {suggestion.rationale}
                </Typography>
            ) : null}
            {Array.isArray(suggestion.quality_notes) && suggestion.quality_notes.length > 0 ? (
                <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 1 }}>
                    注意: {suggestion.quality_notes.join(' / ')}
                </Typography>
            ) : null}
            <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap>
                <Button
                    size="small"
                    variant="outlined"
                    color="inherit"
                    disabled={!isPending || patching}
                    onClick={() => patchStatus('dismissed')}
                >
                    {patching ? '更新中…' : '却下'}
                </Button>
                <Button
                    size="small"
                    variant="outlined"
                    disabled={!isPending || patching}
                    onClick={() => patchStatus('deferred')}
                >
                    あとで
                </Button>
                <Tooltip title="紹介履歴への登録は Phase 192 で実装予定">
                    <span>
                        <Button size="small" variant="contained" disabled>
                            採用して登録
                        </Button>
                    </span>
                </Tooltip>
            </Stack>
        </Box>
    );
}

export function ReferralSuggestionList({ suggestions, kind, onSuggestionUpdated, notify, loading }) {
    if (loading) {
        return (
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, py: 2 }}>
                <CircularProgress size={22} />
                <Typography variant="body2" color="text.secondary">
                    提案を読み込んでいます…
                </Typography>
            </Box>
        );
    }

    if (!Array.isArray(suggestions) || suggestions.length === 0) {
        return (
            <Alert severity="info" sx={{ mt: 1 }}>
                まだ提案がありません。「提案を生成」で AI から候補を抽出してください。
            </Alert>
        );
    }

    return (
        <Stack spacing={1.5} sx={{ mt: 1 }}>
            {suggestions.map((s) => (
                <SuggestionRow
                    key={s.id}
                    suggestion={s}
                    kind={kind}
                    onUpdated={onSuggestionUpdated}
                    notify={notify}
                />
            ))}
        </Stack>
    );
}
