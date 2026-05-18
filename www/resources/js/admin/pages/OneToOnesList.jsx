import React, { useEffect, useMemo, useState } from 'react';
import {
    List,
    Datagrid,
    FunctionField,
    TextInput,
    SelectInput,
    BooleanInput,
    Filter,
    TopToolbar,
    Button,
    useListContext,
    useRefresh,
    useNotify,
    Form,
    SaveButton,
} from 'react-admin';
import { Link, useSearchParams } from 'react-router-dom';
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
    Tooltip,
    IconButton,
    Divider,
} from '@mui/material';
import ReactMarkdown from 'react-markdown';
import CalendarMonthOutlinedIcon from '@mui/icons-material/CalendarMonthOutlined';
import TaskAltOutlinedIcon from '@mui/icons-material/TaskAltOutlined';
import CancelOutlinedIcon from '@mui/icons-material/CancelOutlined';
import FavoriteBorderOutlinedIcon from '@mui/icons-material/FavoriteBorderOutlined';
import RefreshIcon from '@mui/icons-material/Refresh';
import { OneToOneFormFields } from './OneToOneFormFields';
import { buildOneToOnePayload } from '../utils/oneToOnesTransform';
import { formatMemberWithChapterPrimary } from '../utils/memberDisplay';
import { useReligoOwner } from '../ReligoOwnerContext';

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

function createOneToOneMarkdownComponents(dense) {
    const variant = dense ? 'caption' : 'body2';
    const codeFontSize = dense ? '0.68rem' : '0.78rem';

    const heading = ({ children }) => (
        <Typography
            component="div"
            sx={{
                fontWeight: 700,
                fontSize: dense ? '0.72rem' : '0.95rem',
                mt: dense ? 0.65 : 1,
                mb: dense ? 0.25 : 0.5,
                lineHeight: 1.35,
                '&:first-of-type': { mt: 0 },
            }}
        >
            {children}
        </Typography>
    );

    return {
        p: ({ children }) => (
            <Typography variant={variant} component="p" sx={{ mb: 0.65, mt: 0, '&:last-child': { mb: 0 } }}>
                {children}
            </Typography>
        ),
        h1: heading,
        h2: heading,
        h3: heading,
        h4: heading,
        h5: heading,
        h6: heading,
        ul: ({ children }) => (
            <Box component="ul" sx={{ m: 0, mb: 0.65, pl: 2.25, listStyleType: 'disc', '&:last-child': { mb: 0 } }}>
                {children}
            </Box>
        ),
        ol: ({ children }) => (
            <Box component="ol" sx={{ m: 0, mb: 0.65, pl: 2.25, listStyleType: 'decimal', '&:last-child': { mb: 0 } }}>
                {children}
            </Box>
        ),
        li: ({ children }) => (
            <Typography component="li" variant={variant} sx={{ display: 'list-item', mb: 0.2 }}>
                {children}
            </Typography>
        ),
        a: ({ href, children }) => (
            <Box
                component="a"
                href={href}
                target="_blank"
                rel="noopener noreferrer"
                sx={{ color: 'primary.main', textDecoration: 'underline', wordBreak: 'break-all' }}
            >
                {children}
            </Box>
        ),
        blockquote: ({ children }) => (
            <Box
                component="blockquote"
                sx={{
                    borderLeft: '3px solid',
                    borderColor: 'divider',
                    pl: 1.25,
                    my: 0.65,
                    mx: 0,
                    color: 'text.secondary',
                }}
            >
                {children}
            </Box>
        ),
        hr: () => <Divider sx={{ my: dense ? 0.75 : 1.25 }} />,
        pre: ({ children }) => (
            <Box
                component="pre"
                sx={{
                    m: 0,
                    my: 0.65,
                    p: dense ? 0.65 : 1,
                    bgcolor: 'grey.100',
                    borderRadius: 1,
                    overflow: 'auto',
                    fontFamily: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace',
                    fontSize: codeFontSize,
                    maxWidth: '100%',
                }}
            >
                {children}
            </Box>
        ),
        code: ({ inline, children }) => {
            if (inline) {
                return (
                    <Typography
                        component="code"
                        variant="inherit"
                        sx={{
                            bgcolor: 'action.hover',
                            px: 0.35,
                            py: 0.05,
                            borderRadius: 0.5,
                            fontFamily: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace',
                            fontSize: '0.9em',
                        }}
                    >
                        {children}
                    </Typography>
                );
            }
            return (
                <Box
                    component="code"
                    sx={{
                        fontFamily: 'inherit',
                        fontSize: 'inherit',
                        whiteSpace: 'pre-wrap',
                        wordBreak: 'break-word',
                        display: 'block',
                    }}
                >
                    {children}
                </Box>
            );
        },
    };
}

function OneToOneMarkdownView({ markdown, dense }) {
    const components = useMemo(() => createOneToOneMarkdownComponents(dense), [dense]);
    return <ReactMarkdown components={components}>{markdown}</ReactMarkdown>;
}

function OneToOneNotesPreview({ record }) {
    const raw = typeof record?.notes === 'string' ? record.notes.trim() : '';
    if (!raw) {
        return (
            <Typography component="span" variant="body2" color="text.disabled">
                —
            </Typography>
        );
    }
    return (
        <Box
            sx={{
                minWidth: { xs: 240, sm: 320 },
                maxWidth: { xs: 360, sm: 520 },
                maxHeight: { xs: 200, sm: 260 },
                overflowY: 'auto',
                overflowX: 'hidden',
                pr: 0.5,
                pb: 0.25,
                borderRadius: 1,
                border: '1px solid',
                borderColor: 'divider',
                bgcolor: 'background.default',
                px: 1,
                py: 0.75,
            }}
        >
            <OneToOneMarkdownView markdown={raw} dense />
        </Box>
    );
}

function buildOneToOneStatsQuery(filterValues) {
    const q = new URLSearchParams();
    // 呼び出し側が Context 由来の owner_member_id をマージした filterValues を渡す（一覧フィルタでは持たない）
    const ownerRaw = filterValues?.owner_member_id;
    if (ownerRaw != null && String(ownerRaw).trim() !== '') {
        q.set('owner_member_id', String(ownerRaw).trim());
    }
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
    const ex = filterValues?.exclude_canceled;
    if (ex !== undefined && ex !== null && ex !== '') {
        q.set('exclude_canceled', ex ? '1' : '0');
    }
    const qText = filterValues?.q != null ? String(filterValues.q).trim() : '';
    if (qText !== '') {
        q.set('q', qText);
    }
    return q.toString();
}

function OneToOnesStatsCards() {
    const { filterValues } = useListContext();
    const { ownerMemberId } = useReligoOwner();
    const filterKey = JSON.stringify(filterValues ?? {}) + String(ownerMemberId ?? '');
    const [stats, setStats] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        let cancelled = false;
        const fv = { ...(filterValues ?? {}) };
        if (ownerMemberId != null) {
            fv.owner_member_id = ownerMemberId;
        }
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
            iconEl: <CalendarMonthOutlinedIcon sx={{ fontSize: 22, color: '#f57f17' }} />,
            label: '予定中',
            value: stats.planned_count,
            sub: '今後の予定',
            valColor: '#f57f17',
            iconBg: '#fff8e1',
        },
        {
            key: 'completed',
            iconEl: <TaskAltOutlinedIcon sx={{ fontSize: 22, color: 'success.dark' }} />,
            label: '完了（今月）',
            value: stats.completed_this_month_count,
            sub: '当月（実施日時ベース）',
            valColor: 'success.main',
            iconBg: 'success.light',
        },
        {
            key: 'canceled',
            iconEl: <CancelOutlinedIcon sx={{ fontSize: 22, color: 'error.main' }} />,
            label: 'キャンセル',
            value: stats.canceled_this_month_count,
            sub: '今月',
            valColor: 'error.main',
            iconBg: '#ffebee',
        },
        {
            key: 'want',
            iconEl: <FavoriteBorderOutlinedIcon sx={{ fontSize: 22, color: '#6a1b9a' }} />,
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
                                flexShrink: 0,
                            }}
                        >
                            {it.iconEl}
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

function OneToOneTargetDisplay({ record }) {
    const name = record?.target_name ?? '—';
    const ch = record?.target_workspace_name;
    const cross = record?.is_cross_chapter;
    return (
        <Stack spacing={0.25} alignItems="flex-start" sx={{ minWidth: 0, maxWidth: 320 }}>
            <Typography variant="body2" fontWeight={600} sx={{ wordBreak: 'break-word', lineHeight: 1.25 }}>
                {name}
            </Typography>
            {ch ? (
                <Typography variant="caption" color="text.secondary" sx={{ lineHeight: 1.2 }}>
                    {ch}
                </Typography>
            ) : null}
            {cross ? (
                <Chip size="small" label="他チャプター" color="info" variant="outlined" sx={{ height: 22, mt: 0.25 }} />
            ) : null}
        </Stack>
    );
}

function EffectiveDateField({ record }) {
    const v = record?.started_at ?? record?.scheduled_at;
    if (!v) {
        return (
            <Typography variant="body2" color="text.secondary">
                日時未定
            </Typography>
        );
    }
    try {
        const d = new Date(v);
        const line = d.toLocaleString('ja-JP', { dateStyle: 'short', timeStyle: 'short' });
        return (
            <Typography variant="body2" component="span" sx={{ whiteSpace: 'nowrap' }}>
                {line}
            </Typography>
        );
    } catch {
        return (
            <Typography variant="body2" component="span">
                {String(v)}
            </Typography>
        );
    }
}

function TargetMemberFilterSelect() {
    const { ownerMemberId } = useReligoOwner();
    const raw = ownerMemberId;
    const ownerId =
        raw != null && String(raw).trim() !== '' ? Number(String(raw).trim()) : null;
    const [choices, setChoices] = useState([{ id: '', name: '相手: すべて' }]);

    useEffect(() => {
        let cancelled = false;
        if (ownerId == null || Number.isNaN(ownerId)) {
            setChoices([{ id: '', name: '相手: すべて' }]);
            return () => {
                cancelled = true;
            };
        }
        const id = String(ownerId);
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
                        name: formatMemberWithChapterPrimary(m) || `#${m.id}`,
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
            <BooleanInput source="exclude_canceled" label="キャンセルを一覧から除く" alwaysOn />
            <TextInput source="q" label="検索（相手名・メモ）" resettable />
            <TargetMemberFilterSelect />
            <SelectInput source="status" choices={STATUS_CHOICES} label="状態" emptyText="すべて" />
            <TextInput source="from" label="日付 from（YYYY-MM-DD）" />
            <TextInput source="to" label="日付 to（YYYY-MM-DD）" />
        </Filter>
    );
}

function OneToOnesToolbarRefresh() {
    const refresh = useRefresh();
    return (
        <Tooltip title="一覧・統計を再読込">
            <IconButton size="small" onClick={() => refresh()} aria-label="一覧・統計を再読込" sx={{ mr: 0.5 }}>
                <RefreshIcon fontSize="small" />
            </IconButton>
        </Tooltip>
    );
}

function OneToOnesListActions({ onQuickCreate }) {
    return (
        <TopToolbar>
            <OneToOnesToolbarRefresh />
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

function formatLaravel422Message(payload) {
    if (!payload || typeof payload !== 'object') {
        return null;
    }
    if (payload.message && typeof payload.message === 'string') {
        return payload.message;
    }
    const err = payload.errors;
    if (!err || typeof err !== 'object') {
        return null;
    }
    const firstKey = Object.keys(err)[0];
    const first = firstKey != null ? err[firstKey] : null;
    if (Array.isArray(first) && first[0]) {
        return `${firstKey}: ${first[0]}`;
    }
    return null;
}

function OneToOnesQuickCreateDialog({ open, onClose }) {
    const { ownerMemberId: globalOwnerMemberId } = useReligoOwner();
    const refresh = useRefresh();
    const notify = useNotify();
    const [searchParams] = useSearchParams();

    const [resolvedOwnerId, setResolvedOwnerId] = useState(null);
    const [workspaceId, setWorkspaceId] = useState(null);
    const [ownerMemberOptions, setOwnerMemberOptions] = useState([]);
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState('');
    const [durationMinutes, setDurationMinutes] = useState(60);
    const [formSession, setFormSession] = useState(0);
    const [prefillTargetId, setPrefillTargetId] = useState(null);

    useEffect(() => {
        if (!open) {
            return;
        }
        setFormSession((s) => s + 1);
        setDurationMinutes(60);
        setError('');
        setPrefillTargetId(null);
        setResolvedOwnerId(null);
    }, [open]);

    useEffect(() => {
        if (!open) {
            return;
        }
        let cancelled = false;
        setLoading(true);
        (async () => {
            try {
                setError('');
                let owner = null;
                if (globalOwnerMemberId != null) {
                    owner = Number(globalOwnerMemberId);
                }
                if (cancelled) {
                    return;
                }
                if (owner == null || Number.isNaN(owner)) {
                    setResolvedOwnerId(null);
                    setWorkspaceId(null);
                    setOwnerMemberOptions([]);
                    setPrefillTargetId(null);
                    setError('Owner（自分）が未設定です。画面上部の Owner でメンバーを選んでください。');
                    return;
                }
                setResolvedOwnerId(owner);

                const [wsArr, allMembers] = await Promise.all([
                    fetchJson('/api/workspaces'),
                    fetchJson('/api/dragonfly/members'),
                ]);
                if (cancelled) {
                    return;
                }
                if (!Array.isArray(wsArr) || wsArr.length === 0) {
                    setWorkspaceId(null);
                    setOwnerMemberOptions([]);
                    setPrefillTargetId(null);
                    setError('ワークスペースがありません');
                    return;
                }
                setWorkspaceId(wsArr[0].id);
                setOwnerMemberOptions(Array.isArray(allMembers) ? allMembers : []);
                const scoped = await fetchJson(
                    `/api/dragonfly/members?owner_member_id=${encodeURIComponent(String(owner))}`
                );
                if (cancelled) {
                    return;
                }
                const scopedList = Array.isArray(scoped) ? scoped : [];
                const qs = searchParams.get('target_member_id');
                const qNum =
                    qs != null && /^\d+$/.test(String(qs).trim()) ? Number(String(qs).trim()) : null;
                const ok =
                    qNum != null &&
                    qNum !== owner &&
                    scopedList.some((m) => Number(m.id) === qNum);
                setPrefillTargetId(ok ? qNum : null);
            } catch {
                if (!cancelled) {
                    setResolvedOwnerId(null);
                    setWorkspaceId(null);
                    setOwnerMemberOptions([]);
                    setPrefillTargetId(null);
                    setError('初期データの取得に失敗しました');
                }
            } finally {
                if (!cancelled) {
                    setLoading(false);
                }
            }
        })();
        return () => {
            cancelled = true;
        };
    }, [open, searchParams, globalOwnerMemberId]);

    const defaultValues = useMemo(
        () => ({
            owner_member_id: resolvedOwnerId,
            status: 'planned',
            target_member_id: prefillTargetId,
            scheduled_at: null,
            meeting_id: null,
            notes: '',
        }),
        [resolvedOwnerId, formSession, prefillTargetId]
    );

    const handleSubmit = async (data) => {
        if (!workspaceId) {
            notify('ワークスペースがありません', { type: 'warning' });
            return;
        }
        if (resolvedOwnerId == null || data.owner_member_id == null || data.owner_member_id === '') {
            notify('Owner（自分）が無効です。画面上部の Owner を確認するか、/settings で設定してください。', {
                type: 'warning',
            });
            return;
        }
        setSaving(true);
        setError('');
        try {
            const body = buildOneToOnePayload(data, durationMinutes, { mode: 'create', workspaceId });
            const res = await fetch(`${API}/api/one-to-ones`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify(body),
            });
            const j = await res.json().catch(() => ({}));
            if (!res.ok) {
                const detail = formatLaravel422Message(j) || j.message || `保存に失敗しました (${res.status})`;
                throw new Error(detail);
            }
            notify('1 to 1 を登録しました');
            refresh();
            onClose();
        } catch (e) {
            const msg = e.message || '保存に失敗しました';
            setError(msg);
            notify(msg, { type: 'error' });
        } finally {
            setSaving(false);
        }
    };

    const ownerLabel =
        resolvedOwnerId != null && !Number.isNaN(resolvedOwnerId) ? String(resolvedOwnerId) : '未設定';

    return (
        <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth scroll="paper">
            <DialogTitle>
                📅 1 to 1 を追加
                <Typography component="div" variant="caption" color="text.secondary" sx={{ mt: 0.5, fontWeight: 400 }}>
                    Owner（自分）: {ownerLabel}（ヘッダーと同じ解決済み ID）
                </Typography>
            </DialogTitle>
            {loading && (
                <DialogContent>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, py: 2 }}>
                        <CircularProgress size={22} />
                        <Typography variant="body2">読込中…</Typography>
                    </Box>
                </DialogContent>
            )}
            {!loading && workspaceId != null && resolvedOwnerId != null && (
                <Form
                    key={`o2o-${formSession}-${resolvedOwnerId}-${prefillTargetId ?? ''}`}
                    onSubmit={handleSubmit}
                    defaultValues={defaultValues}
                >
                    <DialogContent
                        dividers
                        sx={{
                            maxHeight: { xs: '65vh', sm: '70vh' },
                            overflowY: 'auto',
                        }}
                    >
                        <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                            相手は一覧の Owner にスコープされたメンバーから検索して選びます（作成フォームと同じ）。
                        </Typography>
                        {error ? (
                            <Typography color="error" variant="body2" sx={{ mb: 1 }}>
                                {error}
                            </Typography>
                        ) : null}
                        <OneToOneFormFields
                            mode="create"
                            ownerMemberOptions={ownerMemberOptions}
                            durationMinutes={durationMinutes}
                            onDurationChange={setDurationMinutes}
                            suppressCreateOwnerHint
                            ownerInputDisabled
                        />
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={onClose} disabled={saving}>
                            キャンセル
                        </Button>
                        <SaveButton label={saving ? '保存中…' : '保存'} disabled={saving} />
                    </DialogActions>
                </Form>
            )}
            {!loading && workspaceId == null && error ? (
                <>
                    <DialogContent>
                        <Typography color="error" variant="body2">
                            {error}
                        </Typography>
                    </DialogContent>
                    <DialogActions>
                        <Button variant="contained" onClick={onClose}>
                            閉じる
                        </Button>
                    </DialogActions>
                </>
            ) : null}
        </Dialog>
    );
}

function OneToOnesListBody({ onMemoOpen }) {
    const { total, isLoading } = useListContext();

    return (
        <>
            <Typography variant="body2" color="text.secondary" sx={{ px: 2, pt: 1.5, pb: 0, maxWidth: 860 }}>
                予定・実施・キャンセル履歴の管理。1 to 1 は関係性の履歴として保持し、レコード削除は行いません。予定を無効化する場合は状態を「キャンセル」に変更してください。
            </Typography>
            <Typography variant="caption" color="text.secondary" sx={{ px: 2, pt: 0.5, pb: 0, display: 'block', maxWidth: 860 }}>
                「相手」下の小さな文字は相手メンバーの所属チャプターです。メモ列は Markdown で表示され、枠内をスクロールして読めます。
            </Typography>
            <OneToOnesStatsCards />
            {!isLoading && (
                <Typography variant="body2" color="text.secondary" sx={{ px: 2, pt: 0.5, pb: 0 }}>
                    {total != null ? `${total} 件` : ''}
                </Typography>
            )}
            <Datagrid
                rowClick={false}
                bulkActionButtons={false}
                rowSx={() => ({ '&:hover': { bgcolor: 'action.hover' } })}
                sx={{
                    '& .RaDatagrid-headerCell': {
                        fontWeight: 700,
                        whiteSpace: 'nowrap',
                    },
                }}
            >
                <FunctionField label="予定/実施日" render={(record) => <EffectiveDateField record={record} />} />
                <FunctionField label="相手" render={(r) => <OneToOneTargetDisplay record={r} />} />
                <FunctionField label="状態" render={(record) => <OneToOneStatusChip record={record} />} />
                <FunctionField label="メモ" render={(r) => <OneToOneNotesPreview record={r} />} />
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
            <Dialog open={Boolean(memoRecord)} onClose={() => setMemoRecord(null)} maxWidth="md" fullWidth>
                <DialogTitle>
                    📝 メモ（notes）
                    {memoRecord?.target_name && (
                        <Typography component="span" variant="body2" color="text.secondary" fontWeight={400} sx={{ ml: 1 }}>
                            — {memoRecord.target_name}
                        </Typography>
                    )}
                    {memoRecord?.target_workspace_name ? (
                        <Typography component="div" variant="caption" color="text.secondary" sx={{ mt: 0.5, fontWeight: 400 }}>
                            相手所属: {memoRecord.target_workspace_name}
                        </Typography>
                    ) : null}
                </DialogTitle>
                <DialogContent
                    dividers
                    sx={{
                        maxHeight: { xs: '70vh', sm: '72vh' },
                        overflowY: 'auto',
                    }}
                >
                    <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 1 }}>
                        この1to1レコードに紐づく要約メモです（Markdown 表示）。長文・履歴は今後 contact_memos で扱う想定。
                    </Typography>
                    {memoRecord?.notes?.trim() ? (
                        <OneToOneMarkdownView markdown={memoRecord.notes.trim()} dense={false} />
                    ) : (
                        <Typography variant="body2" color="text.secondary">
                            （メモなし）
                        </Typography>
                    )}
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

const ONETOONES_FILTER_DEFAULTS = { exclude_canceled: true };

export function OneToOnesList() {
    const { loading: ownerLoading } = useReligoOwner();
    const [memoRecord, setMemoRecord] = useState(null);
    const [createOpen, setCreateOpen] = useState(false);
    const [listReady, setListReady] = useState(false);

    useEffect(() => {
        if (ownerLoading) return;
        setListReady(true);
    }, [ownerLoading]);

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
            filterDefaultValues={ONETOONES_FILTER_DEFAULTS}
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
