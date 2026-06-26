import React, { useCallback, useEffect, useState } from 'react';
import {
    Alert,
    Box,
    Button,
    Card,
    CardContent,
    Container,
    FormControl,
    InputLabel,
    MenuItem,
    Select,
    Snackbar,
    Stack,
    TextField,
    Typography,
} from '@mui/material';
import { useSonaeChapter } from '../../sonae/SonaeChapterContext';
import { fetchSonaeLineAccount, updateSonaeLineAccount } from '../../sonae/sonaeApi';

export default function SonaeLinePage() {
    const { chapterId } = useSonaeChapter();
    const [account, setAccount] = useState(null);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [form, setForm] = useState({
        channel_id: '',
        channel_secret: '',
        messaging_api_access_token: '',
        friend_add_url: '',
        status: 'inactive',
    });
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'info' });

    const notify = (message, severity = 'info') => setSnack({ open: true, message, severity });

    const load = useCallback(async () => {
        if (chapterId == null) return;
        setLoading(true);
        try {
            const data = await fetchSonaeLineAccount(chapterId);
            setAccount(data);
            setForm((f) => ({
                ...f,
                channel_id: data.channel_id ?? '',
                friend_add_url: data.friend_add_url ?? '',
                status: data.status ?? 'inactive',
                channel_secret: '',
                messaging_api_access_token: '',
            }));
        } catch (e) {
            notify(e instanceof Error ? e.message : '読み込みに失敗しました', 'error');
        } finally {
            setLoading(false);
        }
    }, [chapterId]);

    useEffect(() => {
        load();
    }, [load]);

    const save = async () => {
        setSaving(true);
        try {
            const body = {
                channel_id: form.channel_id,
                friend_add_url: form.friend_add_url || null,
                status: form.status,
            };
            if (form.channel_secret.trim() !== '') body.channel_secret = form.channel_secret.trim();
            if (form.messaging_api_access_token.trim() !== '') {
                body.messaging_api_access_token = form.messaging_api_access_token.trim();
            }
            const data = await updateSonaeLineAccount(chapterId, body);
            setAccount(data);
            setForm((f) => ({ ...f, channel_secret: '', messaging_api_access_token: '' }));
            notify('LINE 設定を保存しました', 'success');
        } catch (e) {
            notify(e instanceof Error ? e.message : '保存に失敗しました', 'error');
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <Container sx={{ py: 3 }}>
                <Typography>読み込み中…</Typography>
            </Container>
        );
    }

    return (
        <Container maxWidth="md" sx={{ py: 3 }}>
            <Typography variant="h5" gutterBottom>
                SONAE LINE 設定
            </Typography>

            <Card variant="outlined" sx={{ mb: 2 }}>
                <CardContent>
                    <Typography variant="subtitle2" color="text.secondary">
                        Webhook URL（LINE Developers に登録）
                    </Typography>
                    <Typography variant="body2" sx={{ fontFamily: 'monospace', wordBreak: 'break-all' }}>
                        {account?.webhook_url ?? '—'}
                    </Typography>
                    {account?.has_usable_credentials ? (
                        <Alert severity="success" sx={{ mt: 2 }}>
                            Push 送信可能な設定です
                        </Alert>
                    ) : (
                        <Alert severity="warning" sx={{ mt: 2 }}>
                            Channel ID と Messaging API トークンを設定してください
                        </Alert>
                    )}
                </CardContent>
            </Card>

            <Stack spacing={2} component={Card} variant="outlined" sx={{ p: 2 }}>
                <TextField
                    label="Channel ID"
                    value={form.channel_id}
                    onChange={(e) => setForm((f) => ({ ...f, channel_id: e.target.value }))}
                    fullWidth
                />
                <TextField
                    label="Channel Secret（変更時のみ入力）"
                    type="password"
                    value={form.channel_secret}
                    onChange={(e) => setForm((f) => ({ ...f, channel_secret: e.target.value }))}
                    helperText={account?.channel_secret_set ? '設定済み（空欄のままなら変更しません）' : '未設定'}
                    fullWidth
                />
                <TextField
                    label="Messaging API Access Token（変更時のみ入力）"
                    type="password"
                    value={form.messaging_api_access_token}
                    onChange={(e) => setForm((f) => ({ ...f, messaging_api_access_token: e.target.value }))}
                    helperText={account?.access_token_set ? '設定済み' : '未設定'}
                    fullWidth
                />
                <TextField
                    label="友だち追加 URL"
                    value={form.friend_add_url}
                    onChange={(e) => setForm((f) => ({ ...f, friend_add_url: e.target.value }))}
                    fullWidth
                />
                <FormControl fullWidth>
                    <InputLabel id="sonae-line-status">ステータス</InputLabel>
                    <Select
                        labelId="sonae-line-status"
                        label="ステータス"
                        value={form.status}
                        onChange={(e) => setForm((f) => ({ ...f, status: e.target.value }))}
                    >
                        <MenuItem value="active">active</MenuItem>
                        <MenuItem value="inactive">inactive</MenuItem>
                    </Select>
                </FormControl>
                <Box>
                    <Button variant="contained" disabled={saving} onClick={save}>
                        保存
                    </Button>
                </Box>
            </Stack>

            <Snackbar open={snack.open} autoHideDuration={5000} onClose={() => setSnack((s) => ({ ...s, open: false }))}>
                <Alert severity={snack.severity}>{snack.message}</Alert>
            </Snackbar>
        </Container>
    );
}
