import React, { useState, useEffect, useCallback } from 'react';
import { Box, Card, CardContent, Container, Typography, Select, MenuItem, FormControl, InputLabel } from '@mui/material';
import DashboardHeader from './dashboard/DashboardHeader';
import DashboardKpiGrid from './dashboard/DashboardKpiGrid';
import DashboardTasksPanel from './dashboard/DashboardTasksPanel';
import DashboardShortcutsPanel from './dashboard/DashboardShortcutsPanel';
import DashboardActivityPanel from './dashboard/DashboardActivityPanel';
import DashboardLeadsPanel from './dashboard/DashboardLeadsPanel';

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

/**
 * Religo Dashboard. SSOT: docs/SSOT/DASHBOARD_FIT_AND_GAP.md, DASHBOARD_DATA_SSOT.md.
 * E-4: owner を user 設定で保存。P7-3: 空状態・ローディングをパネル単位で整理（フェールバック凡例データは出さない）。
 */
export default function Dashboard() {
    const [ownerMemberId, setOwnerMemberId] = useState(null);
    const [needOwnerSetup, setNeedOwnerSetup] = useState(false);
    const [members, setMembers] = useState([]);
    const [stats, setStats] = useState(null);
    const [tasks, setTasks] = useState([]);
    const [activity, setActivity] = useState([]);
    const [oneToOneLeads, setOneToOneLeads] = useState([]);
    const [bootLoading, setBootLoading] = useState(true);
    const [panelsRefreshing, setPanelsRefreshing] = useState(false);
    const [savingOwner, setSavingOwner] = useState(false);
    const [ownerError, setOwnerError] = useState('');
    /** BO-AUDIT-P4: GET /api/users/me の解決済み workspace（Dashboard API には未送信・表示・説明用のみ） */
    const [resolvedWorkspaceId, setResolvedWorkspaceId] = useState(null);

    const loadMe = useCallback(async () => {
        try {
            const data = await fetchJson('/api/users/me');
            const id = data.owner_member_id ?? null;
            setOwnerMemberId(id);
            setNeedOwnerSetup(id == null);
            setResolvedWorkspaceId(data.workspace_id != null ? Number(data.workspace_id) : null);
            return id;
        } catch {
            setNeedOwnerSetup(true);
            setOwnerMemberId(null);
            setResolvedWorkspaceId(null);
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
            if (s && typeof s.stale_contacts_count === 'number') {
                setStats(s);
            } else {
                setStats(null);
            }
            setTasks(Array.isArray(t) ? t : []);
            setActivity(Array.isArray(a) ? a : []);
        } catch {
            setStats(null);
            setTasks([]);
            setActivity([]);
        }
    }, []);

    const loadOneToOneLeads = useCallback(async (ownerId) => {
        if (ownerId == null) {
            setOneToOneLeads([]);
            return;
        }
        try {
            const rows = await fetchJson(`/api/dragonfly/members/one-to-one-status?owner_member_id=${ownerId}`);
            setOneToOneLeads(Array.isArray(rows) ? rows : []);
        } catch {
            setOneToOneLeads([]);
        }
    }, []);

    useEffect(() => {
        let cancelled = false;
        setBootLoading(true);
        setOwnerError('');
        (async () => {
            const id = await loadMe();
            if (cancelled) return;
            if (id != null) {
                await Promise.all([loadDashboard(), loadMembers(), loadOneToOneLeads(id)]);
            } else {
                await loadMembers();
                setOneToOneLeads([]);
                setStats(null);
                setTasks([]);
                setActivity([]);
            }
            if (!cancelled) setBootLoading(false);
        })();
        return () => { cancelled = true; };
    }, [loadMe, loadMembers, loadDashboard, loadOneToOneLeads]);

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
            setPanelsRefreshing(true);
            try {
                await loadDashboard();
                await loadOneToOneLeads(data.owner_member_id);
            } finally {
                setPanelsRefreshing(false);
            }
        } catch {
            setOwnerError('保存に失敗しました');
        } finally {
            setSavingOwner(false);
        }
    }, [loadDashboard, loadOneToOneLeads]);

    const handleOwnerSelect = (e) => {
        const id = Number(e.target.value);
        if (Number.isInteger(id)) saveOwner(id);
    };

    const panelsBusy = bootLoading || panelsRefreshing;
    const ownerConfigured = ownerMemberId != null && !needOwnerSetup;
    const leadsReady = ownerConfigured;

    return (
        <Container maxWidth="lg" sx={{ py: 0 }}>
            <DashboardHeader
                ownerMemberId={ownerMemberId}
                members={members}
                savingOwner={savingOwner}
                onOwnerChange={handleOwnerSelect}
                showOwnerSelect={ownerMemberId != null && members.length > 0}
                resolvedWorkspaceId={resolvedWorkspaceId}
            />

            {needOwnerSetup && (
                <Card variant="outlined" sx={{ mb: 2, bgcolor: 'grey.50', borderColor: 'warning.main', borderRadius: '10px' }}>
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

            <DashboardKpiGrid stats={stats} loading={panelsBusy} ownerConfigured={ownerConfigured} />

            <Box
                sx={{
                    display: 'grid',
                    gridTemplateColumns: { xs: '1fr', md: '1fr 340px' },
                    gap: 1.75,
                    alignItems: 'start',
                }}
            >
                <Box sx={{ display: 'flex', flexDirection: 'column', minWidth: 0 }}>
                    <DashboardTasksPanel tasks={tasks} loading={panelsBusy} ownerConfigured={ownerConfigured} />
                    <DashboardShortcutsPanel />
                    <DashboardActivityPanel items={activity} loading={panelsBusy} ownerConfigured={ownerConfigured} />
                </Box>
                <DashboardLeadsPanel
                    hasOwner={leadsReady}
                    oneToOneLeads={oneToOneLeads}
                    loading={panelsBusy && leadsReady}
                />
            </Box>
        </Container>
    );
}
