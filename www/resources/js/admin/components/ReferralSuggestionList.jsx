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
import { RegisterReferralIntroductionDialog } from './RegisterReferralIntroductionDialog';
import { ReferralConnectCopyDialog } from './ReferralConnectCopyDialog';
import {
    CONFIDENCE_LABELS,
    CORPUS_SOURCE_LABELS,
    MEETING_DIRECTION_LABELS,
    MEETING_SECTION_LABELS,
    ONE_TO_ONE_DIRECTION_LABELS,
    SUGGESTION_STATUS_LABELS,
    canRegisterIntroduction,
    patchReferralSuggestion,
} from '../referralSuggestionApi';

function directionLabel(kind, direction) {
    const map = kind === 'meeting' ? MEETING_DIRECTION_LABELS : ONE_TO_ONE_DIRECTION_LABELS;
    return map[direction] ?? direction ?? '—';
}

function memberLabel(suggestion, idKey, nameKey, fallbackPrefix = 'メンバー') {
    const name = suggestion?.[nameKey];
    if (name) return name;
    const id = suggestion?.[idKey];
    if (id != null) return `${fallbackPrefix} #${id}`;
    return null;
}

function SuggestionRow({ suggestion, kind, onUpdated, notify, defaultIntroducedAt, subjectLabel, aiReady }) {
    const [patching, setPatching] = useState(false);
    const [registerOpen, setRegisterOpen] = useState(false);
    const [connectCopyOpen, setConnectCopyOpen] = useState(false);
    const status = suggestion?.status ?? 'pending';
    const isPending = status === 'pending' || status === 'deferred';
    const canRegister = canRegisterIntroduction(suggestion);
    const isSubjectMeet = suggestion.direction === 'subject_should_meet';
    const connectorLabel = memberLabel(suggestion, 'suggested_from_member_id', 'suggested_from_member_name', 'つなぎ手');
    const matchLabel = memberLabel(suggestion, 'suggested_to_member_id', 'suggested_to_member_name', '候補');
    const subjectName =
        suggestion.subject_member_name ||
        (subjectLabel ? subjectLabel.replace(/^主役:\s*/, '') : null);

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
        <>
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
                    {suggestion.corpus_source ? (
                        <Chip
                            size="small"
                            label={CORPUS_SOURCE_LABELS[suggestion.corpus_source] ?? suggestion.corpus_source}
                            color={suggestion.corpus_source === 'member_network' ? 'secondary' : 'default'}
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
                {isSubjectMeet && (subjectName || matchLabel) ? (
                    <Typography variant="body2" color="primary.main" sx={{ mb: 0.5 }}>
                        つなぐ: {subjectName ? `${subjectName} ↔ ` : '主役 ↔ '}
                        {matchLabel ?? '（メンバー未特定）'}
                    </Typography>
                ) : null}
                {suggestion.suggested_contact_label ? (
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 0.5 }}>
                        紹介してほしい相手: {suggestion.suggested_contact_label}
                    </Typography>
                ) : null}
                {suggestion.suggested_to_label ? (
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 0.5 }}>
                        紹介先候補: {suggestion.suggested_to_label}
                    </Typography>
                ) : null}
                {Array.isArray(suggestion.evidence_lines) && suggestion.evidence_lines.length > 0 ? (
                    <Box
                        component="ul"
                        sx={{
                            m: 0,
                            mb: 1,
                            pl: 2.25,
                            color: 'text.secondary',
                            fontSize: '0.875rem',
                            whiteSpace: 'pre-wrap',
                        }}
                    >
                        {suggestion.evidence_lines.map((line, idx) => (
                            <li key={idx}>{line}</li>
                        ))}
                    </Box>
                ) : suggestion.rationale ? (
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 1, whiteSpace: 'pre-wrap' }}>
                        根拠: {suggestion.rationale}
                    </Typography>
                ) : null}
                {suggestion.introduction_id ? (
                    <Typography variant="caption" color="success.main" display="block" sx={{ mb: 1 }}>
                        紹介履歴 #{suggestion.introduction_id} に登録済み
                    </Typography>
                ) : null}
                <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap>
                    <Button
                        size="small"
                        variant="contained"
                        color="primary"
                        disabled={patching}
                        onClick={() => setConnectCopyOpen(true)}
                    >
                        紹介文を作成
                    </Button>
                    {isSubjectMeet && suggestion.suggested_to_member_id ? (
                        <Button
                            size="small"
                            variant="contained"
                            color="primary"
                            component="a"
                            href={`/one-to-ones/create?target_member_id=${suggestion.suggested_to_member_id}`}
                            disabled={patching}
                        >
                            {matchLabel ? `${matchLabel} さんと 1 to 1（つなぐ）` : '1 to 1 を作成（つなぐ）'}
                        </Button>
                    ) : null}
                    {suggestion.direction === 'via_connector' && suggestion.suggested_from_member_id ? (
                        <Button
                            size="small"
                            variant="outlined"
                            color="secondary"
                            component="a"
                            href={`/one-to-ones/create?target_member_id=${suggestion.suggested_from_member_id}`}
                            disabled={patching}
                        >
                            {connectorLabel
                                ? `${connectorLabel} さんと 1 to 1`
                                : `メンバー #${suggestion.suggested_from_member_id} と 1 to 1`}
                        </Button>
                    ) : null}
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
                    {canRegister ? (
                        <Button
                            size="small"
                            variant="contained"
                            disabled={patching}
                            onClick={() => setRegisterOpen(true)}
                        >
                            採用して登録
                        </Button>
                    ) : (
                        <Tooltip
                            title={
                                suggestion?.introduction_id
                                    ? '登録済み'
                                    : 'to_member_id が未設定の提案は、採用ダイアログで to を指定して登録できます'
                            }
                        >
                            <span>
                                <Button
                                    size="small"
                                    variant="outlined"
                                    disabled={!isPending || patching || Boolean(suggestion?.introduction_id)}
                                    onClick={() => setRegisterOpen(true)}
                                >
                                    採用…
                                </Button>
                            </span>
                        </Tooltip>
                    )}
                </Stack>
            </Box>
            <RegisterReferralIntroductionDialog
                open={registerOpen}
                onClose={() => setRegisterOpen(false)}
                suggestion={suggestion}
                kind={kind}
                defaultIntroducedAt={defaultIntroducedAt}
                notify={notify}
                onSuccess={onUpdated}
            />
            <ReferralConnectCopyDialog
                open={connectCopyOpen}
                onClose={() => setConnectCopyOpen(false)}
                suggestion={suggestion}
                kind={kind}
                aiReady={aiReady}
                notify={notify}
            />
        </>
    );
}

export function ReferralSuggestionList({
    suggestions,
    kind,
    onSuggestionUpdated,
    notify,
    loading,
    defaultIntroducedAt,
    subjectLabel = null,
    aiReady = true,
}) {
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
                    defaultIntroducedAt={defaultIntroducedAt}
                    subjectLabel={subjectLabel}
                    aiReady={aiReady}
                />
            ))}
        </Stack>
    );
}
