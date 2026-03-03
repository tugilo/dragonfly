import { useState, useEffect, useCallback } from 'react';
import { Box, Grid, TextField, Autocomplete, Card, CardContent, Typography, FormControlLabel, Switch } from '@mui/material';

const API = '';

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
    const [loading, setLoading] = useState(false);
    const [loadingSummary, setLoadingSummary] = useState(false);

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
            .then(setSummary)
            .catch((e) => {
                console.error('summary load failed', e);
                setSummary(null);
            })
            .finally(() => setLoadingSummary(false));
    }, [targetMember?.id, ownerMemberId]);

    useEffect(() => {
        loadSummary();
    }, [loadSummary]);

    const handleToggle = async (field, value) => {
        if (!targetMember?.id) return;
        setLoading(true);
        try {
            await putFlags(ownerMemberId, targetMember.id, { [field]: value });
            loadSummary();
        } catch (e) {
            console.error('PUT flags failed', e);
        } finally {
            setLoading(false);
        }
    };

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
                                                checked={!!summary?.flags?.interested}
                                                disabled={loading}
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
                                                checked={!!summary?.flags?.want_1on1}
                                                disabled={loading}
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
                            </CardContent>
                        </Card>
                    )}
                </Grid>
            </Grid>
        </Box>
    );
}
