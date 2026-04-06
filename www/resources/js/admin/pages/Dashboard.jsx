import React, { useState, useEffect, useCallback } from 'react';
import { Box, Container } from '@mui/material';
import DashboardHeader from './dashboard/DashboardHeader';
import DashboardKpiGrid from './dashboard/DashboardKpiGrid';
import DashboardTasksPanel from './dashboard/DashboardTasksPanel';
import DashboardShortcutsPanel from './dashboard/DashboardShortcutsPanel';
import DashboardActivityPanel from './dashboard/DashboardActivityPanel';
import DashboardLeadsPanel from './dashboard/DashboardLeadsPanel';
import { useReligoOwner } from '../ReligoOwnerContext';

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
 * Owner はグローバルヘッダー（ReligoOwnerContext）と同期。ADMIN_GLOBAL_OWNER_SELECTION。
 */
export default function Dashboard() {
    const { ownerMemberId, resolvedWorkspaceId, resolvedWorkspaceName } = useReligoOwner();
    const [stats, setStats] = useState(null);
    const [tasks, setTasks] = useState([]);
    const [activity, setActivity] = useState([]);
    const [oneToOneLeads, setOneToOneLeads] = useState([]);
    const [panelsBusy, setPanelsBusy] = useState(true);

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
        if (ownerMemberId == null) return;
        let cancelled = false;
        setPanelsBusy(true);
        (async () => {
            await Promise.all([loadDashboard(), loadOneToOneLeads(ownerMemberId)]);
            if (!cancelled) setPanelsBusy(false);
        })();
        return () => {
            cancelled = true;
        };
    }, [ownerMemberId, loadDashboard, loadOneToOneLeads]);

    useEffect(() => {
        const onWs = () => {
            if (ownerMemberId != null) {
                loadDashboard();
            }
        };
        window.addEventListener('religo-workspace-changed', onWs);
        return () => window.removeEventListener('religo-workspace-changed', onWs);
    }, [ownerMemberId, loadDashboard]);

    const ownerConfigured = ownerMemberId != null;
    const leadsReady = ownerConfigured;

    return (
        <Container maxWidth="lg" sx={{ py: 0 }}>
            <DashboardHeader
                resolvedWorkspaceId={resolvedWorkspaceId}
                resolvedWorkspaceName={resolvedWorkspaceName}
            />

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
