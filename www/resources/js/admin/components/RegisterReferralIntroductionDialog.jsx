import React, { useEffect, useState } from 'react';
import {
    Alert,
    Button,
    CircularProgress,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    TextField,
    Typography,
} from '@mui/material';
import {
    buildDefaultIntroductionNote,
    patchReferralSuggestion,
    registerReferralIntroduction,
} from '../referralSuggestionApi';

export function RegisterReferralIntroductionDialog({
    open,
    onClose,
    suggestion,
    kind,
    defaultIntroducedAt,
    onSuccess,
    notify,
}) {
    const [fromId, setFromId] = useState('');
    const [toId, setToId] = useState('');
    const [note, setNote] = useState('');
    const [introducedAt, setIntroducedAt] = useState('');
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState(null);

    useEffect(() => {
        if (!open || !suggestion) return;
        const viaConnector = suggestion.direction === 'via_connector';
        setFromId(suggestion.suggested_from_member_id != null ? String(suggestion.suggested_from_member_id) : '');
        setToId(suggestion.suggested_to_member_id != null ? String(suggestion.suggested_to_member_id) : '');
        if (viaConnector && suggestion.suggested_from_member_id && !suggestion.suggested_to_member_id) {
            setToId('');
        }
        setNote(buildDefaultIntroductionNote(suggestion));
        setIntroducedAt(defaultIntroducedAt ?? '');
        setError(null);
    }, [open, suggestion, defaultIntroducedAt]);

    const snapshot = () => ({
        from_member_id: fromId ? Number(fromId) : null,
        to_member_id: toId ? Number(toId) : null,
        note: note.trim(),
        introduced_at: introducedAt || null,
    });

    const saveAcceptedOnly = async () => {
        if (!suggestion?.id) return;
        setSaving(true);
        setError(null);
        try {
            const updated = await patchReferralSuggestion(kind, suggestion.id, {
                status: 'accepted',
                edited_snapshot: snapshot(),
            });
            onSuccess?.(updated);
            notify?.('提案を採用しました（紹介履歴には未登録）', { type: 'success' });
            onClose();
        } catch (e) {
            setError(e.message || '保存に失敗しました');
        } finally {
            setSaving(false);
        }
    };

    const saveAndRegister = async () => {
        if (!suggestion?.id) return;
        const to = Number(toId);
        const from = Number(fromId);
        if (!to || !from || to === from) {
            setError('from / to のメンバー ID を正しく入力してください（異なる ID）。');
            return;
        }
        setSaving(true);
        setError(null);
        try {
            const result = await registerReferralIntroduction(kind, suggestion.id, {
                from_member_id: from,
                to_member_id: to,
                note: note.trim() || undefined,
                introduced_at: introducedAt || undefined,
                edited_snapshot: snapshot(),
            });
            onSuccess?.(result.suggestion);
            notify?.('紹介履歴に登録しました', { type: 'success' });
            onClose();
        } catch (e) {
            setError(e.message || '登録に失敗しました');
        } finally {
            setSaving(false);
        }
    };

    return (
        <Dialog open={open} onClose={saving ? undefined : onClose} maxWidth="sm" fullWidth>
            <DialogTitle>採用 — 紹介内容の確認</DialogTitle>
            <DialogContent dividers>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                    メンバー ID は一覧の members または DB で確認してください。チャプター外の紹介先のみの提案は、to をメンバーに指定してから登録できます。
                </Typography>
                {error ? (
                    <Alert severity="error" sx={{ mb: 2 }}>
                        {error}
                    </Alert>
                ) : null}
                <TextField
                    label="from_member_id（紹介元）"
                    size="small"
                    fullWidth
                    value={fromId}
                    onChange={(e) => setFromId(e.target.value)}
                    sx={{ mb: 2 }}
                    disabled={saving}
                />
                <TextField
                    label="to_member_id（紹介先・必須）"
                    size="small"
                    fullWidth
                    value={toId}
                    onChange={(e) => setToId(e.target.value)}
                    sx={{ mb: 2 }}
                    disabled={saving}
                    required
                />
                <TextField
                    label="紹介日"
                    type="date"
                    size="small"
                    fullWidth
                    value={introducedAt}
                    onChange={(e) => setIntroducedAt(e.target.value)}
                    InputLabelProps={{ shrink: true }}
                    sx={{ mb: 2 }}
                    disabled={saving}
                />
                <TextField
                    label="メモ（introductions.note）"
                    size="small"
                    fullWidth
                    multiline
                    minRows={4}
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                    disabled={saving}
                />
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose} disabled={saving}>
                    キャンセル
                </Button>
                <Button onClick={saveAcceptedOnly} disabled={saving}>
                    保存のみ
                </Button>
                <Button variant="contained" onClick={saveAndRegister} disabled={saving}>
                    {saving ? <CircularProgress size={20} color="inherit" /> : '保存して紹介に登録'}
                </Button>
            </DialogActions>
        </Dialog>
    );
}
