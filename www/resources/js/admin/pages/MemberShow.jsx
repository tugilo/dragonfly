import React, { useState, useEffect, useCallback } from 'react';
import { Show, useRecordContext, EditButton, TopToolbar } from 'react-admin';
import { Link } from 'react-router-dom';
import {
    Box,
    Typography,
    Tabs,
    Tab,
    Card,
    CardContent,
    Chip,
    Stack,
    Button,
} from '@mui/material';
import { religoOneToOneLeadStatusLabel } from '../religoOneToOneLeadLabels';
import { fetchReligoOwnerMemberId, ownerMemberIdFallback } from '../religoOwnerMemberId';

const API = '';
const OWNER_MEMBER_ID = 1;
const MEMO_LIMIT = 20;

async function fetchJson(url) {
    const res = await fetch(`${API}${url}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

function MemberDetailContent() {
    const record = useRecordContext();
    const [tab, setTab] = useState(0);
    const [summary, setSummary] = useState(null);
    const [memos, setMemos] = useState([]);
    const [o2oList, setO2oList] = useState([]);
    const [loadingSummary, setLoadingSummary] = useState(true);
    const [loadingMemos, setLoadingMemos] = useState(true);
    const [loadingO2o, setLoadingO2o] = useState(true);
    const [leadRow, setLeadRow] = useState(null);
    const id = record?.id;

    const loadLeadStatus = useCallback(() => {
        if (!id) return;
        fetchReligoOwnerMemberId()
            .then((me) => {
                const owner = ownerMemberIdFallback(me);
                return fetch(`${API}/api/dragonfly/members/one-to-one-status?owner_member_id=${owner}`);
            })
            .then((res) => (res.ok ? res.json() : []))
            .then((rows) => {
                if (!Array.isArray(rows)) {
                    setLeadRow(null);
                    return;
                }
                setLeadRow(rows.find((r) => Number(r.member_id) === Number(id)) ?? null);
            })
            .catch(() => setLeadRow(null));
    }, [id]);

    const loadSummary = useCallback(() => {
        if (!id) return;
        setLoadingSummary(true);
        fetchJson(`/api/dragonfly/contacts/${id}/summary?owner_member_id=${OWNER_MEMBER_ID}`)
            .then(setSummary)
            .catch(() => setSummary(null))
            .finally(() => setLoadingSummary(false));
    }, [id]);

    const loadMemos = useCallback(() => {
        if (!id) return;
        setLoadingMemos(true);
        fetch(`${API}/api/contact-memos?owner_member_id=${OWNER_MEMBER_ID}&target_member_id=${id}&limit=${MEMO_LIMIT}`)
            .then((res) => (res.ok ? res.json() : []))
            .then((arr) => setMemos(Array.isArray(arr) ? arr : []))
            .catch(() => setMemos([]))
            .finally(() => setLoadingMemos(false));
    }, [id]);

    const loadO2o = useCallback(() => {
        if (!id) return;
        setLoadingO2o(true);
        fetch(`${API}/api/one-to-ones?owner_member_id=${OWNER_MEMBER_ID}&target_member_id=${id}&limit=${MEMO_LIMIT}`)
            .then((res) => (res.ok ? res.json() : []))
            .then((arr) => setO2oList(Array.isArray(arr) ? arr : []))
            .catch(() => setO2oList([]))
            .finally(() => setLoadingO2o(false));
    }, [id]);

    useEffect(() => {
        if (id) {
            loadSummary();
            loadMemos();
            loadO2o();
            loadLeadStatus();
        }
    }, [id, loadLeadStatus, loadSummary, loadMemos, loadO2o]);

    if (!record) return null;

    const categoryLabel = record?.category ? `${record.category.group_name} / ${record.category.name}` : '—';
    const lastO2oAt = summary?.last_one_on_one_at
        ? (() => { try { return new Date(summary.last_one_on_one_at).toLocaleDateString('ja-JP'); } catch { return summary.last_one_on_one_at; } })()
        : '—';
    const latestMemos = summary?.latest_memos ?? [];
    const lastMemoBody = latestMemos.length > 0
        ? (latestMemos[0].body || '').slice(0, 80) + ((latestMemos[0].body && latestMemos[0].body.length > 80) ? '…' : '')
        : (memos.length > 0 ? (memos[0].body || '').slice(0, 80) + ((memos[0].body && memos[0].body.length > 80) ? '…' : '') : null);
    const flags = summary?.flags ?? { interested: false, want_1on1: false };
    const leadChipColor =
        leadRow?.one_to_one_status === 'needs_action'
            ? 'warning'
            : leadRow?.one_to_one_status === 'ok'
              ? 'success'
              : 'default';

    return (
        <Box sx={{ pt: 1 }}>
            <Typography variant="body2" color="text.secondary" gutterBottom>
                #{record.display_no ?? record.id} · {categoryLabel} · {record.current_role || '—'}
            </Typography>
            <Tabs value={tab} onChange={(_, v) => setTab(v)} sx={{ mt: 2, borderBottom: 1, borderColor: 'divider' }}>
                <Tab label="Overview" id="show-tab-0" />
                <Tab label="Memos" id="show-tab-1" />
                <Tab label="1to1" id="show-tab-2" />
            </Tabs>

            <Box role="tabpanel" hidden={tab !== 0} id="show-tabpanel-0">
                {tab === 0 && (
                    <Stack spacing={1.5} sx={{ mt: 2 }}>
                        <Card variant="outlined">
                            <CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                                <Typography variant="caption" color="text.secondary">要点</Typography>
                                <Stack direction="row" flexWrap="wrap" gap={0.5} sx={{ mt: 0.5 }}>
                                    {!loadingSummary && summary?.same_room_count != null && <Chip size="small" label={`同室 ${summary.same_room_count}`} />}
                                    {!loadingSummary && (summary?.one_on_one_count != null || (summary && 'one_on_one_count' in summary)) && <Chip size="small" label={`1to1 ${summary?.one_on_one_count ?? o2oList.length}`} />}
                                    {!loadingSummary && (lastO2oAt !== '—') && <Chip size="small" label={`直近1to1 ${lastO2oAt}`} />}
                                    {flags.interested && <Chip size="small" color="primary" label="興味" />}
                                    {flags.want_1on1 && <Chip size="small" color="secondary" label="1to1希望" />}
                                    {leadRow && (
                                        <Chip size="small" label={religoOneToOneLeadStatusLabel(leadRow.one_to_one_status)} color={leadChipColor} />
                                    )}
                                </Stack>
                            </CardContent>
                        </Card>
                        {(record?.ncast_profile_url != null && String(record.ncast_profile_url).trim() !== '') && (
                            <Button
                                href={String(record.ncast_profile_url).trim()}
                                target="_blank"
                                rel="noopener noreferrer"
                                size="small"
                                variant="outlined"
                                sx={{ alignSelf: 'flex-start' }}
                            >
                                Nキャス 自己紹介を開く
                            </Button>
                        )}
                        {leadRow && (
                            <Button component={Link} to={`/one-to-ones/create?target_member_id=${id}`} size="small" variant="contained" color="secondary" sx={{ alignSelf: 'flex-start' }}>
                                1 to 1 を記録（フォーム）
                            </Button>
                        )}
                        {lastMemoBody && (
                            <Card variant="outlined">
                                <CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                                    <Typography variant="caption" color="text.secondary">直近メモ</Typography>
                                    <Typography variant="body2" sx={{ mt: 0.5, whiteSpace: 'pre-wrap' }}>{lastMemoBody}</Typography>
                                </CardContent>
                            </Card>
                        )}
                        <Button component={Link} to="/members" size="small" variant="outlined">Members 一覧でメモ・1to1を追加</Button>
                    </Stack>
                )}
            </Box>

            <Box role="tabpanel" hidden={tab !== 1} id="show-tabpanel-1">
                {tab === 1 && (
                    <Stack spacing={1} sx={{ mt: 2 }}>
                        {loadingMemos ? <Typography variant="body2" color="text.secondary">読込中…</Typography> : (
                            memos.length === 0
                                ? <Typography variant="body2" color="text.secondary">メモはまだありません</Typography>
                                : <Stack spacing={1}>{memos.map((m) => (
                                    <Card key={m.id} variant="outlined">
                                        <CardContent sx={{ py: 1, '&:last-child': { pb: 1 } }}>
                                            <Typography variant="caption" color="text.secondary">{m.memo_type} · {m.created_at ? new Date(m.created_at).toLocaleString('ja-JP') : ''}</Typography>
                                            <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap' }}>{(m.body || '').slice(0, 200)}{(m.body && m.body.length > 200) ? '…' : ''}</Typography>
                                        </CardContent>
                                    </Card>
                                ))}</Stack>
                        )}
                    </Stack>
                )}
            </Box>

            <Box role="tabpanel" hidden={tab !== 2} id="show-tabpanel-2">
                {tab === 2 && (
                    <Stack spacing={1} sx={{ mt: 2 }}>
                        {loadingO2o ? <Typography variant="body2" color="text.secondary">読込中…</Typography> : (
                            o2oList.length === 0
                                ? <Typography variant="body2" color="text.secondary">1to1はまだありません</Typography>
                                : <Stack spacing={1}>{o2oList.map((o) => (
                                    <Card key={o.id} variant="outlined">
                                        <CardContent sx={{ py: 1, '&:last-child': { pb: 1 } }}>
                                            <Typography variant="caption" color="text.secondary">{o.status} · {(o.scheduled_at || o.started_at) ? new Date(o.scheduled_at || o.started_at).toLocaleString('ja-JP') : '—'}</Typography>
                                            {o.notes && <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap' }}>{(o.notes || '').slice(0, 120)}{(o.notes && o.notes.length > 120) ? '…' : ''}</Typography>}
                                        </CardContent>
                                    </Card>
                                ))}</Stack>
                        )}
                    </Stack>
                )}
            </Box>
        </Box>
    );
}

function MemberShowActions() {
    return (
        <TopToolbar>
            <EditButton />
        </TopToolbar>
    );
}

export function MemberShow() {
    return (
        <Show
            actions={<MemberShowActions />}
            title={(r) => (r?.name ? `メンバー詳細 — ${r.name}` : 'メンバー詳細')}
        >
            <MemberDetailContent />
        </Show>
    );
}
