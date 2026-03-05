import React, { useState, useEffect, useCallback } from 'react';
import {
    Box,
    Card,
    CardContent,
    Container,
    Typography,
    Button,
    Chip,
    Select,
    MenuItem,
    FormControl,
    InputLabel,
} from '@mui/material';
import { Link } from 'react-router-dom';

const API_BASE = '';

async function dashboardRequest(path, params = {}) {
    const q = new URLSearchParams();
    if (params.owner_member_id != null) q.set('owner_member_id', String(params.owner_member_id));
    if (params.limit != null) q.set('limit', String(params.limit));
    const url = `${API_BASE}/api/dashboard/${path}${q.toString() ? `?${q.toString()}` : ''}`;
    const res = await fetch(url, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`Dashboard API ${res.status}`);
    return res.json();
}

async function fetchJson(url, options = {}) {
    const res = await fetch(`${API_BASE}${url}`, { headers: { Accept: 'application/json', ...options.headers }, ...options });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

const STATS_DEFAULT = {
    stale_contacts_count: 3,
    monthly_one_to_one_count: 5,
    monthly_intro_memo_count: 8,
    monthly_meeting_memo_count: 4,
    subtexts: { stale: '要フォロー', one_to_one: '先月比 +2', intro: 'BO含む', meeting: '例会#247 含む' },
};

const TASKS_FALLBACK = [
    { id: 's1', kind: 'stale_follow', title: '伊藤 勇樹', meta: '55日間未接触 — 1to1を検討', action: { label: '1to1予定', href: '/one-to-ones/create', disabled: false } },
    { id: 's2', kind: 'stale_follow', title: '水野 花菜', meta: '66日間未接触 — フォローアップ要', action: { label: 'メモ追加', href: null, disabled: true } },
    { id: 'o1', kind: 'one_to_one_planned', title: '田中 誠一 との1to1', meta: '本日 12:00 — CRM導入フォロー', badge: '予定', action: { label: '予定', href: null, disabled: true } },
    { id: 'm1', kind: 'meeting_memo_pending', title: '例会 #248 メモ未整理', meta: '次回例会まであと5日', action: { label: 'Meetingsへ', href: '/meetings', disabled: false } },
];

const ACTIVITY_ICONS = { memo_added: '✏️', one_to_one_created: '📅', one_to_one_completed: '🤝', flag_changed: '⭐', bo_assigned: '📋' };

const ACTIVITY_FALLBACK = [
    { id: 'a1', kind: 'memo_added', title: '佐藤 美咲 にメモ追加', meta: 'セミナー案件・1to1メモ — 2分前' },
    { id: 'a2', kind: 'one_to_one_created', title: '田中 誠一 1to1を登録', meta: 'planned — 本日 12:00 — 3時間前' },
    { id: 'a3', kind: 'bo_assigned', title: '例会 #247 BO割当を保存', meta: 'BO4件 — 2025-07-08 — 昨日' },
    { id: 'a4', kind: 'one_to_one_completed', title: '渡辺 彩香 1to1完了', meta: 'DX案件ヒアリング — 2025-07-09' },
    { id: 'a5', kind: 'flag_changed', title: '森 友美 に interested フラグ', meta: 'スポーツ施術コラボ検討 — 2025-07-06' },
    { id: 'a6', kind: 'memo_added', title: '小林 陽子 にメモ追加', meta: '投資物件の情報提供依頼 — 2025-07-05' },
];

/**
 * Religo Dashboard. SSOT: DASHBOARD_REQUIREMENTS.md. E-4: owner を user 設定で保存し、未設定時は設定UI・設定済みは Owner セレクタを表示。
 */
export default function Dashboard() {
    const [ownerMemberId, setOwnerMemberId] = useState(null);
    const [needOwnerSetup, setNeedOwnerSetup] = useState(false);
    const [members, setMembers] = useState([]);
    const [stats, setStats] = useState(STATS_DEFAULT);
    const [tasks, setTasks] = useState(TASKS_FALLBACK);
    const [activity, setActivity] = useState(ACTIVITY_FALLBACK);
    const [loading, setLoading] = useState(true);
    const [savingOwner, setSavingOwner] = useState(false);
    const [ownerError, setOwnerError] = useState('');

    const loadMe = useCallback(async () => {
        try {
            const data = await fetchJson('/api/users/me');
            const id = data.owner_member_id ?? null;
            setOwnerMemberId(id);
            setNeedOwnerSetup(id == null);
            return id;
        } catch {
            setNeedOwnerSetup(true);
            setOwnerMemberId(null);
            return null;
        }
    }, []);

    const loadMembers = useCallback(async () => {
        try {
            const data = await fetchJson('/api/dragonfly/members');
            setMembers(Array.isArray(data) ? data : []);
        } catch {
            setMembers([]);
        }
    }, []);

    const loadDashboard = useCallback(async () => {
        try {
            const [s, t, a] = await Promise.all([
                dashboardRequest('stats').catch(() => null),
                dashboardRequest('tasks').catch(() => null),
                dashboardRequest('activity', { limit: 6 }).catch(() => null),
            ]);
            if (s && typeof s.stale_contacts_count === 'number') setStats(s);
            if (Array.isArray(t) && t.length > 0) setTasks(t);
            if (Array.isArray(a) && a.length > 0) setActivity(a);
        } catch (_) {}
    }, []);

    useEffect(() => {
        let cancelled = false;
        setLoading(true);
        setOwnerError('');
        (async () => {
            const id = await loadMe();
            if (cancelled) return;
            if (id != null) {
                await Promise.all([loadDashboard(), loadMembers()]);
            } else {
                await loadMembers();
            }
            if (!cancelled) setLoading(false);
        })();
        return () => { cancelled = true; };
    }, [loadMe, loadMembers, loadDashboard]);

    const saveOwner = useCallback(async (memberId) => {
        setSavingOwner(true);
        setOwnerError('');
        try {
            const res = await fetch(`${API_BASE}/api/users/me`, {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify({ owner_member_id: memberId }),
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                setOwnerError(data.message || '保存に失敗しました');
                return;
            }
            setOwnerMemberId(data.owner_member_id);
            setNeedOwnerSetup(false);
            await loadDashboard();
        } catch {
            setOwnerError('保存に失敗しました');
        } finally {
            setSavingOwner(false);
        }
    }, [loadDashboard]);

    const handleOwnerSelect = (e) => {
        const id = Number(e.target.value);
        if (Number.isInteger(id)) saveOwner(id);
    };

    const subtexts = stats.subtexts || STATS_DEFAULT.subtexts;
    const tasksToShow = tasks.length > 0 ? tasks : TASKS_FALLBACK;
    const activityToShow = activity.length > 0 ? activity : ACTIVITY_FALLBACK;

    return (
        <Container maxWidth="lg" sx={{ py: 0 }}>
            <Box sx={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', flexWrap: 'wrap', gap: 2, mb: 2.25 }}>
                <Box>
                    <Typography component="h1" sx={{ fontSize: 21, fontWeight: 700, letterSpacing: -0.3 }}>
                        Dashboard
                    </Typography>
                    <Typography sx={{ fontSize: 12, color: 'text.secondary', mt: 0.375 }}>
                        今日の活動・未アクション・KPI
                    </Typography>
                </Box>
                <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', alignItems: 'center' }}>
                    {ownerMemberId != null && members.length > 0 && (
                        <FormControl size="small" sx={{ minWidth: 140 }}>
                            <InputLabel id="dashboard-owner-label">Owner</InputLabel>
                            <Select
                                labelId="dashboard-owner-label"
                                label="Owner"
                                value={String(ownerMemberId)}
                                onChange={handleOwnerSelect}
                                disabled={savingOwner}
                            >
                                {members.map((m) => (
                                    <MenuItem key={m.id} value={String(m.id)}>{m.name}</MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    )}
                    <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connectionsへ</Button>
                    <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">＋ 1to1追加</Button>
                </Box>
            </Box>

            {needOwnerSetup && (
                <Card variant="outlined" sx={{ mb: 2, bgcolor: 'grey.50', borderColor: 'warning.main' }}>
                    <CardContent>
                        <Typography sx={{ fontWeight: 600, mb: 1 }}>オーナーを設定してください</Typography>
                        <Typography variant="body2" color="text.secondary" sx={{ mb: 1.5 }}>
                            ダッシュボードの表示対象となる「自分」に該当するメンバーを選択してください。
                        </Typography>
                        <FormControl size="small" sx={{ minWidth: 200 }}>
                            <InputLabel id="owner-setup-label">メンバーを選択</InputLabel>
                            <Select
                                labelId="owner-setup-label"
                                label="メンバーを選択"
                                value=""
                                onChange={(e) => saveOwner(Number(e.target.value))}
                                disabled={savingOwner || members.length === 0}
                            >
                                {members.map((m) => (
                                    <MenuItem key={m.id} value={String(m.id)}>{m.name}</MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        {ownerError && <Typography color="error" variant="body2" sx={{ mt: 1 }}>{ownerError}</Typography>}
                    </CardContent>
                </Card>
            )}

            {loading && (
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>読込中…</Typography>
            )}

            <Box
                sx={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(4, 1fr)',
                    gap: 1.5,
                    mb: 2,
                    '@media (max-width: 900px)': { gridTemplateColumns: 'repeat(2, 1fr)' },
                    '@media (max-width: 600px)': { gridTemplateColumns: '1fr' },
                }}
            >
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: '#ffebee', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>⚠️</Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>未接触（30日以上）</Typography>
                            <Typography sx={{ fontSize: 20, fontWeight: 700, color: 'warning.main' }}>{stats.stale_contacts_count}</Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>{subtexts.stale}</Typography>
                        </Box>
                    </CardContent>
                </Card>
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'primary.light', color: 'primary.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>🤝</Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>今月の1to1回数</Typography>
                            <Typography sx={{ fontSize: 20, fontWeight: 700 }}>{stats.monthly_one_to_one_count}</Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>{subtexts.one_to_one}</Typography>
                        </Box>
                    </CardContent>
                </Card>
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'success.light', color: 'success.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>📝</Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>紹介メモ数（今月）</Typography>
                            <Typography sx={{ fontSize: 20, fontWeight: 700 }}>{stats.monthly_intro_memo_count}</Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>{subtexts.intro}</Typography>
                        </Box>
                    </CardContent>
                </Card>
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                        <Box sx={{ width: 40, height: 40, borderRadius: 1, bgcolor: 'secondary.light', color: 'secondary.contrastText', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>📋</Box>
                        <Box>
                            <Typography variant="caption" color="text.secondary" fontWeight={600} sx={{ fontSize: 10 }}>例会メモ数（今月）</Typography>
                            <Typography sx={{ fontSize: 20, fontWeight: 700 }}>{stats.monthly_meeting_memo_count}</Typography>
                            <Typography variant="caption" color="text.secondary" sx={{ fontSize: 10 }}>{subtexts.meeting}</Typography>
                        </Box>
                    </CardContent>
                </Card>
            </Box>

            <Box sx={{ display: 'grid', gridTemplateColumns: '1fr 340px', gap: 1.75, '@media (max-width: 1100px)': { gridTemplateColumns: '1fr' } }}>
                <Box>
                    <Card variant="outlined" sx={{ mb: 1.75, boxShadow: 1 }}>
                        <CardContent>
                            <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 1.25 }}>⚡ 今日やること（Tasks）</Typography>
                            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                                {tasksToShow.map((task) => {
                                    const isStale = task.kind === 'stale_follow';
                                    const isO2o = task.kind === 'one_to_one_planned';
                                    const isMeeting = task.kind === 'meeting_memo_pending';
                                    const bg = isStale ? '#fff3e0' : isO2o ? 'primary.light' : '#f8f9fa';
                                    const borderColor = isStale ? 'warning.main' : isO2o ? 'primary.main' : '#ccc';
                                    const icon = isStale ? '⏰' : isO2o ? '📅' : '📝';
                                    const action = task.action || {};
                                    return (
                                        <Box key={task.id} sx={{ display: 'flex', alignItems: 'center', gap: 1.25, py: 1.125, px: 1.5, bgcolor: bg, borderRadius: 1, borderLeft: 3, borderColor }}>
                                            <span style={{ fontSize: 16 }}>{icon}</span>
                                            <Box sx={{ flex: 1 }}>
                                                <Typography sx={{ fontSize: 13, fontWeight: 600, color: isStale ? '#bf360c' : undefined }}>{task.title}</Typography>
                                                <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>{task.meta || ''}</Typography>
                                            </Box>
                                            {action.href ? (
                                                <Button size="small" variant="outlined" color={isStale ? 'warning' : 'inherit'} component={Link} to={action.href} disabled={action.disabled}>{action.label}</Button>
                                            ) : task.badge ? (
                                                <Chip label={task.badge} size="small" sx={{ bgcolor: '#fff3e0', color: '#e65100', border: '1px solid #ffcc80' }} />
                                            ) : (
                                                <Button size="small" variant="outlined" color="warning" disabled>{action.label}</Button>
                                            )}
                                        </Box>
                                    );
                                })}
                            </Box>
                        </CardContent>
                    </Card>
                    <Card variant="outlined" sx={{ boxShadow: 1 }}>
                        <CardContent>
                            <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 1.25 }}>🔗 クイックショートカット</Typography>
                            <Box sx={{ display: 'flex', gap: 1.25, flexWrap: 'wrap' }}>
                                <Button component={Link} to="/connections" variant="contained" size="small">🗺 Connections（会の地図）</Button>
                                <Button component={Link} to="/members" variant="outlined" size="small">👥 Members一覧</Button>
                                <Button component={Link} to="/one-to-ones/create" variant="outlined" size="small">＋ 1to1を追加</Button>
                                <Button component={Link} to="/meetings" variant="outlined" size="small" color="inherit">📋 例会一覧</Button>
                            </Box>
                        </CardContent>
                    </Card>
                </Box>
                <Card variant="outlined" sx={{ boxShadow: 1 }}>
                    <CardContent>
                        <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 1.25 }}>🕐 最近の活動</Typography>
                        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                            {activityToShow.map((item, i) => (
                                <Box key={item.id || i} sx={{ display: 'flex', gap: 1.5, py: 1.25, borderBottom: i < activityToShow.length - 1 ? '1px solid #f5f5f5' : 'none' }}>
                                    <Box sx={{ width: 28, height: 28, borderRadius: '50%', bgcolor: 'grey.200', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 13, flexShrink: 0 }}>
                                        {ACTIVITY_ICONS[item.kind] || '✏️'}
                                    </Box>
                                    <Box sx={{ minWidth: 0 }}>
                                        <Typography sx={{ fontSize: 13, fontWeight: 600 }}>{item.title}</Typography>
                                        <Typography variant="caption" color="text.secondary" sx={{ fontSize: 11 }}>{item.meta || ''}</Typography>
                                    </Box>
                                </Box>
                            ))}
                        </Box>
                    </CardContent>
                </Card>
            </Box>
        </Container>
    );
}
