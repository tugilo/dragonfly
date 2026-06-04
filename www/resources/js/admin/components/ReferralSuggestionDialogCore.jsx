import React, { useCallback, useEffect, useState } from 'react';
import { Link as RouterLink } from 'react-router-dom';
import {
    Alert,
    Box,
    Button,
    CircularProgress,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    FormControl,
    IconButton,
    InputLabel,
    Link,
    MenuItem,
    Select,
    Stack,
    Typography,
} from '@mui/material';
import CloseIcon from '@mui/icons-material/Close';
import AutoAwesomeIcon from '@mui/icons-material/AutoAwesome';
import RefreshIcon from '@mui/icons-material/Refresh';
import { MarkdownView } from './MarkdownView';
import { ReferralSuggestionList } from './ReferralSuggestionList';
import {
    fetchAiCredentialsSummary,
    isAiReady,
} from '../referralSuggestionApi';

function formatRunLabel(run) {
    if (!run) return '';
    const when = run.created_at ? new Date(run.created_at).toLocaleString('ja-JP') : `#${run.id}`;
    const count = run.suggestion_count != null ? `${run.suggestion_count}件` : '';
    return `${when}${count ? ` · ${count}` : ''}`;
}

/**
 * 121 / 定例会共通のリファーラル提案モーダル本体。
 */
export function ReferralSuggestionDialogCore({
    open,
    onClose,
    title,
    subtitle,
    sourceMarkdown,
    sourceLoading,
    kind,
    fetchSuggestions,
    generateSuggestions,
    notify,
    defaultIntroducedAt,
}) {
    const [aiCreds, setAiCreds] = useState(null);
    const [payload, setPayload] = useState(null);
    const [loading, setLoading] = useState(false);
    const [generating, setGenerating] = useState(false);
    const [error, setError] = useState(null);
    const [selectedRunId, setSelectedRunId] = useState('');

    const loadSuggestions = useCallback(async (runId) => {
        setLoading(true);
        setError(null);
        try {
            const data = await fetchSuggestions(runId);
            setPayload(data);
            if (data?.run?.id != null) {
                setSelectedRunId(String(data.run.id));
            }
        } catch (e) {
            setError(e.message || '読み込みに失敗しました');
            setPayload(null);
        } finally {
            setLoading(false);
        }
    }, [fetchSuggestions]);

    useEffect(() => {
        if (!open) {
            setPayload(null);
            setError(null);
            setSelectedRunId('');
            setAiCreds(null);
            return;
        }
        let cancelled = false;
        (async () => {
            try {
                const creds = await fetchAiCredentialsSummary();
                if (!cancelled) setAiCreds(creds);
            } catch {
                if (!cancelled) setAiCreds({ ai_enabled: false, has_api_key: false });
            }
            if (!cancelled) await loadSuggestions(null);
        })();
        return () => { cancelled = true; };
    }, [open, loadSuggestions]);

    const handleGenerate = async () => {
        setGenerating(true);
        setError(null);
        try {
            const data = await generateSuggestions();
            setPayload(data);
            if (data?.run?.id != null) {
                setSelectedRunId(String(data.run.id));
            }
            const reused = Boolean(data?.reused_existing_run);
            notify(
                reused
                    ? '同一内容の提案 run を再利用しました'
                    : 'リファーラル提案を生成しました',
                { type: 'success' },
            );
        } catch (e) {
            setError(e.message || '生成に失敗しました');
            notify(e.message || '生成に失敗しました', { type: 'error' });
        } finally {
            setGenerating(false);
        }
    };

    const handleRunChange = async (event) => {
        const runId = event.target.value;
        setSelectedRunId(runId);
        await loadSuggestions(runId ? Number(runId) : null);
    };

    const handleSuggestionUpdated = (updated) => {
        if (!updated?.id || !payload?.suggestions) return;
        setPayload((prev) => ({
            ...prev,
            suggestions: prev.suggestions.map((s) => (s.id === updated.id ? { ...s, ...updated } : s)),
        }));
    };

    const aiReady = isAiReady(aiCreds);
    const runs = Array.isArray(payload?.runs) ? payload.runs : [];
    const stale = Boolean(payload?.referral_suggestion_stale);

    return (
        <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth scroll="paper">
            <DialogTitle sx={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', pr: 1, gap: 1 }}>
                <Box sx={{ minWidth: 0 }}>
                    <Typography component="span" variant="h6">
                        {title}
                    </Typography>
                    {subtitle ? (
                        <Typography variant="caption" color="text.secondary" display="block" sx={{ mt: 0.5 }}>
                            {subtitle}
                        </Typography>
                    ) : null}
                </Box>
                <IconButton size="small" onClick={onClose} aria-label="閉じる" sx={{ mt: -0.5 }}>
                    <CloseIcon />
                </IconButton>
            </DialogTitle>
            <DialogContent dividers sx={{ px: 2, py: 1.5 }}>
                {!aiReady && aiCreds !== null ? (
                    <Alert severity="warning" sx={{ mb: 2 }}>
                        AI が未設定です。
                        <Link component={RouterLink} to="/settings" sx={{ ml: 0.5 }}>
                            設定画面
                        </Link>
                        で AI を有効化し API キーを登録してください。
                    </Alert>
                ) : null}

                {stale ? (
                    <Alert severity="info" sx={{ mb: 2 }}>
                        議事録が更新されています。再生成すると最新内容に基づく提案 run が作成されます。
                    </Alert>
                ) : null}

                {error ? (
                    <Alert severity="error" sx={{ mb: 2 }} onClose={() => setError(null)}>
                        {error}
                    </Alert>
                ) : null}

                <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap alignItems="center" sx={{ mb: 2 }}>
                    <Button
                        variant="contained"
                        startIcon={generating ? <CircularProgress size={16} color="inherit" /> : <AutoAwesomeIcon />}
                        disabled={!aiReady || generating || loading}
                        onClick={handleGenerate}
                    >
                        {generating ? '生成中…' : payload?.run ? '再生成' : '提案を生成'}
                    </Button>
                    {runs.length > 1 ? (
                        <FormControl size="small" sx={{ minWidth: 220 }}>
                            <InputLabel id="referral-run-select-label">過去 run</InputLabel>
                            <Select
                                labelId="referral-run-select-label"
                                label="過去 run"
                                value={selectedRunId}
                                onChange={handleRunChange}
                                disabled={loading || generating}
                            >
                                {runs.map((run) => (
                                    <MenuItem key={run.id} value={String(run.id)}>
                                        {formatRunLabel(run)}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    ) : null}
                    {payload?.run ? (
                        <Button
                            size="small"
                            variant="text"
                            startIcon={<RefreshIcon fontSize="small" />}
                            disabled={loading || generating}
                            onClick={() => loadSuggestions(selectedRunId ? Number(selectedRunId) : null)}
                        >
                            再読込
                        </Button>
                    ) : null}
                </Stack>

                <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 0.75 }}>
                    議事録（原文）
                </Typography>
                <Box
                    sx={{
                        border: '1px solid',
                        borderColor: 'divider',
                        borderRadius: 1,
                        p: 1.5,
                        maxHeight: 220,
                        overflow: 'auto',
                        mb: 2,
                        bgcolor: 'background.default',
                    }}
                >
                    {sourceLoading ? (
                        <Stack direction="row" spacing={1} alignItems="center">
                            <CircularProgress size={20} />
                            <Typography variant="body2" color="text.secondary">
                                議事録を読み込んでいます…
                            </Typography>
                        </Stack>
                    ) : sourceMarkdown?.trim() ? (
                        <MarkdownView markdown={sourceMarkdown.trim()} dense />
                    ) : (
                        <Typography variant="body2" color="text.secondary">
                            議事録がありません。
                        </Typography>
                    )}
                </Box>

                <Typography variant="subtitle2" sx={{ fontWeight: 600 }}>
                    提案一覧
                    {payload?.run ? (
                        <Typography component="span" variant="caption" color="text.secondary" sx={{ ml: 1 }}>
                            run #{payload.run.id}
                            {payload.run.model ? ` · ${payload.run.model}` : ''}
                        </Typography>
                    ) : null}
                </Typography>
                <ReferralSuggestionList
                    suggestions={payload?.suggestions}
                    kind={kind}
                    loading={loading}
                    notify={notify}
                    onSuggestionUpdated={handleSuggestionUpdated}
                    defaultIntroducedAt={defaultIntroducedAt}
                />
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose}>閉じる</Button>
            </DialogActions>
        </Dialog>
    );
}
