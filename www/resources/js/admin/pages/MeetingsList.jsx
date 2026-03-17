import React, { useState, useCallback, useEffect, useRef } from 'react';
import { List, Datagrid, TextField, FunctionField, TopToolbar, Button, useRefresh, useListContext } from 'react-admin';
import { Link } from 'react-router-dom';
import {
    Typography,
    Chip,
    Stack,
    Drawer,
    Box,
    IconButton,
    CircularProgress,
    Divider,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogContentText,
    DialogActions,
    TextField as MuiTextField,
    InputAdornment,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    Card,
    CardContent,
    Grid,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import CloseIcon from '@mui/icons-material/Close';
import EventIcon from '@mui/icons-material/Event';
import GroupsIcon from '@mui/icons-material/Groups';
import NoteIcon from '@mui/icons-material/Note';
import NextPlanIcon from '@mui/icons-material/NextPlan';
import PictureAsPdfIcon from '@mui/icons-material/PictureAsPdf';
import CloudUploadIcon from '@mui/icons-material/CloudUpload';
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';

const API_BASE = '';

async function fetchMeetingDetail(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

async function fetchMeetingMemo(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/memo`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) throw new Error(`API ${res.status}`);
    const data = await res.json();
    return data.body ?? '';
}

async function putMeetingMemo(meetingId, body) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/memo`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({ body: body == null ? '' : String(body).trim() }),
    });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

async function fetchMeetingsStats() {
    const res = await fetch(`${API_BASE}/api/meetings/stats`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

async function postParticipantImport(meetingId, file) {
    const form = new FormData();
    form.append('pdf', file);
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/participants/import`, {
        method: 'POST',
        headers: { Accept: 'application/json' },
        body: form,
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postParticipantImportParse(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/participants/import/parse`, {
        method: 'POST',
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function fetchMemberSearch(q) {
    const params = new URLSearchParams({ q: String(q || '').trim() });
    const res = await fetch(`${API_BASE}/api/members/search?${params}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

async function putParticipantImportCandidates(meetingId, candidates) {
    const body = candidates.map((c) => {
        const name = String(c.name ?? '').trim();
        const out = {
            name,
            raw_line: String(c.raw_line ?? '').trim(),
            type_hint: c.type_hint === '' || c.type_hint == null ? null : c.type_hint,
        };
        if (c.matched_member_id != null && c.match_source === 'manual') {
            out.matched_member_id = c.matched_member_id;
            out.matched_member_name = c.matched_member_name ?? null;
            out.match_source = 'manual';
        }
        return out;
    }).filter((c) => c.name !== '');
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/participants/import/candidates`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({ candidates: body }),
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postParticipantImportApply(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/participants/import/apply`, {
        method: 'POST',
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

function MeetingsListActions() {
    return (
        <TopToolbar>
            <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connectionsで編集</Button>
        </TopToolbar>
    );
}

function MeetingsToolbar() {
    const { filterValues, setFilters, total } = useListContext();
    const q = filterValues?.q ?? '';
    const hasMemo = filterValues?.has_memo ?? '';
    const hasParticipantPdf = filterValues?.has_participant_pdf ?? '';

    return (
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, flexWrap: 'wrap', px: 1, py: 1.5 }}>
            <Typography variant="subtitle2" color="text.secondary" sx={{ mr: 1 }}>例会一覧</Typography>
            <MuiTextField
                size="small"
                placeholder="番号 / 日付"
                value={q}
                onChange={(e) => setFilters({ ...filterValues, q: e.target.value.trim() || undefined })}
                sx={{ minWidth: 160 }}
                InputProps={{
                    startAdornment: (
                        <InputAdornment position="start">
                            <SearchIcon fontSize="small" />
                        </InputAdornment>
                    ),
                }}
            />
            <FormControl size="small" sx={{ minWidth: 120 }}>
                <InputLabel id="meetings-has-memo-label">メモ</InputLabel>
                <Select
                    labelId="meetings-has-memo-label"
                    label="メモ"
                    value={hasMemo}
                    onChange={(e) => setFilters({ ...filterValues, has_memo: e.target.value === '' ? undefined : e.target.value })}
                >
                    <MenuItem value="">すべて</MenuItem>
                    <MenuItem value="1">メモあり</MenuItem>
                    <MenuItem value="0">メモなし</MenuItem>
                </Select>
            </FormControl>
            <FormControl size="small" sx={{ minWidth: 120 }}>
                <InputLabel id="meetings-has-participant-pdf-label">参加者PDF</InputLabel>
                <Select
                    labelId="meetings-has-participant-pdf-label"
                    label="参加者PDF"
                    value={hasParticipantPdf}
                    onChange={(e) => setFilters({ ...filterValues, has_participant_pdf: e.target.value === '' ? undefined : e.target.value })}
                >
                    <MenuItem value="">すべて</MenuItem>
                    <MenuItem value="1">PDFあり</MenuItem>
                    <MenuItem value="0">PDFなし</MenuItem>
                </Select>
            </FormControl>
            <Typography variant="body2" color="text.secondary">{total}件</Typography>
        </Box>
    );
}

function MeetingsListTitle() {
    return (
        <>
            <Typography variant="h5" component="span">Meetings</Typography>
            <Typography variant="body2" color="text.secondary" display="block" sx={{ mt: 0.25 }}>例会管理 / BO割当 / メモ</Typography>
        </>
    );
}

function MeetingsStatsCards({ stats, loading, error }) {
    if (error) {
        return (
            <Box sx={{ px: 1, py: 1.5, mb: 1 }}>
                <Typography variant="body2" color="error">統計を取得できませんでした</Typography>
            </Box>
        );
    }
    if (loading || !stats) {
        return (
            <Box sx={{ px: 1, py: 2, mb: 1, display: 'flex', justifyContent: 'center' }}>
                <CircularProgress size={24} />
            </Box>
        );
    }
    const nextLabel = stats.next_meeting
        ? `#${stats.next_meeting.number} — ${stats.next_meeting.held_on ? new Date(stats.next_meeting.held_on).toLocaleDateString('ja-JP') : '—'}`
        : 'なし';
    return (
        <Grid container spacing={2} sx={{ px: 1, py: 1.5, mb: 1 }}>
            <Grid item xs={6} sm={3}>
                <Card variant="outlined" sx={{ height: '100%' }}>
                    <CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                        <Stack direction="row" alignItems="center" spacing={1}>
                            <EventIcon color="primary" fontSize="small" />
                            <Typography variant="subtitle2" color="text.secondary">総例会数</Typography>
                        </Stack>
                        <Typography variant="h6" fontWeight={700} sx={{ mt: 0.5 }}>{stats.total_meetings}</Typography>
                    </CardContent>
                </Card>
            </Grid>
            <Grid item xs={6} sm={3}>
                <Card variant="outlined" sx={{ height: '100%' }}>
                    <CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                        <Stack direction="row" alignItems="center" spacing={1}>
                            <GroupsIcon color="primary" fontSize="small" />
                            <Typography variant="subtitle2" color="text.secondary">総BO数</Typography>
                        </Stack>
                        <Typography variant="h6" fontWeight={700} sx={{ mt: 0.5 }}>{stats.total_breakouts}</Typography>
                    </CardContent>
                </Card>
            </Grid>
            <Grid item xs={6} sm={3}>
                <Card variant="outlined" sx={{ height: '100%' }}>
                    <CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                        <Stack direction="row" alignItems="center" spacing={1}>
                            <NoteIcon color="success.main" fontSize="small" />
                            <Typography variant="subtitle2" color="text.secondary">メモ有り例会</Typography>
                        </Stack>
                        <Typography variant="h6" fontWeight={700} sx={{ mt: 0.5 }}>{stats.meetings_with_memo}</Typography>
                    </CardContent>
                </Card>
            </Grid>
            <Grid item xs={6} sm={3}>
                <Card variant="outlined" sx={{ height: '100%' }}>
                    <CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                        <Stack direction="row" alignItems="center" spacing={1}>
                            <NextPlanIcon color="info.main" fontSize="small" />
                            <Typography variant="subtitle2" color="text.secondary">次回例会</Typography>
                        </Stack>
                        <Typography variant="body2" fontWeight={600} sx={{ mt: 0.5 }} noWrap title={nextLabel}>
                            {nextLabel}
                        </Typography>
                    </CardContent>
                </Card>
            </Grid>
        </Grid>
    );
}

function HeldOnField({ record }) {
    const d = record?.held_on;
    if (!d) return <span>—</span>;
    try {
        return <span>{new Date(d).toLocaleDateString('ja-JP')}</span>;
    } catch {
        return <span>{String(d)}</span>;
    }
}

function BreakoutCountField({ record }) {
    const n = record?.breakout_count;
    if (n == null) return <span>—</span>;
    return <Chip size="small" label={String(n)} sx={{ height: 20, fontSize: '0.75rem' }} color="primary" variant="outlined" />;
}

function HasMemoField({ record }) {
    const has = record?.has_memo;
    if (has == null) return <span>—</span>;
    return has
        ? <Chip size="small" label="あり" sx={{ height: 18, fontSize: '0.7rem' }} color="success" variant="outlined" />
        : <Chip size="small" label="なし" sx={{ height: 18, fontSize: '0.7rem' }} color="default" variant="outlined" />;
}

function HasParticipantPdfField({ record }) {
    const has = record?.has_participant_pdf;
    if (has == null) return <span>—</span>;
    return has
        ? <Chip size="small" icon={<PictureAsPdfIcon sx={{ fontSize: 16 }} />} label="あり" sx={{ height: 18, fontSize: '0.7rem' }} color="success" variant="outlined" />
        : <Chip size="small" label="なし" sx={{ height: 18, fontSize: '0.7rem' }} color="default" variant="outlined" />;
}

function MeetingActionsField({ record, onMemoClick }) {
    if (!record) return null;
    return (
        <Stack direction="row" spacing={0.5} flexWrap="wrap" useFlexGap onClick={(e) => e.stopPropagation()}>
            <Button
                size="small"
                variant="outlined"
                onClick={() => onMemoClick(record)}
                sx={{ minWidth: 'auto', px: 1 }}
            >
                📝 メモ
            </Button>
            <Button
                component={Link}
                to="/connections"
                size="small"
                variant="outlined"
                sx={{ minWidth: 'auto', px: 1 }}
            >
                🗺 BO編集
            </Button>
        </Stack>
    );
}

function typeHintLabel(typeHint) {
    switch (typeHint) {
        case 'regular': return 'メンバー候補';
        case 'guest': return 'ゲスト候補';
        case 'visitor': return 'ビジター候補';
        case 'proxy': return '代理候補';
        default: return '不明';
    }
}

const TYPE_HINT_OPTIONS = [
    { value: 'regular', label: 'メンバー候補' },
    { value: 'guest', label: 'ゲスト候補' },
    { value: 'visitor', label: 'ビジター候補' },
    { value: 'proxy', label: '代理候補' },
    { value: '', label: '不明' },
];

function MeetingDetailDrawer({ open, onClose, data, loading, meetingFromList, onMemoClick, onPdfRegisterClick, onDetailRefresh }) {
    const [parseLoading, setParseLoading] = useState(false);
    const [candidateEditMode, setCandidateEditMode] = useState(false);
    const [editingCandidates, setEditingCandidates] = useState([]);
    const [candidatesSaving, setCandidatesSaving] = useState(false);
    const [applyConfirmOpen, setApplyConfirmOpen] = useState(false);
    const [applyLoading, setApplyLoading] = useState(false);
    const [memberSearchRowIndex, setMemberSearchRowIndex] = useState(null);
    const [memberSearchOpen, setMemberSearchOpen] = useState(false);
    const [memberSearchQuery, setMemberSearchQuery] = useState('');
    const [memberSearchResults, setMemberSearchResults] = useState([]);
    const [memberSearchLoading, setMemberSearchLoading] = useState(false);
    useEffect(() => {
        if (!open) {
            setCandidateEditMode(false);
            setEditingCandidates([]);
            setApplyConfirmOpen(false);
            setMemberSearchOpen(false);
        }
    }, [open]);

    useEffect(() => {
        if (!memberSearchOpen) return;
        const q = String(memberSearchQuery || '').trim();
        if (q === '') {
            setMemberSearchResults([]);
            return;
        }
        let cancelled = false;
        setMemberSearchLoading(true);
        fetchMemberSearch(q).then((list) => {
            if (!cancelled) setMemberSearchResults(Array.isArray(list) ? list : []);
        }).catch(() => { if (!cancelled) setMemberSearchResults([]); }).finally(() => { if (!cancelled) setMemberSearchLoading(false); });
        return () => { cancelled = true; };
    }, [memberSearchOpen, memberSearchQuery]);

    const meeting = data?.meeting;
    const memoBody = data?.memo_body;
    const participantImport = data?.participant_import;
    const rooms = data?.rooms ?? [];
    const needsParse = participantImport?.has_pdf && participantImport?.parse_status !== 'success';
    const parseSuccess = participantImport?.has_pdf && participantImport?.parse_status === 'success';
    const parseFailed = participantImport?.has_pdf && participantImport?.parse_status === 'failed';
    const parsePending = participantImport?.has_pdf && (participantImport?.parse_status === 'pending' || !participantImport?.parse_status);
    const candidateCount = participantImport?.candidate_count ?? 0;
    const candidates = Array.isArray(participantImport?.candidates) ? participantImport.candidates : [];
    const matchedCount = participantImport?.matched_count ?? 0;
    const newCount = participantImport?.new_count ?? 0;
    const totalCount = participantImport?.total_count ?? candidateCount;
    const importedAt = participantImport?.imported_at ?? null;
    const appliedCount = participantImport?.applied_count ?? null;

    return (
        <Drawer
            anchor="right"
            open={open}
            onClose={onClose}
            PaperProps={{ sx: { width: { xs: '100%', sm: 380 } } }}
        >
            <Box sx={{ p: 2, display: 'flex', flexDirection: 'column', height: '100%' }}>
                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 1 }}>
                    <Typography variant="h6">📋 例会詳細</Typography>
                    <IconButton size="small" onClick={onClose} aria-label="閉じる">
                        <CloseIcon />
                    </IconButton>
                </Box>
                <Divider sx={{ mb: 2 }} />
                {loading ? (
                    <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
                        <CircularProgress size={32} />
                    </Box>
                ) : meeting ? (
                    <>
                        <Box sx={{ mb: 2 }}>
                            <Typography variant="subtitle1" fontWeight={700}>
                                #{meeting.number}
                            </Typography>
                            <Typography variant="body2" color="text.secondary">
                                {meeting.held_on ? new Date(meeting.held_on).toLocaleDateString('ja-JP') : '—'}
                            </Typography>
                        </Box>
                        <Stack direction="row" spacing={1} sx={{ mb: 2 }}>
                            <Chip
                                size="small"
                                label={`BO数 ${meeting.breakout_count ?? 0}`}
                                color="primary"
                                variant="outlined"
                            />
                            <Chip
                                size="small"
                                label={meeting.has_memo ? 'メモあり' : 'メモなし'}
                                color={meeting.has_memo ? 'success' : 'default'}
                                variant="outlined"
                            />
                        </Stack>
                        {memoBody != null && memoBody !== '' && (
                            <Box sx={{ mb: 2, p: 1.5, bgcolor: 'action.hover', borderRadius: 1, borderLeft: 3, borderColor: 'warning.main' }}>
                                <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 0.5 }}>
                                    例会メモ
                                </Typography>
                                <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap' }}>
                                    {memoBody}
                                </Typography>
                            </Box>
                        )}
                        {participantImport && (
                            <Box sx={{ mb: 2 }}>
                                <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 1 }}>
                                    参加者PDF
                                </Typography>
                                <Box sx={{ border: 1, borderColor: 'divider', borderRadius: 1, p: 1.5 }}>
                                    {participantImport.has_pdf ? (
                                        <Stack spacing={1}>
                                            <Stack direction="row" alignItems="center" spacing={1} flexWrap="wrap">
                                                <PictureAsPdfIcon color="error" fontSize="small" />
                                                <Typography variant="body2" noWrap sx={{ flex: 1, minWidth: 0 }}>
                                                    {participantImport.original_filename || '参加者一覧.pdf'}
                                                </Typography>
                                                <Button
                                                    size="small"
                                                    variant="outlined"
                                                    component="a"
                                                    href={`${API_BASE}/api/meetings/${meeting.id}/participants/import/download`}
                                                    download
                                                    target="_blank"
                                                    rel="noopener noreferrer"
                                                >
                                                    ダウンロード
                                                </Button>
                                            </Stack>
                                            {parsePending && (
                                                <Typography variant="caption" color="text.secondary">
                                                    解析待ち
                                                </Typography>
                                            )}
                                            {parseFailed && (
                                                <Typography variant="caption" color="error">
                                                    解析失敗
                                                </Typography>
                                            )}
                                            {needsParse && (
                                                <Button
                                                    size="small"
                                                    variant="contained"
                                                    disabled={parseLoading}
                                                    onClick={async () => {
                                                        if (!meeting?.id || !onDetailRefresh) return;
                                                        setParseLoading(true);
                                                        try {
                                                            await postParticipantImportParse(meeting.id);
                                                            onDetailRefresh();
                                                        } finally {
                                                            setParseLoading(false);
                                                        }
                                                    }}
                                                >
                                                    {parseLoading ? '解析中…' : 'PDF解析'}
                                                </Button>
                                            )}
                                            {parseSuccess && (
                                                <Stack spacing={1}>
                                                    <Stack direction="row" alignItems="center" justifyContent="space-between" flexWrap="wrap" gap={0.5}>
                                                        <Typography variant="caption" color="text.secondary">
                                                            候補 {candidateEditMode ? editingCandidates.length : candidateCount}件
                                                            {typeof totalCount === 'number' && totalCount >= 0 && (
                                                                <> · 既存一致 {matchedCount}件 / 新規作成 {newCount}件 / 合計 {totalCount}件</>
                                                            )}
                                                        </Typography>
                                                        {!candidateEditMode ? (
                                                            <Stack direction="row" spacing={0.5} flexWrap="wrap">
                                                                <Button
                                                                    size="small"
                                                                    variant="outlined"
                                                                    onClick={() => {
                                                                        setEditingCandidates(candidates.length === 0
                                                                            ? [{ name: '', raw_line: '', type_hint: '', matched_member_id: null, matched_member_name: null, match_source: null }]
                                                                            : candidates.map((c) => ({
                                                                                name: c.name ?? '',
                                                                                raw_line: c.raw_line ?? '',
                                                                                type_hint: c.type_hint ?? '',
                                                                                matched_member_id: c.matched_member_id ?? null,
                                                                                matched_member_name: c.matched_member_name ?? null,
                                                                                match_source: c.match_source ?? null,
                                                                            })));
                                                                        setCandidateEditMode(true);
                                                                    }}
                                                                >
                                                                    候補を編集
                                                                </Button>
                                                                {candidates.length >= 1 && (
                                                                    <Button
                                                                        size="small"
                                                                        variant="contained"
                                                                        color="primary"
                                                                        onClick={() => setApplyConfirmOpen(true)}
                                                                    >
                                                                        participants に反映
                                                                    </Button>
                                                                )}
                                                            </Stack>
                                                        ) : null}
                                                    </Stack>
                                                    {parseSuccess && (
                                                        <Typography variant="caption" color="text.secondary" sx={{ mt: 0.5 }}>
                                                            {importedAt && typeof appliedCount === 'number'
                                                                ? `${new Date(importedAt).toLocaleString('ja-JP', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' })} に ${appliedCount}件反映`
                                                                : '未反映'}
                                                        </Typography>
                                                    )}
                                                    {candidateEditMode ? (
                                                        <Stack spacing={1}>
                                                            <TableContainer sx={{ maxHeight: 260, border: 1, borderColor: 'divider', borderRadius: 1 }}>
                                                                <Table size="small" stickyHeader>
                                                                    <TableHead>
                                                                        <TableRow>
                                                                            <TableCell sx={{ fontWeight: 700, py: 0.5 }}>名前</TableCell>
                                                                            <TableCell sx={{ fontWeight: 700, py: 0.5 }}>種別</TableCell>
                                                                            <TableCell sx={{ fontWeight: 700, py: 0.5 }}>抽出元行</TableCell>
                                                                            <TableCell sx={{ fontWeight: 700, py: 0.5 }}>照合</TableCell>
                                                                            <TableCell sx={{ fontWeight: 700, py: 0.5, width: 40 }} />
                                                                    </TableRow>
                                                                    </TableHead>
                                                                    <TableBody>
                                                                        {editingCandidates.map((c, i) => (
                                                                            <TableRow key={i}>
                                                                                <TableCell sx={{ py: 0.5 }}>
                                                                                    <MuiTextField
                                                                                        size="small"
                                                                                        value={c.name}
                                                                                        onChange={(e) => setEditingCandidates((prev) => prev.map((row, j) => j === i ? { ...row, name: e.target.value } : row))}
                                                                                        placeholder="名前"
                                                                                        fullWidth
                                                                                        sx={{ minWidth: 80 }}
                                                                                    />
                                                                                </TableCell>
                                                                                <TableCell sx={{ py: 0.5 }}>
                                                                                    <Select
                                                                                        size="small"
                                                                                        value={c.type_hint ?? ''}
                                                                                        onChange={(e) => setEditingCandidates((prev) => prev.map((row, j) => j === i ? { ...row, type_hint: e.target.value } : row))}
                                                                                        displayEmpty
                                                                                        sx={{ minWidth: 120, fontSize: '0.8rem' }}
                                                                                    >
                                                                                        {TYPE_HINT_OPTIONS.map((opt) => (
                                                                                            <MenuItem key={opt.value || 'null'} value={opt.value}>{opt.label}</MenuItem>
                                                                                        ))}
                                                                                    </Select>
                                                                                </TableCell>
                                                                                <TableCell sx={{ py: 0.5, fontSize: '0.75rem', color: 'text.secondary', maxWidth: 120 }} title={c.raw_line}>
                                                                                    {(c.raw_line || '').length > 16 ? `${(c.raw_line || '').slice(0, 16)}…` : (c.raw_line || '—')}
                                                                                </TableCell>
                                                                                <TableCell sx={{ py: 0.5 }}>
                                                                                    {c.matched_member_id && c.match_source === 'manual' ? (
                                                                                        <Stack direction="row" alignItems="center" spacing={0.5} flexWrap="wrap">
                                                                                            <Chip size="small" label={`${c.matched_member_name ?? ''}（手動）`} color="primary" variant="outlined" sx={{ height: 20, fontSize: '0.7rem' }} />
                                                                                            <Button size="small" variant="text" sx={{ minWidth: 0, py: 0 }} onClick={() => setEditingCandidates((prev) => prev.map((row, j) => j === i ? { ...row, matched_member_id: null, matched_member_name: null, match_source: null } : row))}>解除</Button>
                                                                                        </Stack>
                                                                                    ) : (
                                                                                        <Button
                                                                                            size="small"
                                                                                            variant="outlined"
                                                                                            sx={{ fontSize: '0.7rem' }}
                                                                                            onClick={() => { setMemberSearchRowIndex(i); setMemberSearchQuery(''); setMemberSearchResults([]); setMemberSearchOpen(true); }}
                                                                                        >
                                                                                            member を選択
                                                                                        </Button>
                                                                                    )}
                                                                                </TableCell>
                                                                                <TableCell sx={{ py: 0.5 }}>
                                                                                    <IconButton
                                                                                        size="small"
                                                                                        onClick={() => setEditingCandidates((prev) => prev.filter((_, j) => j !== i))}
                                                                                        aria-label="行を削除"
                                                                                    >
                                                                                        <DeleteOutlineIcon fontSize="small" />
                                                                                    </IconButton>
                                                                                </TableCell>
                                                                            </TableRow>
                                                                        ))}
                                                                    </TableBody>
                                                                </Table>
                                                            </TableContainer>
                                                            <Button
                                                                size="small"
                                                                variant="outlined"
                                                                onClick={() => setEditingCandidates((prev) => [...prev, { name: '', raw_line: '', type_hint: '', matched_member_id: null, matched_member_name: null, match_source: null }])}
                                                            >
                                                                候補追加
                                                            </Button>
                                                            <Stack direction="row" spacing={1}>
                                                                <Button
                                                                    size="small"
                                                                    variant="contained"
                                                                    disabled={candidatesSaving || editingCandidates.every((c) => !String(c.name || '').trim())}
                                                                    onClick={async () => {
                                                                        if (!meeting?.id || !onDetailRefresh) return;
                                                                        setCandidatesSaving(true);
                                                                        try {
                                                                            await putParticipantImportCandidates(meeting.id, editingCandidates);
                                                                            setCandidateEditMode(false);
                                                                            onDetailRefresh();
                                                                        } finally {
                                                                            setCandidatesSaving(false);
                                                                        }
                                                                    }}
                                                                >
                                                                    {candidatesSaving ? '保存中…' : '保存'}
                                                                </Button>
                                                                <Button
                                                                    size="small"
                                                                    variant="outlined"
                                                                    disabled={candidatesSaving}
                                                                    onClick={() => { setCandidateEditMode(false); setEditingCandidates([]); }}
                                                                >
                                                                    キャンセル
                                                                </Button>
                                                            </Stack>
                                                        </Stack>
                                                    ) : candidates.length === 0 ? (
                                                        <Typography variant="caption" color="text.secondary">
                                                            候補なし
                                                        </Typography>
                                                    ) : (
                                                        <TableContainer sx={{ maxHeight: 220, border: 1, borderColor: 'divider', borderRadius: 1 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead>
                                                                    <TableRow>
                                                                        <TableCell sx={{ fontWeight: 700, py: 0.5 }}>名前</TableCell>
                                                                        <TableCell sx={{ fontWeight: 700, py: 0.5 }}>種別推定</TableCell>
                                                                        <TableCell sx={{ fontWeight: 700, py: 0.5 }}>抽出元行</TableCell>
                                                                        <TableCell sx={{ fontWeight: 700, py: 0.5 }}>照合</TableCell>
                                                                    </TableRow>
                                                                </TableHead>
                                                                <TableBody>
                                                                    {candidates.map((c, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell sx={{ py: 0.5 }}>{c.name || '—'}</TableCell>
                                                                            <TableCell sx={{ py: 0.5 }}>
                                                                                <Chip size="small" label={typeHintLabel(c.type_hint)} variant="outlined" sx={{ height: 20, fontSize: '0.7rem' }} />
                                                                            </TableCell>
                                                                            <TableCell sx={{ py: 0.5, fontSize: '0.75rem', color: 'text.secondary' }} title={c.raw_line}>
                                                                                {(c.raw_line || '').length > 24 ? `${(c.raw_line || '').slice(0, 24)}…` : (c.raw_line || '—')}
                                                                            </TableCell>
                                                                            <TableCell sx={{ py: 0.5 }}>
                                                                                {c.match_source === 'manual' && c.match_status === 'matched' ? (
                                                                                    <Chip size="small" label="既存 member（手動）" color="primary" variant="outlined" sx={{ height: 20, fontSize: '0.7rem' }} title={c.matched_member_name ?? ''} />
                                                                                ) : c.match_status === 'matched' ? (
                                                                                    <Chip size="small" label="既存 member（自動）" color="success" variant="outlined" sx={{ height: 20, fontSize: '0.7rem' }} title={c.matched_member_name ?? ''} />
                                                                                ) : (
                                                                                    <Chip size="small" label="新規作成" color="warning" variant="outlined" sx={{ height: 20, fontSize: '0.7rem' }} />
                                                                                )}
                                                                            </TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    )}
                                                </Stack>
                                            )}
                                        </Stack>
                                    ) : (
                                        <Stack direction="row" alignItems="center" spacing={1} flexWrap="wrap">
                                            <Typography variant="body2" color="text.secondary">
                                                未登録
                                            </Typography>
                                            <Button
                                                size="small"
                                                variant="outlined"
                                                startIcon={<CloudUploadIcon />}
                                                onClick={() => meetingFromList && onPdfRegisterClick?.(meetingFromList)}
                                            >
                                                参加者PDF登録
                                            </Button>
                                        </Stack>
                                    )}
                                </Box>
                            </Box>
                        )}
                        <Dialog open={memberSearchOpen} onClose={() => setMemberSearchOpen(false)} maxWidth="xs" fullWidth>
                            <DialogTitle>member を選択</DialogTitle>
                            <DialogContent>
                                <MuiTextField
                                    size="small"
                                    placeholder="名前で検索"
                                    value={memberSearchQuery}
                                    onChange={(e) => setMemberSearchQuery(e.target.value)}
                                    fullWidth
                                    sx={{ mb: 1 }}
                                    autoFocus
                                />
                                {memberSearchLoading && <CircularProgress size={20} sx={{ display: 'block', mx: 'auto', my: 1 }} />}
                                <Stack spacing={0.5} sx={{ maxHeight: 240, overflow: 'auto' }}>
                                    {!memberSearchLoading && memberSearchResults.length === 0 && memberSearchQuery.trim() !== '' && (
                                        <Typography variant="body2" color="text.secondary">該当なし</Typography>
                                    )}
                                    {!memberSearchLoading && memberSearchResults.map((m) => (
                                        <Button
                                            key={m.id}
                                            size="small"
                                            variant="outlined"
                                            fullWidth
                                            sx={{ justifyContent: 'flex-start', textTransform: 'none' }}
                                            onClick={() => {
                                                                if (memberSearchRowIndex != null) {
                                                                    setEditingCandidates((prev) => prev.map((row, j) => j === memberSearchRowIndex
                                                                        ? { ...row, matched_member_id: m.id, matched_member_name: m.name, match_source: 'manual' }
                                                                        : row));
                                                                }
                                                                setMemberSearchOpen(false);
                                                                setMemberSearchRowIndex(null);
                                                            }}
                                        >
                                            {m.name}
                                        </Button>
                                    ))}
                                </Stack>
                            </DialogContent>
                        </Dialog>
                        <Dialog open={applyConfirmOpen} onClose={() => !applyLoading && setApplyConfirmOpen(false)}>
                            <DialogTitle>participants に反映</DialogTitle>
                            <DialogContent>
                                <DialogContentText component="div">
                                    {typeof totalCount === 'number' && totalCount >= 0 && (
                                        <Typography variant="body2" sx={{ mb: 1 }}>
                                            合計 {totalCount}件（既存 member 一致 {matchedCount}件 / 新規作成 {newCount}件）
                                        </Typography>
                                    )}
                                    <Typography variant="body2">
                                        この Meeting の参加者を候補で上書きします。既存の参加者データは削除されます。よろしいですか？
                                    </Typography>
                                </DialogContentText>
                            </DialogContent>
                            <DialogActions>
                                <Button onClick={() => setApplyConfirmOpen(false)} disabled={applyLoading}>キャンセル</Button>
                                <Button
                                    variant="contained"
                                    onClick={async () => {
                                        if (!meeting?.id || !onDetailRefresh) return;
                                        setApplyLoading(true);
                                        try {
                                            const res = await postParticipantImportApply(meeting.id);
                                            setApplyConfirmOpen(false);
                                            onDetailRefresh();
                                            window.alert(`${res.applied_count}件を participants に反映しました。`);
                                        } catch (e) {
                                            window.alert(e?.message ?? '反映に失敗しました。');
                                        } finally {
                                            setApplyLoading(false);
                                        }
                                    }}
                                    disabled={applyLoading}
                                >
                                    {applyLoading ? '反映中…' : '反映する'}
                                </Button>
                            </DialogActions>
                        </Dialog>
                        {rooms.length > 0 && (
                            <Box sx={{ mb: 2 }}>
                                <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 1 }}>
                                    BO割当
                                </Typography>
                                <Stack spacing={1}>
                                    {rooms.map((room) => (
                                        <Box
                                            key={room.room_label}
                                            sx={{
                                                border: 1,
                                                borderColor: 'divider',
                                                borderRadius: 1,
                                                p: 1,
                                            }}
                                        >
                                            <Typography variant="caption" fontWeight={700} color="primary">
                                                {room.room_label}
                                            </Typography>
                                            {room.member_names?.length ? (
                                                <Stack direction="row" flexWrap="wrap" gap={0.5} sx={{ mt: 0.5 }}>
                                                    {room.member_names.map((name, i) => (
                                                        <Chip key={i} size="small" label={name} variant="outlined" sx={{ height: 22, fontSize: '0.75rem' }} />
                                                    ))}
                                                </Stack>
                                            ) : (
                                                <Typography variant="caption" color="text.secondary" display="block">
                                                    —
                                                </Typography>
                                            )}
                                        </Box>
                                    ))}
                                </Stack>
                            </Box>
                        )}
                        <Stack direction="row" spacing={1} sx={{ mt: 'auto', pt: 2 }}>
                            <Button
                                size="small"
                                variant="outlined"
                                onClick={() => meetingFromList && onMemoClick(meetingFromList)}
                                sx={{ flex: 1 }}
                            >
                                📝 メモ編集
                            </Button>
                            {!participantImport?.has_pdf && meetingFromList && (
                                <Button
                                    size="small"
                                    variant="outlined"
                                    startIcon={<CloudUploadIcon />}
                                    onClick={() => onPdfRegisterClick?.(meetingFromList)}
                                    sx={{ flex: 1 }}
                                >
                                    参加者PDF登録
                                </Button>
                            )}
                            <Button component={Link} to="/connections" size="small" variant="outlined" sx={{ flex: 1 }}>
                                🗺 Connectionsへ
                            </Button>
                        </Stack>
                    </>
                ) : (
                    <Typography color="text.secondary">データを取得できませんでした。</Typography>
                )}
            </Box>
        </Drawer>
    );
}

export function MeetingsList() {
    const refresh = useRefresh();
    const [selectedMeeting, setSelectedMeeting] = useState(null);
    const [detailOpen, setDetailOpen] = useState(false);
    const [detailLoading, setDetailLoading] = useState(false);
    const [detailData, setDetailData] = useState(null);
    const [memoDialogOpen, setMemoDialogOpen] = useState(false);
    const [memoTargetMeeting, setMemoTargetMeeting] = useState(null);
    const [memoValue, setMemoValue] = useState('');
    const [memoSaving, setMemoSaving] = useState(false);
    const [pdfModalOpen, setPdfModalOpen] = useState(false);
    const [pdfTargetMeeting, setPdfTargetMeeting] = useState(null);
    const [pdfFile, setPdfFile] = useState(null);
    const [pdfUploading, setPdfUploading] = useState(false);
    const pdfInputRef = useRef(null);
    const [stats, setStats] = useState(null);
    const [statsLoading, setStatsLoading] = useState(true);
    const [statsError, setStatsError] = useState(null);

    useEffect(() => {
        setStatsLoading(true);
        setStatsError(null);
        fetchMeetingsStats()
            .then(setStats)
            .catch((e) => setStatsError(e?.message ?? 'Error'))
            .finally(() => setStatsLoading(false));
    }, []);

    const openDetail = useCallback((record) => {
        if (!record?.id) return;
        setSelectedMeeting(record);
        setDetailOpen(true);
        setDetailData(null);
        setDetailLoading(true);
        fetchMeetingDetail(record.id)
            .then(setDetailData)
            .catch(() => setDetailData(null))
            .finally(() => setDetailLoading(false));
    }, []);

    const closeDetail = useCallback(() => {
        setDetailOpen(false);
        setSelectedMeeting(null);
        setDetailData(null);
    }, []);

    const handleMeetingMemoClick = useCallback((record) => {
        if (!record?.id) return;
        setMemoTargetMeeting(record);
        if (selectedMeeting?.id === record.id && detailData?.memo_body != null) {
            setMemoValue(detailData.memo_body);
        } else {
            setMemoValue('');
            fetchMeetingMemo(record.id).then((b) => setMemoValue(b ?? '')).catch(() => setMemoValue(''));
        }
        setMemoDialogOpen(true);
    }, [selectedMeeting?.id, detailData?.memo_body]);

    const closeMemoDialog = useCallback(() => {
        setMemoDialogOpen(false);
        setMemoTargetMeeting(null);
        setMemoValue('');
        setMemoSaving(false);
    }, []);

    const handlePdfRegisterClick = useCallback((record) => {
        if (!record?.id) return;
        setPdfTargetMeeting(record);
        setPdfFile(null);
        setPdfModalOpen(true);
    }, []);

    const closePdfModal = useCallback(() => {
        setPdfModalOpen(false);
        setPdfTargetMeeting(null);
        setPdfFile(null);
        setPdfUploading(false);
    }, []);

    const uploadPdf = useCallback(async () => {
        if (!pdfTargetMeeting?.id || !pdfFile) return;
        setPdfUploading(true);
        try {
            await postParticipantImport(pdfTargetMeeting.id, pdfFile);
            if (selectedMeeting?.id === pdfTargetMeeting.id) {
                const next = await fetchMeetingDetail(pdfTargetMeeting.id);
                setDetailData(next);
            }
            closePdfModal();
        } catch (e) {
            setPdfUploading(false);
        }
    }, [pdfTargetMeeting, pdfFile, selectedMeeting?.id, closePdfModal]);

    const saveMeetingMemo = useCallback(async () => {
        if (!memoTargetMeeting?.id) return;
        setMemoSaving(true);
        try {
            const res = await putMeetingMemo(memoTargetMeeting.id, memoValue);
            refresh();
            if (selectedMeeting?.id === memoTargetMeeting.id && detailData) {
                setDetailData((prev) => (prev ? { ...prev, memo_body: res.body, meeting: { ...prev.meeting, has_memo: res.has_memo } } : null));
            }
            closeMemoDialog();
        } catch {
            setMemoSaving(false);
        }
    }, [memoTargetMeeting, memoValue, selectedMeeting?.id, detailData, refresh, closeMemoDialog]);

    return (
        <>
            <List
                title={<MeetingsListTitle />}
                actions={<MeetingsListActions />}
                perPage={25}
            >
                <MeetingsStatsCards stats={stats} loading={statsLoading} error={statsError} />
                <MeetingsToolbar />
                <Datagrid
                    rowClick={(id, resource, record) => openDetail(record)}
                >
                    <TextField source="number" label="番号" />
                    <FunctionField label="開催日" render={(r) => <HeldOnField record={r} />} />
                    <FunctionField label="BO数" render={(r) => <BreakoutCountField record={r} />} />
                    <FunctionField label="メモ" render={(r) => <HasMemoField record={r} />} />
                    <FunctionField label="参加者PDF" render={(r) => <HasParticipantPdfField record={r} />} />
                    <FunctionField label="Actions" render={(r) => <MeetingActionsField record={r} onMemoClick={handleMeetingMemoClick} />} />
                </Datagrid>
            </List>
            <MeetingDetailDrawer
                open={detailOpen}
                onClose={closeDetail}
                data={detailData}
                loading={detailLoading}
                meetingFromList={selectedMeeting}
                onMemoClick={handleMeetingMemoClick}
                onPdfRegisterClick={handlePdfRegisterClick}
                onDetailRefresh={selectedMeeting?.id ? () => fetchMeetingDetail(selectedMeeting.id).then(setDetailData) : undefined}
            />
            <Dialog open={memoDialogOpen} onClose={closeMemoDialog} maxWidth="sm" fullWidth>
                <DialogTitle>📝 例会メモ編集{memoTargetMeeting ? ` — #${memoTargetMeeting.number}` : ''}</DialogTitle>
                <DialogContent>
                    <MuiTextField
                        autoFocus
                        margin="dense"
                        label="例会メモ"
                        fullWidth
                        multiline
                        rows={5}
                        value={memoValue}
                        onChange={(e) => setMemoValue(e.target.value)}
                        placeholder="例会の概要、特記事項、BOの状況など…"
                        disabled={memoSaving}
                        variant="outlined"
                        sx={{ mt: 1 }}
                    />
                    <DialogContentText variant="body2" color="text.secondary" sx={{ mt: 2 }}>
                        💡 BO割当の詳細は <Link to="/connections" onClick={closeMemoDialog}>Connectionsで編集</Link> できます
                    </DialogContentText>
                </DialogContent>
                <DialogActions>
                    <Button onClick={closeMemoDialog} disabled={memoSaving}>キャンセル</Button>
                    <Button onClick={saveMeetingMemo} variant="contained" disabled={memoSaving}>
                        {memoSaving ? '保存中…' : '保存する'}
                    </Button>
                </DialogActions>
            </Dialog>
            <Dialog open={pdfModalOpen} onClose={closePdfModal} maxWidth="sm" fullWidth>
                <DialogTitle>参加者PDF登録{pdfTargetMeeting ? ` — #${pdfTargetMeeting.number}` : ''}</DialogTitle>
                <DialogContent>
                    <DialogContentText variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                        例会前日に届いた参加者一覧PDFをアップロードします。参加者の自動登録は P2 以降で対応予定です。
                    </DialogContentText>
                    <input
                        ref={pdfInputRef}
                        type="file"
                        accept=".pdf,application/pdf"
                        style={{ display: 'none' }}
                        onChange={(e) => setPdfFile(e.target.files?.[0] ?? null)}
                    />
                    <Button
                        variant="outlined"
                        startIcon={<CloudUploadIcon />}
                        disabled={pdfUploading}
                        onClick={() => pdfInputRef.current?.click()}
                        sx={{ mt: 1 }}
                    >
                        PDFを選択
                    </Button>
                    {pdfFile && (
                        <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                            {pdfFile.name}
                        </Typography>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={closePdfModal} disabled={pdfUploading}>キャンセル</Button>
                    <Button onClick={uploadPdf} variant="contained" disabled={!pdfFile || pdfUploading}>
                        {pdfUploading ? 'アップロード中…' : 'アップロード'}
                    </Button>
                </DialogActions>
            </Dialog>
        </>
    );
}
