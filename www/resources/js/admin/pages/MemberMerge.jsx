import React, { useState, useCallback } from 'react';
import {
    Box,
    Button,
    Container,
    TextField,
    Typography,
    Alert,
    Paper,
    Stack,
    Snackbar,
} from '@mui/material';

const LS_TOKEN_KEY = 'religo-member-merge-token';

async function postMerge(path, body, token) {
    const res = await fetch(`/api/admin/member-merge/${path}`, {
        method: 'POST',
        headers: {
            Accept: 'application/json',
            'Content-Type': 'application/json',
            'X-Religo-Member-Merge-Token': token,
        },
        body: JSON.stringify(body),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        const msg = data.message || `HTTP ${res.status}`;
        throw new Error(msg);
    }
    return data;
}

/**
 * 管理者向け member マージ補助（トークン + 手動確認）。SPEC-008 / MEMBERS-MERGE-ASSIST-P1。
 * トークンはサーバの RELIGO_MEMBER_MERGE_TOKEN と一致させる。
 */
export default function MemberMerge() {
    const [token, setToken] = useState(() => (typeof localStorage !== 'undefined' ? localStorage.getItem(LS_TOKEN_KEY) || '' : ''));
    const [canonicalId, setCanonicalId] = useState('');
    const [mergeId, setMergeId] = useState('');
    const [previewJson, setPreviewJson] = useState(null);
    const [loading, setLoading] = useState(false);
    const [confirmPhrase, setConfirmPhrase] = useState('');
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'success' });

    const saveToken = useCallback((t) => {
        setToken(t);
        try {
            localStorage.setItem(LS_TOKEN_KEY, t);
        } catch {
            /* ignore */
        }
    }, []);

    const runPreview = async () => {
        setPreviewJson(null);
        if (!token.trim()) {
            setSnack({ open: true, message: 'マージ用トークンを入力してください。', severity: 'warning' });
            return;
        }
        const c = parseInt(canonicalId, 10);
        const m = parseInt(mergeId, 10);
        if (!Number.isInteger(c) || !Number.isInteger(m) || c < 1 || m < 1) {
            setSnack({ open: true, message: 'canonical / merge は正の整数で入力してください。', severity: 'warning' });
            return;
        }
        setLoading(true);
        try {
            const data = await postMerge(
                'preview',
                { canonical_member_id: c, merge_member_id: m },
                token.trim()
            );
            setPreviewJson(data);
            setConfirmPhrase(`MERGE ${m} INTO ${c}`);
            if (data.blocked) {
                setSnack({ open: true, message: 'プレビュー: ブロック条件あり（詳細を確認）。', severity: 'warning' });
            } else {
                setSnack({ open: true, message: 'プレビュー取得しました。内容を確認してから実行してください。', severity: 'success' });
            }
        } catch (e) {
            setSnack({ open: true, message: e.message || 'プレビュー失敗', severity: 'error' });
        } finally {
            setLoading(false);
        }
    };

    const runExecute = async () => {
        if (!previewJson || previewJson.blocked) {
            setSnack({ open: true, message: 'ブロックされているかプレビューがありません。', severity: 'warning' });
            return;
        }
        if (!token.trim()) {
            setSnack({ open: true, message: 'トークンを入力してください。', severity: 'warning' });
            return;
        }
        const c = parseInt(canonicalId, 10);
        const m = parseInt(mergeId, 10);
        setLoading(true);
        try {
            await postMerge(
                'execute',
                {
                    canonical_member_id: c,
                    merge_member_id: m,
                    confirm_phrase: confirmPhrase.trim(),
                },
                token.trim()
            );
            setSnack({ open: true, message: 'マージが完了しました。', severity: 'success' });
            setPreviewJson(null);
            setMergeId('');
        } catch (e) {
            setSnack({ open: true, message: e.message || '実行失敗', severity: 'error' });
        } finally {
            setLoading(false);
        }
    };

    return (
        <Container maxWidth="md" sx={{ py: 3 }}>
            <Typography variant="h5" sx={{ fontWeight: 700, mb: 1 }}>
                Member マージ（管理者）
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                同一人物の重複レコードを、残す ID（canonical）に寄せます。破壊的処理のためトークンと確認フレーズが必要です。
            </Typography>

            <Alert severity="warning" sx={{ mb: 2 }}>
                実行前に DB バックアップを推奨します。同一例会に両方の participants がある場合は自動マージできません。
            </Alert>

            <Paper sx={{ p: 2, mb: 2 }}>
                <Stack spacing={2}>
                    <TextField
                        label="X-Religo-Member-Merge-Token（サーバの RELIGO_MEMBER_MERGE_TOKEN）"
                        type="password"
                        fullWidth
                        size="small"
                        value={token}
                        onChange={(e) => saveToken(e.target.value)}
                        autoComplete="off"
                    />
                    <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2}>
                        <TextField
                            label="残す member_id（canonical）"
                            fullWidth
                            size="small"
                            value={canonicalId}
                            onChange={(e) => setCanonicalId(e.target.value)}
                            inputMode="numeric"
                        />
                        <TextField
                            label="統合して削除する member_id（merge）"
                            fullWidth
                            size="small"
                            value={mergeId}
                            onChange={(e) => setMergeId(e.target.value)}
                            inputMode="numeric"
                        />
                    </Stack>
                    <Button variant="outlined" onClick={runPreview} disabled={loading}>
                        プレビュー
                    </Button>
                </Stack>
            </Paper>

            {previewJson && (
                <Paper sx={{ p: 2, mb: 2 }}>
                    <Typography variant="subtitle2" sx={{ fontWeight: 700, mb: 1 }}>
                        プレビュー結果
                    </Typography>
                    {previewJson.blocked ? (
                        <Alert severity="error" sx={{ mb: 1 }}>
                            {previewJson.block_reasons?.join(' ') || 'ブロックされています。'}
                        </Alert>
                    ) : (
                        <Alert severity="info" sx={{ mb: 1 }}>
                            ブロックなし。実行時は merge 側の行が削除され、参照は canonical に付け替わります。
                        </Alert>
                    )}
                    {Array.isArray(previewJson.warnings) && previewJson.warnings.length > 0 ? (
                        <Alert severity="warning" sx={{ mb: 1 }}>
                            {previewJson.warnings.join(' ')}
                        </Alert>
                    ) : null}
                    <Box
                        component="pre"
                        sx={{
                            p: 1.5,
                            bgcolor: 'grey.100',
                            borderRadius: 1,
                            fontSize: 12,
                            overflow: 'auto',
                            maxHeight: 360,
                        }}
                    >
                        {JSON.stringify(previewJson, null, 2)}
                    </Box>
                    {!previewJson.blocked && (
                        <Stack spacing={1} sx={{ mt: 2 }}>
                            <TextField
                                label="確認フレーズ（そのまま実行時に送信）"
                                fullWidth
                                size="small"
                                value={confirmPhrase}
                                onChange={(e) => setConfirmPhrase(e.target.value)}
                                helperText="例: MERGE 12 INTO 5（merge を canonical に統合）"
                            />
                            <Button variant="contained" color="error" onClick={runExecute} disabled={loading}>
                                実行（不可逆）
                            </Button>
                        </Stack>
                    )}
                </Paper>
            )}

            <Snackbar
                open={snack.open}
                autoHideDuration={6000}
                onClose={() => setSnack((s) => ({ ...s, open: false }))}
                message={snack.message}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
            />
        </Container>
    );
}
