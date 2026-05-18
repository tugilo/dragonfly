import React, { useState } from 'react';
import { Box, Button, Paper, TextField, Typography, Alert } from '@mui/material';
import { loginReligo } from '../religoApiFetch';

/**
 * Sanctum ログイン（トークンを localStorage に保存し / へリダイレクト）
 */
export function ReligoLogin() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(false);

    const submit = async (e) => {
        e.preventDefault();
        setError(null);
        setLoading(true);
        try {
            await loginReligo(email, password);
            window.location.assign('/');
        } catch (err) {
            setError(err instanceof Error ? err.message : 'ログインに失敗しました');
        } finally {
            setLoading(false);
        }
    };

    return (
        <Box
            sx={{
                minHeight: '100vh',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                backgroundColor: '#f5f7fa',
                p: 2,
            }}
        >
            <Paper elevation={2} sx={{ maxWidth: 400, width: '100%', p: 3 }}>
                <Typography variant="h6" sx={{ mb: 2, fontWeight: 600 }}>
                    Religo にログイン
                </Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                    メールアドレスとパスワードでサインインします（SPEC-010・Sanctum）。
                </Typography>
                {error && (
                    <Alert severity="error" sx={{ mb: 2 }}>
                        {error}
                    </Alert>
                )}
                <Box component="form" onSubmit={submit} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                    <TextField
                        label="メールアドレス"
                        type="email"
                        value={email}
                        onChange={(ev) => setEmail(ev.target.value)}
                        autoComplete="username"
                        required
                        fullWidth
                        size="small"
                    />
                    <TextField
                        label="パスワード"
                        type="password"
                        value={password}
                        onChange={(ev) => setPassword(ev.target.value)}
                        autoComplete="current-password"
                        required
                        fullWidth
                        size="small"
                    />
                    <Button type="submit" variant="contained" disabled={loading} sx={{ mt: 1 }}>
                        {loading ? 'ログイン中…' : 'ログイン'}
                    </Button>
                </Box>
            </Paper>
        </Box>
    );
}
