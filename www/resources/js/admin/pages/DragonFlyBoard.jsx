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
    Tabs,
    Tab,
    Chip,
    IconButton,
    Snackbar,
} from '@mui/material';
import EditNoteIcon from '@mui/icons-material/EditNote';

const API = '';
const TOGGLE_DEBOUNCE_MS = 300;
const MEMO_TYPES = [
    { value: 'other', label: 'その他' },
    { value: 'meeting', label: '例会' },
    { value: 'one_to_one', label: '1 to 1' },
    { value: 'introduction', label: '紹介' },
];
const O2O_STATUSES = [
    { value: 'planned', label: '予定' },
    { value: 'completed', label: '実施済み' },
    { value: 'canceled', label: 'キャンセル' },
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

async function postOneToOne(payload) {
    const res = await fetch(`${API}/api/one-to-ones`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
    });
    if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.message || `POST one-to-ones ${res.status}`);
    }
    return res.json();
}

async function getMeetingBreakoutRounds(meetingId) {
    return fetchJson(`/api/meetings/${meetingId}/breakout-rounds`);
}

async function putMeetingBreakoutRounds(meetingId, payload) {
    const res = await fetch(`${API}/api/meetings/${meetingId}/breakout-rounds`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
    });
    if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.message || `PUT breakout-rounds ${res.status}`);
    }
    return res.json();
}

function RoomCard({
    roomLabel,
    notes,
    memberIds,
    members,
    assignedInRound,
    roundLabel,
    meetingNumber,
    onNotesChange,
    onAddMember,
    onRemoveMember,
    onMemoClick,
}) {
    const candidates = members.filter((m) => !assignedInRound.has(m.id));
    const [addValue, setAddValue] = useState(null);
    return (
        <Card variant="outlined" sx={{ height: '100%' }}>
            <CardContent>
                <Typography variant="subtitle1" sx={{ mb: 1 }}>
                    {roomLabel}
                </Typography>
                <TextField
                    label="ルームメモ"
                    multiline
                    minRows={2}
                    fullWidth
                    size="small"
                    value={notes}
                    onChange={(e) => onNotesChange(e.target.value)}
                    sx={{ mb: 2 }}
                />
                <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1 }}>
                    メンバー割当
                </Typography>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, alignItems: 'center', mb: 1 }}>
                    <Autocomplete
                        size="small"
                        sx={{ minWidth: 180, flex: '1 1 auto' }}
                        options={candidates}
                        getOptionLabel={(m) => `${m.display_no || ''} ${m.name}`.trim() || `#${m.id}`}
                        value={addValue}
                        onChange={(_, v) => {
                            if (v) {
                                onAddMember(v.id);
                                setAddValue(null);
                            }
                        }}
                        renderInput={(params) => <TextField {...params} placeholder="追加するメンバー" />}
                    />
                    <Button size="small" variant="outlined" onClick={() => addValue && (onAddMember(addValue.id), setAddValue(null))}>
                        追加
                    </Button>
                </Box>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5, alignItems: 'center' }}>
                    {memberIds.map((id) => {
                        const m = members.find((x) => x.id === id);
                        const label = m ? `${m.display_no || ''} ${m.name}`.trim() || `#${id}` : `#${id}`;
                        return (
                            <Box key={id} sx={{ display: 'inline-flex', alignItems: 'center', gap: 0.25, mr: 0.5, mb: 0.5 }}>
                                <Chip
                                    size="small"
                                    label={label}
                                    onDelete={() => onRemoveMember(id)}
                                />
                                <IconButton
                                    size="small"
                                    onClick={() => onMemoClick(id)}
                                    aria-label="メモ"
                                    sx={{ p: 0.25 }}
                                >
                                    <EditNoteIcon fontSize="small" />
                                </IconButton>
                            </Box>
                        );
                    })}
                </Box>
            </CardContent>
        </Card>
    );
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

    // 1 to 1 登録モーダル
    const [o2oOpen, setO2oOpen] = useState(false);
    const [firstWorkspace, setFirstWorkspace] = useState(null);
    const [workspaceLoadError, setWorkspaceLoadError] = useState('');
    const [o2oStatus, setO2oStatus] = useState('planned');
    const [o2oScheduledAt, setO2oScheduledAt] = useState('');
    const [o2oStartedAt, setO2oStartedAt] = useState('');
    const [o2oEndedAt, setO2oEndedAt] = useState('');
    const [o2oNotes, setO2oNotes] = useState('');
    const [o2oMeetingId, setO2oMeetingId] = useState('');
    const [o2oError, setO2oError] = useState('');
    const [o2oSubmitting, setO2oSubmitting] = useState(false);

    // Meeting + Round（Phase10R のみ。固定 BO は UI から撤去）
    const [meetings, setMeetings] = useState([]);
    const [selectedMeetingId, setSelectedMeetingId] = useState('');
    const [selectedMeeting, setSelectedMeeting] = useState(null);
    const [roundsEdit, setRoundsEdit] = useState([]);
    const [roundsLoading, setRoundsLoading] = useState(false);
    const [roundsSaving, setRoundsSaving] = useState(false);
    const [roundsError, setRoundsError] = useState('');
    const [selectedRoundIndex, setSelectedRoundIndex] = useState(0);
    const [saveStatus, setSaveStatus] = useState('idle'); // 'idle' | 'loading' | 'saved' | 'unsaved'
    const [dirty, setDirty] = useState(false);
    const savedTimeoutRef = useRef(null);

    // メモモーダル（BO から開くときの文脈）
    const [memoContextTargetMemberId, setMemoContextTargetMemberId] = useState(null);
    const [memoContextMeetingId, setMemoContextMeetingId] = useState(null);
    const [memoContextRoundLabel, setMemoContextRoundLabel] = useState('');
    const [memoContextRoomLabel, setMemoContextRoomLabel] = useState('');
    const [snackbarMessage, setSnackbarMessage] = useState('');

    const refetchMembers = useCallback(() => {
        fetchJson(`/api/dragonfly/members?owner_member_id=${ownerMemberId}&with_summary=1`)
            .then(setMembers)
            .catch((e) => console.error('members load failed', e));
    }, [ownerMemberId]);

    useEffect(() => {
        refetchMembers();
    }, [refetchMembers]);

    useEffect(() => {
        fetchJson('/api/workspaces')
            .then((data) => {
                if (Array.isArray(data) && data.length > 0) {
                    setFirstWorkspace({ id: data[0].id, name: data[0].name || `ID: ${data[0].id}` });
                    setWorkspaceLoadError('');
                } else {
                    setFirstWorkspace(null);
                    setWorkspaceLoadError('workspace が未作成です。seed で 1 件作成してください。');
                }
            })
            .catch(() => {
                setFirstWorkspace(null);
                setWorkspaceLoadError('workspace の取得に失敗しました。');
            });
    }, []);

    useEffect(() => {
        getMeetings().then(setMeetings).catch(() => setMeetings([]));
    }, []);

    useEffect(() => {
        getMeetings().then(setMeetings).catch(() => setMeetings([]));
    }, []);

    useEffect(() => {
        if (!selectedMeetingId) {
            setRoundsEdit([]);
            setSelectedMeeting(null);
            setSaveStatus('idle');
            setDirty(false);
            return;
        }
        const meeting = meetings.find((m) => String(m.id) === String(selectedMeetingId));
        setSelectedMeeting(meeting || null);
        setRoundsLoading(true);
        setRoundsError('');
        setSaveStatus('loading');
        getMeetingBreakoutRounds(selectedMeetingId)
            .then((data) => {
                const rounds = Array.isArray(data.rounds) ? data.rounds : [];
                setRoundsEdit(rounds.map((r) => ({
                    round_no: r.round_no,
                    label: r.label ?? `Round ${r.round_no}`,
                    rooms: (r.rooms ?? []).map((room) => ({
                        room_label: room.room_label,
                        notes: room.notes ?? '',
                        member_ids: Array.isArray(room.member_ids) ? [...room.member_ids] : [],
                    })),
                })));
            })
            .catch((e) => {
                setRoundsError(e.message || 'Round 取得に失敗しました');
                setRoundsEdit([]);
            })
            .finally(() => {
                setRoundsLoading(false);
                setSaveStatus('idle');
                setDirty(false);
            });
    }, [selectedMeetingId, meetings]);

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
        (memoType !== 'meeting' || memoContextMeetingId != null || memoMeetingId.trim() !== '') &&
        (memoType !== 'one_to_one' || memoOneToOneId.trim() !== '');

    const openMemoDialog = () => {
        setMemoBody('');
        setMemoType('other');
        setMemoMeetingId('');
        setMemoOneToOneId('');
        setMemoError('');
        setMemoContextTargetMemberId(null);
        setMemoContextMeetingId(null);
        setMemoOpen(true);
    };

    const openMemoDialogForMeetingMember = (meetingId, memberId, roundLabel, roomLabel) => {
        setMemoBody('');
        setMemoType('meeting');
        setMemoMeetingId(String(meetingId));
        setMemoOneToOneId('');
        setMemoError('');
        setMemoContextTargetMemberId(memberId);
        setMemoContextMeetingId(meetingId);
        setMemoContextRoundLabel(roundLabel ?? '');
        setMemoContextRoomLabel(roomLabel ?? '');
        setMemoOpen(true);
    };

    const closeMemoDialog = () => {
        setMemoOpen(false);
        setMemoError('');
        setMemoContextTargetMemberId(null);
        setMemoContextMeetingId(null);
        setMemoContextRoundLabel('');
        setMemoContextRoomLabel('');
    };

    const submitMemo = async () => {
        const targetId = memoContextTargetMemberId ?? targetMember?.id;
        if (!targetId || !ownerMemberId || !canSubmitMemo) return;
        if (memoType === 'meeting' && !(memoContextMeetingId ?? memoMeetingId.trim())) return;
        setMemoSubmitting(true);
        setMemoError('');
        const payload = {
            owner_member_id: ownerMemberId,
            target_member_id: targetId,
            memo_type: memoType,
            body: memoBody.trim(),
        };
        if (memoType === 'meeting') {
            payload.meeting_id = memoContextMeetingId ?? parseInt(memoMeetingId, 10);
        }
        if (memoType === 'one_to_one' && memoOneToOneId.trim() !== '') {
            payload.one_to_one_id = parseInt(memoOneToOneId, 10);
        }
        try {
            await postContactMemo(payload);
            refetchMembers();
            loadSummary();
            if (memoContextTargetMemberId != null) {
                setSnackbarMessage('保存しました');
                setMemoBody('');
                setMemoError('');
            } else {
                closeMemoDialog();
                setMemoContextTargetMemberId(null);
                setMemoContextMeetingId(null);
            }
        } catch (e) {
            setMemoError(e.message || '保存に失敗しました');
        } finally {
            setMemoSubmitting(false);
        }
    };

    const canSubmitO2o = firstWorkspace != null;

    const openO2oDialog = () => {
        setO2oStatus('planned');
        setO2oScheduledAt('');
        setO2oStartedAt('');
        setO2oEndedAt('');
        setO2oNotes('');
        setO2oMeetingId('');
        setO2oError('');
        setO2oOpen(true);
    };

    const closeO2oDialog = () => {
        setO2oOpen(false);
        setO2oError('');
    };

    const toDateTimeLocal = (s) => {
        if (!s || s.trim() === '') return null;
        const t = s.trim().replace('T', ' ');
        return t.length <= 16 ? `${t}:00` : t;
    };

    const submitO2o = async () => {
        if (!targetMember?.id || !ownerMemberId || !canSubmitO2o) return;
        setO2oSubmitting(true);
        setO2oError('');
        const payload = {
            workspace_id: firstWorkspace.id,
            owner_member_id: ownerMemberId,
            target_member_id: targetMember.id,
            status: o2oStatus,
        };
        if (o2oScheduledAt.trim()) payload.scheduled_at = toDateTimeLocal(o2oScheduledAt);
        if (o2oStartedAt.trim()) payload.started_at = toDateTimeLocal(o2oStartedAt);
        if (o2oEndedAt.trim()) payload.ended_at = toDateTimeLocal(o2oEndedAt);
        if (o2oNotes.trim()) payload.notes = o2oNotes.trim();
        if (o2oMeetingId.trim()) payload.meeting_id = parseInt(o2oMeetingId, 10);
        try {
            await postOneToOne(payload);
            refetchMembers();
            loadSummary();
            closeO2oDialog();
        } catch (e) {
            setO2oError(e.message || '登録に失敗しました');
        } finally {
            setO2oSubmitting(false);
        }
    };

    const addRound = () => {
        setDirty(true);
        const maxNo = roundsEdit.length === 0 ? 0 : Math.max(...roundsEdit.map((r) => r.round_no));
        setRoundsEdit((prev) => [
            ...prev,
            {
                round_no: maxNo + 1,
                label: `Round ${maxNo + 1}`,
                rooms: [
                    { room_label: 'BO1', notes: '', member_ids: [] },
                    { room_label: 'BO2', notes: '', member_ids: [] },
                ],
            },
        ]);
    };

    const toggleRoundMember = (roundIndex, roomLabel, memberId) => {
        setDirty(true);
        setRoundsEdit((prev) => {
            const next = prev.map((r, i) => {
                if (i !== roundIndex) return r;
                const rooms = r.rooms.map((room) => {
                    if (room.room_label !== roomLabel) return room;
                    const ids = room.member_ids.includes(memberId)
                        ? room.member_ids.filter((id) => id !== memberId)
                        : [...room.member_ids, memberId];
                    return { ...room, member_ids: ids };
                });
                return { ...r, rooms };
            });
            return next;
        });
    };

    const setRoundRoomNotes = (roundIndex, roomLabel, notes) => {
        setDirty(true);
        setRoundsEdit((prev) =>
            prev.map((r, i) => {
                if (i !== roundIndex) return r;
                const rooms = r.rooms.map((room) =>
                    room.room_label === roomLabel ? { ...room, notes } : room
                );
                return { ...r, rooms };
            })
        );
    };

    const saveRounds = async () => {
        if (!selectedMeetingId) return;
        const allIdsByRound = roundsEdit.map((r) => {
            const ids = (r.rooms ?? []).flatMap((room) => room.member_ids ?? []);
            return ids;
        });
        for (let i = 0; i < allIdsByRound.length; i++) {
            const ids = allIdsByRound[i];
            if (ids.length !== new Set(ids).size) {
                setRoundsError(`Round ${roundsEdit[i].round_no} 内で同一メンバーを複数ルームに割り当てることはできません。`);
                return;
            }
        }
        setRoundsSaving(true);
        setRoundsError('');
        setSaveStatus('loading');
        try {
            const payload = {
                rounds: roundsEdit.map((r) => ({
                    round_no: r.round_no,
                    label: r.label,
                    rooms: r.rooms.map((room) => ({
                        room_label: room.room_label,
                        notes: room.notes || null,
                        member_ids: room.member_ids ?? [],
                    })),
                })),
            };
            await putMeetingBreakoutRounds(selectedMeetingId, payload);
            const data = await getMeetingBreakoutRounds(selectedMeetingId);
            const rounds = Array.isArray(data.rounds) ? data.rounds : [];
            setRoundsEdit(rounds.map((r) => ({
                round_no: r.round_no,
                label: r.label ?? `Round ${r.round_no}`,
                rooms: (r.rooms ?? []).map((room) => ({
                    room_label: room.room_label,
                    notes: room.notes ?? '',
                    member_ids: Array.isArray(room.member_ids) ? [...room.member_ids] : [],
                })),
            })));
            refetchMembers();
            setDirty(false);
            setSaveStatus('saved');
            if (savedTimeoutRef.current) clearTimeout(savedTimeoutRef.current);
            savedTimeoutRef.current = setTimeout(() => {
                setSaveStatus('idle');
                savedTimeoutRef.current = null;
            }, 3000);
        } catch (e) {
            setRoundsError(e.message || '保存に失敗しました');
            setSaveStatus('idle');
        } finally {
            setRoundsSaving(false);
        }
    };

    const statusChipLabel =
        roundsLoading ? 'Loading' :
        roundsSaving ? '保存中...' :
        saveStatus === 'saved' ? 'Saved' :
        dirty ? 'Unsaved' : null;

    useEffect(() => {
        const onBeforeUnload = (e) => {
            if (dirty) e.preventDefault();
        };
        window.addEventListener('beforeunload', onBeforeUnload);
        return () => window.removeEventListener('beforeunload', onBeforeUnload);
    }, [dirty]);

    return (
        <Box sx={{ p: 2 }}>
            <Box sx={{ display: 'flex', alignItems: 'center', flexWrap: 'wrap', gap: 2, mb: 2 }}>
                <Typography variant="h6">Board（会の地図）</Typography>
                <Autocomplete
                    size="small"
                    sx={{ minWidth: 220 }}
                    options={meetings}
                    getOptionLabel={(m) => `#${m.number} ${m.held_on}`}
                    value={selectedMeeting ? { id: selectedMeeting.id, number: selectedMeeting.number, held_on: selectedMeeting.held_on } : null}
                    onChange={(_, v) => {
                        setSelectedMeetingId(v ? String(v.id) : '');
                        setSelectedRoundIndex(0);
                    }}
                    isOptionEqualToValue={(a, b) => a?.id === b?.id}
                    renderInput={(params) => <TextField {...params} label="Meeting" />}
                />
                {statusChipLabel && (
                    <Chip
                        label={statusChipLabel}
                        size="small"
                        color={statusChipLabel === 'Saved' ? 'success' : statusChipLabel === 'Unsaved' ? 'warning' : 'default'}
                        variant="outlined"
                    />
                )}
            </Box>
            {roundsError && (
                <Typography color="error" variant="body2" sx={{ mb: 1 }}>
                    {roundsError}
                </Typography>
            )}
            {selectedMeetingId && (
                <Grid container spacing={2} sx={{ mb: 2 }}>
                    <Grid item xs={12} md={3}>
                        <Tabs
                            orientation="vertical"
                            value={Math.min(selectedRoundIndex, Math.max(0, roundsEdit.length - 1))}
                            onChange={(_, v) => setSelectedRoundIndex(v)}
                            sx={{ borderRight: 1, borderColor: 'divider' }}
                        >
                            {roundsEdit.map((round, idx) => (
                                <Tab key={`round-${round.round_no}`} label={round.label ?? `Round ${round.round_no}`} id={`round-tab-${idx}`} />
                            ))}
                        </Tabs>
                        <Button variant="outlined" size="small" onClick={addRound} sx={{ mt: 1 }}>
                            ＋ Round
                        </Button>
                    </Grid>
                    <Grid item xs={12} md={9}>
                        {roundsLoading ? (
                            <Typography color="text.secondary">Loading...</Typography>
                        ) : roundsEdit.length > 0 ? (
                            (() => {
                                const round = roundsEdit[selectedRoundIndex] ?? roundsEdit[0];
                                const roundIdx = roundsEdit.indexOf(round);
                                const bo1 = round.rooms?.find((r) => r.room_label === 'BO1') ?? { room_label: 'BO1', notes: '', member_ids: [] };
                                const bo2 = round.rooms?.find((r) => r.room_label === 'BO2') ?? { room_label: 'BO2', notes: '', member_ids: [] };
                                const assignedInRound = new Set((round.rooms ?? []).flatMap((room) => room.member_ids ?? []));
                                const roundLabel = round.label ?? `Round ${round.round_no}`;
                                return (
                                    <Card variant="outlined">
                                        <CardContent>
                                            <TextField
                                                size="small"
                                                label="Round 名"
                                                value={round.label ?? ''}
                                                onChange={(e) => {
                                                    setDirty(true);
                                                    setRoundsEdit((prev) => prev.map((r, i) => (i === roundIdx ? { ...r, label: e.target.value } : r)));
                                                }}
                                                sx={{ mb: 2, minWidth: 200 }}
                                            />
                                            <Grid container spacing={2}>
                                                <Grid item xs={12} md={6}>
                                                    <RoomCard
                                                        roomLabel="BO1"
                                                        notes={bo1.notes}
                                                        memberIds={bo1.member_ids ?? []}
                                                        members={members}
                                                        assignedInRound={assignedInRound}
                                                        roundLabel={roundLabel}
                                                        meetingNumber={selectedMeeting?.number}
                                                        onNotesChange={(notes) => setRoundRoomNotes(roundIdx, 'BO1', notes)}
                                                        onAddMember={(memberId) => toggleRoundMember(roundIdx, 'BO1', memberId)}
                                                        onRemoveMember={(memberId) => toggleRoundMember(roundIdx, 'BO1', memberId)}
                                                        onMemoClick={(memberId) => openMemoDialogForMeetingMember(selectedMeetingId, memberId, roundLabel, 'BO1')}
                                                    />
                                                </Grid>
                                                <Grid item xs={12} md={6}>
                                                    <RoomCard
                                                        roomLabel="BO2"
                                                        notes={bo2.notes}
                                                        memberIds={bo2.member_ids ?? []}
                                                        members={members}
                                                        assignedInRound={assignedInRound}
                                                        roundLabel={roundLabel}
                                                        meetingNumber={selectedMeeting?.number}
                                                        onNotesChange={(notes) => setRoundRoomNotes(roundIdx, 'BO2', notes)}
                                                        onAddMember={(memberId) => toggleRoundMember(roundIdx, 'BO2', memberId)}
                                                        onRemoveMember={(memberId) => toggleRoundMember(roundIdx, 'BO2', memberId)}
                                                        onMemoClick={(memberId) => openMemoDialogForMeetingMember(selectedMeetingId, memberId, roundLabel, 'BO2')}
                                                    />
                                                </Grid>
                                            </Grid>
                                            <Button
                                                variant="contained"
                                                onClick={saveRounds}
                                                disabled={roundsSaving || roundsLoading}
                                                sx={{ mt: 2 }}
                                            >
                                                Round 割当を保存
                                            </Button>
                                        </CardContent>
                                    </Card>
                                );
                            })()
                        ) : (
                            <Typography color="text.secondary">＋ Round で追加してください</Typography>
                        )}
                    </Grid>
                </Grid>
            )}
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
                                    <Button
                                        size="small"
                                        variant="outlined"
                                        onClick={openO2oDialog}
                                        sx={{ ml: 1 }}
                                    >
                                        1 to 1 登録
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
                    {memoContextTargetMemberId != null && (
                        <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                            Meeting #{selectedMeeting?.number ?? memoContextMeetingId} / {memoContextRoundLabel || 'Round'} / {memoContextRoomLabel || 'Room'} / 相手: {members.find((m) => m.id === memoContextTargetMemberId)?.name ?? `#${memoContextTargetMemberId}`}（例会メモ）
                        </Typography>
                    )}
                    <FormControl fullWidth size="small" sx={{ mt: 1 }} disabled={memoContextTargetMemberId != null}>
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
                    {memoType === 'meeting' && memoContextMeetingId == null && (
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
            <Dialog open={o2oOpen} onClose={closeO2oDialog} maxWidth="sm" fullWidth>
                <DialogTitle>1 to 1 登録</DialogTitle>
                <DialogContent>
                    {firstWorkspace ? (
                        <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                            ワークスペース: {firstWorkspace.name} (ID: {firstWorkspace.id})
                        </Typography>
                    ) : (
                        <Typography color="error" variant="body2" sx={{ mt: 1 }}>
                            {workspaceLoadError}
                        </Typography>
                    )}
                    <FormControl fullWidth size="small" sx={{ mt: 2 }}>
                        <InputLabel>状態</InputLabel>
                        <Select
                            value={o2oStatus}
                            label="状態"
                            onChange={(e) => setO2oStatus(e.target.value)}
                        >
                            {O2O_STATUSES.map((s) => (
                                <MenuItem key={s.value} value={s.value}>
                                    {s.label}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                    <TextField
                        label="予定日時"
                        type="datetime-local"
                        size="small"
                        fullWidth
                        value={o2oScheduledAt}
                        onChange={(e) => setO2oScheduledAt(e.target.value)}
                        InputLabelProps={{ shrink: true }}
                        sx={{ mt: 2 }}
                    />
                    <TextField
                        label="開始日時"
                        type="datetime-local"
                        size="small"
                        fullWidth
                        value={o2oStartedAt}
                        onChange={(e) => setO2oStartedAt(e.target.value)}
                        InputLabelProps={{ shrink: true }}
                        sx={{ mt: 1 }}
                    />
                    <TextField
                        label="終了日時"
                        type="datetime-local"
                        size="small"
                        fullWidth
                        value={o2oEndedAt}
                        onChange={(e) => setO2oEndedAt(e.target.value)}
                        InputLabelProps={{ shrink: true }}
                        sx={{ mt: 1 }}
                    />
                    <TextField
                        label="meeting_id（任意）"
                        type="number"
                        size="small"
                        fullWidth
                        value={o2oMeetingId}
                        onChange={(e) => setO2oMeetingId(e.target.value)}
                        sx={{ mt: 2 }}
                    />
                    <TextField
                        label="メモ"
                        multiline
                        minRows={2}
                        fullWidth
                        value={o2oNotes}
                        onChange={(e) => setO2oNotes(e.target.value)}
                        sx={{ mt: 1 }}
                    />
                    {o2oError && (
                        <Typography color="error" variant="body2" sx={{ mt: 2 }}>
                            {o2oError}
                        </Typography>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={closeO2oDialog}>キャンセル</Button>
                    <Button
                        variant="contained"
                        onClick={submitO2o}
                        disabled={!canSubmitO2o || o2oSubmitting}
                    >
                        {o2oSubmitting ? '送信中...' : '登録'}
                    </Button>
                </DialogActions>
            </Dialog>
            <Snackbar
                open={!!snackbarMessage}
                autoHideDuration={3000}
                onClose={() => setSnackbarMessage('')}
                message={snackbarMessage}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
            />
        </Box>
    );
}
