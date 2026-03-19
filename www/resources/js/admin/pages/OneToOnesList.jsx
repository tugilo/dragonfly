import React, { useEffect, useState } from 'react';
import {
    List,
    Datagrid,
    TextField,
    FunctionField,
    TextInput,
    NumberInput,
    SelectInput,
    Filter,
    TopToolbar,
    Button,
    useListContext,
    useRefresh,
    useNotify,
} from 'react-admin';
import { Link } from 'react-router-dom';
import {
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    Typography,
    Stack,
    Box,
    Card,
    CardContent,
    Chip,
    CircularProgress,
    TextField as MuiTextField,
    MenuItem,
    FormControl,
    InputLabel,
    Select,
} from '@mui/material';
import { fetchReligoOwnerMemberId, ownerMemberIdFallback } from '../religoOwnerMemberId';

const STATUS_CHOICES = [
    { id: 'planned', name: '予定' },
    { id: 'completed', name: '実施済み' },
    { id: 'canceled', name: 'キャンセル' },
];

const STATUS_CHIP_MAP = {
    planned: { label: '予定', color: 'warning' },
    completed: { label: '実施済み', color: 'success' },
    canceled: { label: 'キャンセル', color: 'default' },
};

const API = '';

async function fetchJson(url) {
    const res = await fetch(`${API}${url}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

function OneToOneStatusChip({ record }) {
    const s = record?.status;
    const m = STATUS_CHIP_MAP[s] ?? { label: s ? String(s) : '—', color: 'default' };
    return (
        <Chip
            size="small"
            label={m.label}
            color={m.color === 'default' ? 'default' : m.color}
            variant="outlined"
        />
    );
}

function MeetingLabelChip({ record }) {
    const label = record?.meeting_label;
    if (!label) {
        return (
            <Typography component="span" variant="body2" color="text.disabled">
                —
            </Typography>
        );
    }
    return (
        <Chip
            size="small"
            label={label}
            variant="outlined"
            sx={{
                maxWidth: '100%',
                '& .MuiChip-label': { overflow: 'hidden', textOverflow: 'ellipsis' },
            }}
        />
    );
}

function buildOneToOneStatsQuery(filterValues) {
    const q = new URLSearchParams();
    const owner = ownerMemberIdFallback(filterValues?.owner_member_id);
    q.set('owner_member_id', String(owner));
    if (filterValues?.workspace_id != null && String(filterValues.workspace_id).trim() !== '') {
        q.set('workspace_id', String(filterValues.workspace_id).trim());
    }
    if (filterValues?.target_member_id != null && String(filterValues.target_member_id).trim() !== '') {
        q.set('target_member_id', String(filterValues.target_member_id).trim());
    }
    if (filterValues?.status) {
        q.set('status', filterValues.status);
    }
    if (filterValues?.from) {
        q.set('from', filterValues.from);
    }
    if (filterValues?.to) {
        q.set('to', filterValues.to);
    }
    const qText = filterValues?.q != null ? String(filterValues.q).trim() : '';
    if (qText !== '') {
        q.set('q', qText);
    }
    return q.toString();
}

function OneToOnesStatsCards() {
    const { filterValues } = useListContext();
    const filterKey = JSON.stringify(filterValues ?? {});
    const [stats, setStats] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        let cancelled = false;
        const fv = filterValues ?? {};
        const qs = buildOneToOneStatsQuery(fv);
        setLoading(true);
        fetch(`/api/one-to-ones/stats?${qs}`, {
            headers: { Accept: 'application/json' },
        })
            .then((r) => {
                if (!r.ok) throw new Error(`stats ${r.status}`);
                return r.json();
            })
            .then((j) => {
                if (!cancelled) setStats(j);
            })
            .catch(() => {
                if (!cancelled) setStats(null);
            })
            .finally(() => {
                if (!cancelled) setLoading(false);
            });
        return () => {
            cancelled = true;
        };
    }, [filterKey]);

    if (loading) {
        return (
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, px: 2, py: 1 }}>
                <CircularProgress size={22} />
                <Typography variant="caption" color="text.secondary">
                    統計を読込中…
                </Typography>
            </Box>
        );
    }

    if (!stats) {
        return (
            <Typography variant="caption" color="text.secondary" sx={{ px: 2, py: 0.5, display: 'block' }}>
                統計を取得できませんでした
            </Typography>
        );
    }

    const items = [
        {
            key: 'planned',
            icon: '📅',
            label: '予定中',
            value: stats.planned_count,
            sub: '今後の予定',
            valColor: '#f57f17',
            iconBg: '#fff8e1',
        },
        {
            key: 'completed',
            icon: '✅',
            label: '完了（今月）',
            value: stats.completed_this_month_count,
            sub: '当月（実施日時ベース）',
            valColor: 'success.main',
            iconBg: 'success.light',
        },
        {
            key: 'canceled',
            icon: '❌',
            label: 'キャンセル',
            value: stats.canceled_this_month_count,
            sub: '今月',
            valColor: 'error.main',
            iconBg: '#ffebee',
        },
        {
            key: 'want',
            icon: '🔁',
            label: 'want_1on1 ON',
            value: stats.want_1on1_on_count,
            sub: '対象メンバー数',
            valColor: '#6a1b9a',
            iconBg: '#f3e5f5',
        },
    ];

    return (
        <Box
            sx={{
                display: 'grid',
                gridTemplateColumns: 'repeat(4, 1fr)',
                gap: 1.5,
                px: 2,
                py: 1,
                '@media (max-width: 900px)': { gridTemplateColumns: 'repeat(2, 1fr)' },
                '@media (max-width: 600px)': { gridTemplateColumns: '1fr' },
            }}
        >
            {items.map((it) => (
                <Card key={it.key} variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.25, py: 1.5, '&:last-child': { pb: 1.5 } }}>
                        <Box
                            sx={{
                                width: 38,
                                height: 38,
                                borderRadius: 1,
                                bgcolor: it.iconBg,
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                fontSize: 17,
                                flexShrink: 0,
                            }}
                        >
                            {it.icon}
                        </Box>
                        <Box sx={{ minWidth: 0 }}>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10, display: 'block' }}>
                                {it.label}
                            </Typography>
                            <Typography sx={{ fontSize: 18, fontWeight: 700, color: it.valColor, lineHeight: 1.2 }}>
                                {it.value}
                            </Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 9, display: 'block' }}>
                                {it.sub}
                            </Typography>
                        </Box>
                    </CardContent>
                </Card>
            ))}
        </Box>
    );
}

function EffectiveDateField({ record, ...props }) {
    const v = record?.started_at ?? record?.scheduled_at;
    if (!v) return <span>—</span>;
    try {
        return <span>{new Date(v).toLocaleString('ja-JP', { dateStyle: 'short', timeStyle: 'short' })}</span>;
    } catch {
        return <span>{String(v)}</span>;
    }
}

function TargetMemberFilterSelect() {
    const { filterValues } = useListContext();
    const ownerId = ownerMemberIdFallback(filterValues?.owner_member_id);
    const [choices, setChoices] = useState([{ id: '', name: '相手: すべて' }]);

    useEffect(() => {
        let cancelled = false;
        const id = ownerId != null && String(ownerId).trim() !== '' ? String(ownerId).trim() : '1';
        fetch(`/api/dragonfly/members?owner_member_id=${encodeURIComponent(id)}`, {
            headers: { Accept: 'application/json' },
        })
            .then((r) => r.json())
            .then((arr) => {
                if (cancelled || !Array.isArray(arr)) return;
                setChoices([
                    { id: '', name: '相手: すべて' },
                    ...arr.map((m) => ({
                        id: m.id,
                        name: `${m.display_no != null ? `#${m.display_no} ` : ''}${m.name}`.trim() || `#${m.id}`,
                    })),
                ]);
            })
            .catch(() => {
                if (!cancelled) setChoices([{ id: '', name: '相手: すべて' }]);
            });
        return () => {
            cancelled = true;
        };
    }, [ownerId]);

    return (
        <SelectInput
            source="target_member_id"
            label="相手"
            choices={choices}
            emptyText="すべて"
            format={(v) => (v == null || v === '' ? '' : v)}
            parse={(v) => (v === '' || v == null ? undefined : v)}
        />
    );
}

export function OneToOnesListFilters() {
    return (
        <Filter>
            <NumberInput source="owner_member_id" label="Owner（自分）ID" alwaysOn />
            <TextInput source="q" label="検索（相手名・メモ）" resettable />
            <TargetMemberFilterSelect />
            <SelectInput source="status" choices={STATUS_CHOICES} label="状態" emptyText="すべて" />
            <TextInput source="from" label="日付 from（YYYY-MM-DD）" />
            <TextInput source="to" label="日付 to（YYYY-MM-DD）" />
        </Filter>
    );
}

function OneToOnesListActions({ onQuickCreate }) {
    return (
        <TopToolbar>
            <Button variant="contained" size="small" onClick={onQuickCreate}>
                ＋ 1to1を追加
            </Button>
            <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">
                フォームで追加
            </Button>
            <Button component={Link} to="/connections" variant="outlined" size="small">
                🗺 Connectionsへ
            </Button>
        </TopToolbar>
    );
}

function OneToOnesQuickCreateDialog({ open, onClose }) {
    const { filterValues } = useListContext();
    const refresh = useRefresh();
    const notify = useNotify();
    const ownerId = ownerMemberIdFallback(filterValues?.owner_member_id);

    const [targetId, setTargetId] = useState('');
    const [status, setStatus] = useState('planned');
    const [scheduledAt, setScheduledAt] = useState('');
    const [notes, setNotes] = useState('');
    const [meetingId, setMeetingId] = useState('');
    const [members, setMembers] = useState([]);
    const [workspaceId, setWorkspaceId] = useState(null);
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState('');

    useEffect(() => {
        if (!open) return;
        setTargetId('');
        setStatus('planned');
        setScheduledAt('');
        setNotes('');
        setMeetingId('');
        setError('');
        let cancelled = false;
        setLoading(true);
        Promise.all([fetchJson('/api/workspaces'), fetchJson(`/api/dragonfly/members?owner_member_id=${encodeURIComponent(String(ownerId))}`)])
            .then(([ws, mem]) => {
                if (cancelled) return;
                if (Array.isArray(ws) && ws.length > 0) setWorkspaceId(ws[0].id);
                else setWorkspaceId(null);
                setMembers(Array.isArray(mem) ? mem : []);
            })
            .catch(() => {
                if (!cancelled) {
                    setWorkspaceId(null);
                    setMembers([]);
                    setError('初期データの取得に失敗しました');
                }
            })
            .finally(() => {
                if (!cancelled) setLoading(false);
            });
        return () => {
            cancelled = true;
        };
    }, [open, ownerId]);

    const handleSave = async () => {
        if (!workspaceId) {
            notify('ワークスペースがありません', { type: 'warning' });
            return;
        }
        if (!targetId) {
            notify('相手を選択してください', { type: 'warning' });
            return;
        }
        setSaving(true);
        setError('');
        try {
            const body = {
                workspace_id: workspaceId,
                owner_member_id: ownerId,
                target_member_id: parseInt(targetId, 10),
                status,
                scheduled_at: scheduledAt.trim() ? scheduledAt.replace('T', ' ') : null,
                notes: notes.trim() || null,
                meeting_id: meetingId.trim() ? parseInt(meetingId, 10) : null,
            };
            const res = await fetch(`${API}/api/one-to-ones`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify(body),
            });
            const j = await res.json().catch(() => ({}));
            if (!res.ok) {
                throw new Error(j.message || `保存に失敗しました (${res.status})`);
            }
            notify('1 to 1 を登録しました');
            refresh();
            onClose();
        } catch (e) {
            setError(e.message || '保存に失敗しました');
        } finally {
            setSaving(false);
        }
    };

    return (
        <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
            <DialogTitle>
                📅 1to1を追加
                <Typography component="div" variant="caption" color="text.secondary" sx={{ mt: 0.5, fontWeight: 400 }}>
                    Owner（自分）: {ownerId}（一覧のフィルタと同じ。変更はフィルタで）
                </Typography>
            </DialogTitle>
            <DialogContent>
                {loading && (
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, py: 2 }}>
                        <CircularProgress size={22} />
                        <Typography variant="body2">読込中…</Typography>
                    </Box>
                )}
                {error && (
                    <Typography color="error" variant="body2" sx={{ mb: 1 }}>
                        {error}
                    </Typography>
                )}
                {!loading && (
                    <Stack spacing={2} sx={{ mt: 1 }}>
                        <FormControl fullWidth size="small">
                            <InputLabel id="qc-target-label">相手</InputLabel>
                            <Select
                                labelId="qc-target-label"
                                label="相手"
                                value={targetId}
                                onChange={(e) => setTargetId(e.target.value)}
                            >
                                {members.map((m) => (
                                    <MenuItem key={m.id} value={String(m.id)}>
                                        {`${m.display_no != null ? `#${m.display_no} ` : ''}${m.name}`.trim() || `#${m.id}`}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        <FormControl fullWidth size="small">
                            <InputLabel id="qc-status-label">状態</InputLabel>
                            <Select labelId="qc-status-label" label="状態" value={status} onChange={(e) => setStatus(e.target.value)}>
                                {STATUS_CHOICES.map((c) => (
                                    <MenuItem key={c.id} value={c.id}>
                                        {c.name}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        <MuiTextField
                            label="予定日時（任意）"
                            type="datetime-local"
                            size="small"
                            fullWidth
                            InputLabelProps={{ shrink: true }}
                            value={scheduledAt}
                            onChange={(e) => setScheduledAt(e.target.value)}
                        />
                        <MuiTextField
                            label="Meeting ID（任意）"
                            size="small"
                            fullWidth
                            value={meetingId}
                            onChange={(e) => setMeetingId(e.target.value)}
                        />
                        <MuiTextField
                            label="メモ（要約・アジェンダ）"
                            size="small"
                            fullWidth
                            multiline
                            minRows={3}
                            value={notes}
                            onChange={(e) => setNotes(e.target.value)}
                            helperText="会話ログの蓄積は contact_memos を後続で本格化"
                        />
                    </Stack>
                )}
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose} disabled={saving}>
                    キャンセル
                </Button>
                <Button variant="contained" onClick={handleSave} disabled={saving || loading}>
                    {saving ? '保存中…' : '保存'}
                </Button>
            </DialogActions>
        </Dialog>
    );
}

function OneToOnesListBody({ onMemoOpen }) {
    const { total, isLoading } = useListContext();

    return (
        <>
            <Typography variant="body2" color="text.secondary" sx={{ px: 2, pt: 1.5, pb: 0, maxWidth: 720 }}>
                予定・実施・キャンセル履歴の管理
            </Typography>
            <OneToOnesStatsCards />
            {!isLoading && (
                <Typography variant="body2" color="text.secondary" sx={{ px: 2, pt: 0.5, pb: 0 }}>
                    {total != null ? `${total} 件` : ''}
                </Typography>
            )}
            <Datagrid rowClick={false} bulkActionButtons={false}>
                <FunctionField label="予定/実施日" render={(record) => <EffectiveDateField record={record} />} />
                <TextField source="target_name" label="相手" />
                <FunctionField label="状態" render={(record) => <OneToOneStatusChip record={record} />} />
                <TextField source="notes" label="メモ" ellipsis />
                <FunctionField label="例会" render={(record) => <MeetingLabelChip record={record} />} />
                <FunctionField
                    label="操作"
                    render={(record) => (
                        <Stack direction="row" spacing={0.5} alignItems="center" flexWrap="wrap">
                            <Button size="small" variant="text" onClick={() => onMemoOpen(record)}>
                                📝 メモ
                            </Button>
                            <Button size="small" variant="text" component={Link} to={`/one-to-ones/${record.id}`}>
                                ✏️ 編集
                            </Button>
                        </Stack>
                    )}
                />
            </Datagrid>
        </>
    );
}

function OneToOnesListInner({ memoRecord, setMemoRecord, createOpen, setCreateOpen }) {
    return (
        <>
            <OneToOnesListBody onMemoOpen={setMemoRecord} />
            <OneToOnesQuickCreateDialog open={createOpen} onClose={() => setCreateOpen(false)} />
            <Dialog open={Boolean(memoRecord)} onClose={() => setMemoRecord(null)} maxWidth="sm" fullWidth>
                <DialogTitle>
                    📝 メモ（notes）
                    {memoRecord?.target_name && (
                        <Typography component="span" variant="body2" color="text.secondary" fontWeight={400} sx={{ ml: 1 }}>
                            — {memoRecord.target_name}
                        </Typography>
                    )}
                </DialogTitle>
                <DialogContent>
                    <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 1 }}>
                        この1to1レコードに紐づく要約メモです。長文・履歴は今後 contact_memos で扱う想定。
                    </Typography>
                    <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
                        {memoRecord?.notes?.trim() ? memoRecord.notes : '（メモなし）'}
                    </Typography>
                </DialogContent>
                <DialogActions>
                    <Button component={Link} to={`/one-to-ones/${memoRecord?.id}`} onClick={() => setMemoRecord(null)}>
                        編集でメモを更新
                    </Button>
                    <Button variant="contained" onClick={() => setMemoRecord(null)}>
                        閉じる
                    </Button>
                </DialogActions>
            </Dialog>
        </>
    );
}

export function OneToOnesList() {
    const [memoRecord, setMemoRecord] = useState(null);
    const [createOpen, setCreateOpen] = useState(false);
    const [listReady, setListReady] = useState(false);
    const [filterDefaults, setFilterDefaults] = useState({ owner_member_id: 1 });

    useEffect(() => {
        let cancelled = false;
        fetchReligoOwnerMemberId().then((id) => {
            if (!cancelled) {
                setFilterDefaults({ owner_member_id: ownerMemberIdFallback(id) });
                setListReady(true);
            }
        });
        return () => {
            cancelled = true;
        };
    }, []);

    if (!listReady) {
        return (
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, p: 2 }}>
                <CircularProgress size={24} />
                <Typography variant="body2" color="text.secondary">
                    一覧を準備しています…
                </Typography>
            </Box>
        );
    }

    return (
        <List
            filters={[<OneToOnesListFilters key="filters" />]}
            title="1 to 1"
            actions={<OneToOnesListActions onQuickCreate={() => setCreateOpen(true)} />}
            perPage={25}
            filterDefaultValues={filterDefaults}
        >
            <OneToOnesListInner
                memoRecord={memoRecord}
                setMemoRecord={setMemoRecord}
                createOpen={createOpen}
                setCreateOpen={setCreateOpen}
            />
        </List>
    );
}
