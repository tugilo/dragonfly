import React, { useState, useEffect, useCallback, createContext, useContext, useRef, forwardRef, useImperativeHandle, useMemo } from 'react';
import {
    List,
    Datagrid,
    TextField,
    FunctionField,
    TopToolbar,
    Button,
    useRefresh,
    useNotify,
    useListContext,
    useGetList,
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
    Switch,
    Box,
    Typography,
    Drawer,
    Tabs,
    Tab,
    Chip,
    Stack,
    Card,
    CardContent,
} from '@mui/material';

const API = '';
const OWNER_MEMBER_ID = 1;
const CARD_LOGS_LIMIT = 3;

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

async function putFlags(ownerMemberId, targetMemberId, data) {
    const res = await fetch(
        `${API}/api/dragonfly/flags/${targetMemberId}?owner_member_id=${ownerMemberId}`,
        {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
            body: JSON.stringify(data),
        }
    );
    if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.message || `PUT flags ${res.status}`);
    }
    return res.json();
}

const MembersModalContext = createContext(null);
const ViewModeContext = createContext({ viewMode: 'list', setViewMode: () => {}, displaySortKey: 'display_no_asc', setDisplaySortKey: () => {} });

const MembersListActions = () => {
    return (
        <TopToolbar>
            <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connectionsへ</Button>
            <Button variant="outlined" size="small" disabled>＋ メンバー追加（将来）</Button>
        </TopToolbar>
    );
};

// フィルタは MembersFilterBar で MUI のみ使用（SearchInput/BooleanInput は List 外で _names エラーになるため使用しない）
const membersFilters = [];

const THIRTY_DAYS_MS = 30 * 24 * 60 * 60 * 1000;

function MembersStatsCards() {
    const { data = [], total, isLoading } = useListContext();
    const totalMembers = total ?? 0;
    const arr = Array.isArray(data) ? data : [];
    const no1on1Within30 = arr.filter((m) => {
        const d = m?.summary_lite?.last_contact_at;
        if (!d) return true;
        try {
            return (Date.now() - new Date(d).getTime()) > THIRTY_DAYS_MS;
        } catch {
            return true;
        }
    }).length;
    const interestedOn = arr.filter((m) => m?.summary_lite?.interested).length;
    const want1on1On = arr.filter((m) => m?.summary_lite?.want_1on1).length;

    if (isLoading) {
        return (
            <Box sx={{ display: 'flex', gap: 2, flexWrap: 'wrap', mb: 2 }}>
                {[1, 2, 3, 4].map((i) => (
                    <Card key={i} variant="outlined" sx={{ minWidth: 140, flex: '1 1 140px' }}>
                        <CardContent sx={{ py: 1.5 }}><Typography variant="body2" color="text.secondary">—</Typography></CardContent>
                    </Card>
                ))}
            </Box>
        );
    }
    const stats = [
        { label: '総メンバー数', value: totalMembers },
        { label: '1to1未実施(30日)', value: no1on1Within30 },
        { label: 'interested ON', value: interestedOn },
        { label: 'want_1on1 ON', value: want1on1On },
    ];
    return (
        <Box sx={{ display: 'flex', gap: 2, flexWrap: 'wrap', mb: 2 }}>
            {stats.map(({ label, value }) => (
                <Card key={label} variant="outlined" sx={{ minWidth: 140, flex: '1 1 140px' }}>
                    <CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                        <Typography variant="caption" color="text.secondary" display="block">{label}</Typography>
                        <Typography variant="h6" component="span">{value}</Typography>
                    </CardContent>
                </Card>
            ))}
        </Box>
    );
}

function MembersFilterBar() {
    const { sort, setSort, total, filterValues, setFilters } = useListContext();
    const { viewMode, setViewMode, displaySortKey, setDisplaySortKey } = useContext(ViewModeContext);
    const { data: categories = [] } = useGetList('categories', { pagination: { page: 1, perPage: 500 }, sort: { field: 'id', order: 'ASC' } });
    const { data: roles = [] } = useGetList('roles', { pagination: { page: 1, perPage: 100 }, sort: { field: 'id', order: 'ASC' } });
    const field = sort?.field ?? 'display_no';
    const order = sort?.order ?? 'ASC';
    const handleSortChange = (e) => {
        const v = e.target.value;
        setDisplaySortKey(v);
        if (v === 'display_no_asc') setSort({ field: 'display_no', order: 'ASC' });
        else if (v === 'display_no_desc') setSort({ field: 'display_no', order: 'DESC' });
        else if (v === 'name_asc') setSort({ field: 'name', order: 'ASC' });
        else if (v === 'name_desc') setSort({ field: 'name', order: 'DESC' });
        else setSort({ field: 'display_no', order: 'ASC' });
    };
    const sortSelectValue = displaySortKey ?? `${field}_${order.toLowerCase()}`;
    const categoriesArray = Array.isArray(categories) ? categories : [];
    const categoryChoices = categoriesArray.map((c) => ({ id: c.id, name: c?.group_name && c?.name ? `${c.group_name} / ${c.name}` : c?.name ?? String(c?.id ?? ''), group_name: c?.group_name }));
    const groupNames = [...new Set(categoriesArray.map((c) => c?.group_name).filter(Boolean))].sort();
    const roleChoices = Array.isArray(roles) ? roles.map((r) => ({ id: r.id, name: r?.name ?? String(r?.id ?? '') })) : [];
    const fv = filterValues || {};
    const selectedGroup = fv.group_name ?? '';
    const categoryOptionsForSelect = selectedGroup
        ? categoryChoices.filter((c) => c.group_name === selectedGroup)
        : categoryChoices;
    const handleFilter = (key, value) => {
        const next = { ...fv, [key]: value };
        if (value === undefined || value === '' || value === false) delete next[key];
        if (key === 'group_name' && next.category_id) {
            const cat = categoriesArray.find((c) => c.id === next.category_id);
            if (cat && cat.group_name !== (value || '')) delete next.category_id;
        }
        setFilters(next);
    };
    const handleClearFilters = () => setFilters({});
    const activeFilters = [];
    if (fv.q != null && String(fv.q).trim() !== '') activeFilters.push({ key: 'q', label: `検索: ${String(fv.q).trim()}` });
    if (fv.group_name != null && String(fv.group_name).trim() !== '') activeFilters.push({ key: 'group_name', label: `大カテゴリ: ${fv.group_name}` });
    if (fv.category_id != null) {
        const name = categoryChoices.find((c) => c.id === fv.category_id)?.name ?? String(fv.category_id);
        activeFilters.push({ key: 'category_id', label: `カテゴリ: ${name}` });
    }
    if (fv.role_id != null) {
        const name = roleChoices.find((r) => r.id === fv.role_id)?.name ?? String(fv.role_id);
        activeFilters.push({ key: 'role_id', label: `役職: ${name}` });
    }
    if (fv.interested) activeFilters.push({ key: 'interested', label: 'Interested' });
    if (fv.want_1on1) activeFilters.push({ key: 'want_1on1', label: 'Want 1on1' });
    return (
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1, mb: 2, pb: 2, borderBottom: 1, borderColor: 'divider' }}>
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1.5, alignItems: 'center' }}>
                <MuiTextField
                    size="small"
                    placeholder="名前・番号・かな"
                    value={fv.q ?? ''}
                    onChange={(e) => handleFilter('q', e.target.value || undefined)}
                    sx={{ minWidth: 180 }}
                />
                <FormControl size="small" sx={{ minWidth: 140 }}>
                    <InputLabel>大カテゴリ</InputLabel>
                    <Select value={fv.group_name ?? ''} label="大カテゴリ" onChange={(e) => handleFilter('group_name', e.target.value === '' ? undefined : e.target.value)}>
                        <MenuItem value="">—</MenuItem>
                        {groupNames.map((g) => (
                            <MenuItem key={g} value={g}>{g}</MenuItem>
                        ))}
                    </Select>
                </FormControl>
                <FormControl size="small" sx={{ minWidth: 180 }}>
                    <InputLabel>カテゴリ</InputLabel>
                    <Select value={fv.category_id ?? ''} label="カテゴリ" onChange={(e) => handleFilter('category_id', e.target.value === '' ? undefined : Number(e.target.value))}>
                        <MenuItem value="">—</MenuItem>
                        {categoryOptionsForSelect.map((c) => (
                            <MenuItem key={c.id} value={String(c.id)}>{c.name}</MenuItem>
                        ))}
                    </Select>
                </FormControl>
                <FormControl size="small" sx={{ minWidth: 140 }}>
                    <InputLabel>役職</InputLabel>
                    <Select value={fv.role_id ?? ''} label="役職" onChange={(e) => handleFilter('role_id', e.target.value === '' ? undefined : Number(e.target.value))}>
                        <MenuItem value="">—</MenuItem>
                        {roleChoices.map((r) => (
                            <MenuItem key={r.id} value={String(r.id)}>{r.name}</MenuItem>
                        ))}
                    </Select>
                </FormControl>
                <FormControlLabel
                    control={<Checkbox size="small" checked={!!fv.interested} onChange={(e) => handleFilter('interested', e.target.checked ? true : undefined)} />}
                    label="Interested"
                />
                <FormControlLabel
                    control={<Checkbox size="small" checked={!!fv.want_1on1} onChange={(e) => handleFilter('want_1on1', e.target.checked ? true : undefined)} />}
                    label="Want 1on1"
                />
                <FormControl size="small" sx={{ minWidth: 200 }}>
                    <InputLabel>並び順</InputLabel>
                    <Select value={sortSelectValue} label="並び順" onChange={handleSortChange}>
                        <MenuItem value="display_no_asc">番号 昇順</MenuItem>
                        <MenuItem value="display_no_desc">番号 降順</MenuItem>
                        <MenuItem value="name_asc">名前 昇順</MenuItem>
                        <MenuItem value="name_desc">名前 降順</MenuItem>
                        <MenuItem value="last_contact_oldest_first">最終接触が古い順（要フォロー）</MenuItem>
                        <MenuItem value="relationship_score_desc">関係温度が高い順</MenuItem>
                        <MenuItem value="interested_first">Interested 優先</MenuItem>
                        <MenuItem value="want_1on1_first">Want 1on1 優先</MenuItem>
                    </Select>
                </FormControl>
                {total != null && <Typography variant="body2" color="text.secondary">件数: {total}</Typography>}
                {activeFilters.length > 0 && (
                    <Button size="small" variant="outlined" color="secondary" onClick={handleClearFilters} sx={{ flexShrink: 0 }}>条件クリア</Button>
                )}
                <Box sx={{ ml: 'auto', display: 'flex', gap: 0.5 }}>
                    <Button size="small" variant={viewMode === 'list' ? 'contained' : 'outlined'} onClick={() => setViewMode('list')}>List</Button>
                    <Button size="small" variant={viewMode === 'card' ? 'contained' : 'outlined'} onClick={() => setViewMode('card')}>Card</Button>
                </Box>
            </Box>
            {activeFilters.length > 0 && (
                <Box sx={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: 0.75 }}>
                    <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 600 }}>適用中:</Typography>
                    {activeFilters.map((f) => (
                        <Chip
                            key={f.key}
                            size="small"
                            label={f.label}
                            onDelete={() => handleFilter(f.key, undefined)}
                        />
                    ))}
                </Box>
            )}
        </Box>
    );
}

function SameRoomCountField({ record }) {
    const n = record?.summary_lite?.same_room_count;
    if (n == null) return <span>—</span>;
    return <span>{n}</span>;
}

function OneToOneCountField({ record }) {
    const n = record?.summary_lite?.one_to_one_count;
    if (n == null) return <span>—</span>;
    return <span>{n}</span>;
}

function FlagsField({ record }) {
    const s = record?.summary_lite;
    if (!s) return null;
    const interested = s.interested;
    const want1on1 = s.want_1on1;
    if (!interested && !want1on1) return null;
    return (
        <Box component="span" sx={{ display: 'flex', gap: 0.5, flexWrap: 'wrap' }}>
            {interested && <Chip size="small" label="Interested" sx={{ height: 20 }} />}
            {want1on1 && <Chip size="small" label="1on1" variant="outlined" sx={{ height: 20 }} />}
        </Box>
    );
}

function CategoryField({ record }) {
    const c = record?.category;
    if (!c) return <span>—</span>;
    return <span>{c.group_name} / {c.name}</span>;
}

function LastContactField({ record }) {
    const d = record?.summary_lite?.last_contact_at;
    if (!d) return <span>—</span>;
    try {
        return <span>{new Date(d).toLocaleDateString('ja-JP')}</span>;
    } catch {
        return <span>{String(d)}</span>;
    }
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
        <Box sx={{ display: 'flex', gap: 0.5, flexWrap: 'wrap', alignItems: 'center' }}>
            <Button size="small" variant="contained" onClick={() => ctx.openMemo(record)}>✏️ メモ</Button>
            <Button size="small" variant="outlined" onClick={() => ctx.openO2o(record)}>📅 1to1</Button>
            <Button size="small" variant="text" onClick={() => ctx.openO2oMemo(record)}>📝 1to1メモ</Button>
            <Button size="small" component={Link} to={`/connections?member_id=${record.id}`} variant="outlined" color="primary">🗺 Connections</Button>
            <Button size="small" variant="outlined" color="inherit" onClick={() => ctx.openFlagEdit(record)}>🚩 フラグ</Button>
            <Button size="small" variant="outlined" color="inherit" onClick={() => ctx.openDrawer(record)}>詳細</Button>
        </Box>
    );
}

/** Relationship Score 0..5 from summary_lite (C-7 rule, UI only). last_memo counts as "recent memo". */
function relationshipScoreFromSummaryLite(lite) {
    if (!lite) return 0;
    let s = 0;
    const same = lite.same_room_count ?? 0;
    if (same >= 10) s += 2;
    else if (same >= 5) s += 1;
    if (lite.last_memo != null && (lite.last_memo.body_short != null || lite.last_memo.body != null)) s += 1;
    if (lite.interested === true) s += 1;
    if (lite.want_1on1 === true) s += 1;
    return Math.min(5, Math.max(0, s));
}

const RELATIONSHIP_SCORE_STARS = ['☆☆☆☆☆', '★☆☆☆☆', '★★☆☆☆', '★★★☆☆', '★★★★☆', '★★★★★'];

// Card view: mcard structure per SSOT FIT_AND_GAP §4.1
function MemberCard({ record }) {
    const ctx = useContext(MembersModalContext);
    const [recentLogs, setRecentLogs] = useState([]);
    const [loadingLogs, setLoadingLogs] = useState(false);

    useEffect(() => {
        if (!record?.id) return;
        setLoadingLogs(true);
        fetch(`${API}/api/contact-memos?owner_member_id=${OWNER_MEMBER_ID}&target_member_id=${record.id}&limit=${CARD_LOGS_LIMIT}`)
            .then((res) => (res.ok ? res.json() : []))
            .then((data) => {
                setRecentLogs(Array.isArray(data) ? data : []);
            })
            .catch(() => setRecentLogs([]))
            .finally(() => setLoadingLogs(false));
    }, [record?.id]);

    if (!record) return null;
    const no = record.display_no != null ? String(record.display_no).padStart(2, '0') : record.id;
    const role = record.current_role || '—';
    const c = record?.category;
    const s = record?.summary_lite || {};
    const sameRoom = s.same_room_count != null ? s.same_room_count : '—';
    const lastContact = s.last_contact_at
        ? (() => { try { return new Date(s.last_contact_at).toLocaleDateString('ja-JP'); } catch { return s.last_contact_at; } })()
        : '—';
    const lastMemo = s.last_memo?.body_short;
    const interested = !!s.interested;
    const want1on1 = !!s.want_1on1;
    const contactWarn = s.last_contact_at && (Date.now() - new Date(s.last_contact_at).getTime()) > THIRTY_DAYS_MS;

    return (
        <Box
            className="mcard"
            sx={{
                bgcolor: 'background.paper',
                borderRadius: 2,
                boxShadow: 1,
                border: '1px solid',
                borderColor: 'divider',
                overflow: 'hidden',
                display: 'flex',
                flexDirection: 'column',
                '&:hover': { boxShadow: 2, transform: 'translateY(-1px)' },
                transition: 'box-shadow .2s, transform .15s',
            }}
        >
            <Box className="mc-hdr" sx={{ p: 1.5, pb: 1, borderBottom: '1px solid', borderColor: 'grey.200', background: 'linear-gradient(135deg, #fafbff, #fff)' }}>
                <Box className="mc-hdr-r" sx={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', mb: 0.5 }}>
                    <Typography component="span" className="mc-no" variant="caption" sx={{ height: 19, px: 0.875, borderRadius: '9px', bgcolor: 'grey.200', color: 'grey.700', fontWeight: 700, display: 'inline-flex', alignItems: 'center' }}>#{no}</Typography>
                    <Chip size="small" label={role} sx={{ height: 22 }} />
                </Box>
                <Typography className="mc-name" variant="subtitle1" fontWeight={700}>{record.name}</Typography>
                <Typography className="mc-kana" variant="caption" color="text.secondary" sx={{ display: 'block', mt: 0.25 }}>{(record.name_kana != null && String(record.name_kana).trim() !== '') ? String(record.name_kana).trim() : '—'}</Typography>
            </Box>
            <Box className="mc-body" sx={{ p: 1.5, flex: 1, display: 'flex', flexDirection: 'column', gap: 1 }}>
                <Box className="mc-cat" sx={{ display: 'flex', alignItems: 'center', gap: 0.5, flexWrap: 'wrap' }}>
                    <Chip size="small" label={c?.group_name ?? '—'} sx={{ fontSize: '10px', height: 20 }} />
                    <Typography component="span" variant="caption" color="text.secondary">/</Typography>
                    <Chip size="small" label={c?.name ?? '—'} color="primary" variant="outlined" sx={{ fontSize: '10px', height: 20 }} />
                </Box>
                <Box className="mc-rel" sx={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 0.5 }}>
                    <Box sx={{ bgcolor: 'grey.50', borderRadius: 1, p: 0.75 }}>
                        <Typography variant="caption" color="text.secondary" display="block" sx={{ fontSize: '9px', fontWeight: 600, textTransform: 'uppercase' }}>同室回数</Typography>
                        <Typography variant="body2" fontWeight={700} color="primary.main">{sameRoom}回</Typography>
                    </Box>
                    <Box sx={{ bgcolor: 'grey.50', borderRadius: 1, p: 0.75 }}>
                        <Typography variant="caption" color="text.secondary" display="block" sx={{ fontSize: '9px', fontWeight: 600, textTransform: 'uppercase' }}>最終接触</Typography>
                        {contactWarn ? (
                            <Typography variant="caption" color="warning.main" fontWeight={700}>⚠ {Math.floor((Date.now() - new Date(s.last_contact_at).getTime()) / 86400000)}日未接触</Typography>
                        ) : (
                            <Typography variant="body2" fontWeight={700}>{lastContact}</Typography>
                        )}
                    </Box>
                </Box>
                <Box className="mc-score" sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                    <Typography variant="caption" color="text.secondary" sx={{ fontSize: '9px', fontWeight: 600, textTransform: 'uppercase' }}>関係温度</Typography>
                    <Typography component="span" variant="body2" fontWeight={700} sx={{ letterSpacing: 0.5 }} aria-label={`Relationship Score ${relationshipScoreFromSummaryLite(s)}`}>
                        {RELATIONSHIP_SCORE_STARS[relationshipScoreFromSummaryLite(s)]}
                    </Typography>
                </Box>
                <Box className="mc-memo" sx={{ bgcolor: 'warning.50', borderLeft: '3px solid', borderColor: 'warning.main', py: 0.5, px: 1, borderRadius: '0 5px 5px 0', fontSize: '11px', color: 'grey.800', overflow: 'hidden', display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical' }}>
                    {lastMemo ? (lastMemo.length > 80 ? `${lastMemo.slice(0, 80)}…` : lastMemo) : '—'}
                </Box>
                <Box className="mc-flags" sx={{ display: 'flex', gap: 0.75, flexWrap: 'wrap' }}>
                    <Chip size="small" label="⭐ interested" variant={interested ? 'filled' : 'outlined'} color={interested ? 'success' : 'default'} sx={{ height: 22 }} onClick={() => ctx?.openFlagEdit(record)} />
                    <Chip size="small" label="🔁 want 1on1" variant={want1on1 ? 'filled' : 'outlined'} color={want1on1 ? 'primary' : 'default'} sx={{ height: 22 }} onClick={() => ctx?.openFlagEdit(record)} />
                </Box>
            </Box>
            <Box className="mc-act" sx={{ p: 1, borderTop: '1px solid', borderColor: 'grey.200', display: 'flex', gap: 0.5, flexWrap: 'wrap', bgcolor: 'grey.50' }}>
                <Button size="small" variant="contained" onClick={() => ctx?.openMemo(record)}>✏️ メモ</Button>
                <Button size="small" variant="outlined" onClick={() => ctx?.openO2o(record)}>📅 1to1</Button>
                <Button size="small" variant="text" onClick={() => ctx?.openO2oMemo(record)}>📝 1to1メモ</Button>
                <Button size="small" component={Link} to={`/connections?member_id=${record.id}`} variant="outlined" color="primary" sx={{ flexShrink: 0 }}>🗺 Connections で見る</Button>
                <Button size="small" variant="outlined" color="inherit" sx={{ ml: 'auto' }} onClick={() => ctx?.openDrawer(record)}>詳細 →</Button>
            </Box>
            <Box className="mc-logs" sx={{ p: 1, borderTop: '1px solid', borderColor: 'grey.200' }}>
                <Typography variant="caption" color="text.secondary" sx={{ fontSize: '9px', fontWeight: 700, letterSpacing: 0.5, textTransform: 'uppercase', display: 'block', mb: 0.5 }}>関係ログ（最近）</Typography>
                {loadingLogs ? (
                    <Typography variant="body2" color="text.secondary">読込中…</Typography>
                ) : recentLogs.length === 0 ? (
                    <Typography variant="body2" color="text.secondary">—</Typography>
                ) : (
                    recentLogs.map((log) => {
                        const typeLabel = log.memo_type === 'one_to_one' ? '1to1' : log.memo_type === 'meeting' ? '例会' : 'その他';
                        const dateStr = log.created_at ? (() => { try { return new Date(log.created_at).toLocaleDateString('ja-JP', { month: 'numeric', day: 'numeric' }); } catch { return ''; } })() : '';
                        const bodyShort = (log.body_short || log.body || '').slice(0, 40);
                        const bodyDisplay = bodyShort.length >= 40 ? `${bodyShort}…` : bodyShort;
                        return (
                            <Box key={log.id} className="log-i" sx={{ display: 'flex', alignItems: 'flex-start', gap: 0.75, mb: 0.5, fontSize: '11px', color: 'text.secondary', lineHeight: 1.4 }}>
                                <Chip size="small" label={typeLabel} sx={{ height: 15, fontSize: '9px', fontWeight: 700, flexShrink: 0 }} />
                                <Typography component="span" variant="caption" sx={{ flexShrink: 0, fontSize: '10px' }}>{dateStr}</Typography>
                                <Typography component="span" variant="body2" sx={{ fontSize: '11px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{bodyDisplay || '—'}</Typography>
                            </Box>
                        );
                    })
                )}
            </Box>
        </Box>
    );
}

function MembersCardGrid() {
    const { data = [], isLoading } = useListContext();
    const { displaySortKey } = useContext(ViewModeContext);
    const rawMembers = Array.isArray(data) ? data : [];
    const members = useMemo(() => {
        const key = displaySortKey ?? 'display_no_asc';
        if (key === 'display_no_asc' || key === 'display_no_desc' || key === 'name_asc' || key === 'name_desc') return rawMembers;
        const arr = [...rawMembers];
        if (key === 'last_contact_oldest_first') {
            arr.sort((a, b) => {
                const da = a?.summary_lite?.last_contact_at ? new Date(a.summary_lite.last_contact_at).getTime() : Infinity;
                const db = b?.summary_lite?.last_contact_at ? new Date(b.summary_lite.last_contact_at).getTime() : Infinity;
                if (da !== db) return da - db;
                return (a?.display_no ?? a?.id ?? 0) - (b?.display_no ?? b?.id ?? 0);
            });
        } else if (key === 'relationship_score_desc') {
            arr.sort((a, b) => {
                const sa = relationshipScoreFromSummaryLite(a?.summary_lite);
                const sb = relationshipScoreFromSummaryLite(b?.summary_lite);
                if (sb !== sa) return sb - sa;
                return (a?.display_no ?? a?.id ?? 0) - (b?.display_no ?? b?.id ?? 0);
            });
        } else if (key === 'interested_first') {
            arr.sort((a, b) => {
                const ia = a?.summary_lite?.interested ? 1 : 0;
                const ib = b?.summary_lite?.interested ? 1 : 0;
                if (ib !== ia) return ib - ia;
                return (a?.display_no ?? a?.id ?? 0) - (b?.display_no ?? b?.id ?? 0);
            });
        } else if (key === 'want_1on1_first') {
            arr.sort((a, b) => {
                const wa = a?.summary_lite?.want_1on1 ? 1 : 0;
                const wb = b?.summary_lite?.want_1on1 ? 1 : 0;
                if (wb !== wa) return wb - wa;
                return (a?.display_no ?? a?.id ?? 0) - (b?.display_no ?? b?.id ?? 0);
            });
        }
        return arr;
    }, [rawMembers, displaySortKey]);
    if (isLoading) {
        return (
            <Box sx={{ py: 3, textAlign: 'center' }}>
                <Typography color="text.secondary">読込中…</Typography>
            </Box>
        );
    }
    return (
        <Box
            className="cgrid"
            sx={{
                display: 'grid',
                gridTemplateColumns: { xs: '1fr 1fr', md: 'repeat(3, 1fr)' },
                gap: 2,
            }}
        >
            {members.map((member) => (
                <MemberCard key={member.id} record={member} />
            ))}
        </Box>
    );
}

function FlagEditDialog({ open, member, onClose, onSaved }) {
    const [interested, setInterested] = useState(false);
    const [want_1on1, setWant_1on1] = useState(false);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const notify = useNotify();

    useEffect(() => {
        if (open && member) {
            const s = member?.summary_lite;
            setInterested(!!s?.interested);
            setWant_1on1(!!s?.want_1on1);
            setError('');
        }
    }, [open, member?.id]);

    const handleSave = async () => {
        if (!member?.id) return;
        setLoading(true);
        setError('');
        try {
            await putFlags(OWNER_MEMBER_ID, member.id, { interested, want_1on1 });
            notify('フラグを更新しました');
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
        <Dialog open onClose={onClose} maxWidth="xs" fullWidth>
            <DialogTitle>🚩 フラグ編集 — {member?.name}</DialogTitle>
            <DialogContent>
                <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1, pt: 1 }}>
                    <FormControlLabel
                        control={<Switch size="small" checked={interested} onChange={(_, v) => setInterested(v)} />}
                        label="気になる（Interested）"
                    />
                    <FormControlLabel
                        control={<Switch size="small" checked={want_1on1} onChange={(_, v) => setWant_1on1(v)} />}
                        label="1on1 したい（Want 1on1）"
                    />
                </Box>
                {error && <Typography color="error" variant="body2" sx={{ mt: 2 }}>{error}</Typography>}
            </DialogContent>
            <DialogActions sx={{ bgcolor: 'grey.50' }}>
                <Button onClick={onClose}>キャンセル</Button>
                <Button variant="contained" onClick={handleSave} disabled={loading}>{loading ? '保存中…' : '保存'}</Button>
            </DialogActions>
        </Dialog>
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
    const [oneToOneId, setOneToOneId] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [otoList, setOtoList] = useState([]);
    const notify = useNotify();

    useEffect(() => {
        if (open) { setBody(''); setOneToOneId(''); setError(''); setOtoList([]); }
    }, [open, member?.id]);

    useEffect(() => {
        if (!open || !member?.id) return;
        fetch(`${API}/api/one-to-ones?owner_member_id=${OWNER_MEMBER_ID}`)
            .then((res) => res.ok ? res.json() : [])
            .then((arr) => {
                const forTarget = Array.isArray(arr) ? arr.filter((o) => Number(o.target_member_id) === Number(member.id)) : [];
                setOtoList(forTarget);
            })
            .catch(() => setOtoList([]));
    }, [open, member?.id]);

    const handleSave = async () => {
        if (!member?.id || !body.trim()) return;
        setLoading(true);
        setError('');
        const payload = {
            owner_member_id: OWNER_MEMBER_ID,
            target_member_id: member.id,
            memo_type: 'one_to_one',
            body: body.trim(),
        };
        if (oneToOneId) payload.one_to_one_id = parseInt(oneToOneId, 10);
        try {
            await postContactMemo(payload);
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
                <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ display: 'block', mb: 1 }}>過去の1to1（紐付け任意）</Typography>
                <Box sx={{ bgcolor: 'grey.100', borderRadius: 1, p: 1.5, maxHeight: 140, overflow: 'auto' }}>
                    {otoList.length === 0 ? (
                        <Typography variant="body2" color="text.secondary">1to1履歴はまだありません</Typography>
                    ) : (
                        <FormControl fullWidth size="small" sx={{ mt: 0 }}>
                            <InputLabel>今回のメモを紐づける1to1（任意）</InputLabel>
                            <Select value={oneToOneId} label="今回のメモを紐づける1to1（任意）" onChange={(e) => setOneToOneId(e.target.value)}>
                                <MenuItem value="">— 紐づけない</MenuItem>
                                {otoList.map((o) => (
                                    <MenuItem key={o.id} value={String(o.id)}>
                                        {o.scheduled_at || o.started_at ? new Date(o.scheduled_at || o.started_at).toLocaleDateString('ja-JP') : '—'} — {o.status || ''}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    )}
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

const MEMO_LIMIT = 20;

const MemberDetailDrawer = forwardRef(function MemberDetailDrawer({ open, member, onClose, openMemo, openO2o }, ref) {
    const [tab, setTab] = useState(0);
    const [memos, setMemos] = useState([]);
    const [o2oList, setO2oList] = useState([]);
    const [loadingMemos, setLoadingMemos] = useState(false);
    const [loadingO2o, setLoadingO2o] = useState(false);

    const refetchMemos = useCallback(() => {
        if (!member?.id || !open) return;
        setLoadingMemos(true);
        fetch(`${API}/api/contact-memos?owner_member_id=${OWNER_MEMBER_ID}&target_member_id=${member.id}&limit=${MEMO_LIMIT}`)
            .then((res) => (res.ok ? res.json() : []))
            .then(setMemos)
            .catch(() => setMemos([]))
            .finally(() => setLoadingMemos(false));
    }, [member?.id, open]);

    const refetchO2o = useCallback(() => {
        if (!member?.id || !open) return;
        setLoadingO2o(true);
        fetch(`${API}/api/one-to-ones?owner_member_id=${OWNER_MEMBER_ID}&target_member_id=${member.id}&limit=${MEMO_LIMIT}`)
            .then((res) => (res.ok ? res.json() : []))
            .then(setO2oList)
            .catch(() => setO2oList([]))
            .finally(() => setLoadingO2o(false));
    }, [member?.id, open]);

    useImperativeHandle(ref, () => ({ refetchMemos, refetchO2o }), [refetchMemos, refetchO2o]);

    useEffect(() => {
        if (open && member?.id) {
            setTab(0);
            refetchMemos();
            refetchO2o();
        }
    }, [open, member?.id]);

    if (!member) return null;

    const categoryLabel = member?.category
        ? `${member.category.group_name} / ${member.category.name}`
        : '—';
    const summary = member?.summary_lite || {};
    const lastContact = summary.last_contact_at
        ? (() => { try { return new Date(summary.last_contact_at).toLocaleDateString('ja-JP'); } catch { return summary.last_contact_at; } })()
        : '—';
    const lastMemoBody = summary.last_memo?.body_short || (memos.length > 0 ? (memos[0].body || '').slice(0, 80) + ((memos[0].body && memos[0].body.length > 80) ? '…' : '') : null);

    return (
        <Drawer anchor="right" open={open} onClose={onClose} sx={{ '& .MuiDrawer-paper': { width: { xs: '100%', sm: 440 } } }}>
            <Box sx={{ p: 2, pt: 3 }}>
                <Typography variant="h6" gutterBottom>{member.name}</Typography>
                <Typography variant="body2" color="text.secondary" gutterBottom>#{member.display_no ?? member.id} · {categoryLabel}</Typography>
                <Tabs value={tab} onChange={(_, v) => setTab(v)} sx={{ mt: 1, borderBottom: 1, borderColor: 'divider' }}>
                    <Tab label="Overview" id="drawer-tab-0" />
                    <Tab label="Memos" id="drawer-tab-1" />
                    <Tab label="1to1" id="drawer-tab-2" />
                </Tabs>
                <Box role="tabpanel" hidden={tab !== 0} id="drawer-tabpanel-0">
                    {tab === 0 && (
                        <Stack spacing={1.5} sx={{ mt: 2 }}>
                            <Card variant="outlined"><CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                                <Typography variant="caption" color="text.secondary">役職</Typography>
                                <Typography variant="body2">{member.current_role || '—'}</Typography>
                            </CardContent></Card>
                            <Card variant="outlined"><CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                                <Typography variant="caption" color="text.secondary">要点</Typography>
                                <Stack direction="row" flexWrap="wrap" gap={0.5} sx={{ mt: 0.5 }}>
                                    {summary.same_room_count != null && <Chip size="small" label={`同室 ${summary.same_room_count}`} />}
                                    {summary.one_to_one_count != null && <Chip size="small" label={`1to1 ${summary.one_to_one_count}`} />}
                                    <Chip size="small" label={`最終接触 ${lastContact}`} />
                                    {summary.interested && <Chip size="small" color="primary" label="興味" />}
                                    {summary.want_1on1 && <Chip size="small" color="secondary" label="1to1希望" />}
                                </Stack>
                            </CardContent></Card>
                            {lastMemoBody && (
                                <Card variant="outlined"><CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                                    <Typography variant="caption" color="text.secondary">直近メモ</Typography>
                                    <Typography variant="body2" sx={{ mt: 0.5, whiteSpace: 'pre-wrap' }}>{lastMemoBody}</Typography>
                                </CardContent></Card>
                            )}
                            <Stack direction="row" gap={1}>
                                <Button size="small" variant="contained" onClick={() => openMemo(member)}>✏️ メモ追加</Button>
                                <Button size="small" variant="outlined" onClick={() => openO2o(member)}>📅 1to1予定</Button>
                            </Stack>
                        </Stack>
                    )}
                </Box>
                <Box role="tabpanel" hidden={tab !== 1} id="drawer-tabpanel-1">
                    {tab === 1 && (
                        <Stack spacing={1} sx={{ mt: 2 }}>
                            <Button size="small" variant="contained" onClick={() => openMemo(member)}>✏️ メモ追加</Button>
                            {loadingMemos ? <Typography variant="body2" color="text.secondary">読込中…</Typography> : (
                                memos.length === 0
                                    ? <Typography variant="body2" color="text.secondary">メモはまだありません</Typography>
                                    : <Stack spacing={1}>{memos.map((m) => (
                                        <Card key={m.id} variant="outlined"><CardContent sx={{ py: 1, '&:last-child': { pb: 1 } }}>
                                            <Typography variant="caption" color="text.secondary">{m.memo_type} · {m.created_at ? new Date(m.created_at).toLocaleString('ja-JP') : ''}</Typography>
                                            <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap' }}>{(m.body || '').slice(0, 200)}{(m.body && m.body.length > 200) ? '…' : ''}</Typography>
                                        </CardContent></Card>
                                    ))}</Stack>
                            )}
                        </Stack>
                    )}
                </Box>
                <Box role="tabpanel" hidden={tab !== 2} id="drawer-tabpanel-2">
                    {tab === 2 && (
                        <Stack spacing={1} sx={{ mt: 2 }}>
                            <Button size="small" variant="contained" onClick={() => openO2o(member)}>📅 1to1予定追加</Button>
                            {loadingO2o ? <Typography variant="body2" color="text.secondary">読込中…</Typography> : (
                                o2oList.length === 0
                                    ? <Typography variant="body2" color="text.secondary">1to1はまだありません</Typography>
                                    : <Stack spacing={1}>{o2oList.map((o) => (
                                        <Card key={o.id} variant="outlined"><CardContent sx={{ py: 1, '&:last-child': { pb: 1 } }}>
                                            <Typography variant="caption" color="text.secondary">{o.status} · {(o.scheduled_at || o.started_at) ? new Date(o.scheduled_at || o.started_at).toLocaleString('ja-JP') : '—'}</Typography>
                                            {o.notes && <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap' }}>{(o.notes || '').slice(0, 120)}{(o.notes && o.notes.length > 120) ? '…' : ''}</Typography>}
                                        </CardContent></Card>
                                    ))}</Stack>
                            )}
                        </Stack>
                    )}
                </Box>
            </Box>
        </Drawer>
    );
});

function MembersListInner() {
    const [viewMode, setViewMode] = useState('card');
    const [displaySortKey, setDisplaySortKey] = useState('display_no_asc');
    return (
        <ViewModeContext.Provider value={{ viewMode, setViewMode, displaySortKey, setDisplaySortKey }}>
            <MembersStatsCards />
            <MembersFilterBar />
            {viewMode === 'list' ? (
                    <Datagrid rowClick={false}>
                    <TextField source="display_no" label="番号" emptyText="—" sortable />
                    <FunctionField label="名前" sortable sortBy="name" source="name" render={(r) => (
                        <Box>
                            <Typography variant="body2" component="span">{r?.name ?? '—'}</Typography>
                            {(r?.name_kana != null && String(r.name_kana).trim() !== '') && (
                                <Typography variant="caption" display="block" color="text.secondary">{String(r.name_kana).trim()}</Typography>
                            )}
                        </Box>
                    )} />
                    <FunctionField label="カテゴリ" render={(r) => <CategoryField record={r} />} />
                    <TextField source="current_role" label="役職" emptyText="—" />
                    <FunctionField label="同室回数" render={(r) => <SameRoomCountField record={r} />} />
                    <FunctionField label="1to1回数" render={(r) => <OneToOneCountField record={r} />} />
                    <FunctionField label="最終接触" render={(r) => <LastContactField record={r} />} />
                    <FunctionField label="直近メモ" render={(r) => <LastMemoField record={r} />} />
                    <FunctionField label="フラグ" render={(r) => <FlagsField record={r} />} />
                    <FunctionField label="Actions" render={(r) => <MemberRowActions record={r} />} />
                </Datagrid>
            ) : (
                <MembersCardGrid />
            )}
        </ViewModeContext.Provider>
    );
}

export function MembersList() {
    const [memoOpen, setMemoOpen] = useState(false);
    const [memoMember, setMemoMember] = useState(null);
    const [o2oOpen, setO2oOpen] = useState(false);
    const [o2oMember, setO2oMember] = useState(null);
    const [o2oMemoOpen, setO2oMemoOpen] = useState(false);
    const [o2oMemoMember, setO2oMemoMember] = useState(null);
    const [drawerMember, setDrawerMember] = useState(null);
    const [flagEditMember, setFlagEditMember] = useState(null);
    const drawerRef = useRef(null);
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
    const openFlagEdit = useCallback((member) => {
        setFlagEditMember(member);
    }, []);
    const openDrawer = useCallback((member) => {
        setDrawerMember(member);
    }, []);

    const onSaved = useCallback(() => {
        refresh();
        drawerRef.current?.refetchMemos?.();
        drawerRef.current?.refetchO2o?.();
    }, [refresh]);
    const onO2oSaved = useCallback(() => {
        refresh();
        drawerRef.current?.refetchO2o?.();
    }, [refresh]);

    return (
        <>
            <MembersModalContext.Provider value={{ openMemo, openO2o, openO2oMemo, openFlagEdit, openDrawer }}>
                <List
                    title={
                        <Box>
                            <Typography variant="h5" component="span">Members</Typography>
                            <Typography variant="body2" color="text.secondary" display="block" sx={{ mt: 0.5 }}>
                                仕事 / 役職 / 関係性を把握し、1to1とメモで接点を増やす
                            </Typography>
                        </Box>
                    }
                    actions={<MembersListActions />}
                    filters={membersFilters}
                    sort={{ field: 'display_no', order: 'ASC' }}
                    perPage={25}
                >
                    <MembersListInner />
                </List>
            </MembersModalContext.Provider>
            <MemberDetailDrawer
                ref={drawerRef}
                open={!!drawerMember}
                member={drawerMember}
                onClose={() => setDrawerMember(null)}
                openMemo={openMemo}
                openO2o={openO2o}
            />
            <MemoModal open={memoOpen} member={memoMember} onClose={() => setMemoOpen(false)} onSaved={onSaved} />
            <O2oModal open={o2oOpen} member={o2oMember} onClose={() => setO2oOpen(false)} onSaved={onO2oSaved} />
            <O2oMemoModal open={o2oMemoOpen} member={o2oMemoMember} onClose={() => setO2oMemoOpen(false)} onSaved={onSaved} />
            <FlagEditDialog open={!!flagEditMember} member={flagEditMember} onClose={() => setFlagEditMember(null)} onSaved={onSaved} />
        </>
    );
}
