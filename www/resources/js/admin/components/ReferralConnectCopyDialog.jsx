import React, { useCallback, useEffect, useMemo, useState } from 'react';
import {
    Alert,
    Autocomplete,
    Box,
    Button,
    Checkbox,
    Chip,
    CircularProgress,
    Collapse,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    FormControl,
    FormControlLabel,
    IconButton,
    InputLabel,
    MenuItem,
    Select,
    Stack,
    Tab,
    Tabs,
    TextField,
    Typography,
} from '@mui/material';
import CloseIcon from '@mui/icons-material/Close';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import AutoAwesomeIcon from '@mui/icons-material/AutoAwesome';
import { Link as RouterLink } from 'react-router-dom';
import { religoFetch } from '../religoApiFetch';
import { useReligoOwner } from '../ReligoOwnerContext';
import {
    formatMemberAutocompleteLabel,
    formatMemberSecondaryLine,
    formatMemberWithChapterPrimary,
} from '../utils/memberDisplay';
import { memberFilterMatches } from '../pages/OneToOnesFormParts';
import {
    CORPUS_SOURCE_LABELS,
    MEETING_DIRECTION_LABELS,
    ONE_TO_ONE_DIRECTION_LABELS,
    deriveDefaultParties,
    generateConnectCopy,
} from '../referralSuggestionApi';

async function fetchMembers(ownerMemberId) {
    const res = await religoFetch(
        `/api/dragonfly/members?owner_member_id=${encodeURIComponent(String(ownerMemberId))}`,
        { headers: { Accept: 'application/json' } },
    );
    if (!res.ok) throw new Error(`メンバー一覧の取得に失敗しました (${res.status})`);
    return res.json();
}

function directionLabel(kind, direction) {
    const map = kind === 'meeting' ? MEETING_DIRECTION_LABELS : ONE_TO_ONE_DIRECTION_LABELS;
    return map[direction] ?? direction ?? '—';
}

function CopyBlock({ block, onCopied }) {
    const handleCopy = async () => {
        try {
            await navigator.clipboard.writeText(block.text);
            onCopied?.(`「${block.label}」をコピーしました`);
        } catch {
            onCopied?.('コピーに失敗しました', { type: 'error' });
        }
    };

    return (
        <Box sx={{ mb: 2 }}>
            <Stack direction="row" alignItems="center" justifyContent="space-between" sx={{ mb: 0.75 }}>
                <Typography variant="subtitle2" sx={{ fontWeight: 600 }}>
                    {block.label}
                </Typography>
                <Button size="small" variant="outlined" startIcon={<ContentCopyIcon fontSize="small" />} onClick={handleCopy}>
                    コピー
                </Button>
            </Stack>
            <TextField
                value={block.text}
                multiline
                minRows={4}
                fullWidth
                InputProps={{ readOnly: true }}
                size="small"
            />
        </Box>
    );
}

export function ReferralConnectCopyDialog({
    open,
    onClose,
    suggestion,
    kind,
    aiReady,
    notify,
}) {
    const { ownerMemberId } = useReligoOwner();
    const [members, setMembers] = useState([]);
    const [membersLoading, setMembersLoading] = useState(false);
    const [partyAId, setPartyAId] = useState(null);
    const [partyBId, setPartyBId] = useState(null);
    const [partyBLabel, setPartyBLabel] = useState('');
    const [bMode, setBMode] = useState('member');
    const [channelHint, setChannelHint] = useState('messenger');
    const [generating, setGenerating] = useState(false);
    const [error, setError] = useState(null);
    const [result, setResult] = useState(null);
    const [tab, setTab] = useState(0);
    const [consentA, setConsentA] = useState(false);
    const [consentB, setConsentB] = useState(false);
    const [memo, setMemo] = useState('');
    const [rationaleOpen, setRationaleOpen] = useState(false);

    const partyA = useMemo(
        () => members.find((m) => String(m.id) === String(partyAId)) ?? null,
        [members, partyAId],
    );
    const partyB = useMemo(
        () => members.find((m) => String(m.id) === String(partyBId)) ?? null,
        [members, partyBId],
    );

    useEffect(() => {
        if (!open || !suggestion || ownerMemberId == null) return;
        const defaults = deriveDefaultParties(suggestion, ownerMemberId);
        setPartyAId(defaults.party_a_member_id);
        setPartyBId(defaults.party_b_member_id);
        setPartyBLabel(defaults.party_b_label ?? '');
        setBMode(defaults.party_b_member_id != null ? 'member' : defaults.party_b_label ? 'label' : 'member');
        setChannelHint('messenger');
        setResult(null);
        setError(null);
        setTab(0);
        setConsentA(false);
        setConsentB(false);
        setMemo('');
        setRationaleOpen(false);
    }, [open, suggestion, ownerMemberId]);

    useEffect(() => {
        if (!open || ownerMemberId == null) return;
        let cancelled = false;
        setMembersLoading(true);
        fetchMembers(ownerMemberId)
            .then((rows) => { if (!cancelled) setMembers(Array.isArray(rows) ? rows : []); })
            .catch((e) => { if (!cancelled) setError(e.message); })
            .finally(() => { if (!cancelled) setMembersLoading(false); });
        return () => { cancelled = true; };
    }, [open, ownerMemberId]);

    const canGenerate = partyAId != null && (
        (bMode === 'member' && partyBId != null && partyBId !== partyAId)
        || (bMode === 'label' && partyBLabel.trim() !== '')
    );

    const handleGenerate = useCallback(async () => {
        if (!suggestion?.id || !canGenerate) return;
        setGenerating(true);
        setError(null);
        try {
            const body = {
                party_a_member_id: Number(partyAId),
                channel_hint: channelHint,
            };
            if (bMode === 'member') {
                body.party_b_member_id = Number(partyBId);
            } else {
                body.party_b_label = partyBLabel.trim();
            }
            const data = await generateConnectCopy(kind, suggestion.id, body);
            setResult(data);
            setTab(0);
            notify?.('紹介文案を生成しました', { type: 'success' });
        } catch (e) {
            setError(e.message || '生成に失敗しました');
            notify?.(e.message || '生成に失敗しました', { type: 'error' });
        } finally {
            setGenerating(false);
        }
    }, [suggestion?.id, canGenerate, partyAId, partyBId, partyBLabel, bMode, channelHint, kind, notify]);

    const blocks = Array.isArray(result?.blocks) ? result.blocks : [];
    const activeBlock = blocks[tab] ?? null;

    return (
        <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth scroll="paper">
            <DialogTitle sx={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', pr: 1 }}>
                <Box sx={{ minWidth: 0 }}>
                    <Typography component="span" variant="h6">
                        紹介文を作成（つなぐ準備）
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                        きっかけ: {suggestion?.summary || '—'}
                    </Typography>
                    <Stack direction="row" spacing={0.75} flexWrap="wrap" useFlexGap sx={{ mt: 0.75 }}>
                        <Chip size="small" label={directionLabel(kind, suggestion?.direction)} variant="outlined" />
                        {suggestion?.corpus_source ? (
                            <Chip
                                size="small"
                                label={CORPUS_SOURCE_LABELS[suggestion.corpus_source] ?? suggestion.corpus_source}
                                variant="outlined"
                            />
                        ) : null}
                    </Stack>
                </Box>
                <IconButton size="small" onClick={onClose} aria-label="閉じる">
                    <CloseIcon />
                </IconButton>
            </DialogTitle>
            <DialogContent dividers>
                {!aiReady ? (
                    <Alert severity="warning" sx={{ mb: 2 }}>
                        AI が未設定です。
                        <RouterLink to="/settings" style={{ marginLeft: 4 }}>
                            設定画面
                        </RouterLink>
                        で API キーを登録してください。
                    </Alert>
                ) : null}

                {error ? (
                    <Alert severity="error" sx={{ mb: 2 }} onClose={() => setError(null)}>
                        {error}
                    </Alert>
                ) : null}

                {(suggestion?.rationale || (Array.isArray(suggestion?.evidence_lines) && suggestion.evidence_lines.length > 0)) ? (
                    <Box sx={{ mb: 2 }}>
                        <Button size="small" onClick={() => setRationaleOpen((v) => !v)}>
                            {rationaleOpen ? '根拠を隠す' : '根拠を表示'}
                        </Button>
                        <Collapse in={rationaleOpen}>
                            {Array.isArray(suggestion.evidence_lines) && suggestion.evidence_lines.length > 0 ? (
                                <Box component="ul" sx={{ m: 0, pl: 2.25, color: 'text.secondary', fontSize: '0.875rem' }}>
                                    {suggestion.evidence_lines.map((line, idx) => (
                                        <li key={idx}>{line}</li>
                                    ))}
                                </Box>
                            ) : (
                                <Typography variant="body2" color="text.secondary" sx={{ whiteSpace: 'pre-wrap' }}>
                                    {suggestion.rationale}
                                </Typography>
                            )}
                        </Collapse>
                    </Box>
                ) : null}

                <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 1 }}>
                    パーティ指定
                </Typography>
                <Stack spacing={1.5} sx={{ mb: 2 }}>
                    <Autocomplete
                        size="small"
                        loading={membersLoading}
                        options={members}
                        value={partyA}
                        onChange={(_, v) => setPartyAId(v?.id ?? null)}
                        getOptionLabel={(o) => formatMemberAutocompleteLabel(o)}
                        isOptionEqualToValue={(a, b) => String(a.id) === String(b.id)}
                        filterOptions={(opts, state) => opts.filter((m) => memberFilterMatches(m, state.inputValue))}
                        renderOption={(props, option) => {
                            const { key: optKey, ...optionProps } = props;
                            const sec = formatMemberSecondaryLine(option);
                            return (
                                <Box key={optKey ?? option.id} component="li" {...optionProps}>
                                    <Typography sx={{ fontSize: 13, fontWeight: 600 }}>
                                        {formatMemberWithChapterPrimary(option)}
                                    </Typography>
                                    {sec ? (
                                        <Typography sx={{ fontSize: 10, color: 'text.secondary' }}>{sec}</Typography>
                                    ) : null}
                                </Box>
                            );
                        }}
                        renderInput={(params) => (
                            <TextField {...params} label="パーティ A（必須）" placeholder="メンバーを検索" />
                        )}
                    />
                    <Stack direction="row" spacing={1} alignItems="center">
                        <FormControl size="small" sx={{ minWidth: 140 }}>
                            <InputLabel id="party-b-mode-label">パーティ B</InputLabel>
                            <Select
                                labelId="party-b-mode-label"
                                label="パーティ B"
                                value={bMode}
                                onChange={(e) => setBMode(e.target.value)}
                            >
                                <MenuItem value="member">章内メンバー</MenuItem>
                                <MenuItem value="label">社外・自由テキスト</MenuItem>
                            </Select>
                        </FormControl>
                        <FormControl size="small" sx={{ minWidth: 140 }}>
                            <InputLabel id="channel-hint-label">チャネル</InputLabel>
                            <Select
                                labelId="channel-hint-label"
                                label="チャネル"
                                value={channelHint}
                                onChange={(e) => setChannelHint(e.target.value)}
                            >
                                <MenuItem value="messenger">Messenger</MenuItem>
                                <MenuItem value="line">LINE</MenuItem>
                                <MenuItem value="email">メール</MenuItem>
                            </Select>
                        </FormControl>
                    </Stack>
                    {bMode === 'member' ? (
                        <Autocomplete
                            size="small"
                            loading={membersLoading}
                            options={members.filter((m) => String(m.id) !== String(partyAId))}
                            value={partyB}
                            onChange={(_, v) => setPartyBId(v?.id ?? null)}
                            getOptionLabel={(o) => formatMemberAutocompleteLabel(o)}
                            isOptionEqualToValue={(a, b) => String(a.id) === String(b.id)}
                            filterOptions={(opts, state) => opts.filter((m) => memberFilterMatches(m, state.inputValue))}
                            renderInput={(params) => (
                                <TextField {...params} label="パーティ B（メンバー）" placeholder="メンバーを検索" />
                            )}
                        />
                    ) : (
                        <TextField
                            size="small"
                            fullWidth
                            label="パーティ B（社外・未登録）"
                            placeholder="例: 静岡の建設会社 田中さん"
                            value={partyBLabel}
                            onChange={(e) => setPartyBLabel(e.target.value)}
                        />
                    )}
                    <Button
                        variant="contained"
                        startIcon={generating ? <CircularProgress size={16} color="inherit" /> : <AutoAwesomeIcon />}
                        disabled={!aiReady || !canGenerate || generating}
                        onClick={handleGenerate}
                    >
                        {generating ? '生成中…' : result ? '文案を再生成' : '文案を生成'}
                    </Button>
                </Stack>

                {blocks.length > 0 ? (
                    <Box>
                        <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 1 }}>
                            文案ブロック
                        </Typography>
                        <Tabs
                            value={tab}
                            onChange={(_, v) => setTab(v)}
                            variant="scrollable"
                            scrollButtons="auto"
                            sx={{ mb: 1, borderBottom: 1, borderColor: 'divider' }}
                        >
                            {blocks.map((b, idx) => (
                                <Tab key={b.key} label={b.label} value={idx} />
                            ))}
                        </Tabs>
                        {activeBlock ? (
                            <CopyBlock
                                block={activeBlock}
                                onCopied={(msg, opts) => notify?.(msg, opts ?? { type: 'success' })}
                            />
                        ) : null}
                        <Stack direction="row" spacing={2} flexWrap="wrap" sx={{ mt: 1 }}>
                            <FormControlLabel
                                control={<Checkbox checked={consentA} onChange={(e) => setConsentA(e.target.checked)} />}
                                label="A 了承済み"
                            />
                            <FormControlLabel
                                control={<Checkbox checked={consentB} onChange={(e) => setConsentB(e.target.checked)} />}
                                label="B 了承済み"
                            />
                        </Stack>
                        <TextField
                            size="small"
                            fullWidth
                            label="メモ（任意・この画面のみ）"
                            value={memo}
                            onChange={(e) => setMemo(e.target.value)}
                            sx={{ mt: 1 }}
                        />
                    </Box>
                ) : null}
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose}>閉じる</Button>
            </DialogActions>
        </Dialog>
    );
}
