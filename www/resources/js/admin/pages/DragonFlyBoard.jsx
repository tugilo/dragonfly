import { useState, useEffect, useCallback, useRef } from 'react';
import { Box, Grid, TextField, Autocomplete, Card, CardContent, Typography, FormControlLabel, Switch } from '@mui/material';

const API = '';
const TOGGLE_DEBOUNCE_MS = 300;

async function fetchJson(url) {
    const res = await fetch(`${API}${url}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
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
    if (!res.ok) throw new Error(`PUT flags ${res.status}`);
    return res.json();
}

export default function DragonFlyBoard() {
    const [ownerMemberId, setOwnerMemberId] = useState(1);
    const [members, setMembers] = useState([]);
    const [targetMember, setTargetMember] = useState(null);
    const [summary, setSummary] = useState(null);
    const [loadingSummary, setLoadingSummary] = useState(false);
    const [pendingFlags, setPendingFlags] = useState(null);
    const debounceRef = useRef(null);

    useEffect(() => {
        fetchJson('/api/dragonfly/members')
            .then(setMembers)
            .catch((e) => console.error('members load failed', e));
    }, []);

    const loadSummary = useCallback(() => {
        if (!targetMember?.id || !ownerMemberId) return;
        setLoadingSummary(true);
        fetchJson(
            `/api/dragonfly/contacts/${targetMember.id}/summary?owner_member_id=${ownerMemberId}`
        )
            .then((s) => {
                setSummary(s);
                setPendingFlags(null);
            })
            .catch((e) => {
                console.error('summary load failed', e);
                setSummary(null);
                setPendingFlags(null);
            })
            .finally(() => setLoadingSummary(false));
    }, [targetMember?.id, ownerMemberId]);

    useEffect(() => {
        loadSummary();
    }, [loadSummary]);

    const handleToggle = (field, value) => {
        if (!targetMember?.id || !summary?.flags) return;
        const next = { ...summary.flags, [field]: value };
        setPendingFlags(next);

        if (debounceRef.current) clearTimeout(debounceRef.current);
        debounceRef.current = setTimeout(async () => {
            debounceRef.current = null;
            try {
                await putFlags(ownerMemberId, targetMember.id, {
                    interested: next.interested,
                    want_1on1: next.want_1on1,
                });
                loadSummary();
            } catch (e) {
                console.error('PUT flags failed', e);
                setPendingFlags(null);
            }
        }, TOGGLE_DEBOUNCE_MS);
    };

    const displayFlags = pendingFlags ?? summary?.flags ?? { interested: false, want_1on1: false };
    const latestMemos = summary?.latest_memos ?? [];
    const interestedReason = summary?.latest_interested_reason;

    return (
        <Box sx={{ p: 2 }}>
            <Typography variant="h6" sx={{ mb: 2 }}>
                DragonFly Board
            </Typography>
            <Grid container spacing={2}>
                <Grid item xs={12} md={4}>
                    <TextField
                        label="Owner member ID"
                        type="number"
                        size="small"
                        value={ownerMemberId}
                        onChange={(e) => setOwnerMemberId(Number(e.target.value) || 1)}
                        sx={{ mb: 1 }}
                    />
                    <Autocomplete
                        options={members}
                        getOptionLabel={(m) => `${m.display_no || ''} ${m.name}`.trim() || `#${m.id}`}
                        value={targetMember}
                        onChange={(_, v) => setTargetMember(v)}
                        renderInput={(params) => (
                            <TextField {...params} label="メンバーを選択" size="small" />
                        )}
                    />
                </Grid>
                <Grid item xs={12} md={8}>
                    {loadingSummary && <Typography color="text.secondary">Loading...</Typography>}
                    {!targetMember && !loadingSummary && (
                        <Typography color="text.secondary">左でメンバーを選択してください</Typography>
                    )}
                    {targetMember && summary && !loadingSummary && (
                        <Card variant="outlined">
                            <CardContent>
                                <Typography variant="subtitle1">
                                    {targetMember.display_no} {targetMember.name}
                                </Typography>
                                <Box sx={{ mt: 1 }}>
                                    <FormControlLabel
                                        control={
                                            <Switch
                                                checked={!!displayFlags.interested}
                                                onChange={(_, v) =>
                                                    handleToggle('interested', v)
                                                }
                                            />
                                        }
                                        label="気になる"
                                    />
                                    <FormControlLabel
                                        control={
                                            <Switch
                                                checked={!!displayFlags.want_1on1}
                                                onChange={(_, v) =>
                                                    handleToggle('want_1on1', v)
                                                }
                                            />
                                        }
                                        label="1on1 したい"
                                    />
                                </Box>
                                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                                    同室回数: {summary?.same_room_count ?? 0}
                                </Typography>
                                {interestedReason?.reason && (
                                    <Typography variant="body2" sx={{ mt: 1 }} color="text.secondary">
                                        気になる理由: {interestedReason.reason}
                                    </Typography>
                                )}
                                {latestMemos.length > 0 && (
                                    <Box sx={{ mt: 1 }}>
                                        <Typography variant="caption" color="text.secondary">
                                            メモ（直近{latestMemos.length}件）
                                        </Typography>
                                        {latestMemos.map((m) => (
                                            <Typography
                                                key={m.id}
                                                variant="body2"
                                                sx={{ display: 'block', mt: 0.5 }}
                                            >
                                                #{m.meeting_number}: {m.body || '(なし)'}
                                            </Typography>
                                        ))}
                                    </Box>
                                )}
                            </CardContent>
                        </Card>
                    )}
                </Grid>
            </Grid>
        </Box>
    );
}
