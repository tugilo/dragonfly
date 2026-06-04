import React, { useState, useCallback, useEffect, useMemo } from 'react';
import {
    Box,
    Button,
    Container,
    Typography,
    Alert,
    Paper,
    Stack,
    Snackbar,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    Checkbox,
    Chip,
    TextField,
    CircularProgress,
    Divider,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    List,
    ListItemButton,
    ListItemText,
    Link,
} from '@mui/material';
import { religoFetch } from '../religoApiFetch';

const MEMBER_TYPE_CHOICES = [
    { id: 'guest', name: 'ゲスト（他チャプター/来訪・既定）' },
    { id: 'visitor', name: 'ビジター' },
    { id: 'member', name: 'メンバー' },
    { id: 'active', name: '在籍（active）' },
];

/**
 * 相手選択ダイアログ。開くと推定名で候補を即フィルタ表示し、タップで選択。
 * 未登録なら「新規登録」フォームに切替（同名は重複ガード）。
 */
function CounterpartPickerDialog({ open, row, members, workspaces, onClose, onPick, onCreate }) {
    const [query, setQuery] = useState('');
    const [mode, setMode] = useState('search');
    const [name, setName] = useState('');
    const [kana, setKana] = useState('');
    const [type, setType] = useState('guest');
    const [workspaceId, setWorkspaceId] = useState('');
    const [duplicates, setDuplicates] = useState([]);
    const [busy, setBusy] = useState(false);

    useEffect(() => {
        if (open && row) {
            const guessed = row.counterpart_name || '';
            setQuery(guessed);
            setName(guessed);
            setKana('');
            setType('guest');
            setWorkspaceId('');
            setDuplicates([]);
            setMode('search');
        }
    }, [open, row]);

    const filtered = useMemo(() => {
        const q = query.trim().toLowerCase();
        const list = Array.isArray(members) ? members : [];
        if (q === '') return list.slice(0, 50);
        return list
            .filter((m) => `${m.name || ''} ${m.name_kana || ''}`.toLowerCase().includes(q))
            .slice(0, 50);
    }, [members, query]);

    const submitCreate = async (force) => {
        const nm = name.trim();
        if (nm === '') return;
        setBusy(true);
        try {
            const result = await onCreate(row, {
                name: nm,
                name_kana: kana.trim() || null,
                type,
                workspace_id: workspaceId === '' ? null : Number(workspaceId),
                force: Boolean(force),
            });
            if (result && result.created === false && Array.isArray(result.duplicates) && result.duplicates.length > 0) {
                setDuplicates(result.duplicates);
                return;
            }
            onClose();
        } finally {
            setBusy(false);
        }
    };

    if (!row) return null;

    return (
        <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
            <DialogTitle>
                相手を選択 / 登録
                <Typography variant="caption" color="text.secondary" display="block">
                    {row.topic}
                </Typography>
            </DialogTitle>
            <DialogContent dividers>
                {mode === 'search' ? (
                    <>
                        <TextField
                            autoFocus
                            fullWidth
                            size="small"
                            label="名前で検索"
                            value={query}
                            onChange={(e) => setQuery(e.target.value)}
                            sx={{ mb: 1 }}
                        />
                        <List dense sx={{ maxHeight: 280, overflow: 'auto', border: '1px solid', borderColor: 'divider', borderRadius: 1 }}>
                            {filtered.length === 0 ? (
                                <ListItemText sx={{ p: 2 }} primary="一致するメンバーがいません" secondary="下のボタンで新規登録できます" />
                            ) : (
                                filtered.map((m) => (
                                    <ListItemButton
                                        key={m.id}
                                        onClick={() => {
                                            onPick(row, m);
                                            onClose();
                                        }}
                                    >
                                        <ListItemText
                                            primary={m.name}
                                            secondary={[m.name_kana, m.workspace_name, m.category_label].filter(Boolean).join(' / ') || null}
                                        />
                                    </ListItemButton>
                                ))
                            )}
                        </List>
                        <Box sx={{ mt: 2, textAlign: 'center' }}>
                            <Button
                                variant="contained"
                                onClick={() => {
                                    setName(query.trim() || row.counterpart_name || '');
                                    setMode('create');
                                }}
                            >
                                ＋ 新規登録{query.trim() ? `「${query.trim()}」` : ''}
                            </Button>
                        </Box>
                    </>
                ) : (
                    <Stack spacing={2} sx={{ mt: 0.5 }}>
                        {duplicates.length > 0 && (
                            <Alert severity="warning">
                                同名のメンバーがいます。既存を使う場合は選択してください。
                                <List dense>
                                    {duplicates.map((d) => (
                                        <ListItemButton
                                            key={d.id}
                                            onClick={() => {
                                                onPick(row, { id: d.id, name: d.name });
                                                onClose();
                                            }}
                                        >
                                            <ListItemText primary={d.name} secondary={[d.name_kana, d.type].filter(Boolean).join(' / ') || null} />
                                        </ListItemButton>
                                    ))}
                                </List>
                            </Alert>
                        )}
                        <TextField label="氏名" size="small" fullWidth value={name} onChange={(e) => setName(e.target.value)} />
                        <TextField label="ふりがな（任意）" size="small" fullWidth value={kana} onChange={(e) => setKana(e.target.value)} />
                        <FormControl size="small" fullWidth>
                            <InputLabel id="cp-type">種別</InputLabel>
                            <Select labelId="cp-type" label="種別" value={type} onChange={(e) => setType(e.target.value)}>
                                {MEMBER_TYPE_CHOICES.map((c) => (
                                    <MenuItem key={c.id} value={c.id}>{c.name}</MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        <FormControl size="small" fullWidth>
                            <InputLabel id="cp-ws">所属チャプター（任意）</InputLabel>
                            <Select labelId="cp-ws" label="所属チャプター（任意）" value={workspaceId} onChange={(e) => setWorkspaceId(e.target.value)} displayEmpty>
                                <MenuItem value=""><em>未設定</em></MenuItem>
                                {(workspaces || []).map((w) => (
                                    <MenuItem key={w.id} value={String(w.id)}>{w.name}</MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        <Link component="button" type="button" variant="caption" onClick={() => { setMode('search'); setDuplicates([]); }}>
                            ← 検索に戻る
                        </Link>
                    </Stack>
                )}
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose} disabled={busy}>閉じる</Button>
                {mode === 'create' && (
                    <Button variant="contained" onClick={() => submitCreate(duplicates.length > 0)} disabled={busy || !name.trim()}>
                        {busy ? '登録中…' : duplicates.length > 0 ? 'それでも新規作成' : '新規作成して紐付け'}
                    </Button>
                )}
            </DialogActions>
        </Dialog>
    );
}

async function fetchJson(url, init) {
    const res = await religoFetch(url, init);
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data.message || `HTTP ${res.status}`);
    }
    return data;
}

const CONFIDENCE_COLOR = { high: 'success', medium: 'warning', low: 'default' };

function formatDateTime(iso) {
    if (!iso) return '—';
    try {
        return new Date(iso).toLocaleString('ja-JP', {
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
        });
    } catch {
        return iso;
    }
}

/**
 * Zoom 取り込み（SPEC-012 Phase B）。
 * Zoom の予定・実施を一覧表示し、複数選択して 1 to 1 に登録する。
 * BNI 以外のミーティングも含まれるため、人が登録要否を選ぶ。
 */
export default function ZoomImport() {
    const [status, setStatus] = useState(null);
    const [rows, setRows] = useState([]);
    const [members, setMembers] = useState([]);
    const [workspaces, setWorkspaces] = useState([]);
    const [pickerRow, setPickerRow] = useState(null);
    const [loading, setLoading] = useState(false);
    const [syncing, setSyncing] = useState(false);
    const [pastDays, setPastDays] = useState(30);
    const [upcomingDays, setUpcomingDays] = useState(14);
    const [snack, setSnack] = useState({ open: false, message: '', severity: 'success' });

    const notify = useCallback((message, severity = 'success') => {
        setSnack({ open: true, message, severity });
    }, []);

    const loadStatus = useCallback(async () => {
        try {
            const data = await fetchJson('/api/zoom/status');
            setStatus(data);
        } catch (e) {
            notify(e.message || '連携状態の取得に失敗しました', 'error');
        }
    }, [notify]);

    const loadImports = useCallback(async () => {
        setLoading(true);
        try {
            const data = await fetchJson('/api/zoom/imports');
            setRows(Array.isArray(data) ? data : []);
        } catch (e) {
            notify(e.message || '一覧取得に失敗しました', 'error');
        } finally {
            setLoading(false);
        }
    }, [notify]);

    const loadMembers = useCallback(async () => {
        try {
            const [m, ws] = await Promise.all([
                fetchJson('/api/dragonfly/members'),
                fetchJson('/api/workspaces').catch(() => []),
            ]);
            setMembers(Array.isArray(m) ? m : []);
            setWorkspaces(Array.isArray(ws) ? ws : []);
        } catch {
            /* メンバー候補は任意 */
        }
    }, []);

    useEffect(() => {
        loadStatus();
        loadMembers();
        loadImports();
    }, [loadStatus, loadMembers, loadImports]);

    const connect = async () => {
        try {
            const data = await fetchJson('/api/zoom/connect');
            if (data.authorize_url) {
                window.location.href = data.authorize_url;
            }
        } catch (e) {
            notify(e.message || '連携開始に失敗しました', 'error');
        }
    };

    const disconnect = async () => {
        try {
            await fetchJson('/api/zoom/connect', { method: 'DELETE' });
            notify('連携を解除しました');
            loadStatus();
        } catch (e) {
            notify(e.message || '解除に失敗しました', 'error');
        }
    };

    const runSync = async () => {
        setSyncing(true);
        try {
            const result = await fetchJson('/api/zoom/sync', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ past_days: Number(pastDays), upcoming_days: Number(upcomingDays) }),
            });
            notify(`取得しました（予定 ${result.scheduled} / 実施 ${result.past} / 候補 ${result.candidates}）`);
            await loadImports();
        } catch (e) {
            notify(e.message || '取得に失敗しました', 'error');
        } finally {
            setSyncing(false);
        }
    };

    const patchRow = async (id, patch) => {
        // 楽観更新
        setRows((prev) => prev.map((r) => (r.id === id ? { ...r, ...patch } : r)));
        try {
            await fetchJson(`/api/zoom/imports/${id}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(patch),
            });
        } catch (e) {
            notify(e.message || '更新に失敗しました', 'error');
            loadImports();
        }
    };

    const toggleSelect = (row, checked) => {
        if (row.already_imported) return;
        patchRow(row.id, { selected: checked });
    };

    const setMatch = (row, member) => {
        patchRow(row.id, {
            matched_member_id: member ? member.id : null,
            match_status: member ? 'matched' : 'unmatched',
        });
    };

    const selectAll = (onlyCandidates) => {
        const targets = rows.filter((r) => !r.already_imported && (!onlyCandidates || r.is_one_to_one_candidate));
        const ids = new Set(targets.map((r) => r.id));
        setRows((prev) => prev.map((r) => (ids.has(r.id) ? { ...r, selected: true } : r)));
        targets.forEach((r) => {
            if (!r.selected) patchRow(r.id, { selected: true });
        });
    };

    const clearAll = () => {
        const targets = rows.filter((r) => r.selected && !r.already_imported);
        setRows((prev) => prev.map((r) => (r.selected ? { ...r, selected: false } : r)));
        targets.forEach((r) => patchRow(r.id, { selected: false }));
    };

    const selectedRows = useMemo(() => rows.filter((r) => r.selected && !r.already_imported), [rows]);

    const applySelected = async () => {
        if (selectedRows.length === 0) {
            notify('登録する行を選択してください', 'warning');
            return;
        }
        setLoading(true);
        try {
            const result = await fetchJson('/api/zoom/imports/apply', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ ids: selectedRows.map((r) => r.id) }),
            });
            notify(`登録 ${result.imported} / 保留 ${result.held} / スキップ ${result.skipped}`);
            await loadImports();
        } catch (e) {
            notify(e.message || '登録に失敗しました', 'error');
        } finally {
            setLoading(false);
        }
    };

    const fetchSummary = async (row) => {
        try {
            const data = await fetchJson(`/api/zoom/imports/${row.id}/summary`, { method: 'POST' });
            if (data.available) {
                notify(data.applied_to_notes ? '要約を取得し 1to1 のメモに反映しました' : '要約を取得しました');
            } else {
                notify(data.message || '要約を取得できませんでした', 'warning');
            }
        } catch (e) {
            notify(e.message || '要約取得に失敗しました', 'error');
        }
    };

    const createMember = async (row, payload) => {
        try {
            const res = await religoFetch(`/api/zoom/imports/${row.id}/create-member`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify(payload),
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                notify(data.message || '新規登録に失敗しました', 'error');
                return { created: false };
            }
            if (data.created === false) {
                return data; // 重複候補をダイアログ側で表示
            }
            // 作成成功 → members 候補に追加して行に反映
            if (data.member) {
                setMembers((prev) => (prev.some((m) => m.id === data.member.id) ? prev : [...prev, data.member]));
            }
            if (data.import) {
                setRows((prev) => prev.map((r) => (r.id === data.import.id ? { ...r, ...data.import } : r)));
            }
            notify(`「${data.member?.name}」を登録して紐付けました`);
            return data;
        } catch (e) {
            notify(e.message || '新規登録に失敗しました', 'error');
            return { created: false };
        }
    };

    const memberDisplayName = (row) =>
        row.matched_member_id
            ? row.matched_member_name || members.find((m) => m.id === row.matched_member_id)?.name || `#${row.matched_member_id}`
            : null;

    return (
        <Container maxWidth="lg" sx={{ py: 3 }}>
            <Typography variant="h5" sx={{ fontWeight: 700, mb: 1 }}>
                Zoom から 1 to 1 を取り込み
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                Zoom の予定・実施ミーティングを取得し、登録するものを選んで 1 to 1 にします。BNI 以外の会議は既定で未選択です。
            </Typography>

            {status && !status.configured && (
                <Alert severity="warning" sx={{ mb: 2 }}>
                    Zoom 連携が未設定です。設定画面で Client ID / Client Secret を登録するか、管理者に ZOOM_REDIRECT_URI の設定を確認してください。
                </Alert>
            )}

            {status?.configured && !status?.connected && (
                <Alert severity="info" sx={{ mb: 2 }}>
                    <strong>「Zoom から取得」</strong>を使うには、先に下の<strong>「Zoom と連携」</strong>で OAuth 認可を完了してください（連携中チップが表示されたら取得可能）。
                    {status.redirect_uri?.startsWith('http://') && (
                        <>
                            {' '}
                            現在の Redirect URI が <Typography component="code" variant="body2">{status.redirect_uri}</Typography>{' '}
                            のため、Zoom OAuth は <strong>HTTPS</strong> が必要です。ngrok 等で HTTPS トンネルを立て、
                            <Link href="#/settings">設定</Link> に表示される Redirect URI と Zoom Marketplace の Allow List を一致させてください。
                        </>
                    )}
                </Alert>
            )}

            <Paper sx={{ p: 2, mb: 2 }}>
                <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2} alignItems={{ sm: 'center' }}>
                    {status?.connected ? (
                        <>
                            <Chip color="success" label={`連携中: ${status.zoom_email || 'Zoom'}`} />
                            <Button size="small" color="inherit" onClick={disconnect}>
                                連携解除
                            </Button>
                        </>
                    ) : (
                        <Button variant="contained" onClick={connect} disabled={status ? !status.configured : true}>
                            Zoom と連携
                        </Button>
                    )}
                    <Divider flexItem orientation="vertical" sx={{ display: { xs: 'none', sm: 'block' } }} />
                    <TextField
                        label="過去（日）"
                        size="small"
                        type="number"
                        value={pastDays}
                        onChange={(e) => setPastDays(e.target.value)}
                        sx={{ width: 110 }}
                    />
                    <TextField
                        label="今後（日）"
                        size="small"
                        type="number"
                        value={upcomingDays}
                        onChange={(e) => setUpcomingDays(e.target.value)}
                        sx={{ width: 110 }}
                    />
                    <Button variant="outlined" onClick={runSync} disabled={!status?.connected || syncing}>
                        {syncing ? <CircularProgress size={18} /> : 'Zoom から取得'}
                    </Button>
                </Stack>
            </Paper>

            <Paper sx={{ p: 2, mb: 2 }}>
                <Stack direction="row" spacing={1} sx={{ mb: 1 }} alignItems="center" flexWrap="wrap">
                    <Button size="small" onClick={() => selectAll(false)}>全選択</Button>
                    <Button size="small" onClick={() => selectAll(true)}>候補のみ選択</Button>
                    <Button size="small" onClick={clearAll}>全解除</Button>
                    <Box sx={{ flexGrow: 1 }} />
                    <Typography variant="body2" color="text.secondary">
                        全 {rows.length} 件・選択 {selectedRows.length} 件
                    </Typography>
                    <Button variant="contained" onClick={applySelected} disabled={loading || selectedRows.length === 0}>
                        選択を Religo に登録
                    </Button>
                </Stack>

                <TableContainer sx={{ maxHeight: 'calc(100vh - 300px)', minHeight: 240 }}>
                    <Table stickyHeader size="small">
                        <TableHead>
                            <TableRow>
                                <TableCell padding="checkbox" />
                                <TableCell>件名 / 日時</TableCell>
                                <TableCell>区分</TableCell>
                                <TableCell>参加</TableCell>
                                <TableCell>1to1判定</TableCell>
                                <TableCell>相手（members）</TableCell>
                                <TableCell>登録</TableCell>
                                <TableCell>状態</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {rows.length === 0 && (
                                <TableRow>
                                    <TableCell colSpan={8}>
                                        <Typography variant="body2" color="text.secondary" sx={{ py: 2, textAlign: 'center' }}>
                                            候補がありません。「Zoom から取得」を実行してください。
                                        </Typography>
                                    </TableCell>
                                </TableRow>
                            )}
                            {rows.map((row) => {
                                const isCompleted = row.kind === 'past' && row.start_time;
                                return (
                                    <TableRow
                                        key={row.id}
                                        hover
                                        sx={{ opacity: row.already_imported ? 0.5 : 1 }}
                                    >
                                        <TableCell padding="checkbox">
                                            <Checkbox
                                                checked={Boolean(row.selected) && !row.already_imported}
                                                disabled={row.already_imported}
                                                onChange={(e) => toggleSelect(row, e.target.checked)}
                                            />
                                        </TableCell>
                                        <TableCell>
                                            <Typography variant="body2" sx={{ fontWeight: 600 }}>
                                                {row.topic || '(無題)'}
                                            </Typography>
                                            <Typography variant="caption" color="text.secondary">
                                                {formatDateTime(row.start_time)}
                                                {row.end_time ? ` 〜 ${formatDateTime(row.end_time)}` : ''}
                                            </Typography>
                                        </TableCell>
                                        <TableCell>
                                            <Chip
                                                size="small"
                                                variant="outlined"
                                                label={row.kind === 'past' ? '実施' : '予定'}
                                            />
                                        </TableCell>
                                        <TableCell>{row.participants_count ?? '—'}</TableCell>
                                        <TableCell>
                                            {row.is_one_to_one_candidate ? (
                                                <Chip
                                                    size="small"
                                                    color={CONFIDENCE_COLOR[row.confidence] || 'default'}
                                                    label={`候補 (${row.confidence})`}
                                                />
                                            ) : (
                                                <Chip size="small" variant="outlined" label="対象外候補" />
                                            )}
                                        </TableCell>
                                        <TableCell sx={{ minWidth: 220 }}>
                                            {memberDisplayName(row) ? (
                                                <Button
                                                    size="small"
                                                    variant="text"
                                                    disabled={row.already_imported}
                                                    onClick={() => setPickerRow(row)}
                                                    sx={{ textTransform: 'none', justifyContent: 'flex-start' }}
                                                >
                                                    {memberDisplayName(row)}（変更）
                                                </Button>
                                            ) : (
                                                <Button
                                                    size="small"
                                                    variant="outlined"
                                                    color="warning"
                                                    disabled={row.already_imported}
                                                    onClick={() => setPickerRow(row)}
                                                    sx={{ textTransform: 'none' }}
                                                >
                                                    {row.counterpart_name ? `${row.counterpart_name}（未登録・選択/登録）` : '相手を選択 / 登録'}
                                                </Button>
                                            )}
                                        </TableCell>
                                        <TableCell>
                                            <Chip
                                                size="small"
                                                variant="outlined"
                                                color={isCompleted ? 'primary' : 'default'}
                                                label={isCompleted ? 'completed' : 'planned'}
                                            />
                                        </TableCell>
                                        <TableCell>
                                            <Stack spacing={0.5} alignItems="flex-start">
                                                <Typography variant="caption">{row.import_status_label}</Typography>
                                                {row.kind === 'past' && row.one_to_one_id && (
                                                    <Button size="small" onClick={() => fetchSummary(row)}>
                                                        要約取得
                                                    </Button>
                                                )}
                                            </Stack>
                                        </TableCell>
                                    </TableRow>
                                );
                            })}
                        </TableBody>
                    </Table>
                </TableContainer>
            </Paper>

            <CounterpartPickerDialog
                open={pickerRow !== null}
                row={pickerRow}
                members={members}
                workspaces={workspaces}
                onClose={() => setPickerRow(null)}
                onPick={(row, member) => setMatch(row, member)}
                onCreate={createMember}
            />

            <Snackbar
                open={snack.open}
                autoHideDuration={6000}
                onClose={() => setSnack((s) => ({ ...s, open: false }))}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
            >
                <Alert
                    severity={snack.severity}
                    onClose={() => setSnack((s) => ({ ...s, open: false }))}
                    sx={{ width: '100%' }}
                >
                    {snack.message}
                </Alert>
            </Snackbar>
        </Container>
    );
}
