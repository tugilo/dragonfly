import React, { useState, useEffect, useCallback, createContext, useContext } from 'react';
import {
    List,
    Datagrid,
    TextField,
    FunctionField,
    TopToolbar,
    Button,
    useRefresh,
    useNotify,
} from 'react-admin';
import { Link } from 'react-router-dom';
import {
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    TextField as MuiTextField,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    FormControlLabel,
    Checkbox,
    Box,
    Typography,
} from '@mui/material';

const API = '';
const OWNER_MEMBER_ID = 1;

async function fetchJson(url) {
    const res = await fetch(`${API}${url}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
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

const MembersModalContext = createContext(null);

function MembersListActions() {
    return (
        <TopToolbar>
            <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connectionsへ</Button>
            <Button variant="outlined" size="small" disabled>＋ メンバー追加（将来）</Button>
        </TopToolbar>
    );
}

function SameRoomCountField({ record }) {
    const n = record?.summary_lite?.same_room_count;
    if (n == null) return <span>—</span>;
    return <span>{n}</span>;
}

function LastMemoField({ record }) {
    const body = record?.summary_lite?.last_memo?.body_short;
    if (!body) return <span>—</span>;
    return <span title={body}>{body.length > 20 ? `${body.slice(0, 20)}…` : body}</span>;
}

function MemberRowActions({ record }) {
    const ctx = useContext(MembersModalContext);
    if (!ctx || !record) return null;
    return (
        <Box sx={{ display: 'flex', gap: 0.5, flexWrap: 'wrap' }}>
            <Button size="small" variant="contained" onClick={() => ctx.openMemo(record)}>✏️ メモ</Button>
            <Button size="small" variant="outlined" onClick={() => ctx.openO2o(record)}>📅 1to1</Button>
            <Button size="small" variant="text" onClick={() => ctx.openO2oMemo(record)}>📝 1to1メモ</Button>
        </Box>
    );
}

function MemoModal({ open, member, onClose, onSaved }) {
    const [memoType, setMemoType] = useState('other');
    const [body, setBody] = useState('');
    const [meetingId, setMeetingId] = useState('');
    const [oneToOneId, setOneToOneId] = useState('');
    const [important, setImportant] = useState(false);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [meetings, setMeetings] = useState([]);
    const notify = useNotify();

    useEffect(() => {
        if (open) {
            setBody('');
            setMemoType('other');
            setMeetingId('');
            setOneToOneId('');
            setImportant(false);
            setError('');
        }
    }, [open, member?.id]);

    useEffect(() => {
        if (open) fetchJson('/api/meetings').then(setMeetings).catch(() => setMeetings([]));
    }, [open]);

    const handleSave = async () => {
        if (!member?.id || !body.trim()) return;
        setLoading(true);
        setError('');
        const payload = {
            owner_member_id: OWNER_MEMBER_ID,
            target_member_id: member.id,
            memo_type: memoType,
            body: body.trim(),
        };
        if (memoType === 'meeting' && meetingId) payload.meeting_id = parseInt(meetingId, 10);
        if (memoType === 'one_to_one' && oneToOneId) payload.one_to_one_id = parseInt(oneToOneId, 10);
        try {
            await postContactMemo(payload);
            notify('メモを保存しました');
            onSaved?.();
            onClose();
        } catch (e) {
            setError(e.message || '保存に失敗しました');
        } finally {
            setLoading(false);
        }
    };

    if (!open) return null;
    return (
        <Dialog open onClose={onClose} maxWidth="sm" fullWidth>
            <DialogTitle>✏️ メモ追加 <Typography component="span" variant="body2" color="text.secondary" fontWeight={400}>— {member?.name}</Typography></DialogTitle>
            <DialogContent>
                <FormControl fullWidth size="small" sx={{ mt: 1 }}>
                    <InputLabel>メモ種別</InputLabel>
                    <Select value={memoType} label="メモ種別" onChange={(e) => setMemoType(e.target.value)}>
                        <MenuItem value="other">other（その他）</MenuItem>
                        <MenuItem value="meeting">meeting（例会メモ）</MenuItem>
                        <MenuItem value="one_to_one">one_to_one（1to1メモ）</MenuItem>
                    </Select>
                </FormControl>
                {memoType === 'meeting' && (
                    <FormControl fullWidth size="small" sx={{ mt: 2 }}>
                        <InputLabel>例会（任意）</InputLabel>
                        <Select value={meetingId} label="例会（任意）" onChange={(e) => setMeetingId(e.target.value)}>
                            <MenuItem value="">—</MenuItem>
                            {meetings.map((m) => (
                                <MenuItem key={m.id} value={String(m.id)}>#{m.number} — {m.held_on}</MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                )}
                {memoType === 'one_to_one' && (
                    <MuiTextField label="1to1 ID（任意）" type="number" size="small" fullWidth value={oneToOneId} onChange={(e) => setOneToOneId(e.target.value)} sx={{ mt: 2 }} />
                )}
                <MuiTextField label="本文" multiline rows={4} fullWidth placeholder="メモ内容を入力…" value={body} onChange={(e) => setBody(e.target.value)} sx={{ mt: 2 }} />
                <FormControlLabel control={<Checkbox checked={important} onChange={(e) => setImportant(e.target.checked)} />} label="重要フラグを立てる" sx={{ mt: 1 }} />
                {error && <Typography color="error" variant="body2" sx={{ mt: 2 }}>{error}</Typography>}
            </DialogContent>
            <DialogActions sx={{ bgcolor: 'grey.50' }}>
                <Button onClick={onClose}>キャンセル</Button>
                <Button variant="contained" onClick={handleSave} disabled={!body.trim() || loading}>{loading ? '保存中…' : '保存する'}</Button>
            </DialogActions>
        </Dialog>
    );
}

function O2oModal({ open, member, onClose, onSaved }) {
    const [workspaceId, setWorkspaceId] = useState(null);
    const [scheduledAt, setScheduledAt] = useState('');
    const [status, setStatus] = useState('planned');
    const [meetingId, setMeetingId] = useState('');
    const [notes, setNotes] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [meetings, setMeetings] = useState([]);
    const notify = useNotify();

    useEffect(() => {
        if (open) {
            setScheduledAt('2025-08-20T12:00:00');
            setStatus('planned');
            setMeetingId('');
            setNotes('');
            setError('');
        }
    }, [open, member?.id]);

    useEffect(() => {
        if (open) {
            fetchJson('/api/workspaces').then((arr) => {
                if (Array.isArray(arr) && arr.length > 0) setWorkspaceId(arr[0].id);
                else setWorkspaceId(null);
            }).catch(() => setWorkspaceId(null));
            fetchJson('/api/meetings').then(setMeetings).catch(() => setMeetings([]));
        }
    }, [open]);

    const handleSave = async () => {
        if (!member?.id || !workspaceId) {
            setError('ワークスペースが取得できていません');
            return;
        }
        setLoading(true);
        setError('');
        const payload = {
            workspace_id: workspaceId,
            owner_member_id: OWNER_MEMBER_ID,
            target_member_id: member.id,
            status,
            notes: notes.trim() || undefined,
        };
        if (scheduledAt) payload.scheduled_at = scheduledAt.replace('T', ' ').slice(0, 19) + ':00';
        if (meetingId) payload.meeting_id = parseInt(meetingId, 10);
        try {
            await postOneToOne(payload);
            notify('1to1予定を保存しました');
            onSaved?.();
            onClose();
        } catch (e) {
            setError(e.message || '保存に失敗しました');
        } finally {
            setLoading(false);
        }
    };

    if (!open) return null;
    return (
        <Dialog open onClose={onClose} maxWidth="sm" fullWidth>
            <DialogTitle>📅 1to1予定作成 <Typography component="span" variant="body2" color="text.secondary" fontWeight={400}>— {member?.name}</Typography></DialogTitle>
            <DialogContent>
                <Box sx={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 2, mt: 1 }}>
                    <MuiTextField label="日付" type="date" size="small" fullWidth value={scheduledAt ? scheduledAt.slice(0, 10) : ''} onChange={(e) => setScheduledAt(e.target.value + 'T' + (scheduledAt ? scheduledAt.slice(11, 16) : '12:00') + ':00')} InputLabelProps={{ shrink: true }} />
                    <MuiTextField label="時刻" type="time" size="small" fullWidth value={scheduledAt ? scheduledAt.slice(11, 16) : '12:00'} onChange={(e) => setScheduledAt((scheduledAt || '2025-08-20T12:00:00').slice(0, 10) + 'T' + e.target.value + ':00')} InputLabelProps={{ shrink: true }} />
                </Box>
                <FormControl fullWidth size="small" sx={{ mt: 2 }}>
                    <InputLabel>ステータス</InputLabel>
                    <Select value={status} label="ステータス" onChange={(e) => setStatus(e.target.value)}>
                        <MenuItem value="planned">planned（予定）</MenuItem>
                        <MenuItem value="completed">completed（完了）</MenuItem>
                        <MenuItem value="canceled">canceled（キャンセル）</MenuItem>
                    </Select>
                </FormControl>
                <FormControl fullWidth size="small" sx={{ mt: 2 }}>
                    <InputLabel>関連例会（任意）</InputLabel>
                    <Select value={meetingId} label="関連例会（任意）" onChange={(e) => setMeetingId(e.target.value)}>
                        <MenuItem value="">—</MenuItem>
                        {meetings.map((m) => (
                            <MenuItem key={m.id} value={String(m.id)}>#{m.number} — {m.held_on}</MenuItem>
                        ))}
                    </Select>
                </FormControl>
                <MuiTextField label="メモ / アジェンダ" multiline rows={3} fullWidth placeholder="打ち合わせ内容、目的など…" value={notes} onChange={(e) => setNotes(e.target.value)} sx={{ mt: 2 }} />
                {error && <Typography color="error" variant="body2" sx={{ mt: 2 }}>{error}</Typography>}
            </DialogContent>
            <DialogActions sx={{ bgcolor: 'grey.50' }}>
                <Button onClick={onClose}>キャンセル</Button>
                <Button variant="contained" onClick={handleSave} disabled={!workspaceId || loading}>{loading ? '保存中…' : '保存する'}</Button>
            </DialogActions>
        </Dialog>
    );
}

function O2oMemoModal({ open, member, onClose, onSaved }) {
    const [body, setBody] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const notify = useNotify();

    useEffect(() => {
        if (open) { setBody(''); setError(''); }
    }, [open, member?.id]);

    const handleSave = async () => {
        if (!member?.id || !body.trim()) return;
        setLoading(true);
        setError('');
        try {
            await postContactMemo({
                owner_member_id: OWNER_MEMBER_ID,
                target_member_id: member.id,
                memo_type: 'one_to_one',
                body: body.trim(),
            });
            notify('1to1メモを保存しました');
            onSaved?.();
            onClose();
        } catch (e) {
            setError(e.message || '保存に失敗しました');
        } finally {
            setLoading(false);
        }
    };

    if (!open) return null;
    return (
        <Dialog open onClose={onClose} maxWidth="sm" fullWidth>
            <DialogTitle>📝 1to1メモ <Typography component="span" variant="body2" color="text.secondary" fontWeight={400}>— {member?.name}</Typography></DialogTitle>
            <DialogContent>
                <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ display: 'block', mb: 1 }}>過去の1to1履歴</Typography>
                <Box sx={{ bgcolor: 'grey.100', borderRadius: 1, p: 1.5, maxHeight: 140, overflow: 'auto' }}>
                    <Typography variant="body2" color="text.secondary">（一覧は API 連携後に表示）</Typography>
                </Box>
                <MuiTextField label="今回のメモ" multiline rows={4} fullWidth placeholder="今回の1to1で話した内容…" value={body} onChange={(e) => setBody(e.target.value)} sx={{ mt: 2 }} />
                {error && <Typography color="error" variant="body2" sx={{ mt: 2 }}>{error}</Typography>}
            </DialogContent>
            <DialogActions sx={{ bgcolor: 'grey.50' }}>
                <Button onClick={onClose}>キャンセル</Button>
                <Button variant="contained" onClick={handleSave} disabled={!body.trim() || loading}>{loading ? '保存中…' : '保存する'}</Button>
            </DialogActions>
        </Dialog>
    );
}

export function MembersList() {
    const [memoOpen, setMemoOpen] = useState(false);
    const [memoMember, setMemoMember] = useState(null);
    const [o2oOpen, setO2oOpen] = useState(false);
    const [o2oMember, setO2oMember] = useState(null);
    const [o2oMemoOpen, setO2oMemoOpen] = useState(false);
    const [o2oMemoMember, setO2oMemoMember] = useState(null);
    const refresh = useRefresh();

    const openMemo = useCallback((member) => {
        setMemoMember(member);
        setMemoOpen(true);
    }, []);
    const openO2o = useCallback((member) => {
        setO2oMember(member);
        setO2oOpen(true);
    }, []);
    const openO2oMemo = useCallback((member) => {
        setO2oMemoMember(member);
        setO2oMemoOpen(true);
    }, []);

    const onSaved = useCallback(() => { refresh(); }, [refresh]);

    return (
        <>
            <MembersModalContext.Provider value={{ openMemo, openO2o, openO2oMemo }}>
                <List
                    title="Members"
                    actions={<MembersListActions />}
                    perPage={25}
                >
                    <Datagrid rowClick={false}>
                        <TextField source="display_no" label="番号" emptyText="—" />
                        <TextField source="name" label="名前" />
                        <FunctionField label="同室回数" render={(r) => <SameRoomCountField record={r} />} />
                        <FunctionField label="直近メモ" render={(r) => <LastMemoField record={r} />} />
                        <FunctionField label="Actions" render={(r) => <MemberRowActions record={r} />} />
                    </Datagrid>
                </List>
            </MembersModalContext.Provider>
            <MemoModal open={memoOpen} member={memoMember} onClose={() => setMemoOpen(false)} onSaved={onSaved} />
            <O2oModal open={o2oOpen} member={o2oMember} onClose={() => setO2oOpen(false)} onSaved={onSaved} />
            <O2oMemoModal open={o2oMemoOpen} member={o2oMemoMember} onClose={() => setO2oMemoOpen(false)} onSaved={onSaved} />
        </>
    );
}
