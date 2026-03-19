import React, { useState, useCallback, useEffect, useRef, Fragment } from 'react';
import { List, Datagrid, TextField, FunctionField, TopToolbar, Button, useRefresh, useListContext, useNotify } from 'react-admin';
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
    FormControlLabel,
    InputLabel,
    Select,
    MenuItem,
    Checkbox,
    Card,
    CardContent,
    Grid,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    Alert,
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
import AddIcon from '@mui/icons-material/Add';

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

async function postMeeting(payload) {
    const res = await fetch(`${API_BASE}/api/meetings`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        const fromErrors = data.errors && typeof data.errors === 'object'
            ? Object.values(data.errors).flat().filter(Boolean).join(' ')
            : '';
        throw new Error(fromErrors || data.message || `API ${res.status}`);
    }
    return data;
}

async function patchMeeting(meetingId, payload) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        const fromErrors = data.errors && typeof data.errors === 'object'
            ? Object.values(data.errors).flat().filter(Boolean).join(' ')
            : '';
        throw new Error(fromErrors || data.message || `API ${res.status}`);
    }
    return data;
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

async function postCsvImport(meetingId, file) {
    const form = new FormData();
    form.append('csv', file);
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import`, {
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

async function fetchCsvPreview(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/preview`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function fetchCsvDiffPreview(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/diff-preview`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function fetchCsvMemberDiffPreview(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/member-diff-preview`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function fetchCsvRoleDiffPreview(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/role-diff-preview`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postCsvMemberApply(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/member-apply`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: '{}',
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postCsvRoleApply(meetingId, body = {}) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/role-apply`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(body && Object.keys(body).length ? body : {}),
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postCsvImportApply(meetingId, body = {}) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/apply`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: Object.keys(body).length ? JSON.stringify(body) : undefined,
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

async function fetchCategorySearch(q) {
    const params = new URLSearchParams({ q: String(q || '').trim() });
    const res = await fetch(`${API_BASE}/api/categories/search?${params}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

async function fetchRoleSearch(q) {
    const params = new URLSearchParams({ q: String(q || '').trim() });
    const res = await fetch(`${API_BASE}/api/roles/search?${params}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

async function fetchCsvUnresolved(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/unresolved`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function fetchCsvUnresolvedSuggestions(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/unresolved-suggestions`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postCsvResolution(meetingId, body) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/resolutions`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postCsvResolutionCreateMember(meetingId, body) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/resolutions/create-member`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postCsvResolutionCreateCategory(meetingId, body) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/resolutions/create-category`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function postCsvResolutionCreateRole(meetingId, body) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/resolutions/create-role`, {
        method: 'POST',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function fetchCsvResolutionsList(meetingId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/resolutions`, {
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function putCsvResolution(meetingId, resolutionId, body) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/resolutions/${resolutionId}`, {
        method: 'PUT',
        headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
    return res.json();
}

async function deleteCsvResolution(meetingId, resolutionId) {
    const res = await fetch(`${API_BASE}/api/meetings/${meetingId}/csv-import/resolutions/${resolutionId}`, {
        method: 'DELETE',
        headers: { Accept: 'application/json' },
    });
    if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `API ${res.status}`);
    }
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

function MeetingsListTopActions({ onMeetingCreated }) {
    const refresh = useRefresh();
    const notify = useNotify();
    const [createOpen, setCreateOpen] = useState(false);
    const [numberInput, setNumberInput] = useState('');
    const [heldOnInput, setHeldOnInput] = useState('');
    const [nameInput, setNameInput] = useState('');
    const [creating, setCreating] = useState(false);

    const handleCloseCreate = () => {
        if (creating) return;
        setCreateOpen(false);
    };

    const submitCreate = async () => {
        const num = parseInt(numberInput, 10);
        if (Number.isNaN(num)) {
            notify('番号は整数で入力してください', { type: 'warning' });
            return;
        }
        if (!heldOnInput || String(heldOnInput).trim() === '') {
            notify('開催日を入力してください', { type: 'warning' });
            return;
        }
        setCreating(true);
        try {
            const payload = { number: num, held_on: heldOnInput };
            if (nameInput.trim() !== '') {
                payload.name = nameInput.trim();
            }
            await postMeeting(payload);
            notify('例会を作成しました', { type: 'success' });
            setCreateOpen(false);
            setNumberInput('');
            setHeldOnInput('');
            setNameInput('');
            refresh();
            onMeetingCreated?.();
        } catch (e) {
            notify(e.message || '作成に失敗しました', { type: 'error' });
        } finally {
            setCreating(false);
        }
    };

    return (
        <>
            <TopToolbar>
                <Button
                    label="＋ 新規例会"
                    onClick={() => setCreateOpen(true)}
                    variant="contained"
                    size="small"
                    startIcon={<AddIcon />}
                />
                <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connectionsで編集</Button>
            </TopToolbar>
            <Dialog open={createOpen} onClose={handleCloseCreate} maxWidth="sm" fullWidth>
                <DialogTitle>新規例会</DialogTitle>
                <DialogContent>
                    <MuiTextField
                        autoFocus
                        margin="dense"
                        label="例会番号（必須）"
                        type="number"
                        fullWidth
                        value={numberInput}
                        onChange={(e) => setNumberInput(e.target.value)}
                        disabled={creating}
                        sx={{ mt: 0.5 }}
                    />
                    <MuiTextField
                        margin="dense"
                        label="開催日（必須）"
                        type="date"
                        fullWidth
                        value={heldOnInput}
                        onChange={(e) => setHeldOnInput(e.target.value)}
                        disabled={creating}
                        InputLabelProps={{ shrink: true }}
                        sx={{ mt: 1 }}
                    />
                    <MuiTextField
                        margin="dense"
                        label="名称（任意）"
                        fullWidth
                        value={nameInput}
                        onChange={(e) => setNameInput(e.target.value)}
                        disabled={creating}
                        placeholder="例: 第200回定例会"
                        helperText="未入力のときは「第N回定例会」になります（N＝例会番号）"
                        sx={{ mt: 1 }}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCloseCreate} disabled={creating}>キャンセル</Button>
                    <Button onClick={submitCreate} variant="contained" disabled={creating}>
                        {creating ? '作成中…' : '作成する'}
                    </Button>
                </DialogActions>
            </Dialog>
        </>
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

function MeetingActionsField({ record, onMemoClick, onEditClick }) {
    if (!record) return null;
    return (
        <Stack direction="row" spacing={0.5} flexWrap="wrap" useFlexGap onClick={(e) => e.stopPropagation()}>
            <Button
                size="small"
                variant="outlined"
                onClick={() => onEditClick?.(record)}
                sx={{ minWidth: 'auto', px: 1 }}
            >
                編集
            </Button>
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

function participantTypeLabel(t) {
    if (t == null || t === '') return '—';
    const map = { regular: 'メンバー', visitor: 'ビジター', guest: 'ゲスト', proxy: '代理' };
    return map[t] ?? t;
}

function csvMatchReasonLabel(reason) {
    const map = {
        exact_match: '完全一致',
        normalized_match: '正規化一致',
        kana_match: 'かな一致',
        prefix_match: '前方一致',
        partial_match: '部分一致',
    };
    return map[reason] || String(reason || '');
}

const TYPE_HINT_OPTIONS = [
    { value: 'regular', label: 'メンバー候補' },
    { value: 'guest', label: 'ゲスト候補' },
    { value: 'visitor', label: 'ビジター候補' },
    { value: 'proxy', label: '代理候補' },
    { value: '', label: '不明' },
];

function MeetingDetailDrawer({ open, onClose, data, loading, meetingFromList, onMemoClick, onPdfRegisterClick, onDetailRefresh }) {
    const notify = useNotify();
    const [parseLoading, setParseLoading] = useState(false);
    const [csvUploadLoading, setCsvUploadLoading] = useState(false);
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
    const [csvPreviewData, setCsvPreviewData] = useState(null);
    const [csvPreviewLoading, setCsvPreviewLoading] = useState(false);
    const [csvPreviewError, setCsvPreviewError] = useState(null);
    const [csvDiffData, setCsvDiffData] = useState(null);
    const [csvDiffLoading, setCsvDiffLoading] = useState(false);
    const [csvDiffError, setCsvDiffError] = useState(null);
    const [csvMemberDiffData, setCsvMemberDiffData] = useState(null);
    const [csvMemberDiffLoading, setCsvMemberDiffLoading] = useState(false);
    const [csvMemberDiffError, setCsvMemberDiffError] = useState(null);
    const [csvRoleDiffData, setCsvRoleDiffData] = useState(null);
    const [csvRoleDiffLoading, setCsvRoleDiffLoading] = useState(false);
    const [csvRoleDiffError, setCsvRoleDiffError] = useState(null);
    const [csvRoleApplyConfirmOpen, setCsvRoleApplyConfirmOpen] = useState(false);
    const [csvRoleApplyLoading, setCsvRoleApplyLoading] = useState(false);
    const [roleEffectiveDate, setRoleEffectiveDate] = useState('');
    const [deleteMissing, setDeleteMissing] = useState(false);
    const [csvApplyConfirmOpen, setCsvApplyConfirmOpen] = useState(false);
    const [csvApplyLoading, setCsvApplyLoading] = useState(false);
    const [csvMemberApplyConfirmOpen, setCsvMemberApplyConfirmOpen] = useState(false);
    const [csvMemberApplyLoading, setCsvMemberApplyLoading] = useState(false);
    const [csvUnresolvedOpen, setCsvUnresolvedOpen] = useState(false);
    const [csvUnresolvedData, setCsvUnresolvedData] = useState(null);
    const [csvUnresolvedLoading, setCsvUnresolvedLoading] = useState(false);
    const [csvUnresolvedError, setCsvUnresolvedError] = useState(null);
    const [csvResSaving, setCsvResSaving] = useState(false);
    const [csvResPick, setCsvResPick] = useState(null);
    const [csvResPickQ, setCsvResPickQ] = useState('');
    const [csvResPickResults, setCsvResPickResults] = useState([]);
    const [csvResPickLoading, setCsvResPickLoading] = useState(false);
    const [csvResCreate, setCsvResCreate] = useState(null);
    const [csvCreateMemberName, setCsvCreateMemberName] = useState('');
    const [csvCreateMemberKana, setCsvCreateMemberKana] = useState('');
    const [csvCreateMemberType, setCsvCreateMemberType] = useState('regular');
    const [csvCreateCatGroup, setCsvCreateCatGroup] = useState('');
    const [csvCreateCatName, setCsvCreateCatName] = useState('');
    const [csvCreateRoleName, setCsvCreateRoleName] = useState('');
    const [csvSuggestionsData, setCsvSuggestionsData] = useState(null);
    const [csvSuggestionsLoading, setCsvSuggestionsLoading] = useState(false);
    const [csvSuggestionsExpanded, setCsvSuggestionsExpanded] = useState({});
    const [csvResManageOpen, setCsvResManageOpen] = useState(false);
    const [csvResolutionsList, setCsvResolutionsList] = useState([]);
    const [csvResolutionsLoading, setCsvResolutionsLoading] = useState(false);
    const [csvResolutionsError, setCsvResolutionsError] = useState(null);
    const csvInputRef = useRef(null);

    const meeting = data?.meeting;
    const memoBody = data?.memo_body;
    const participantImport = data?.participant_import;
    const rooms = data?.rooms ?? [];
    const parseSuccess = participantImport?.has_pdf && participantImport?.parse_status === 'success';
    const parseFailed = participantImport?.has_pdf && participantImport?.parse_status === 'failed';
    const parsePending = participantImport?.has_pdf && (participantImport?.parse_status === 'pending' || !participantImport?.parse_status);
    const showParseButton = participantImport?.has_pdf && !candidateEditMode;
    const parseButtonLabel = parsePending ? 'PDF解析' : '再解析';
    const candidateCount = participantImport?.candidate_count ?? 0;
    const candidates = Array.isArray(participantImport?.candidates) ? participantImport.candidates : [];
    const matchedCount = participantImport?.matched_count ?? 0;
    const newCount = participantImport?.new_count ?? 0;
    const totalCount = participantImport?.total_count ?? candidateCount;
    const importedAt = participantImport?.imported_at ?? null;
    const appliedCount = participantImport?.applied_count ?? null;
    const csvImport = data?.csv_import;
    const csvApplyLogsRecent = Array.isArray(data?.csv_apply_logs_recent) ? data.csv_apply_logs_recent : [];

    const hasCsvMemberApplyTarget =
        csvMemberDiffData &&
        ((Array.isArray(csvMemberDiffData.updated_member_basic) && csvMemberDiffData.updated_member_basic.length > 0) ||
            (Array.isArray(csvMemberDiffData.category_changed) &&
                csvMemberDiffData.category_changed.some((c) => c.category_master_resolved === true)));

    const hasCsvRoleApplyTarget =
        csvRoleDiffData &&
        ((Array.isArray(csvRoleDiffData.changed_role) && csvRoleDiffData.changed_role.some((r) => r.role_master_resolved === true)) ||
            (Array.isArray(csvRoleDiffData.csv_role_only) && csvRoleDiffData.csv_role_only.some((r) => r.role_master_resolved === true)) ||
            (Array.isArray(csvRoleDiffData.current_role_only) && csvRoleDiffData.current_role_only.length > 0));

    useEffect(() => {
        if (!open) {
            setCandidateEditMode(false);
            setEditingCandidates([]);
            setApplyConfirmOpen(false);
            setMemberSearchOpen(false);
            setCsvPreviewData(null);
            setCsvPreviewError(null);
            setCsvDiffData(null);
            setCsvDiffError(null);
            setCsvMemberDiffData(null);
            setCsvMemberDiffError(null);
            setCsvRoleDiffData(null);
            setCsvRoleDiffError(null);
            setCsvRoleApplyConfirmOpen(false);
            setRoleEffectiveDate('');
            setCsvMemberApplyConfirmOpen(false);
            setDeleteMissing(false);
            setCsvUnresolvedOpen(false);
            setCsvUnresolvedData(null);
            setCsvUnresolvedError(null);
            setCsvResPick(null);
            setCsvResCreate(null);
            setCsvResPickQ('');
            setCsvSuggestionsData(null);
            setCsvSuggestionsExpanded({});
            setCsvResManageOpen(false);
            setCsvResolutionsList([]);
            setCsvResolutionsError(null);
        }
    }, [open]);

    useEffect(() => {
        if (!csvResPick) {
            setCsvResPickResults([]);
            setCsvResPickLoading(false);
            return;
        }
        const q = String(csvResPickQ || '').trim();
        if (q === '') {
            setCsvResPickResults([]);
            setCsvResPickLoading(false);
            return;
        }
        let cancelled = false;
        setCsvResPickLoading(true);
        const fetchFn = csvResPick.kind === 'member' ? fetchMemberSearch
            : csvResPick.kind === 'category' ? fetchCategorySearch
            : fetchRoleSearch;
        fetchFn(q).then((list) => {
            if (!cancelled) setCsvResPickResults(Array.isArray(list) ? list : []);
        }).catch(() => { if (!cancelled) setCsvResPickResults([]); }).finally(() => { if (!cancelled) setCsvResPickLoading(false); });
        return () => { cancelled = true; };
    }, [csvResPick, csvResPickQ]);

    useEffect(() => {
        if (!open || !meeting?.held_on) return;
        const d = String(meeting.held_on).slice(0, 10);
        if (/^\d{4}-\d{2}-\d{2}$/.test(d)) setRoleEffectiveDate(d);
    }, [open, meeting?.id, meeting?.held_on]);

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

    useEffect(() => {
        if (!csvImport?.has_csv || !meeting?.id) {
            setCsvPreviewData(null);
            setCsvPreviewError(null);
            setCsvDiffData(null);
            setCsvDiffError(null);
        }
    }, [csvImport?.has_csv, meeting?.id]);

    const refreshCsvAfterResolution = useCallback(async () => {
        if (!meeting?.id || !csvImport?.has_csv) return;
        const mid = meeting.id;
        try {
            const unr = await fetchCsvUnresolved(mid);
            setCsvUnresolvedData(unr);
            setCsvUnresolvedError(null);
        } catch (e) {
            setCsvUnresolvedError(e?.message || '再取得に失敗しました');
        }
        setCsvSuggestionsData(null);
        setCsvSuggestionsExpanded({});
        try {
            if (csvPreviewData) {
                setCsvPreviewData(await fetchCsvPreview(mid));
            }
            if (csvDiffData) {
                setCsvDiffData(await fetchCsvDiffPreview(mid));
            }
            if (csvMemberDiffData) {
                setCsvMemberDiffData(await fetchCsvMemberDiffPreview(mid));
            }
            if (csvRoleDiffData) {
                setCsvRoleDiffData(await fetchCsvRoleDiffPreview(mid));
            }
        } catch {
            /* プレビュー再取得失敗時は既存表示を維持 */
        }
        if (csvResManageOpen) {
            try {
                const d = await fetchCsvResolutionsList(mid);
                setCsvResolutionsList(Array.isArray(d.resolutions) ? d.resolutions : []);
                setCsvResolutionsError(null);
            } catch (e) {
                setCsvResolutionsError(e?.message || '解決一覧の再取得に失敗しました');
            }
        }
    }, [meeting?.id, csvImport?.has_csv, csvPreviewData, csvDiffData, csvMemberDiffData, csvRoleDiffData, csvResManageOpen]);

    const csvSugFor = (kind, sourceValue) => {
        const key = kind === 'member' ? 'unresolved_member' : kind === 'category' ? 'unresolved_category' : 'unresolved_role';
        const arr = csvSuggestionsData?.[key];
        if (!Array.isArray(arr)) return [];
        const b = arr.find((x) => x.source_value === sourceValue);
        return Array.isArray(b?.suggestions) ? b.suggestions : [];
    };

    const csvSugMemberDupMeta = (sourceValue) => {
        const arr = csvSuggestionsData?.unresolved_member;
        if (!Array.isArray(arr)) {
            return { duplicate_name_warning: false, duplicate_count: 0 };
        }
        const b = arr.find((x) => x.source_value === sourceValue);
        return {
            duplicate_name_warning: !!b?.duplicate_name_warning,
            duplicate_count: b?.duplicate_count ?? 0,
        };
    };

    const toggleCsvSuggestions = async (kind, sourceValue) => {
        const prefix = kind === 'member' ? 'm' : kind === 'category' ? 'c' : 'r';
        const sk = `${prefix}:${sourceValue}`;
        if (!meeting?.id) return;
        if (!csvSuggestionsData) {
            setCsvSuggestionsLoading(true);
            try {
                const d = await fetchCsvUnresolvedSuggestions(meeting.id);
                setCsvSuggestionsData(d);
                setCsvSuggestionsExpanded((p) => ({ ...p, [sk]: true }));
            } catch (e) {
                notify(e?.message || '候補の取得に失敗しました', { type: 'error' });
            } finally {
                setCsvSuggestionsLoading(false);
            }
        } else {
            setCsvSuggestionsExpanded((p) => ({ ...p, [sk]: !p[sk] }));
        }
    };

    const applySuggestionResolution = async (resolutionType, sourceValue, resolvedId) => {
        if (!meeting?.id) return;
        setCsvResSaving(true);
        try {
            await postCsvResolution(meeting.id, {
                resolution_type: resolutionType,
                source_value: sourceValue,
                resolved_id: resolvedId,
                action_type: 'mapped',
            });
            setCsvSuggestionsData(null);
            setCsvSuggestionsExpanded({});
            await refreshCsvAfterResolution();
            notify('解決を保存しました');
        } catch (e) {
            notify(e?.message || '保存に失敗しました', { type: 'error' });
        } finally {
            setCsvResSaving(false);
        }
    };

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
                                            {showParseButton && (
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
                                                    {parseLoading ? '解析中…' : parseButtonLabel}
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
                        <Box sx={{ mb: 2 }}>
                            <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 1 }}>
                                参加者CSV
                            </Typography>
                            <Box sx={{ border: 1, borderColor: 'divider', borderRadius: 1, p: 1.5 }}>
                                <input
                                    ref={csvInputRef}
                                    type="file"
                                    accept=".csv,.txt"
                                    style={{ display: 'none' }}
                                    onChange={(e) => {
                                        const f = e.target.files?.[0];
                                        if (!f || !meeting?.id || !onDetailRefresh) return;
                                        setCsvUploadLoading(true);
                                        postCsvImport(meeting.id, f)
                                            .then(() => {
                                                notify('CSVを保存しました');
                                                onDetailRefresh();
                                            })
                                            .catch((err) => notify(err?.message || 'アップロードに失敗しました', { type: 'error' }))
                                            .finally(() => {
                                                setCsvUploadLoading(false);
                                                e.target.value = '';
                                            });
                                    }}
                                />
                                {csvImport?.has_csv ? (
                                    <Stack spacing={1}>
                                        <Typography variant="body2" noWrap sx={{ minWidth: 0 }}>
                                            {csvImport.file_name || '参加者.csv'}
                                        </Typography>
                                        <Stack direction="row" spacing={1} flexWrap="wrap">
                                            <Button
                                                size="small"
                                                variant="outlined"
                                                disabled={csvUploadLoading}
                                                onClick={() => csvInputRef.current?.click()}
                                            >
                                                {csvUploadLoading ? 'アップロード中…' : '再アップロード'}
                                            </Button>
                                            <Button
                                                size="small"
                                                variant="outlined"
                                                color="warning"
                                                disabled={csvUnresolvedLoading || !meeting?.id}
                                                onClick={async () => {
                                                    if (!meeting?.id) return;
                                                    setCsvUnresolvedOpen(true);
                                                    setCsvUnresolvedError(null);
                                                    setCsvUnresolvedLoading(true);
                                                    try {
                                                        const d = await fetchCsvUnresolved(meeting.id);
                                                        setCsvUnresolvedData(d);
                                                    } catch (e) {
                                                        setCsvUnresolvedError(e?.message || '取得に失敗しました');
                                                        setCsvUnresolvedData(null);
                                                    } finally {
                                                        setCsvUnresolvedLoading(false);
                                                    }
                                                }}
                                            >
                                                {csvUnresolvedLoading ? '読込中…' : '未解決を解消'}
                                            </Button>
                                            <Button
                                                size="small"
                                                variant="outlined"
                                                color="secondary"
                                                disabled={csvResolutionsLoading || !meeting?.id}
                                                onClick={async () => {
                                                    if (!meeting?.id) return;
                                                    setCsvResManageOpen(true);
                                                    setCsvResolutionsError(null);
                                                    setCsvResolutionsLoading(true);
                                                    try {
                                                        const d = await fetchCsvResolutionsList(meeting.id);
                                                        setCsvResolutionsList(Array.isArray(d.resolutions) ? d.resolutions : []);
                                                    } catch (e) {
                                                        setCsvResolutionsError(e?.message || '取得に失敗しました');
                                                        setCsvResolutionsList([]);
                                                    } finally {
                                                        setCsvResolutionsLoading(false);
                                                    }
                                                }}
                                            >
                                                {csvResolutionsLoading && csvResManageOpen ? '読込中…' : '解決済みを確認'}
                                            </Button>
                                            <Button
                                                size="small"
                                                variant="outlined"
                                                disabled={csvPreviewLoading || !meeting?.id}
                                                onClick={() => {
                                                    if (!meeting?.id) return;
                                                    setCsvPreviewError(null);
                                                    setCsvPreviewLoading(true);
                                                    fetchCsvPreview(meeting.id)
                                                        .then((d) => {
                                                            setCsvPreviewData(d);
                                                        })
                                                        .catch((err) => {
                                                            setCsvPreviewError(err?.message || '読み込みに失敗しました');
                                                            setCsvPreviewData(null);
                                                        })
                                                        .finally(() => setCsvPreviewLoading(false));
                                                }}
                                            >
                                                {csvPreviewLoading ? '読込中…' : 'プレビュー表示'}
                                            </Button>
                                            {csvPreviewData?.row_count > 0 && (
                                                <Button
                                                    size="small"
                                                    variant="outlined"
                                                    disabled={csvDiffLoading || !meeting?.id}
                                                    onClick={() => {
                                                        if (!meeting?.id) return;
                                                        setCsvDiffError(null);
                                                        setCsvDiffLoading(true);
                                                        fetchCsvDiffPreview(meeting.id)
                                                            .then((d) => setCsvDiffData(d))
                                                            .catch((err) => {
                                                                setCsvDiffError(err?.message || '差分の取得に失敗しました');
                                                                setCsvDiffData(null);
                                                            })
                                                            .finally(() => setCsvDiffLoading(false));
                                                    }}
                                                >
                                                    {csvDiffLoading ? '取得中…' : '差分を確認'}
                                                </Button>
                                            )}
                                            {csvPreviewData?.row_count > 0 && (
                                                <Button
                                                    size="small"
                                                    variant="outlined"
                                                    color="secondary"
                                                    disabled={csvMemberDiffLoading || !meeting?.id}
                                                    onClick={() => {
                                                        if (!meeting?.id) return;
                                                        setCsvMemberDiffError(null);
                                                        setCsvMemberDiffLoading(true);
                                                        fetchCsvMemberDiffPreview(meeting.id)
                                                            .then((d) => setCsvMemberDiffData(d))
                                                            .catch((err) => {
                                                                setCsvMemberDiffError(err?.message || '取得に失敗しました');
                                                                setCsvMemberDiffData(null);
                                                            })
                                                            .finally(() => setCsvMemberDiffLoading(false));
                                                    }}
                                                >
                                                    {csvMemberDiffLoading ? '取得中…' : 'member差分を確認'}
                                                </Button>
                                            )}
                                            {csvPreviewData?.row_count > 0 && (
                                                <Button
                                                    size="small"
                                                    variant="outlined"
                                                    color="secondary"
                                                    disabled={csvRoleDiffLoading || !meeting?.id}
                                                    onClick={() => {
                                                        if (!meeting?.id) return;
                                                        setCsvRoleDiffError(null);
                                                        setCsvRoleDiffLoading(true);
                                                        fetchCsvRoleDiffPreview(meeting.id)
                                                            .then((d) => setCsvRoleDiffData(d))
                                                            .catch((err) => {
                                                                setCsvRoleDiffError(err?.message || '取得に失敗しました');
                                                                setCsvRoleDiffData(null);
                                                            })
                                                            .finally(() => setCsvRoleDiffLoading(false));
                                                    }}
                                                >
                                                    {csvRoleDiffLoading ? '取得中…' : 'role差分を確認'}
                                                </Button>
                                            )}
                                            {csvPreviewData?.row_count > 0 && (
                                                <Button
                                                    size="small"
                                                    variant="contained"
                                                    color="primary"
                                                    disabled={csvApplyLoading || !meeting?.id}
                                                    onClick={() => setCsvApplyConfirmOpen(true)}
                                                >
                                                    {csvApplyLoading ? '反映中…' : 'participants に反映'}
                                                </Button>
                                            )}
                                        </Stack>
                                        {csvDiffData?.missing?.length > 0 && (
                                            <FormControlLabel
                                                control={
                                                    <Checkbox
                                                        checked={deleteMissing}
                                                        onChange={(e) => setDeleteMissing(e.target.checked)}
                                                        size="small"
                                                    />
                                                }
                                                label="CSVにない既存 participant を削除する（BO ありは削除しない）"
                                                sx={{ mt: 0.5 }}
                                            />
                                        )}
                                        {(csvImport?.imported_at || csvImport?.applied_count != null) && (
                                            <Typography variant="caption" color="text.secondary" display="block" sx={{ mt: 0.5 }}>
                                                {csvImport?.imported_at
                                                    ? `${new Date(csvImport.imported_at).toLocaleString('ja-JP')} に ${csvImport?.applied_count ?? 0}件反映`
                                                    : `反映件数: ${csvImport?.applied_count ?? 0}件`}
                                            </Typography>
                                        )}
                                        {csvPreviewError && (
                                            <Typography variant="body2" color="error">
                                                {csvPreviewError}
                                            </Typography>
                                        )}
                                        {csvDiffError && (
                                            <Typography variant="body2" color="error" sx={{ mt: 0.5 }}>
                                                {csvDiffError}
                                            </Typography>
                                        )}
                                        {csvMemberDiffError && (
                                            <Typography variant="body2" color="error" sx={{ mt: 0.5 }}>
                                                {csvMemberDiffError}
                                            </Typography>
                                        )}
                                        {csvRoleDiffError && (
                                            <Typography variant="body2" color="error" sx={{ mt: 0.5 }}>
                                                {csvRoleDiffError}
                                            </Typography>
                                        )}
                                        {csvMemberDiffData && (
                                            <Box sx={{ mt: 1.5, p: 1.5, bgcolor: 'grey.50', borderRadius: 1, border: 1, borderColor: 'divider' }}>
                                                <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 1 }}>
                                                    members 更新候補プレビュー
                                                </Typography>
                                                <Alert severity="info" sx={{ mb: 1.5 }}>
                                                    名前・よみがな・カテゴリー（マスタ解決済みのみ）を「members に反映」で確定できます。マスタ未登録のカテゴリー・名前未解決の行は反映されません。役職 / Role History は更新しません。
                                                </Alert>
                                                <Stack direction="row" flexWrap="wrap" gap={0.5} sx={{ mb: 1.5 }} alignItems="center">
                                                    <Chip size="small" label={`基本情報更新 ${csvMemberDiffData.summary?.updated_member_basic_count ?? 0}件`} color="primary" variant="outlined" />
                                                    <Chip size="small" label={`カテゴリー変更 ${csvMemberDiffData.summary?.category_changed_count ?? 0}件`} color="warning" variant="outlined" />
                                                    <Chip size="small" label={`未解決 ${csvMemberDiffData.summary?.unresolved_member_count ?? 0}件`} variant="outlined" />
                                                    <Chip size="small" label={`変更なし ${csvMemberDiffData.summary?.unchanged_member_count ?? 0}件`} variant="outlined" />
                                                    {(csvMemberDiffData.summary?.duplicate_name_member_count ?? 0) > 0 && (
                                                        <Chip size="small" color="warning" label={`同名要注意 ${csvMemberDiffData.summary.duplicate_name_member_count}名`} variant="outlined" />
                                                    )}
                                                    {hasCsvMemberApplyTarget && (
                                                        <Button
                                                            size="small"
                                                            variant="contained"
                                                            color="secondary"
                                                            disabled={csvMemberApplyLoading || !meeting?.id}
                                                            onClick={() => setCsvMemberApplyConfirmOpen(true)}
                                                        >
                                                            {csvMemberApplyLoading ? '反映中…' : 'members に反映'}
                                                        </Button>
                                                    )}
                                                </Stack>
                                                {Array.isArray(csvMemberDiffData.updated_member_basic) && csvMemberDiffData.updated_member_basic.length > 0 && (
                                                    <Box sx={{ mb: 1.5 }}>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>基本情報更新候補</Typography>
                                                        <TableContainer sx={{ maxHeight: 160, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead>
                                                                    <TableRow>
                                                                        <TableCell>名前</TableCell>
                                                                        <TableCell>現在の名前</TableCell>
                                                                        <TableCell>CSVの名前</TableCell>
                                                                        <TableCell>現在かな</TableCell>
                                                                        <TableCell>新かな</TableCell>
                                                                        <TableCell>同名</TableCell>
                                                                    </TableRow>
                                                                </TableHead>
                                                                <TableBody>
                                                                    {csvMemberDiffData.updated_member_basic.map((r, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{r.name ?? '—'}</TableCell>
                                                                            <TableCell>{r.current_name ?? '—'}</TableCell>
                                                                            <TableCell>{r.new_name ?? '—'}</TableCell>
                                                                            <TableCell>{r.current_name_kana != null && r.current_name_kana !== '' ? r.current_name_kana : '—'}</TableCell>
                                                                            <TableCell>{r.new_name_kana != null && r.new_name_kana !== '' ? r.new_name_kana : '—'}</TableCell>
                                                                            <TableCell>
                                                                                {r.duplicate_name_warning ? (
                                                                                    <Chip size="small" color="warning" label={`${r.duplicate_count ?? '?'}件`} />
                                                                                ) : '—'}
                                                                            </TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                                {Array.isArray(csvMemberDiffData.category_changed) && csvMemberDiffData.category_changed.length > 0 && (
                                                    <Box sx={{ mb: 1.5 }}>
                                                        <Alert severity="warning" sx={{ mb: 0.5 }}>
                                                            カテゴリーは毎週変わりうるため、反映時は慎重に確認してください。マスタ未登録の値は categories に存在しません。
                                                        </Alert>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>カテゴリー変更候補</Typography>
                                                        <TableContainer sx={{ maxHeight: 160, border: 1, borderColor: 'warning.light', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead>
                                                                    <TableRow>
                                                                        <TableCell>名前</TableCell>
                                                                        <TableCell>現在カテゴリー</TableCell>
                                                                        <TableCell>新カテゴリー（CSV）</TableCell>
                                                                        <TableCell>マスタ</TableCell>
                                                                        <TableCell>同名</TableCell>
                                                                    </TableRow>
                                                                </TableHead>
                                                                <TableBody>
                                                                    {csvMemberDiffData.category_changed.map((r, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{r.name ?? '—'}</TableCell>
                                                                            <TableCell>{r.current_category || '—'}</TableCell>
                                                                            <TableCell>{r.new_category || '—'}</TableCell>
                                                                            <TableCell>{r.category_master_resolved ? <Chip size="small" label="解決" color="success" /> : <Chip size="small" label="未登録" color="warning" />}</TableCell>
                                                                            <TableCell>
                                                                                {r.duplicate_name_warning ? (
                                                                                    <Chip size="small" color="warning" label={`${r.duplicate_count ?? '?'}件`} />
                                                                                ) : '—'}
                                                                            </TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                                {Array.isArray(csvMemberDiffData.unresolved_member) && csvMemberDiffData.unresolved_member.length > 0 && (
                                                    <Box>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>未解決 member（名前がマスタにない行）</Typography>
                                                        <TableContainer sx={{ maxHeight: 120, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead><TableRow><TableCell>CSV上の名前</TableCell><TableCell>CSVカテゴリー</TableCell></TableRow></TableHead>
                                                                <TableBody>
                                                                    {csvMemberDiffData.unresolved_member.map((r, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{r.csv_name ?? '—'}</TableCell>
                                                                            <TableCell>{r.csv_category ?? '—'}</TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                            </Box>
                                        )}
                                        {csvRoleDiffData && (
                                            <Box sx={{ mt: 1.5, p: 1.5, bgcolor: 'grey.100', borderRadius: 1, border: 1, borderColor: 'divider' }}>
                                                <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 1 }}>
                                                    役職（Role）差分プレビュー
                                                </Typography>
                                                <Alert severity="info" sx={{ mb: 1.5 }}>
                                                    同じ役職が継続しているメンバーは候補に含めません。roles マスタにない CSV 役職は「マスタ未登録」として表示し、反映しません。「Role History に反映」で、マスタ解決済みの変更・CSVのみ役職の開始・CSVに役職がない現在役職の終了のみを member_roles に書き込みます。基準日はダイアログで指定（空欄＝例会日、DB上未設定時のみ今日）。participants / members は更新しません。
                                                </Alert>
                                                <Stack direction="row" flexWrap="wrap" gap={0.5} sx={{ mb: 1.5 }} alignItems="center">
                                                    <Chip size="small" label={`役職変更 ${csvRoleDiffData.summary?.changed_role_count ?? 0}件`} color="error" variant="outlined" />
                                                    <Chip size="small" label={`CSV側のみ ${csvRoleDiffData.summary?.csv_role_only_count ?? 0}件`} color="warning" variant="outlined" />
                                                    <Chip size="small" label={`現在roleのみ ${csvRoleDiffData.summary?.current_role_only_count ?? 0}件`} variant="outlined" />
                                                    <Chip size="small" label={`継続 ${csvRoleDiffData.summary?.unchanged_role_count ?? 0}件`} color="success" variant="outlined" />
                                                    <Chip size="small" label={`未解決名 ${csvRoleDiffData.summary?.unresolved_member_count ?? 0}件`} variant="outlined" />
                                                    {(csvRoleDiffData.summary?.duplicate_name_member_count ?? 0) > 0 && (
                                                        <Chip size="small" color="warning" label={`同名要注意 ${csvRoleDiffData.summary.duplicate_name_member_count}名`} variant="outlined" />
                                                    )}
                                                    {hasCsvRoleApplyTarget && (
                                                        <Button
                                                            size="small"
                                                            variant="contained"
                                                            color="warning"
                                                            disabled={csvRoleApplyLoading || !meeting?.id}
                                                            onClick={() => setCsvRoleApplyConfirmOpen(true)}
                                                        >
                                                            {csvRoleApplyLoading ? '反映中…' : 'Role History に反映'}
                                                        </Button>
                                                    )}
                                                </Stack>
                                                {Array.isArray(csvRoleDiffData.changed_role) && csvRoleDiffData.changed_role.length > 0 && (
                                                    <Box sx={{ mb: 1.5 }}>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>役職変更候補</Typography>
                                                        <TableContainer sx={{ maxHeight: 160, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead>
                                                                    <TableRow>
                                                                        <TableCell>名前</TableCell>
                                                                        <TableCell>現在 role</TableCell>
                                                                        <TableCell>CSV role</TableCell>
                                                                        <TableCell>マスタ</TableCell>
                                                                        <TableCell>同名</TableCell>
                                                                    </TableRow>
                                                                </TableHead>
                                                                <TableBody>
                                                                    {csvRoleDiffData.changed_role.map((r, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{r.name ?? '—'}</TableCell>
                                                                            <TableCell>{r.current_role ?? '—'}</TableCell>
                                                                            <TableCell>{r.csv_role ?? '—'}</TableCell>
                                                                            <TableCell>{r.role_master_resolved ? <Chip size="small" label="解決" color="success" /> : <Chip size="small" label="未登録" color="warning" />}</TableCell>
                                                                            <TableCell>
                                                                                {r.duplicate_name_warning ? (
                                                                                    <Chip size="small" color="warning" label={`${r.duplicate_count ?? '?'}件`} />
                                                                                ) : '—'}
                                                                            </TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                                {Array.isArray(csvRoleDiffData.csv_role_only) && csvRoleDiffData.csv_role_only.length > 0 && (
                                                    <Box sx={{ mb: 1.5 }}>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>CSV側のみ役職あり（現在の Role History なし）</Typography>
                                                        <TableContainer sx={{ maxHeight: 140, border: 1, borderColor: 'warning.light', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead>
                                                                    <TableRow>
                                                                        <TableCell>名前</TableCell>
                                                                        <TableCell>CSV role</TableCell>
                                                                        <TableCell>マスタ</TableCell>
                                                                        <TableCell>同名</TableCell>
                                                                    </TableRow>
                                                                </TableHead>
                                                                <TableBody>
                                                                    {csvRoleDiffData.csv_role_only.map((r, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{r.name ?? '—'}</TableCell>
                                                                            <TableCell>{r.csv_role ?? '—'}</TableCell>
                                                                            <TableCell>{r.role_master_resolved ? <Chip size="small" label="解決" color="success" /> : <Chip size="small" label="未登録" color="warning" />}</TableCell>
                                                                            <TableCell>
                                                                                {r.duplicate_name_warning ? (
                                                                                    <Chip size="small" color="warning" label={`${r.duplicate_count ?? '?'}件`} />
                                                                                ) : '—'}
                                                                            </TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                                {Array.isArray(csvRoleDiffData.current_role_only) && csvRoleDiffData.current_role_only.length > 0 && (
                                                    <Box sx={{ mb: 1.5 }}>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>現在 role のみあり（CSV に役職列が空）</Typography>
                                                        <TableContainer sx={{ maxHeight: 140, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead><TableRow><TableCell>名前</TableCell><TableCell>現在 role</TableCell><TableCell>同名</TableCell></TableRow></TableHead>
                                                                <TableBody>
                                                                    {csvRoleDiffData.current_role_only.map((r, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{r.name ?? '—'}</TableCell>
                                                                            <TableCell>{r.current_role ?? '—'}</TableCell>
                                                                            <TableCell>
                                                                                {r.duplicate_name_warning ? (
                                                                                    <Chip size="small" color="warning" label={`${r.duplicate_count ?? '?'}件`} />
                                                                                ) : '—'}
                                                                            </TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                                {Array.isArray(csvRoleDiffData.unresolved_member) && csvRoleDiffData.unresolved_member.length > 0 && (
                                                    <Box>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>未解決 member（名前がマスタにない行）</Typography>
                                                        <TableContainer sx={{ maxHeight: 100, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead><TableRow><TableCell>CSV上の名前</TableCell><TableCell>CSVカテゴリー</TableCell></TableRow></TableHead>
                                                                <TableBody>
                                                                    {csvRoleDiffData.unresolved_member.map((r, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{r.csv_name ?? '—'}</TableCell>
                                                                            <TableCell>{r.csv_category ?? '—'}</TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                            </Box>
                                        )}
                                        {csvDiffData && (
                                            <Box sx={{ mt: 1.5, p: 1.5, bgcolor: 'action.hover', borderRadius: 1 }}>
                                                <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 1 }}>
                                                    差分プレビュー（名前 → member_id ベース）
                                                </Typography>
                                                <Stack direction="row" flexWrap="wrap" gap={0.5} sx={{ mb: 1.5 }}>
                                                    <Chip size="small" label={`追加 ${csvDiffData.summary?.added_count ?? 0}件`} color="success" variant="outlined" />
                                                    <Chip size="small" label={`更新 ${csvDiffData.summary?.updated_count ?? 0}件`} color="info" variant="outlined" />
                                                    <Chip size="small" label={`変更なし ${csvDiffData.summary?.unchanged_count ?? 0}件`} variant="outlined" />
                                                    <Chip size="small" label={`削除候補 ${csvDiffData.summary?.missing_count ?? 0}件`} color="warning" variant="outlined" />
                                                </Stack>
                                                {Array.isArray(csvDiffData.added) && csvDiffData.added.length > 0 && (
                                                    <Box sx={{ mb: 1.5 }}>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>追加</Typography>
                                                        <TableContainer sx={{ maxHeight: 120, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead><TableRow><TableCell>名前</TableCell><TableCell>種別</TableCell><TableCell>No</TableCell><TableCell>注記</TableCell></TableRow></TableHead>
                                                                <TableBody>
                                                                    {csvDiffData.added.map((a, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{a.name ?? '—'}</TableCell>
                                                                            <TableCell>{participantTypeLabel(a.type)}</TableCell>
                                                                            <TableCell>{a.source_no ?? '—'}</TableCell>
                                                                            <TableCell>
                                                                                {a.duplicate_name_warning ? (
                                                                                    <Chip size="small" color="warning" label={`同名${a.duplicate_count ?? '?'}件`} />
                                                                                ) : '—'}
                                                                            </TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                                {Array.isArray(csvDiffData.updated) && csvDiffData.updated.length > 0 && (
                                                    <Box sx={{ mb: 1.5 }}>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>更新</Typography>
                                                        <TableContainer sx={{ maxHeight: 120, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead><TableRow><TableCell>名前</TableCell><TableCell>現在の種別</TableCell><TableCell>新しい種別</TableCell><TableCell>No</TableCell><TableCell>注記</TableCell></TableRow></TableHead>
                                                                <TableBody>
                                                                    {csvDiffData.updated.map((u, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{u.name ?? '—'}</TableCell>
                                                                            <TableCell>{participantTypeLabel(u.current_type)}</TableCell>
                                                                            <TableCell>{participantTypeLabel(u.new_type)}</TableCell>
                                                                            <TableCell>{u.source_no ?? '—'}</TableCell>
                                                                            <TableCell>
                                                                                {u.duplicate_name_warning ? (
                                                                                    <Chip size="small" color="warning" label={`同名${u.duplicate_count ?? '?'}件`} />
                                                                                ) : '—'}
                                                                            </TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                                {Array.isArray(csvDiffData.missing) && csvDiffData.missing.length > 0 && (
                                                    <Box>
                                                        <Typography variant="caption" color="text.secondary" fontWeight={600} display="block" sx={{ mb: 0.5 }}>削除候補（CSVにない既存 participant）</Typography>
                                                        <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 0.5 }}>BO ありは削除されません。</Typography>
                                                        <TableContainer sx={{ maxHeight: 120, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                                            <Table size="small" stickyHeader>
                                                                <TableHead><TableRow><TableCell>名前</TableCell><TableCell>現在の種別</TableCell><TableCell>BO</TableCell><TableCell>削除可否</TableCell></TableRow></TableHead>
                                                                <TableBody>
                                                                    {csvDiffData.missing.map((m, i) => (
                                                                        <TableRow key={i}>
                                                                            <TableCell>{m.name ?? '—'}</TableCell>
                                                                            <TableCell>{participantTypeLabel(m.current_type)}</TableCell>
                                                                            <TableCell>{m.has_breakout ? <Chip size="small" label="あり" color="warning" /> : 'なし'}</TableCell>
                                                                            <TableCell>{m.deletable ? '削除可' : (m.reason === 'breakout_attached' ? 'BO ありのため削除不可' : '—')}</TableCell>
                                                                        </TableRow>
                                                                    ))}
                                                                </TableBody>
                                                            </Table>
                                                        </TableContainer>
                                                    </Box>
                                                )}
                                            </Box>
                                        )}
                                        {csvPreviewData && !csvDiffData && (
                                            <Box sx={{ mt: 1 }}>
                                                <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 0.5 }}>
                                                    {csvPreviewData.row_count}件
                                                </Typography>
                                                <TableContainer sx={{ maxHeight: 280, border: 1, borderColor: 'divider', borderRadius: 1 }}>
                                                    <Table size="small" stickyHeader>
                                                        <TableHead>
                                                            <TableRow>
                                                                {(csvPreviewData.headers || []).map((h) => (
                                                                    <TableCell key={h} sx={{ fontWeight: 600, whiteSpace: 'nowrap' }}>{h}</TableCell>
                                                                ))}
                                                                <TableCell sx={{ fontWeight: 600, whiteSpace: 'nowrap' }}>同名</TableCell>
                                                            </TableRow>
                                                        </TableHead>
                                                        <TableBody>
                                                            {(csvPreviewData.rows || []).map((row, idx) => (
                                                                <TableRow key={idx}>
                                                                    {(csvPreviewData.headers || []).map((h) => {
                                                                        const key = { '種別': 'type', 'No': 'no', '名前': 'name', 'よみがな': 'kana', '大カテゴリー': 'category_group', 'カテゴリー': 'category', '役職': 'role', '紹介者': 'introducer', 'アテンド': 'attendant', 'オリエン': 'orient' }[h];
                                                                        return <TableCell key={h}>{key ? (row[key] ?? '—') : '—'}</TableCell>;
                                                                    })}
                                                                    <TableCell>
                                                                        {row.duplicate_name_warning ? (
                                                                            <Chip size="small" color="warning" label={`${row.duplicate_count ?? '?'}件`} />
                                                                        ) : '—'}
                                                                    </TableCell>
                                                                </TableRow>
                                                            ))}
                                                        </TableBody>
                                                    </Table>
                                                </TableContainer>
                                            </Box>
                                        )}
                                        {csvApplyLogsRecent.length > 0 && (
                                            <Box sx={{ mt: 1.5, pt: 1.5, borderTop: 1, borderColor: 'divider' }}>
                                                <Typography variant="caption" fontWeight={700} color="text.secondary" display="block" sx={{ mb: 0.5 }}>
                                                    CSV反映履歴（直近）
                                                </Typography>
                                                {csvApplyLogsRecent.map((log) => (
                                                    <Typography key={log.id} variant="caption" display="block" color="text.secondary" sx={{ pl: 0.25 }}>
                                                        {(log.applied_on || '').replace(/-/g, '/')}
                                                        {' '}
                                                        {log.apply_type === 'participants' ? '参加者' : log.apply_type === 'members' ? 'members' : 'roles'}
                                                        : {log.summary}
                                                    </Typography>
                                                ))}
                                            </Box>
                                        )}
                                    </Stack>
                                ) : (
                                    <Button
                                        size="small"
                                        variant="outlined"
                                        disabled={csvUploadLoading}
                                        startIcon={<CloudUploadIcon />}
                                        onClick={() => csvInputRef.current?.click()}
                                    >
                                        {csvUploadLoading ? 'アップロード中…' : 'CSVアップロード'}
                                    </Button>
                                )}
                            </Box>
                        </Box>
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
                        <Dialog open={csvApplyConfirmOpen} onClose={() => !csvApplyLoading && setCsvApplyConfirmOpen(false)}>
                            <DialogTitle>CSV を participants に反映</DialogTitle>
                            <DialogContent>
                                <DialogContentText component="div">
                                    {csvDiffData?.summary && (
                                        <Typography variant="body2" sx={{ mb: 1 }}>
                                            追加 {csvDiffData.summary.added_count}件、更新 {csvDiffData.summary.updated_count}件、
                                            削除候補 {csvDiffData.summary.missing_count ?? 0}件
                                            {Array.isArray(csvDiffData.missing) && (
                                                <>
                                                    、実際に削除される見込み {csvDiffData.missing.filter((m) => m.deletable).length}件、
                                                    BO ありのため削除されない件数 {csvDiffData.missing.filter((m) => !m.deletable).length}件
                                                </>
                                            )}
                                        </Typography>
                                    )}
                                    <Typography variant="body2" paragraph>
                                        この Meeting の参加者をCSV内容で差分更新します。
                                    </Typography>
                                    {deleteMissing ? (
                                        <>
                                            <Typography variant="body2" paragraph color="warning.main">
                                                削除オプションが有効なため、CSVにない既存 participant のうち BO がないものを削除します。
                                            </Typography>
                                            <Typography variant="body2" paragraph>
                                                BO が設定されている participant は削除しません。
                                            </Typography>
                                        </>
                                    ) : (
                                        <Typography variant="body2" paragraph>
                                            既存 participant は削除せず、追加・更新のみ行います。CSV にない既存 participant は残ります（BO 割当は維持されます）。
                                        </Typography>
                                    )}
                                    <Typography variant="body2">
                                        よろしいですか？
                                    </Typography>
                                </DialogContentText>
                            </DialogContent>
                            <DialogActions>
                                <Button onClick={() => setCsvApplyConfirmOpen(false)} disabled={csvApplyLoading}>キャンセル</Button>
                                <Button
                                    variant="contained"
                                    onClick={async () => {
                                        if (!meeting?.id || !onDetailRefresh) return;
                                        setCsvApplyLoading(true);
                                        try {
                                            const res = await postCsvImportApply(meeting.id, { delete_missing: deleteMissing });
                                            setCsvApplyConfirmOpen(false);
                                            onDetailRefresh();
                                            const parts = [];
                                            if (res.added_count > 0) parts.push(`追加 ${res.added_count}件`);
                                            if (res.updated_count > 0) parts.push(`更新 ${res.updated_count}件`);
                                            if (res.deleted_count > 0) parts.push(`削除 ${res.deleted_count}件`);
                                            if (res.protected_count > 0) parts.push(`BO保護 ${res.protected_count}件`);
                                            if (res.missing_count > 0 && res.deleted_count === 0 && res.protected_count === 0) parts.push(`削除候補 ${res.missing_count}件（残存）`);
                                            notify(parts.length > 0 ? parts.join('、') + '。' : `${res.applied_count}件を participants に反映しました。`);
                                        } catch (e) {
                                            notify(e?.message ?? '反映に失敗しました。', { type: 'error' });
                                        } finally {
                                            setCsvApplyLoading(false);
                                        }
                                    }}
                                    disabled={csvApplyLoading}
                                >
                                    {csvApplyLoading ? '反映中…' : '反映する'}
                                </Button>
                            </DialogActions>
                        </Dialog>
                        <Dialog open={csvMemberApplyConfirmOpen} onClose={() => !csvMemberApplyLoading && setCsvMemberApplyConfirmOpen(false)}>
                            <DialogTitle>members の基本情報を更新</DialogTitle>
                            <DialogContent>
                                <DialogContentText component="div">
                                    <Typography variant="body2" paragraph>
                                        members の基本情報を更新します。
                                    </Typography>
                                    <Typography variant="body2" paragraph>
                                        名前・よみがな・カテゴリー（既存 master に解決できたもののみ）を反映します。
                                    </Typography>
                                    <Typography variant="body2" paragraph>
                                        役職 / Role History は更新しません。名前がマスタにない行・カテゴリーマスタ未登録の変更はスキップされます。
                                    </Typography>
                                    {csvMemberDiffData?.summary && (
                                        <Typography variant="body2" sx={{ mb: 1 }}>
                                            基本情報更新候補 {csvMemberDiffData.summary.updated_member_basic_count ?? 0}件／
                                            カテゴリー変更候補 {csvMemberDiffData.summary.category_changed_count ?? 0}件（反映はマスタ解決済みのみ）／
                                            未解決名簿行 {csvMemberDiffData.summary.unresolved_member_count ?? 0}件（反映しません）
                                        </Typography>
                                    )}
                                    <Typography variant="body2">よろしいですか？</Typography>
                                </DialogContentText>
                            </DialogContent>
                            <DialogActions>
                                <Button onClick={() => setCsvMemberApplyConfirmOpen(false)} disabled={csvMemberApplyLoading}>キャンセル</Button>
                                <Button
                                    variant="contained"
                                    color="secondary"
                                    onClick={async () => {
                                        if (!meeting?.id || !onDetailRefresh) return;
                                        setCsvMemberApplyLoading(true);
                                        try {
                                            const res = await postCsvMemberApply(meeting.id);
                                            setCsvMemberApplyConfirmOpen(false);
                                            onDetailRefresh();
                                            const d = await fetchCsvMemberDiffPreview(meeting.id).catch(() => null);
                                            if (d) setCsvMemberDiffData(d);
                                            const parts = [];
                                            if (res.updated_member_basic_count > 0) parts.push(`基本情報 ${res.updated_member_basic_count}件`);
                                            if (res.updated_category_count > 0) parts.push(`カテゴリー ${res.updated_category_count}件`);
                                            if (res.skipped_unresolved_count > 0) parts.push(`未解決名 ${res.skipped_unresolved_count}件スキップ`);
                                            if (res.skipped_unresolved_category_count > 0) parts.push(`未登録カテゴリー ${res.skipped_unresolved_category_count}件スキップ`);
                                            notify(parts.length > 0 ? `members を更新: ${parts.join('、')}` : (res.message ?? '完了'));
                                        } catch (e) {
                                            notify(e?.message ?? '反映に失敗しました。', { type: 'error' });
                                        } finally {
                                            setCsvMemberApplyLoading(false);
                                        }
                                    }}
                                    disabled={csvMemberApplyLoading}
                                >
                                    {csvMemberApplyLoading ? '反映中…' : '反映する'}
                                </Button>
                            </DialogActions>
                        </Dialog>
                        <Dialog open={csvRoleApplyConfirmOpen} onClose={() => !csvRoleApplyLoading && setCsvRoleApplyConfirmOpen(false)}>
                            <DialogTitle>Role History を更新</DialogTitle>
                            <DialogContent>
                                <DialogContentText component="div">
                                    <Typography variant="body2" paragraph>
                                        Role History（member_roles）を更新します。term_end / term_start に使う基準日を下記で指定できます。
                                    </Typography>
                                    <MuiTextField
                                        margin="dense"
                                        label="Role 基準日"
                                        type="date"
                                        fullWidth
                                        value={roleEffectiveDate}
                                        onChange={(e) => setRoleEffectiveDate(e.target.value)}
                                        InputLabelProps={{ shrink: true }}
                                        helperText="空欄にすると例会日（held_on）を使用します。未設定の例会のみフォールバックで今日。"
                                        disabled={csvRoleApplyLoading}
                                        sx={{ mb: 1.5 }}
                                    />
                                    <Typography variant="body2" paragraph>
                                        現在の役職を終了（term_end）し、CSV の役職に対応する新しい役職を開始（term_start）します。
                                    </Typography>
                                    <Typography variant="body2" paragraph>
                                        CSV に役職がない行については、現在の役職のみがある場合はその役職を終了します。
                                    </Typography>
                                    <Typography variant="body2" paragraph>
                                        同じ役職の継続は更新しません。roles マスタに存在しない CSV 役職は反映しません。名前未解決の行は対象外です。
                                    </Typography>
                                    <Typography variant="body2" sx={{ mb: 1 }}>
                                        よろしいですか？
                                    </Typography>
                                </DialogContentText>
                            </DialogContent>
                            <DialogActions>
                                <Button onClick={() => setCsvRoleApplyConfirmOpen(false)} disabled={csvRoleApplyLoading}>キャンセル</Button>
                                <Button
                                    variant="contained"
                                    color="warning"
                                    onClick={async () => {
                                        if (!meeting?.id || !onDetailRefresh) return;
                                        setCsvRoleApplyLoading(true);
                                        try {
                                            const payload = {};
                                            if (String(roleEffectiveDate || '').trim() !== '') {
                                                payload.effective_date = String(roleEffectiveDate).trim();
                                            }
                                            const res = await postCsvRoleApply(meeting.id, payload);
                                            setCsvRoleApplyConfirmOpen(false);
                                            onDetailRefresh();
                                            const d = await fetchCsvRoleDiffPreview(meeting.id).catch(() => null);
                                            if (d) setCsvRoleDiffData(d);
                                            const parts = [];
                                            if (res.effective_date) parts.push(`基準日 ${res.effective_date}`);
                                            if (res.changed_role_applied_count > 0) parts.push(`役職変更 ${res.changed_role_applied_count}件`);
                                            if (res.csv_role_only_applied_count > 0) parts.push(`CSVのみ役職 ${res.csv_role_only_applied_count}件`);
                                            if (res.current_role_only_closed_count > 0) parts.push(`役職終了 ${res.current_role_only_closed_count}件`);
                                            if (res.skipped_unresolved_role_count > 0) parts.push(`未登録役職スキップ ${res.skipped_unresolved_role_count}件`);
                                            notify(parts.length > 0 ? `Role History: ${parts.join('、')}` : (res.message ?? '完了'));
                                        } catch (e) {
                                            notify(e?.message ?? '反映に失敗しました。', { type: 'error' });
                                        } finally {
                                            setCsvRoleApplyLoading(false);
                                        }
                                    }}
                                    disabled={csvRoleApplyLoading}
                                >
                                    {csvRoleApplyLoading ? '反映中…' : '反映する'}
                                </Button>
                            </DialogActions>
                        </Dialog>
                        <Dialog
                            open={csvResManageOpen}
                            onClose={() => !csvResSaving && setCsvResManageOpen(false)}
                            maxWidth="md"
                            fullWidth
                            scroll="paper"
                        >
                            <DialogTitle>解決済み resolution の管理</DialogTitle>
                            <DialogContent dividers>
                                <Alert severity="info" sx={{ mb: 2 }}>
                                    最新の CSV import に紐づく解決のみ表示します。解除するとマスタは残り、名前解決は通常ルールに戻ります。再マップは検索ダイアログで別のマスタを選んでください。
                                </Alert>
                                {csvResolutionsError && (
                                    <Typography color="error" variant="body2" sx={{ mb: 1 }}>{csvResolutionsError}</Typography>
                                )}
                                {csvResolutionsLoading && csvResolutionsList.length === 0 ? (
                                    <Box sx={{ display: 'flex', justifyContent: 'center', py: 3 }}><CircularProgress size={28} /></Box>
                                ) : (
                                    <TableContainer sx={{ maxHeight: 360 }}>
                                        <Table size="small" stickyHeader>
                                            <TableHead>
                                                <TableRow>
                                                    <TableCell>種別</TableCell>
                                                    <TableCell>CSV側</TableCell>
                                                    <TableCell>解決先</TableCell>
                                                    <TableCell>action</TableCell>
                                                    <TableCell>更新</TableCell>
                                                    <TableCell align="right">操作</TableCell>
                                                </TableRow>
                                            </TableHead>
                                            <TableBody>
                                                {csvResolutionsList.map((rw) => (
                                                    <TableRow key={rw.id}>
                                                        <TableCell>{rw.resolution_type}</TableCell>
                                                        <TableCell sx={{ maxWidth: 140, wordBreak: 'break-all' }}>{rw.source_value}</TableCell>
                                                        <TableCell sx={{ maxWidth: 180, wordBreak: 'break-all' }}>
                                                            {(rw.resolved_label ?? '—')} (id {rw.resolved_id})
                                                        </TableCell>
                                                        <TableCell>{rw.action_type ?? '—'}</TableCell>
                                                        <TableCell sx={{ whiteSpace: 'nowrap', fontSize: 11 }}>
                                                            {(rw.updated_at || rw.created_at || '').replace('T', ' ').slice(0, 19)}
                                                        </TableCell>
                                                        <TableCell align="right">
                                                            <Stack direction="row" spacing={0.5} justifyContent="flex-end" flexWrap="wrap" useFlexGap>
                                                                <Button
                                                                    size="small"
                                                                    variant="outlined"
                                                                    disabled={csvResSaving || !meeting?.id}
                                                                    onClick={() => {
                                                                        setCsvResPick({
                                                                            kind: rw.resolution_type,
                                                                            sourceValue: rw.source_value,
                                                                            remapResolutionId: rw.id,
                                                                        });
                                                                        setCsvResPickQ('');
                                                                    }}
                                                                >
                                                                    再マップ
                                                                </Button>
                                                                <Button
                                                                    size="small"
                                                                    color="error"
                                                                    variant="outlined"
                                                                    disabled={csvResSaving || !meeting?.id}
                                                                    onClick={async () => {
                                                                        if (!meeting?.id) return;
                                                                        if (!window.confirm('この解決を削除しますか？（マスタは削除されません）')) return;
                                                                        setCsvResSaving(true);
                                                                        try {
                                                                            await deleteCsvResolution(meeting.id, rw.id);
                                                                            const d = await fetchCsvResolutionsList(meeting.id);
                                                                            setCsvResolutionsList(Array.isArray(d.resolutions) ? d.resolutions : []);
                                                                            await refreshCsvAfterResolution();
                                                                            notify('解除しました');
                                                                        } catch (e) {
                                                                            notify(e?.message || '削除に失敗しました', { type: 'error' });
                                                                        } finally {
                                                                            setCsvResSaving(false);
                                                                        }
                                                                    }}
                                                                >
                                                                    解除
                                                                </Button>
                                                            </Stack>
                                                        </TableCell>
                                                    </TableRow>
                                                ))}
                                            </TableBody>
                                        </Table>
                                    </TableContainer>
                                )}
                                {!csvResolutionsLoading && csvResolutionsList.length === 0 && !csvResolutionsError && (
                                    <Typography variant="body2" color="text.secondary">登録されている resolution はありません。</Typography>
                                )}
                            </DialogContent>
                            <DialogActions>
                                <Button
                                    onClick={() => refreshCsvAfterResolution()}
                                    disabled={csvResSaving || csvResolutionsLoading || !meeting?.id}
                                >
                                    プレビュー類を再取得
                                </Button>
                                <Button onClick={() => setCsvResManageOpen(false)} disabled={csvResSaving}>閉じる</Button>
                            </DialogActions>
                        </Dialog>
                        <Dialog
                            open={csvUnresolvedOpen}
                            onClose={() => !csvResSaving && setCsvUnresolvedOpen(false)}
                            maxWidth="md"
                            fullWidth
                            scroll="paper"
                        >
                            <DialogTitle>CSV 未解決データの解消</DialogTitle>
                            <DialogContent dividers>
                                <Alert severity="info" sx={{ mb: 2 }}>
                                    解決内容はこの CSV import に紐づけて保存されます（CSVファイル自体は変更しません）。保存後は「プレビュー類を再取得」または各差分ボタンで反映を確認してください。
                                </Alert>
                                {csvUnresolvedError && (
                                    <Typography color="error" variant="body2" sx={{ mb: 1 }}>{csvUnresolvedError}</Typography>
                                )}
                                {csvUnresolvedLoading && !csvUnresolvedData ? (
                                    <Box sx={{ display: 'flex', justifyContent: 'center', py: 3 }}><CircularProgress size={28} /></Box>
                                ) : (
                                    <>
                                        <Typography variant="subtitle2" sx={{ mb: 0.5 }}>Member（CSV上の名前）</Typography>
                                        <TableContainer sx={{ maxHeight: 200, border: 1, borderColor: 'divider', borderRadius: 0.5, mb: 2 }}>
                                            <Table size="small" stickyHeader>
                                                <TableHead>
                                                    <TableRow>
                                                        <TableCell>状態</TableCell>
                                                        <TableCell>CSV名</TableCell>
                                                        <TableCell>よみがな</TableCell>
                                                        <TableCell>解決先 / 操作</TableCell>
                                                    </TableRow>
                                                </TableHead>
                                                <TableBody>
                                                    {(csvUnresolvedData?.unresolved_member ?? []).map((row, i) => {
                                                        const sk = `m:${row.source_value}`;
                                                        const memSug = csvSugFor('member', row.source_value);
                                                        const memExp = !!csvSuggestionsExpanded[sk];
                                                        return (
                                                            <Fragment key={`m-${i}`}>
                                                                <TableRow>
                                                                    <TableCell>
                                                                        {row.status === 'resolved' ? (
                                                                            <Chip size="small" label="解決済み" color="success" />
                                                                        ) : (
                                                                            <Chip size="small" label="未解決" color="warning" variant="outlined" />
                                                                        )}
                                                                    </TableCell>
                                                                    <TableCell>{row.csv_name ?? row.source_value ?? '—'}</TableCell>
                                                                    <TableCell>{row.csv_kana != null && row.csv_kana !== '' ? row.csv_kana : '—'}</TableCell>
                                                                    <TableCell>
                                                                        {row.status === 'resolved' ? (
                                                                            <Stack spacing={0.5} alignItems="flex-start">
                                                                                <Typography variant="caption" display="block">
                                                                                    {row.resolved_name ?? '—'} (id {row.resolved_member_id})
                                                                                    {row.action_type ? ` · ${row.action_type}` : ''}
                                                                                </Typography>
                                                                                {row.duplicate_name_warning ? (
                                                                                    <Alert severity="warning" sx={{ py: 0.25, px: 1, fontSize: 12 }}>
                                                                                        同名の member が {row.duplicate_count ?? '複数'} 件います。現在は名前一致の先頭のみ採用されています。resolution で明示的に紐づけることを推奨します。
                                                                                    </Alert>
                                                                                ) : null}
                                                                            </Stack>
                                                                        ) : (
                                                                            <Stack spacing={0.5} alignItems="flex-start">
                                                                                <Stack direction="row" spacing={0.5} flexWrap="wrap" useFlexGap>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        disabled={csvResSaving || !meeting?.id || csvSuggestionsLoading}
                                                                                        onClick={() => toggleCsvSuggestions('member', row.source_value)}
                                                                                    >
                                                                                        {memExp ? '候補を隠す' : '候補を表示'}
                                                                                    </Button>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        disabled={csvResSaving || !meeting?.id}
                                                                                        onClick={() => {
                                                                                            setCsvResPick({ kind: 'member', sourceValue: row.source_value });
                                                                                            setCsvResPickQ('');
                                                                                        }}
                                                                                    >
                                                                                        既存を選ぶ
                                                                                    </Button>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        color="secondary"
                                                                                        disabled={csvResSaving || !meeting?.id}
                                                                                        onClick={() => {
                                                                                            setCsvResCreate({ kind: 'member', sourceValue: row.source_value });
                                                                                            setCsvCreateMemberName(row.csv_name || row.source_value || '');
                                                                                            setCsvCreateMemberKana(row.csv_kana || '');
                                                                                            setCsvCreateMemberType('regular');
                                                                                        }}
                                                                                    >
                                                                                        新規作成
                                                                                    </Button>
                                                                                </Stack>
                                                                            </Stack>
                                                                        )}
                                                                    </TableCell>
                                                                </TableRow>
                                                                {row.status === 'open' && memExp && (
                                                                    <TableRow>
                                                                        <TableCell colSpan={4} sx={{ py: 1, bgcolor: 'grey.50', borderTop: 0 }}>
                                                                            {csvSuggestionsLoading && !csvSuggestionsData ? (
                                                                                <CircularProgress size={22} />
                                                                            ) : memSug.length === 0 ? (
                                                                                <Typography variant="caption" color="text.secondary">候補がありません（検索から選ぶか新規作成してください）</Typography>
                                                                            ) : (
                                                                                <Stack spacing={0.75}>
                                                                                    {(() => {
                                                                                        const dm = csvSugMemberDupMeta(row.source_value);
                                                                                        return dm.duplicate_name_warning ? (
                                                                                            <Alert severity="warning" sx={{ py: 0.25 }}>
                                                                                                マスタ上に同名が {dm.duplicate_count} 件あります。候補から resolution を登録することを推奨します。
                                                                                            </Alert>
                                                                                        ) : null;
                                                                                    })()}
                                                                                    <Typography variant="caption" color="text.secondary" fontWeight={600}>あいまい一致候補（参考・自動確定しません）</Typography>
                                                                                    {memSug.map((sug) => (
                                                                                        <Stack key={sug.id} direction="row" alignItems="center" spacing={1} flexWrap="wrap" useFlexGap>
                                                                                            <Typography variant="body2" sx={{ flex: 1, minWidth: 120 }}>
                                                                                                {sug.label}
                                                                                            </Typography>
                                                                                            <Chip size="small" label={`score ${sug.score}`} variant="outlined" />
                                                                                            <Chip size="small" label={csvMatchReasonLabel(sug.match_reason)} variant="outlined" />
                                                                                            <Button
                                                                                                size="small"
                                                                                                variant="contained"
                                                                                                disabled={csvResSaving || !meeting?.id}
                                                                                                onClick={() => applySuggestionResolution('member', row.source_value, sug.id)}
                                                                                            >
                                                                                                これを使う
                                                                                            </Button>
                                                                                        </Stack>
                                                                                    ))}
                                                                                </Stack>
                                                                            )}
                                                                        </TableCell>
                                                                    </TableRow>
                                                                )}
                                                            </Fragment>
                                                        );
                                                    })}
                                                </TableBody>
                                            </Table>
                                        </TableContainer>
                                        <Typography variant="subtitle2" sx={{ mb: 0.5 }}>Category（CSVカテゴリーラベル）</Typography>
                                        <TableContainer sx={{ maxHeight: 180, border: 1, borderColor: 'divider', borderRadius: 0.5, mb: 2 }}>
                                            <Table size="small" stickyHeader>
                                                <TableHead>
                                                    <TableRow>
                                                        <TableCell>状態</TableCell>
                                                        <TableCell>ラベル</TableCell>
                                                        <TableCell>解決先 / 操作</TableCell>
                                                    </TableRow>
                                                </TableHead>
                                                <TableBody>
                                                    {(csvUnresolvedData?.unresolved_category ?? []).map((row, i) => {
                                                        const sk = `c:${row.source_value}`;
                                                        const catSug = csvSugFor('category', row.source_value);
                                                        const catExp = !!csvSuggestionsExpanded[sk];
                                                        return (
                                                            <Fragment key={`c-${i}`}>
                                                                <TableRow>
                                                                    <TableCell>
                                                                        {row.status === 'resolved' ? (
                                                                            <Chip size="small" label="解決済み" color="success" />
                                                                        ) : (
                                                                            <Chip size="small" label="未解決" color="warning" variant="outlined" />
                                                                        )}
                                                                    </TableCell>
                                                                    <TableCell>{row.display_label ?? row.source_value ?? '—'}</TableCell>
                                                                    <TableCell>
                                                                        {row.status === 'resolved' ? (
                                                                            <Typography variant="caption" display="block">
                                                                                {row.resolved_label ?? '—'} (id {row.resolved_category_id})
                                                                                {row.action_type ? ` · ${row.action_type}` : ''}
                                                                            </Typography>
                                                                        ) : (
                                                                            <Stack spacing={0.5} alignItems="flex-start">
                                                                                <Stack direction="row" spacing={0.5} flexWrap="wrap" useFlexGap>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        disabled={csvResSaving || !meeting?.id || csvSuggestionsLoading}
                                                                                        onClick={() => toggleCsvSuggestions('category', row.source_value)}
                                                                                    >
                                                                                        {catExp ? '候補を隠す' : '候補を表示'}
                                                                                    </Button>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        disabled={csvResSaving || !meeting?.id}
                                                                                        onClick={() => {
                                                                                            setCsvResPick({ kind: 'category', sourceValue: row.source_value });
                                                                                            setCsvResPickQ('');
                                                                                        }}
                                                                                    >
                                                                                        既存を選ぶ
                                                                                    </Button>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        color="secondary"
                                                                                        disabled={csvResSaving || !meeting?.id}
                                                                                        onClick={() => {
                                                                                            setCsvResCreate({ kind: 'category', sourceValue: row.source_value });
                                                                                            const parts = String(row.source_value || '').split(' / ');
                                                                                            setCsvCreateCatGroup(parts[0] || '');
                                                                                            setCsvCreateCatName(parts[1] || parts[0] || '');
                                                                                        }}
                                                                                    >
                                                                                        新規作成
                                                                                    </Button>
                                                                                </Stack>
                                                                            </Stack>
                                                                        )}
                                                                    </TableCell>
                                                                </TableRow>
                                                                {row.status === 'open' && catExp && (
                                                                    <TableRow>
                                                                        <TableCell colSpan={3} sx={{ py: 1, bgcolor: 'grey.50', borderTop: 0 }}>
                                                                            {csvSuggestionsLoading && !csvSuggestionsData ? (
                                                                                <CircularProgress size={22} />
                                                                            ) : catSug.length === 0 ? (
                                                                                <Typography variant="caption" color="text.secondary">候補がありません（検索から選ぶか新規作成してください）</Typography>
                                                                            ) : (
                                                                                <Stack spacing={0.75}>
                                                                                    <Typography variant="caption" color="text.secondary" fontWeight={600}>あいまい一致候補（参考）</Typography>
                                                                                    {catSug.map((sug) => (
                                                                                        <Stack key={sug.id} direction="row" alignItems="center" spacing={1} flexWrap="wrap" useFlexGap>
                                                                                            <Typography variant="body2" sx={{ flex: 1, minWidth: 120 }}>{sug.label}</Typography>
                                                                                            <Chip size="small" label={`score ${sug.score}`} variant="outlined" />
                                                                                            <Chip size="small" label={csvMatchReasonLabel(sug.match_reason)} variant="outlined" />
                                                                                            <Button
                                                                                                size="small"
                                                                                                variant="contained"
                                                                                                disabled={csvResSaving || !meeting?.id}
                                                                                                onClick={() => applySuggestionResolution('category', row.source_value, sug.id)}
                                                                                            >
                                                                                                これを使う
                                                                                            </Button>
                                                                                        </Stack>
                                                                                    ))}
                                                                                </Stack>
                                                                            )}
                                                                        </TableCell>
                                                                    </TableRow>
                                                                )}
                                                            </Fragment>
                                                        );
                                                    })}
                                                </TableBody>
                                            </Table>
                                        </TableContainer>
                                        <Typography variant="subtitle2" sx={{ mb: 0.5 }}>Role（CSV役職名）</Typography>
                                        <TableContainer sx={{ maxHeight: 180, border: 1, borderColor: 'divider', borderRadius: 0.5 }}>
                                            <Table size="small" stickyHeader>
                                                <TableHead>
                                                    <TableRow>
                                                        <TableCell>状態</TableCell>
                                                        <TableCell>CSV役職</TableCell>
                                                        <TableCell>解決先 / 操作</TableCell>
                                                    </TableRow>
                                                </TableHead>
                                                <TableBody>
                                                    {(csvUnresolvedData?.unresolved_role ?? []).map((row, i) => {
                                                        const sk = `r:${row.source_value}`;
                                                        const roleSug = csvSugFor('role', row.source_value);
                                                        const roleExp = !!csvSuggestionsExpanded[sk];
                                                        return (
                                                            <Fragment key={`r-${i}`}>
                                                                <TableRow>
                                                                    <TableCell>
                                                                        {row.status === 'resolved' ? (
                                                                            <Chip size="small" label="解決済み" color="success" />
                                                                        ) : (
                                                                            <Chip size="small" label="未解決" color="warning" variant="outlined" />
                                                                        )}
                                                                    </TableCell>
                                                                    <TableCell>{row.source_value ?? '—'}</TableCell>
                                                                    <TableCell>
                                                                        {row.status === 'resolved' ? (
                                                                            <Typography variant="caption" display="block">
                                                                                {row.resolved_name ?? '—'} (id {row.resolved_role_id})
                                                                                {row.action_type ? ` · ${row.action_type}` : ''}
                                                                            </Typography>
                                                                        ) : (
                                                                            <Stack spacing={0.5} alignItems="flex-start">
                                                                                <Stack direction="row" spacing={0.5} flexWrap="wrap" useFlexGap>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        disabled={csvResSaving || !meeting?.id || csvSuggestionsLoading}
                                                                                        onClick={() => toggleCsvSuggestions('role', row.source_value)}
                                                                                    >
                                                                                        {roleExp ? '候補を隠す' : '候補を表示'}
                                                                                    </Button>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        disabled={csvResSaving || !meeting?.id}
                                                                                        onClick={() => {
                                                                                            setCsvResPick({ kind: 'role', sourceValue: row.source_value });
                                                                                            setCsvResPickQ('');
                                                                                        }}
                                                                                    >
                                                                                        既存を選ぶ
                                                                                    </Button>
                                                                                    <Button
                                                                                        size="small"
                                                                                        variant="outlined"
                                                                                        color="secondary"
                                                                                        disabled={csvResSaving || !meeting?.id}
                                                                                        onClick={() => {
                                                                                            setCsvResCreate({ kind: 'role', sourceValue: row.source_value });
                                                                                            setCsvCreateRoleName(row.source_value || '');
                                                                                        }}
                                                                                    >
                                                                                        新規作成
                                                                                    </Button>
                                                                                </Stack>
                                                                            </Stack>
                                                                        )}
                                                                    </TableCell>
                                                                </TableRow>
                                                                {row.status === 'open' && roleExp && (
                                                                    <TableRow>
                                                                        <TableCell colSpan={3} sx={{ py: 1, bgcolor: 'grey.50', borderTop: 0 }}>
                                                                            {csvSuggestionsLoading && !csvSuggestionsData ? (
                                                                                <CircularProgress size={22} />
                                                                            ) : roleSug.length === 0 ? (
                                                                                <Typography variant="caption" color="text.secondary">候補がありません（検索から選ぶか新規作成してください）</Typography>
                                                                            ) : (
                                                                                <Stack spacing={0.75}>
                                                                                    <Typography variant="caption" color="text.secondary" fontWeight={600}>あいまい一致候補（参考）</Typography>
                                                                                    {roleSug.map((sug) => (
                                                                                        <Stack key={sug.id} direction="row" alignItems="center" spacing={1} flexWrap="wrap" useFlexGap>
                                                                                            <Typography variant="body2" sx={{ flex: 1, minWidth: 120 }}>{sug.label}</Typography>
                                                                                            <Chip size="small" label={`score ${sug.score}`} variant="outlined" />
                                                                                            <Chip size="small" label={csvMatchReasonLabel(sug.match_reason)} variant="outlined" />
                                                                                            <Button
                                                                                                size="small"
                                                                                                variant="contained"
                                                                                                disabled={csvResSaving || !meeting?.id}
                                                                                                onClick={() => applySuggestionResolution('role', row.source_value, sug.id)}
                                                                                            >
                                                                                                これを使う
                                                                                            </Button>
                                                                                        </Stack>
                                                                                    ))}
                                                                                </Stack>
                                                                            )}
                                                                        </TableCell>
                                                                    </TableRow>
                                                                )}
                                                            </Fragment>
                                                        );
                                                    })}
                                                </TableBody>
                                            </Table>
                                        </TableContainer>
                                    </>
                                )}
                            </DialogContent>
                            <DialogActions>
                                <Button
                                    onClick={() => refreshCsvAfterResolution()}
                                    disabled={csvUnresolvedLoading || csvResSaving || !meeting?.id}
                                >
                                    プレビュー類を再取得
                                </Button>
                                <Button onClick={() => setCsvUnresolvedOpen(false)} disabled={csvResSaving}>閉じる</Button>
                            </DialogActions>
                        </Dialog>
                        <Dialog open={Boolean(csvResPick)} onClose={() => !csvResSaving && setCsvResPick(null)} maxWidth="sm" fullWidth>
                            <DialogTitle>
                                {csvResPick?.remapResolutionId != null ? '解決の再マップ — ' : ''}
                                {csvResPick?.kind === 'member' ? '既存 Member を選択'
                                    : csvResPick?.kind === 'category' ? '既存 Category を選択'
                                    : '既存 Role を選択'}
                            </DialogTitle>
                            <DialogContent>
                                <MuiTextField
                                    autoFocus
                                    margin="dense"
                                    label="検索"
                                    fullWidth
                                    value={csvResPickQ}
                                    onChange={(e) => setCsvResPickQ(e.target.value)}
                                    disabled={csvResSaving}
                                    InputProps={{
                                        startAdornment: (
                                            <InputAdornment position="start">
                                                <SearchIcon fontSize="small" />
                                            </InputAdornment>
                                        ),
                                    }}
                                    sx={{ mb: 1 }}
                                />
                                <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 1 }}>
                                    CSV側の値: {csvResPick?.source_value ?? '—'}
                                </Typography>
                                {csvResPickLoading && <CircularProgress size={24} sx={{ display: 'block', mx: 'auto', my: 1 }} />}
                                <Stack spacing={0.5} sx={{ maxHeight: 280, overflow: 'auto' }}>
                                    {csvResPickResults.map((item) => (
                                        <Button
                                            key={item.id}
                                            size="small"
                                            variant="text"
                                            fullWidth
                                            sx={{ justifyContent: 'flex-start', textTransform: 'none' }}
                                            disabled={csvResSaving || !meeting?.id}
                                            onClick={async () => {
                                                if (!meeting?.id || !csvResPick) return;
                                                const wasRemap = csvResPick.remapResolutionId != null;
                                                setCsvResSaving(true);
                                                try {
                                                    if (wasRemap) {
                                                        await putCsvResolution(meeting.id, csvResPick.remapResolutionId, {
                                                            resolved_id: item.id,
                                                            action_type: 'mapped',
                                                        });
                                                    } else {
                                                        await postCsvResolution(meeting.id, {
                                                            resolution_type: csvResPick.kind,
                                                            source_value: csvResPick.sourceValue,
                                                            resolved_id: item.id,
                                                            action_type: 'mapped',
                                                        });
                                                    }
                                                    setCsvResPick(null);
                                                    await refreshCsvAfterResolution();
                                                    notify(wasRemap ? '再マップしました' : '解決を保存しました');
                                                } catch (e) {
                                                    notify(e?.message || '保存に失敗しました', { type: 'error' });
                                                } finally {
                                                    setCsvResSaving(false);
                                                }
                                            }}
                                        >
                                            {item.name}
                                        </Button>
                                    ))}
                                </Stack>
                            </DialogContent>
                            <DialogActions>
                                <Button onClick={() => setCsvResPick(null)} disabled={csvResSaving}>キャンセル</Button>
                            </DialogActions>
                        </Dialog>
                        <Dialog open={Boolean(csvResCreate)} onClose={() => !csvResSaving && setCsvResCreate(null)} maxWidth="sm" fullWidth>
                            <DialogTitle>
                                {csvResCreate?.kind === 'member' ? '新規 Member を作成して解決'
                                    : csvResCreate?.kind === 'category' ? '新規 Category を作成して解決'
                                    : '新規 Role を作成して解決'}
                            </DialogTitle>
                            <DialogContent>
                                <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 1 }}>
                                    CSV側の値: {csvResCreate?.source_value ?? '—'}
                                </Typography>
                                {csvResCreate?.kind === 'member' && (
                                    <>
                                        <MuiTextField
                                            margin="dense"
                                            label="名前"
                                            fullWidth
                                            required
                                            value={csvCreateMemberName}
                                            onChange={(e) => setCsvCreateMemberName(e.target.value)}
                                            disabled={csvResSaving}
                                        />
                                        <MuiTextField
                                            margin="dense"
                                            label="よみがな（任意）"
                                            fullWidth
                                            value={csvCreateMemberKana}
                                            onChange={(e) => setCsvCreateMemberKana(e.target.value)}
                                            disabled={csvResSaving}
                                        />
                                        <FormControl margin="dense" fullWidth size="small">
                                            <InputLabel>種別</InputLabel>
                                            <Select
                                                label="種別"
                                                value={csvCreateMemberType}
                                                onChange={(e) => setCsvCreateMemberType(e.target.value)}
                                                disabled={csvResSaving}
                                            >
                                                <MenuItem value="regular">メンバー</MenuItem>
                                                <MenuItem value="visitor">ビジター</MenuItem>
                                                <MenuItem value="guest">ゲスト</MenuItem>
                                                <MenuItem value="proxy">代理出席</MenuItem>
                                            </Select>
                                        </FormControl>
                                    </>
                                )}
                                {csvResCreate?.kind === 'category' && (
                                    <>
                                        <MuiTextField
                                            margin="dense"
                                            label="大カテゴリー（group_name）"
                                            fullWidth
                                            required
                                            value={csvCreateCatGroup}
                                            onChange={(e) => setCsvCreateCatGroup(e.target.value)}
                                            disabled={csvResSaving}
                                        />
                                        <MuiTextField
                                            margin="dense"
                                            label="カテゴリー名（name）"
                                            fullWidth
                                            required
                                            value={csvCreateCatName}
                                            onChange={(e) => setCsvCreateCatName(e.target.value)}
                                            disabled={csvResSaving}
                                        />
                                    </>
                                )}
                                {csvResCreate?.kind === 'role' && (
                                    <MuiTextField
                                        margin="dense"
                                        label="役職名（roles.name）"
                                        fullWidth
                                        required
                                        value={csvCreateRoleName}
                                        onChange={(e) => setCsvCreateRoleName(e.target.value)}
                                        disabled={csvResSaving}
                                    />
                                )}
                            </DialogContent>
                            <DialogActions>
                                <Button onClick={() => setCsvResCreate(null)} disabled={csvResSaving}>キャンセル</Button>
                                <Button
                                    variant="contained"
                                    disabled={csvResSaving || !meeting?.id}
                                    onClick={async () => {
                                        if (!meeting?.id || !csvResCreate) return;
                                        if (csvResCreate.kind === 'member') {
                                            const n = String(csvCreateMemberName || '').trim();
                                            if (!n) {
                                                notify('名前を入力してください', { type: 'warning' });
                                                return;
                                            }
                                        } else if (csvResCreate.kind === 'category') {
                                            const g = String(csvCreateCatGroup || '').trim();
                                            const n = String(csvCreateCatName || '').trim();
                                            if (!g || !n) {
                                                notify('大カテゴリーとカテゴリー名を入力してください', { type: 'warning' });
                                                return;
                                            }
                                        } else {
                                            const n = String(csvCreateRoleName || '').trim();
                                            if (!n) {
                                                notify('役職名を入力してください', { type: 'warning' });
                                                return;
                                            }
                                        }
                                        setCsvResSaving(true);
                                        try {
                                            if (csvResCreate.kind === 'member') {
                                                const n = String(csvCreateMemberName || '').trim();
                                                await postCsvResolutionCreateMember(meeting.id, {
                                                    source_value: csvResCreate.sourceValue,
                                                    name: n,
                                                    name_kana: String(csvCreateMemberKana || '').trim() || undefined,
                                                    type: csvCreateMemberType,
                                                });
                                            } else if (csvResCreate.kind === 'category') {
                                                await postCsvResolutionCreateCategory(meeting.id, {
                                                    source_value: csvResCreate.sourceValue,
                                                    group_name: String(csvCreateCatGroup || '').trim(),
                                                    name: String(csvCreateCatName || '').trim(),
                                                });
                                            } else {
                                                await postCsvResolutionCreateRole(meeting.id, {
                                                    source_value: csvResCreate.sourceValue,
                                                    name: String(csvCreateRoleName || '').trim(),
                                                });
                                            }
                                            setCsvResCreate(null);
                                            await refreshCsvAfterResolution();
                                            notify('新規作成して解決を保存しました');
                                        } catch (e) {
                                            notify(e?.message || '保存に失敗しました', { type: 'error' });
                                        } finally {
                                            setCsvResSaving(false);
                                        }
                                    }}
                                >
                                    {csvResSaving ? '保存中…' : '作成して解決'}
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
    const [editDialogOpen, setEditDialogOpen] = useState(false);
    const [editTargetMeeting, setEditTargetMeeting] = useState(null);
    const [editNumberInput, setEditNumberInput] = useState('');
    const [editHeldOnInput, setEditHeldOnInput] = useState('');
    const [editNameInput, setEditNameInput] = useState('');
    const [editSaving, setEditSaving] = useState(false);

    const refetchStats = useCallback(() => {
        setStatsLoading(true);
        setStatsError(null);
        fetchMeetingsStats()
            .then(setStats)
            .catch((e) => setStatsError(e?.message ?? 'Error'))
            .finally(() => setStatsLoading(false));
    }, []);

    useEffect(() => {
        refetchStats();
    }, [refetchStats]);

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

    const notify = useNotify();

    const handleMeetingEditClick = useCallback((record) => {
        if (!record?.id) return;
        setEditTargetMeeting(record);
        setEditNumberInput(String(record.number ?? ''));
        const ho = record.held_on;
        if (ho && typeof ho === 'string' && ho.length >= 10) {
            setEditHeldOnInput(ho.slice(0, 10));
        } else if (ho) {
            try {
                setEditHeldOnInput(new Date(ho).toISOString().slice(0, 10));
            } catch {
                setEditHeldOnInput('');
            }
        } else {
            setEditHeldOnInput('');
        }
        setEditNameInput(record.name != null ? String(record.name) : '');
        setEditDialogOpen(true);
    }, []);

    const closeEditDialog = useCallback(() => {
        if (editSaving) return;
        setEditDialogOpen(false);
        setEditTargetMeeting(null);
        setEditNumberInput('');
        setEditHeldOnInput('');
        setEditNameInput('');
    }, [editSaving]);

    const submitMeetingEdit = useCallback(async () => {
        if (!editTargetMeeting?.id) return;
        const num = parseInt(editNumberInput, 10);
        if (Number.isNaN(num)) {
            notify('番号は整数で入力してください', { type: 'warning' });
            return;
        }
        if (!editHeldOnInput || String(editHeldOnInput).trim() === '') {
            notify('開催日を入力してください', { type: 'warning' });
            return;
        }
        setEditSaving(true);
        try {
            const payload = { number: num, held_on: editHeldOnInput };
            if (editNameInput.trim() !== '') {
                payload.name = editNameInput.trim();
            }
            const updated = await patchMeeting(editTargetMeeting.id, payload);
            notify('例会を更新しました', { type: 'success' });
            setEditDialogOpen(false);
            setEditTargetMeeting(null);
            setEditNumberInput('');
            setEditHeldOnInput('');
            setEditNameInput('');
            refresh();
            refetchStats();
            if (selectedMeeting?.id === updated.id) {
                setSelectedMeeting((prev) => (prev ? { ...prev, ...updated } : prev));
                setDetailLoading(true);
                fetchMeetingDetail(updated.id)
                    .then(setDetailData)
                    .catch(() => setDetailData(null))
                    .finally(() => setDetailLoading(false));
            }
        } catch (e) {
            notify(e.message || '更新に失敗しました', { type: 'error' });
        } finally {
            setEditSaving(false);
        }
    }, [editTargetMeeting, editNumberInput, editHeldOnInput, editNameInput, notify, refresh, refetchStats, selectedMeeting?.id]);

    return (
        <>
            <List
                title={<MeetingsListTitle />}
                actions={<MeetingsListTopActions onMeetingCreated={refetchStats} />}
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
                    <FunctionField label="Actions" render={(r) => <MeetingActionsField record={r} onMemoClick={handleMeetingMemoClick} onEditClick={handleMeetingEditClick} />} />
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
            <Dialog open={editDialogOpen} onClose={closeEditDialog} maxWidth="sm" fullWidth>
                <DialogTitle>例会を編集{editTargetMeeting ? ` — id ${editTargetMeeting.id}` : ''}</DialogTitle>
                <DialogContent>
                    <MuiTextField
                        autoFocus
                        margin="dense"
                        label="例会番号（必須）"
                        type="number"
                        fullWidth
                        value={editNumberInput}
                        onChange={(e) => setEditNumberInput(e.target.value)}
                        disabled={editSaving}
                        sx={{ mt: 0.5 }}
                    />
                    <MuiTextField
                        margin="dense"
                        label="開催日（必須）"
                        type="date"
                        fullWidth
                        value={editHeldOnInput}
                        onChange={(e) => setEditHeldOnInput(e.target.value)}
                        disabled={editSaving}
                        InputLabelProps={{ shrink: true }}
                        sx={{ mt: 1 }}
                    />
                    <MuiTextField
                        margin="dense"
                        label="名称（任意）"
                        fullWidth
                        value={editNameInput}
                        onChange={(e) => setEditNameInput(e.target.value)}
                        disabled={editSaving}
                        placeholder="例: 第200回定例会"
                        helperText="未入力のときは「第N回定例会」になります（N＝例会番号）"
                        sx={{ mt: 1 }}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={closeEditDialog} disabled={editSaving}>キャンセル</Button>
                    <Button onClick={submitMeetingEdit} variant="contained" disabled={editSaving}>
                        {editSaving ? '保存中…' : '保存する'}
                    </Button>
                </DialogActions>
            </Dialog>
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
