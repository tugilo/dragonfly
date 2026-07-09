import React, { useState, useEffect, useCallback } from 'react';
import {
    Box,
    Button,
    Card,
    CardContent,
    Container,
    FormControl,
    FormControlLabel,
    InputLabel,
    Link,
    MenuItem,
    Select,
    Stack,
    Switch,
    TextField,
    Snackbar,
    Alert,
    Typography,
    CircularProgress,
} from '@mui/material';
import { religoFetch } from '../religoApiFetch';
import { fetchReferralCorpusSettings, patchReferralCorpusSettings } from '../referralSuggestionApi';

const AI_PROVIDER_LABELS = { openai: 'OpenAI', anthropic: 'Claude (Anthropic)', google: 'Gemini (Google)' };

/** tugilo 式: 設定ページ内のセクション見出し */
function SettingsSection({ title, description, children }) {
    return (
        <Box component="section" sx={{ mb: 3 }}>
            <Typography component="h2" sx={{ fontSize: 15, fontWeight: 700, mb: 0.5 }}>
                {title}
            </Typography>
            {description ? (
                <Typography variant="body2" color="text.secondary" sx={{ mb: 1.5 }}>
                    {description}
                </Typography>
            ) : null}
            <Stack spacing={2}>{children}</Stack>
        </Box>
    );
}

function SettingsCard({ children }) {
    return (
        <Card variant="outlined" sx={{ borderRadius: '10px' }}>
            <CardContent>{children}</CardContent>
        </Card>
    );
}

/** AI 設定カード（SPEC-013・ユーザーごと BYO key）。 */
function AiSettingsCard({ notify }) {
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [aiEnabled, setAiEnabled] = useState(false);
    const [provider, setProvider] = useState('openai');
    const [model, setModel] = useState('');
    const [apiKey, setApiKey] = useState('');
    const [hasKey, setHasKey] = useState(false);
    const [providers, setProviders] = useState(['openai']);
    const [implemented, setImplemented] = useState(['openai']);
    const [availableModels, setAvailableModels] = useState({ openai: [] });
    const [defaultModel, setDefaultModel] = useState('gpt-4o-mini');
    const [testing, setTesting] = useState(false);
    const [credentialDecryptError, setCredentialDecryptError] = useState(false);

    const load = useCallback(async () => {
        setLoading(true);
        try {
            const res = await religoFetch('/api/ai/credentials', { headers: { Accept: 'application/json' } });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                notify(data.message || 'AI 設定の読み込みに失敗しました', 'error');
                return;
            }
            setCredentialDecryptError(Boolean(data.credential_decrypt_error));
            setAiEnabled(Boolean(data.ai_enabled));
            setProvider(data.provider || 'openai');
            setModel(data.model || '');
            setHasKey(Boolean(data.has_api_key));
            setProviders(Array.isArray(data.available_providers) ? data.available_providers : ['openai']);
            setImplemented(Array.isArray(data.implemented_providers) ? data.implemented_providers : ['openai']);
            setAvailableModels(
                data.available_models && typeof data.available_models === 'object' ? data.available_models : { openai: [] }
            );
            setDefaultModel(data.default_model || 'gpt-4o-mini');
        } catch {
            /* 未ログイン等 */
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        load();
    }, [load]);

    const save = async () => {
        setSaving(true);
        try {
            const body = { ai_enabled: aiEnabled, provider, model: model || null };
            if (apiKey.trim() !== '') body.api_key = apiKey.trim();
            const res = await religoFetch('/api/ai/credentials', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify(body),
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                notify(data.message || '保存に失敗しました', 'error');
                return;
            }
            setApiKey('');
            setHasKey(Boolean(data.has_api_key));
            setCredentialDecryptError(Boolean(data.credential_decrypt_error));
            notify('AI 設定を保存しました');
        } catch {
            notify('保存に失敗しました', 'error');
        } finally {
            setSaving(false);
        }
    };

    const test = async () => {
        setTesting(true);
        try {
            const res = await religoFetch('/api/ai/credentials/test', {
                method: 'POST',
                headers: { Accept: 'application/json' },
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok || !data.ok) {
                notify(data.message || '接続テストに失敗しました', 'error');
                return;
            }
            notify(`接続OK（${data.provider} / ${data.model}）${data.sample ? '：' + data.sample : ''}`);
        } catch {
            notify('接続テストに失敗しました', 'error');
        } finally {
            setTesting(false);
        }
    };

    const modelOptions = Array.isArray(availableModels[provider]) ? availableModels[provider] : [];
    const modelInList = model === '' || modelOptions.some((m) => m.id === model);

    if (loading) return null;

    return (
        <SettingsCard>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                    AI 利用は任意です。利用する場合はプロバイダを選び、ご自身の API キーを登録してください（キーは暗号化保存・各自の契約で課金）。
                </Typography>
                <FormControlLabel
                    control={<Switch checked={aiEnabled} onChange={(e) => setAiEnabled(e.target.checked)} />}
                    label="AI を利用する"
                    sx={{ mb: 1 }}
                />
                {credentialDecryptError && (
                    <Alert severity="warning" sx={{ mb: 2 }}>
                        保存済みの API キーを復号できません（別環境の DB をローカルで使っている可能性があります）。
                        API キーを再入力して保存してください。
                    </Alert>
                )}
                {aiEnabled && (
                    <>
                        <FormControl fullWidth size="small" sx={{ mb: 2 }}>
                            <InputLabel id="ai-provider-label">プロバイダ</InputLabel>
                            <Select
                                labelId="ai-provider-label"
                                label="プロバイダ"
                                value={provider}
                                onChange={(e) => {
                                    const next = String(e.target.value);
                                    setProvider(next);
                                    const nextOptions = Array.isArray(availableModels[next]) ? availableModels[next] : [];
                                    if (model !== '' && !nextOptions.some((m) => m.id === model)) {
                                        setModel('');
                                    }
                                }}
                            >
                                {providers.map((p) => (
                                    <MenuItem key={p} value={p} disabled={!implemented.includes(p)}>
                                        {AI_PROVIDER_LABELS[p] || p}
                                        {!implemented.includes(p) ? '（近日対応）' : ''}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        <FormControl fullWidth size="small" sx={{ mb: 2 }}>
                            <InputLabel id="ai-model-label">モデル</InputLabel>
                            <Select
                                labelId="ai-model-label"
                                label="モデル"
                                value={model}
                                onChange={(e) => setModel(String(e.target.value))}
                            >
                                <MenuItem value="">
                                    <em>既定（{defaultModel}）</em>
                                </MenuItem>
                                {modelOptions.map((m) => (
                                    <MenuItem key={m.id} value={m.id}>
                                        {m.label || m.id}
                                    </MenuItem>
                                ))}
                                {!modelInList && model !== '' && (
                                    <MenuItem value={model}>
                                        {model}（一覧外・保存済み）
                                    </MenuItem>
                                )}
                            </Select>
                        </FormControl>
                        <TextField
                            label={hasKey ? 'API キー（登録済み・変更時のみ入力）' : 'API キー'}
                            size="small"
                            fullWidth
                            type="password"
                            value={apiKey}
                            onChange={(e) => setApiKey(e.target.value)}
                            autoComplete="off"
                            placeholder={hasKey ? '••••••••（変更しない場合は空のまま）' : 'sk-...'}
                            sx={{ mb: 2 }}
                        />
                    </>
                )}
                <Button variant="contained" onClick={save} disabled={saving}>
                    {saving ? '保存中…' : 'AI 設定を保存'}
                </Button>
                {aiEnabled && (
                    <Button variant="outlined" onClick={test} disabled={testing || saving} sx={{ ml: 1 }}>
                        {testing ? 'テスト中…' : '接続テスト'}
                    </Button>
                )}
                {aiEnabled && (
                    <Typography variant="caption" color="text.secondary" display="block" sx={{ mt: 1 }}>
                        ※ 接続テストは「保存済み」のキー・モデルで実行します。変更したら先に保存してください。
                    </Typography>
                )}
        </SettingsCard>
    );
}

/** Zoom OAuth アプリ資格情報（SPEC-012 拡張・ユーザーごと BYO app credentials）。 */
function ZoomSettingsCard({ notify }) {
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [testing, setTesting] = useState(false);
    const [clientId, setClientId] = useState('');
    const [clientSecret, setClientSecret] = useState('');
    const [webhookSecret, setWebhookSecret] = useState('');
    const [hasClientSecret, setHasClientSecret] = useState(false);
    const [hasWebhookSecret, setHasWebhookSecret] = useState(false);
    const [redirectUri, setRedirectUri] = useState('');
    const [configured, setConfigured] = useState(false);
    const [credentialSource, setCredentialSource] = useState(null);
    const [credentialDecryptError, setCredentialDecryptError] = useState(false);

    const load = useCallback(async () => {
        setLoading(true);
        try {
            const res = await religoFetch('/api/zoom/credentials', { headers: { Accept: 'application/json' } });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                notify(data.message || 'Zoom 設定の読み込みに失敗しました', 'error');
                return;
            }
            setCredentialDecryptError(Boolean(data.credential_decrypt_error));
            setClientId(data.client_id || '');
            setHasClientSecret(Boolean(data.has_client_secret));
            setHasWebhookSecret(Boolean(data.has_webhook_secret));
            setRedirectUri(data.redirect_uri || '');
            setConfigured(Boolean(data.configured));
            setCredentialSource(data.credential_source || null);
        } catch {
            /* 未ログイン等 */
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        load();
    }, [load]);

    const save = async () => {
        setSaving(true);
        try {
            const body = { client_id: clientId.trim() || null };
            if (clientSecret.trim() !== '') body.client_secret = clientSecret.trim();
            if (webhookSecret.trim() !== '') body.webhook_secret_token = webhookSecret.trim();
            const res = await religoFetch('/api/zoom/credentials', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify(body),
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                notify(data.message || '保存に失敗しました', 'error');
                return;
            }
            setClientSecret('');
            setWebhookSecret('');
            setHasClientSecret(Boolean(data.has_client_secret));
            setHasWebhookSecret(Boolean(data.has_webhook_secret));
            setConfigured(Boolean(data.configured));
            setCredentialSource(data.credential_source || null);
            setCredentialDecryptError(Boolean(data.credential_decrypt_error));
            notify('Zoom 資格情報を保存しました');
        } catch {
            notify('保存に失敗しました', 'error');
        } finally {
            setSaving(false);
        }
    };

    const test = async () => {
        setTesting(true);
        try {
            const res = await religoFetch('/api/zoom/credentials/test', {
                method: 'POST',
                headers: { Accept: 'application/json' },
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok || !data.ok) {
                notify(data.message || '接続テストに失敗しました', 'error');
                return;
            }
            notify(data.message || 'Zoom 資格情報の疎通に成功しました');
        } catch {
            notify('接続テストに失敗しました', 'error');
        } finally {
            setTesting(false);
        }
    };

    if (loading) return null;

    return (
        <SettingsCard>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                    Zoom Marketplace で作成した OAuth アプリの Client ID / Secret を登録してください（Secret は暗号化保存）。
                    登録後、<Link href="#/zoom-import">Zoom 取り込み画面</Link>から OAuth 連携を行います。
                </Typography>
                {redirectUri && (
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                        Zoom アプリに登録する Redirect URI: <Typography component="code" variant="body2">{redirectUri}</Typography>
                    </Typography>
                )}
                {!redirectUri && (
                    <Alert severity="warning" sx={{ mb: 2 }}>
                        ZOOM_REDIRECT_URI が未設定です。管理者にサーバー設定を依頼してください。
                    </Alert>
                )}
                {credentialDecryptError && (
                    <Alert severity="warning" sx={{ mb: 2 }}>
                        保存済みの Client Secret / Webhook Secret を復号できません（別環境の DB の可能性があります）。
                        Secret を再入力して保存してください。
                    </Alert>
                )}
                {credentialSource === 'env' && !hasClientSecret && (
                    <Alert severity="info" sx={{ mb: 2 }}>
                        現在はサーバー共通の Zoom 資格情報（.env）が使われています。ここで登録すると自分専用のアプリに切り替わります。
                    </Alert>
                )}
                <TextField
                    label="Client ID"
                    size="small"
                    fullWidth
                    value={clientId}
                    onChange={(e) => setClientId(e.target.value)}
                    autoComplete="off"
                    sx={{ mb: 2 }}
                />
                <TextField
                    label={hasClientSecret ? 'Client Secret（登録済み・変更時のみ入力）' : 'Client Secret'}
                    size="small"
                    fullWidth
                    type="password"
                    value={clientSecret}
                    onChange={(e) => setClientSecret(e.target.value)}
                    autoComplete="off"
                    placeholder={hasClientSecret ? '••••••••' : ''}
                    sx={{ mb: 2 }}
                />
                <TextField
                    label={hasWebhookSecret ? 'Webhook Secret Token（登録済み・変更時のみ入力）' : 'Webhook Secret Token（任意）'}
                    size="small"
                    fullWidth
                    type="password"
                    value={webhookSecret}
                    onChange={(e) => setWebhookSecret(e.target.value)}
                    autoComplete="off"
                    placeholder={hasWebhookSecret ? '••••••••' : ''}
                    helperText="Webhook を使う場合のみ。Zoom アプリの Event Subscriptions で設定した Secret Token。"
                    sx={{ mb: 2 }}
                />
                <Button variant="contained" onClick={save} disabled={saving}>
                    {saving ? '保存中…' : 'Zoom 資格情報を保存'}
                </Button>
                <Button variant="outlined" onClick={test} disabled={testing || saving || !hasClientSecret} sx={{ ml: 1 }}>
                    {testing ? 'テスト中…' : '接続テスト'}
                </Button>
                {configured && (
                    <Typography variant="caption" color="text.secondary" display="block" sx={{ mt: 1 }}>
                        状態: {credentialSource === 'user' ? '自分の資格情報で利用可能' : credentialSource === 'env' ? 'サーバー共通設定で利用可能' : '未設定'}
                    </Typography>
                )}
        </SettingsCard>
    );
}

/** Phase 195: 横断コーパス共有（§0.7 Givers Gain）。 */
function ReferralCorpusSettingsCard({ notify }) {
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [allow, setAllow] = useState(false);
    const [peerCount, setPeerCount] = useState(0);

    const load = useCallback(async () => {
        setLoading(true);
        try {
            const data = await fetchReferralCorpusSettings();
            setAllow(Boolean(data.allow_cross_corpus_contribution));
            setPeerCount(Number(data.consented_peer_count) || 0);
        } catch {
            /* ignore */
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        load();
    }, [load]);

    const save = async () => {
        setSaving(true);
        try {
            const data = await patchReferralCorpusSettings({ allow_cross_corpus_contribution: allow });
            setAllow(Boolean(data.allow_cross_corpus_contribution));
            setPeerCount(Number(data.consented_peer_count) || 0);
            notify('リファーラル横断共有の設定を保存しました');
        } catch (e) {
            notify(e.message || '保存に失敗しました', 'error');
        } finally {
            setSaving(false);
        }
    };

    if (loading) return null;

    return (
        <SettingsCard>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                    ON にすると、あなたの 1 to 1 議事録（completed）が、他メンバーの「つなぎ手経由」リファーラル提案の材料になります。
                    他者の 121 を自分の提案に含めたい場合は、章内の他メンバーがここを ON にする必要があります（Givers Gain）。
                </Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                    現在、章内で共有 ON の他メンバー: {peerCount} 名
                </Typography>
                <FormControlLabel
                    control={<Switch checked={allow} onChange={(e) => setAllow(e.target.checked)} />}
                    label="他メンバーのリファーラル提案に、自分の 1 to 1 記録を使ってよい"
                    sx={{ mb: 1, display: 'block' }}
                />
                <Button variant="contained" onClick={save} disabled={saving}>
                    {saving ? '保存中…' : '共有設定を保存'}
                </Button>
        </SettingsCard>
    );
}

const RELIGO_WORKSPACE_CHANGED = 'religo-workspace-changed';

async function fetchJson(url, options = {}) {
    const res = await religoFetch(url, { headers: { Accept: 'application/json', ...options.headers }, ...options });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

/**
 * 個人設定ハブ（tugilo 式）。所属チャプター・リファーラル共有・AI・Zoom を 1 ページに集約。
 * GET /api/workspaces + GET/PATCH /api/users/me
 */
export default function ReligoSettings() {
    const [loading, setLoading] = useState(true);
    const [workspaces, setWorkspaces] = useState([]);
    const [selectedId, setSelectedId] = useState('');
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState('');
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'success' });

    const load = useCallback(async () => {
        setLoading(true);
        setError('');
        try {
            const [me, rows] = await Promise.all([
                fetchJson('/api/users/me'),
                fetchJson('/api/workspaces'),
            ]);
            const list = Array.isArray(rows) ? rows : [];
            setWorkspaces(list);
            const initial = me.workspace_id != null ? String(me.workspace_id) : '';
            setSelectedId(initial);
        } catch (e) {
            setError('設定の読み込みに失敗しました。');
            setWorkspaces([]);
            setSelectedId('');
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        load();
    }, [load]);

    const handleSave = async () => {
        const id = selectedId === '' ? null : Number(selectedId);
        if (id == null || !Number.isInteger(id)) {
            setSnack({ open: true, message: 'チャプターを選択してください。', severity: 'warning' });
            return;
        }
        setSaving(true);
        setError('');
        try {
            const res = await religoFetch('/api/users/me', {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify({ default_workspace_id: id }),
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                setSnack({ open: true, message: data.message || '保存に失敗しました', severity: 'error' });
                return;
            }
            if (data.workspace_id != null) {
                setSelectedId(String(data.workspace_id));
            }
            window.dispatchEvent(new CustomEvent(RELIGO_WORKSPACE_CHANGED));
            setSnack({ open: true, message: '所属チャプターを保存しました。', severity: 'success' });
        } catch {
            setSnack({ open: true, message: '保存に失敗しました', severity: 'error' });
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <Container maxWidth="sm" sx={{ py: 4, display: 'flex', justifyContent: 'center' }}>
                <CircularProgress size={28} />
            </Container>
        );
    }

    return (
        <Container maxWidth="md" sx={{ py: 2 }}>
            <Typography component="h1" sx={{ fontSize: 21, fontWeight: 700, mb: 0.5 }}>
                設定
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
                ログイン中のあなた（Owner）に紐づく個人設定です。所属チャプター・AI・Zoom・リファーラル共有をここで管理します。
            </Typography>

            <SettingsSection
                title="アカウント"
                description="BNI の所属チャプターに相当する workspace を選択します（1 user = 1 workspace）。"
            >
                <SettingsCard>
                    <Typography sx={{ fontWeight: 600, mb: 0.5 }}>所属チャプター</Typography>
                    {workspaces.length === 0 ? (
                        <Typography color="error" variant="body2">
                            登録されている workspace がありません。管理者に連絡してください。
                        </Typography>
                    ) : (
                        <>
                            <FormControl fullWidth size="small" sx={{ mb: 2 }}>
                                <InputLabel id="chapter-select-label">チャプター</InputLabel>
                                <Select
                                    labelId="chapter-select-label"
                                    label="チャプター"
                                    value={selectedId}
                                    onChange={(e) => setSelectedId(String(e.target.value))}
                                    disabled={saving}
                                    required
                                    displayEmpty
                                >
                                    <MenuItem value="" disabled>
                                        <em>選択してください</em>
                                    </MenuItem>
                                    {workspaces.map((w) => (
                                        <MenuItem key={w.id} value={String(w.id)}>
                                            {w.name}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                            {error && (
                                <Typography color="error" variant="body2" sx={{ mb: 1 }}>
                                    {error}
                                </Typography>
                            )}
                            <Button
                                variant="contained"
                                size="medium"
                                onClick={handleSave}
                                disabled={saving || selectedId === ''}
                            >
                                {saving ? '保存中…' : '所属チャプターを保存'}
                            </Button>
                        </>
                    )}
                </SettingsCard>
            </SettingsSection>

            <SettingsSection
                title="リファーラル提案"
                description="章内の横断マッチング（つなぎ手経由）に、自分の 121 記録を貢献するかどうか。"
            >
                <ReferralCorpusSettingsCard notify={(message, severity = 'success') => setSnack({ open: true, message, severity })} />
            </SettingsSection>

            <SettingsSection
                title="AI 連携"
                description="1 to 1 事前準備・リファーラル提案など。API キーは暗号化保存し、各自の契約で課金されます。"
            >
                <AiSettingsCard notify={(message, severity = 'success') => setSnack({ open: true, message, severity })} />
            </SettingsSection>

            <SettingsSection
                title="Zoom 連携"
                description="1 to 1 の Zoom 取り込み用 OAuth アプリ資格情報。登録後は Zoom 取り込み画面から連携します。"
            >
                <ZoomSettingsCard notify={(message, severity = 'success') => setSnack({ open: true, message, severity })} />
            </SettingsSection>

            <Snackbar
                open={snack.open}
                autoHideDuration={4000}
                onClose={() => setSnack((s) => ({ ...s, open: false }))}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
            >
                <Alert severity={snack.severity} onClose={() => setSnack((s) => ({ ...s, open: false }))} variant="filled">
                    {snack.message}
                </Alert>
            </Snackbar>
        </Container>
    );
}
