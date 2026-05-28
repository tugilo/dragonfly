import React, { useState } from 'react';
import { useLogin } from 'react-admin';
import {
    Alert,
    Box,
    Button,
    Link,
    Paper,
    Tab,
    Tabs,
    TextField,
    Typography,
} from '@mui/material';
import { completeReligoRegistration, requestReligoRegistration } from '../religoApiFetch';

function LoginForm() {
    const login = useLogin();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(false);

    const submit = async (e) => {
        e.preventDefault();
        setError(null);
        setLoading(true);
        try {
            await login({ username: email, password });
        } catch (err) {
            setError(err instanceof Error ? err.message : 'ログインに失敗しました');
        } finally {
            setLoading(false);
        }
    };

    return (
        <>
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
        </>
    );
}

function RegisterForm() {
    const login = useLogin();
    const [step, setStep] = useState('email');
    const [email, setEmail] = useState('');
    const [code, setCode] = useState('');
    const [password, setPassword] = useState('');
    const [passwordConfirmation, setPasswordConfirmation] = useState('');
    const [debugCode, setDebugCode] = useState(null);
    const [info, setInfo] = useState(null);
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(false);

    const requestCode = async (e) => {
        e.preventDefault();
        setError(null);
        setInfo(null);
        setDebugCode(null);
        setLoading(true);
        try {
            const data = await requestReligoRegistration(email);
            setInfo(data.message);
            if (data.debug_code) {
                setDebugCode(data.debug_code);
                setCode(data.debug_code);
            }
            setStep('verify');
        } catch (err) {
            setError(err instanceof Error ? err.message : '確認コードの送信に失敗しました');
        } finally {
            setLoading(false);
        }
    };

    const complete = async (e) => {
        e.preventDefault();
        setError(null);
        setLoading(true);
        try {
            await completeReligoRegistration(email, code, password, passwordConfirmation);
            await login({ username: email, password });
        } catch (err) {
            setError(err instanceof Error ? err.message : 'アカウント作成に失敗しました');
        } finally {
            setLoading(false);
        }
    };

    if (step === 'email') {
        return (
            <>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                    Members に登録済みのメールアドレスで初回パスワードを設定します。
                </Typography>
                {error && (
                    <Alert severity="error" sx={{ mb: 2 }}>
                        {error}
                    </Alert>
                )}
                <Box component="form" onSubmit={requestCode} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                    <TextField
                        label="メールアドレス"
                        type="email"
                        value={email}
                        onChange={(ev) => setEmail(ev.target.value)}
                        autoComplete="email"
                        required
                        fullWidth
                        size="small"
                    />
                    <Button type="submit" variant="contained" disabled={loading}>
                        {loading ? '送信中…' : '確認コードを取得'}
                    </Button>
                </Box>
            </>
        );
    }

    return (
        <>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                {email} 宛に確認コードを送信しました。
            </Typography>
            <Link component="button" type="button" variant="body2" onClick={() => setStep('email')} sx={{ mb: 2, display: 'inline-block' }}>
                メールアドレスを変更
            </Link>
            {info && (
                <Alert severity="info" sx={{ mb: 2 }}>
                    {info}
                </Alert>
            )}
            {debugCode && (
                <Alert severity="warning" sx={{ mb: 2 }}>
                    ローカル確認用コード: <strong>{debugCode}</strong>
                </Alert>
            )}
            {error && (
                <Alert severity="error" sx={{ mb: 2 }}>
                    {error}
                </Alert>
            )}
            <Box component="form" onSubmit={complete} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                <TextField
                    label="確認コード（6桁）"
                    value={code}
                    onChange={(ev) => setCode(ev.target.value)}
                    inputProps={{ inputMode: 'numeric', pattern: '[0-9]*', maxLength: 6 }}
                    required
                    fullWidth
                    size="small"
                />
                <TextField
                    label="パスワード（8文字以上）"
                    type="password"
                    value={password}
                    onChange={(ev) => setPassword(ev.target.value)}
                    autoComplete="new-password"
                    required
                    fullWidth
                    size="small"
                />
                <TextField
                    label="パスワード（確認）"
                    type="password"
                    value={passwordConfirmation}
                    onChange={(ev) => setPasswordConfirmation(ev.target.value)}
                    autoComplete="new-password"
                    required
                    fullWidth
                    size="small"
                />
                <Button type="submit" variant="contained" disabled={loading}>
                    {loading ? '作成中…' : 'アカウントを作成してログイン'}
                </Button>
            </Box>
        </>
    );
}

/**
 * ログイン / 初回アカウント作成（members.email 照合・SPEC-010 §7.2）
 */
export function ReligoLogin() {
    const [tab, setTab] = useState('login');

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
            <Paper elevation={2} sx={{ maxWidth: 420, width: '100%', p: 3 }}>
                <Typography variant="h6" sx={{ mb: 2, fontWeight: 600 }}>
                    Religo
                </Typography>
                <Tabs
                    value={tab}
                    onChange={(_e, value) => setTab(value)}
                    sx={{ mb: 2, minHeight: 36 }}
                    variant="fullWidth"
                >
                    <Tab label="ログイン" value="login" sx={{ minHeight: 36, py: 0.5 }} />
                    <Tab label="初回登録" value="register" sx={{ minHeight: 36, py: 0.5 }} />
                </Tabs>
                {tab === 'login' ? <LoginForm /> : <RegisterForm />}
            </Paper>
        </Box>
    );
}
