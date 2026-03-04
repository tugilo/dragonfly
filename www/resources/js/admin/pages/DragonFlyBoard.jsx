import React, { useState, useEffect, useCallback, useRef } from 'react';
import {
    Box,
    Grid,
    TextField,
    Autocomplete,
    Card,
    CardContent,
    Typography,
    FormControlLabel,
    Switch,
    Button,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
} from '@mui/material';

const API = '';
const TOGGLE_DEBOUNCE_MS = 300;
const MEMO_TYPES = [
    { value: 'other', label: 'その他' },
    { value: 'meeting', label: '例会' },
    { value: 'one_to_one', label: '1 to 1' },
    { value: 'introduction', label: '紹介' },
];

async function fetchJson(url) {
    const res = await fetch(`${API}${url}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

async function putFlags(ownerMemberId, targetMemberId, data) {
    const res = await fetch(
        `${API}/api/dragonfly/flags/${targetMemberId}?owner_member_id=${ownerMemberId}`,
        {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
            body: JSON.stringify(data),
        }
    );
    if (!res.ok) throw new Error(`PUT flags ${res.status}`);
    return res.json();
}

async function postContactMemo(payload) {
    const res = await fetch(`${API}/api/contact-memos`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
    });
    if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.message || `POST contact-memos ${res.status}`);
    }
    return res.json();
}

export default function DragonFlyBoard() {
    const [ownerMemberId, setOwnerMemberId] = useState(1);
    const [members, setMembers] = useState([]);
    const [targetMember, setTargetMember] = useState(null);
    const [summary, setSummary] = useState(null);
    const [loadingSummary, setLoadingSummary] = useState(false);
    const [pendingFlags, setPendingFlags] = useState(null);
    const debounceRef = useRef(null);

    // メモ追加モーダル
    const [memoOpen, setMemoOpen] = useState(false);
    const [memoBody, setMemoBody] = useState('');
    const [memoType, setMemoType] = useState('other');
    const [memoMeetingId, setMemoMeetingId] = useState('');
    const [memoOneToOneId, setMemoOneToOneId] = useState('');
    const [memoError, setMemoError] = useState('');
    const [memoSubmitting, setMemoSubmitting] = useState(false);

    const refetchMembers = useCallback(() => {
        fetchJson(`/api/dragonfly/members?owner_member_id=${ownerMemberId}&with_summary=1`)
            .then(setMembers)
            .catch((e) => console.error('members load failed', e));
    }, [ownerMemberId]);

    useEffect(() => {
        refetchMembers();
    }, [refetchMembers]);

    const loadSummary = useCallback(() => {
        if (!targetMember?.id || !ownerMemberId) return;
        setLoadingSummary(true);
        fetchJson(
            `/api/dragonfly/contacts/${targetMember.id}/summary?owner_member_id=${ownerMemberId}`
        )
            .then((s) => {
                setSummary(s);
                setPendingFlags(null);
            })
            .catch((e) => {
                console.error('summary load failed', e);
                setSummary(null);
                setPendingFlags(null);
            })
            .finally(() => setLoadingSummary(false));
    }, [targetMember?.id, ownerMemberId]);

    useEffect(() => {
        loadSummary();
    }, [loadSummary]);

    const handleToggle = (field, value) => {
        if (!targetMember?.id || !summary?.flags) return;
        const next = { ...summary.flags, [field]: value };
        setPendingFlags(next);

        if (debounceRef.current) clearTimeout(debounceRef.current);
        debounceRef.current = setTimeout(async () => {
            debounceRef.current = null;
            try {
                await putFlags(ownerMemberId, targetMember.id, {
                    interested: next.interested,
                    want_1on1: next.want_1on1,
                });
                loadSummary();
            } catch (e) {
                console.error('PUT flags failed', e);
                setPendingFlags(null);
            }
        }, TOGGLE_DEBOUNCE_MS);
    };

    const displayFlags = pendingFlags ?? summary?.flags ?? { interested: false, want_1on1: false };
    const latestMemos = summary?.latest_memos ?? [];
    const interestedReason = summary?.latest_interested_reason;

    const canSubmitMemo =
        memoBody.trim() !== '' &&
        (memoType !== 'meeting' || memoMeetingId.trim() !== '') &&
        (memoType !== 'one_to_one' || memoOneToOneId.trim() !== '');

    const openMemoDialog = () => {
        setMemoBody('');
        setMemoType('other');
        setMemoMeetingId('');
        setMemoOneToOneId('');
        setMemoError('');
        setMemoOpen(true);
    };

    const closeMemoDialog = () => {
        setMemoOpen(false);
        setMemoError('');
    };

    const submitMemo = async () => {
        if (!targetMember?.id || !ownerMemberId || !canSubmitMemo) return;
        setMemoSubmitting(true);
        setMemoError('');
        const payload = {
            owner_member_id: ownerMemberId,
            target_member_id: targetMember.id,
            memo_type: memoType,
            body: memoBody.trim(),
        };
        if (memoType === 'meeting' && memoMeetingId.trim() !== '') {
            payload.meeting_id = parseInt(memoMeetingId, 10);
        }
        if (memoType === 'one_to_one' && memoOneToOneId.trim() !== '') {
            payload.one_to_one_id = parseInt(memoOneToOneId, 10);
        }
        try {
            await postContactMemo(payload);
            refetchMembers();
            loadSummary();
            closeMemoDialog();
        } catch (e) {
            setMemoError(e.message || '保存に失敗しました');
        } finally {
            setMemoSubmitting(false);
        }
    };

    return (
        <Box sx={{ p: 2 }}>
            <Typography variant="h6" sx={{ mb: 2 }}>
                DragonFly Board
            </Typography>
            <Grid container spacing={2}>
                <Grid item xs={12} md={4}>
                    <TextField
                        label="Owner member ID"
                        type="number"
                        size="small"
                        value={ownerMemberId}
                        onChange={(e) => setOwnerMemberId(Number(e.target.value) || 1)}
                        sx={{ mb: 1 }}
                    />
                    <Autocomplete
                        options={members}
                        getOptionLabel={(m) => `${m.display_no || ''} ${m.name}`.trim() || `#${m.id}`}
                        value={targetMember}
                        onChange={(_, v) => setTargetMember(v)}
                        renderOption={(props, m) => {
                            const lite = m.summary_lite;
                            const contact = lite?.last_contact_at
                                ? new Date(lite.last_contact_at).toLocaleDateString('ja-JP')
                                : '未接触';
                            const sameRoom = lite?.same_room_count ?? 0;
                            const o2o = lite?.one_to_one_count ?? 0;
                            const memoShort = lite?.last_memo?.body_short ?? '';
                            return (
                                <li {...props} key={m.id}>
                                    <Box sx={{ width: '100%' }}>
                                        <Typography variant="body2">
                                            {`${m.display_no || ''} ${m.name}`.trim() || `#${m.id}`}
                                            {lite && (lite.interested || lite.want_1on1) && (
                                                <Typography component="span" variant="caption" color="primary" sx={{ ml: 1 }}>
                                                    {lite.interested && '気になる'}
                                                    {lite.interested && lite.want_1on1 && ' / '}
                                                    {lite.want_1on1 && '1on1'}
                                                </Typography>
                                            )}
                                        </Typography>
                                        {lite && (
                                            <Typography variant="caption" color="text.secondary" display="block">
                                                同室{sameRoom}回 / 1on1 {o2o}回 / 最終接触: {contact}
                                                {memoShort && ` / ${memoShort}`}
                                            </Typography>
                                        )}
                                    </Box>
                                </li>
                            );
                        }}
                        renderInput={(params) => (
                            <TextField {...params} label="メンバーを選択" size="small" />
                        )}
                    />
                </Grid>
                <Grid item xs={12} md={8}>
                    {loadingSummary && <Typography color="text.secondary">Loading...</Typography>}
                    {!targetMember && !loadingSummary && (
                        <Typography color="text.secondary">左でメンバーを選択してください</Typography>
                    )}
                    {targetMember && summary && !loadingSummary && (
                        <Card variant="outlined">
                            <CardContent>
                                <Typography variant="subtitle1">
                                    {targetMember.display_no} {targetMember.name}
                                </Typography>
                                <Box sx={{ mt: 1 }}>
                                    <FormControlLabel
                                        control={
                                            <Switch
                                                checked={!!displayFlags.interested}
                                                onChange={(_, v) =>
                                                    handleToggle('interested', v)
                                                }
                                            />
                                        }
                                        label="気になる"
                                    />
                                    <FormControlLabel
                                        control={
                                            <Switch
                                                checked={!!displayFlags.want_1on1}
                                                onChange={(_, v) =>
                                                    handleToggle('want_1on1', v)
                                                }
                                            />
                                        }
                                        label="1on1 したい"
                                    />
                                    <Button
                                        size="small"
                                        variant="outlined"
                                        onClick={openMemoDialog}
                                        sx={{ ml: 1 }}
                                    >
                                        メモ追加
                                    </Button>
                                </Box>
                                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                                    同室回数: {summary?.same_room_count ?? 0}
                                </Typography>
                                {interestedReason?.reason && (
                                    <Typography variant="body2" sx={{ mt: 1 }} color="text.secondary">
                                        気になる理由: {interestedReason.reason}
                                    </Typography>
                                )}
                                {latestMemos.length > 0 && (
                                    <Box sx={{ mt: 1 }}>
                                        <Typography variant="caption" color="text.secondary">
                                            メモ（直近{latestMemos.length}件）
                                        </Typography>
                                        {latestMemos.map((m) => (
                                            <Typography
                                                key={m.id}
                                                variant="body2"
                                                sx={{ display: 'block', mt: 0.5 }}
                                            >
                                                #{m.meeting_number}: {m.body || '(なし)'}
                                            </Typography>
                                        ))}
                                    </Box>
                                )}
                            </CardContent>
                        </Card>
                    )}
                </Grid>
            </Grid>
            <Dialog open={memoOpen} onClose={closeMemoDialog} maxWidth="sm" fullWidth>
                <DialogTitle>メモ追加</DialogTitle>
                <DialogContent>
                    <FormControl fullWidth size="small" sx={{ mt: 1 }}>
                        <InputLabel>種別</InputLabel>
                        <Select
                            value={memoType}
                            label="種別"
                            onChange={(e) => setMemoType(e.target.value)}
                        >
                            {MEMO_TYPES.map((t) => (
                                <MenuItem key={t.value} value={t.value}>
                                    {t.label}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                    <TextField
                        label="本文"
                        multiline
                        minRows={3}
                        fullWidth
                        required
                        value={memoBody}
                        onChange={(e) => setMemoBody(e.target.value)}
                        sx={{ mt: 2 }}
                    />
                    {memoType === 'meeting' && (
                        <TextField
                            label="meeting_id（数値）"
                            type="number"
                            size="small"
                            fullWidth
                            value={memoMeetingId}
                            onChange={(e) => setMemoMeetingId(e.target.value)}
                            sx={{ mt: 2 }}
                        />
                    )}
                    {memoType === 'one_to_one' && (
                        <TextField
                            label="one_to_one_id（数値）"
                            type="number"
                            size="small"
                            fullWidth
                            value={memoOneToOneId}
                            onChange={(e) => setMemoOneToOneId(e.target.value)}
                            sx={{ mt: 2 }}
                        />
                    )}
                    {memoError && (
                        <Typography color="error" variant="body2" sx={{ mt: 2 }}>
                            {memoError}
                        </Typography>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={closeMemoDialog}>キャンセル</Button>
                    <Button
                        variant="contained"
                        onClick={submitMemo}
                        disabled={!canSubmitMemo || memoSubmitting}
                    >
                        {memoSubmitting ? '送信中...' : '保存'}
                    </Button>
                </DialogActions>
            </Dialog>
        </Box>
    );
}
