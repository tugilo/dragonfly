import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
    Edit,
    SimpleForm,
    Toolbar,
    SaveButton,
    ListButton,
    useNotify,
    useRedirect,
    useRecordContext,
} from 'react-admin';
import { Box, Button, CircularProgress, Stack, TextField as MuiTextField, Typography } from '@mui/material';
import { MarkdownView } from '../components/MarkdownView';
import { OneToOneFormFields } from './OneToOneFormFields';
import { buildOneToOnePayload, inferDurationMinutes } from '../utils/oneToOnesTransform';
import { religoFetch } from '../religoApiFetch';

async function fetchJson(url) {
    const res = await religoFetch(url, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

const EditToolbar = () => (
    <Toolbar>
        <SaveButton />
        <ListButton label="一覧へ戻る" />
    </Toolbar>
);

const STATUS_HELPER_EDIT =
    'キャンセルは「予定が無効になった事実」を残す業務状態です。レコードの削除は行いません（製品方針）。';

/** レコード読込後に所要時間チップを scheduled/ended から推定（ONETOONES_EDIT_UX_P2） */
function EditDurationInitializer({ setDurationMinutes }) {
    const record = useRecordContext();
    const prevIdRef = useRef(null);

    useEffect(() => {
        if (!record?.id) {
            return;
        }
        if (prevIdRef.current !== record.id) {
            prevIdRef.current = record.id;
            setDurationMinutes(inferDurationMinutes(record.scheduled_at, record.ended_at, record.status));
        }
    }, [record, setDurationMinutes]);

    return null;
}

function OneToOneMemosPanel() {
    const record = useRecordContext();
    const notify = useNotify();
    const [memos, setMemos] = useState([]);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [draft, setDraft] = useState('');
    const id = record?.id;

    const load = useCallback(() => {
        if (id == null) {
            return;
        }
        setLoading(true);
        religoFetch(`/api/one-to-ones/${id}/memos`, { headers: { Accept: 'application/json' } })
            .then((r) => {
                if (!r.ok) {
                    throw new Error(String(r.status));
                }
                return r.json();
            })
            .then((rows) => setMemos(Array.isArray(rows) ? rows : []))
            .catch(() => {
                setMemos([]);
                notify('履歴メモの取得に失敗しました', { type: 'warning' });
            })
            .finally(() => setLoading(false));
    }, [id, notify]);

    useEffect(() => {
        load();
    }, [load]);

    const handleAdd = () => {
        const t = draft.trim();
        if (!t || id == null) {
            return;
        }
        setSaving(true);
        religoFetch(`/api/one-to-ones/${id}/memos`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
            body: JSON.stringify({ body: t }),
        })
            .then(async (r) => {
                if (!r.ok) {
                    throw new Error(await r.text());
                }
                return r.json();
            })
            .then(() => {
                setDraft('');
                notify('履歴メモを追加しました');
                load();
            })
            .catch(() => notify('追加に失敗しました', { type: 'warning' }))
            .finally(() => setSaving(false));
    };

    if (id == null) {
        return null;
    }

    return (
        <Box sx={{ mt: 3, pt: 2, borderTop: '1px solid', borderColor: 'divider' }}>
            <Typography variant="subtitle2" gutterBottom sx={{ fontWeight: 700 }}>
                履歴メモ（contact_memos）
            </Typography>
            <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 1.5 }}>
                上の「この回で話した内容」（notes）がその回の主記録です。ここでは追記・分割を時系列で足す場合に使います（任意）。
            </Typography>
            {loading ? (
                <CircularProgress size={22} sx={{ my: 1 }} />
            ) : (
                <Stack spacing={1} sx={{ mb: 2, maxHeight: 280, overflow: 'auto' }}>
                    {memos.length === 0 ? (
                        <Typography variant="body2" color="text.secondary">
                            まだ履歴メモがありません
                        </Typography>
                    ) : (
                        memos.map((m) => (
                            <Box key={m.id} sx={{ bgcolor: 'action.hover', borderRadius: 1, p: 1.25 }}>
                                <Typography variant="caption" color="text.secondary" display="block">
                                    {m.created_at
                                        ? new Date(m.created_at).toLocaleString('ja-JP', {
                                              dateStyle: 'short',
                                              timeStyle: 'short',
                                          })
                                        : ''}
                                </Typography>
                                <Box sx={{ mt: 0.5 }}>
                                    <MarkdownView markdown={m.body ?? ''} dense />
                                </Box>
                            </Box>
                        ))
                    )}
                </Stack>
            )}
            <Stack direction={{ xs: 'column', sm: 'row' }} spacing={1} alignItems={{ xs: 'stretch', sm: 'flex-start' }}>
                <MuiTextField
                    label="履歴メモを追加"
                    multiline
                    minRows={2}
                    fullWidth
                    size="small"
                    value={draft}
                    onChange={(e) => setDraft(e.target.value)}
                />
                <Button variant="contained" onClick={handleAdd} disabled={saving || !draft.trim()} sx={{ flexShrink: 0 }}>
                    {saving ? '…' : '追加'}
                </Button>
            </Stack>
        </Box>
    );
}

/** SPEC-013: 1to1 事前準備（相手プロフィール添付・AI 原稿生成）。 */
function OneToOnePrepPanel() {
    const record = useRecordContext();
    const notify = useNotify();
    const id = record?.id;
    const [attachments, setAttachments] = useState([]);
    const [url, setUrl] = useState('');
    const [busy, setBusy] = useState(false);
    const [draft, setDraft] = useState('');

    const load = useCallback(() => {
        if (id == null) return;
        religoFetch(`/api/one-to-ones/${id}/attachments`, { headers: { Accept: 'application/json' } })
            .then((r) => (r.ok ? r.json() : []))
            .then((rows) => setAttachments(Array.isArray(rows) ? rows : []))
            .catch(() => setAttachments([]));
    }, [id]);

    useEffect(() => {
        load();
    }, [load]);

    const uploadPdf = (file) => {
        if (!file || id == null) return;
        const fd = new FormData();
        fd.append('file', file);
        setBusy(true);
        religoFetch(`/api/one-to-ones/${id}/attachments`, { method: 'POST', body: fd })
            .then(async (r) => {
                if (!r.ok) throw new Error((await r.json().catch(() => ({}))).message || 'PDFアップロード失敗');
                return r.json();
            })
            .then(() => {
                notify('PDF を添付しました');
                load();
            })
            .catch((e) => notify(e.message, { type: 'warning' }))
            .finally(() => setBusy(false));
    };

    const addUrl = () => {
        const u = url.trim();
        if (!u || id == null) return;
        setBusy(true);
        religoFetch(`/api/one-to-ones/${id}/attachments/url`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
            body: JSON.stringify({ url: u }),
        })
            .then(async (r) => {
                if (!r.ok) throw new Error((await r.json().catch(() => ({}))).message || 'URL取込失敗');
                return r.json();
            })
            .then((data) => {
                setUrl('');
                notify(data.fetch_ok ? 'URL を取り込みました' : 'URL を登録しました（本文取得は失敗・後で手動補完）');
                load();
            })
            .catch((e) => notify(e.message, { type: 'warning' }))
            .finally(() => setBusy(false));
    };

    const removeAttachment = (attId) => {
        if (id == null) return;
        religoFetch(`/api/one-to-ones/${id}/attachments/${attId}`, { method: 'DELETE', headers: { Accept: 'application/json' } })
            .then((r) => {
                if (!r.ok) throw new Error('削除失敗');
                notify('添付を削除しました');
                load();
            })
            .catch(() => notify('削除に失敗しました', { type: 'warning' }));
    };

    const generate = (saveTo) => {
        if (id == null) return;
        setBusy(true);
        setDraft('');
        religoFetch(`/api/one-to-ones/${id}/prep/generate`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
            body: JSON.stringify(saveTo ? { save_to: saveTo } : {}),
        })
            .then(async (r) => {
                const data = await r.json().catch(() => ({}));
                if (!r.ok) throw new Error(data.message || '原稿生成に失敗しました');
                return data;
            })
            .then((data) => {
                setDraft(data.draft || '');
                notify(data.saved_to ? `原稿を生成し ${data.saved_to} に保存しました` : '原稿を生成しました（下書き）');
            })
            .catch((e) => notify(e.message, { type: 'warning' }))
            .finally(() => setBusy(false));
    };

    if (id == null) return null;

    return (
        <Box sx={{ mt: 3, pt: 2, borderTop: '1px solid', borderColor: 'divider' }}>
            <Typography variant="subtitle2" gutterBottom sx={{ fontWeight: 700 }}>
                事前準備（相手プロフィール・AI 原稿）
            </Typography>
            <Typography variant="caption" color="text.secondary" display="block" sx={{ mb: 1.5 }}>
                相手の PDF（GAINS/略歴等）を添付、または NCAS プロフィール URL を取り込み、AI で 1to1 原稿の下書きを生成します。AI は設定画面で有効化が必要です。
            </Typography>

            <Stack direction={{ xs: 'column', sm: 'row' }} spacing={1} sx={{ mb: 1.5 }} alignItems={{ sm: 'center' }}>
                <Button variant="outlined" component="label" disabled={busy} sx={{ flexShrink: 0 }}>
                    PDF を添付
                    <input
                        type="file"
                        accept="application/pdf"
                        hidden
                        onChange={(e) => {
                            uploadPdf(e.target.files?.[0]);
                            e.target.value = '';
                        }}
                    />
                </Button>
                <MuiTextField
                    label="NCAS プロフィール URL"
                    size="small"
                    fullWidth
                    value={url}
                    onChange={(e) => setUrl(e.target.value)}
                    placeholder="https://...ncas.jp/...viewsheets.php?..."
                />
                <Button variant="outlined" onClick={addUrl} disabled={busy || !url.trim()} sx={{ flexShrink: 0 }}>
                    URL 取込
                </Button>
            </Stack>

            <Stack spacing={0.75} sx={{ mb: 2 }}>
                {attachments.length === 0 ? (
                    <Typography variant="body2" color="text.secondary">
                        添付はまだありません
                    </Typography>
                ) : (
                    attachments.map((a) => (
                        <Box
                            key={a.id}
                            sx={{ display: 'flex', alignItems: 'center', gap: 1, bgcolor: 'action.hover', borderRadius: 1, p: 1 }}
                        >
                            <Typography variant="body2" sx={{ flexGrow: 1, wordBreak: 'break-all' }}>
                                [{a.source_type}] {a.original_name || a.source_url}
                                {a.has_text ? ` ・抽出 ${a.text_length}字` : ' ・テキスト無し'}
                            </Typography>
                            <Button size="small" color="error" onClick={() => removeAttachment(a.id)}>
                                削除
                            </Button>
                        </Box>
                    ))
                )}
            </Stack>

            <Stack direction="row" spacing={1} sx={{ mb: 1.5 }} flexWrap="wrap">
                <Button variant="contained" onClick={() => generate(null)} disabled={busy}>
                    {busy ? '生成中…' : '原稿を生成（下書き）'}
                </Button>
                <Button variant="outlined" onClick={() => generate('notes')} disabled={busy}>
                    生成して notes に保存
                </Button>
                <Button variant="outlined" onClick={() => generate('memo')} disabled={busy}>
                    生成して履歴メモに保存
                </Button>
            </Stack>

            {draft && (
                <MuiTextField
                    label="生成された原稿（下書き・要校正）"
                    multiline
                    minRows={8}
                    fullWidth
                    value={draft}
                    InputProps={{ readOnly: true }}
                />
            )}
        </Box>
    );
}

export function OneToOnesEdit() {
    const notify = useNotify();
    const redirect = useRedirect();
    const [ownerMemberOptions, setOwnerMemberOptions] = useState([]);
    const [durationMinutes, setDurationMinutes] = useState(60);

    useEffect(() => {
        fetchJson('/api/dragonfly/members')
            .then((arr) => setOwnerMemberOptions(Array.isArray(arr) ? arr : []))
            .catch(() => setOwnerMemberOptions([]));
    }, []);

    const transform = useCallback(
        (data) => buildOneToOnePayload(data, durationMinutes, { mode: 'edit' }),
        [durationMinutes]
    );

    return (
        <Edit
            mutationMode="pessimistic"
            title="1 to 1 編集"
            mutationOptions={{
                onSuccess: () => {
                    notify('1 to 1 を更新しました');
                    redirect('list', 'one-to-ones');
                },
            }}
        >
            <SimpleForm toolbar={<EditToolbar />} transform={transform}>
                <EditDurationInitializer setDurationMinutes={setDurationMinutes} />
                <OneToOneFormFields
                    mode="edit"
                    ownerMemberOptions={ownerMemberOptions}
                    durationMinutes={durationMinutes}
                    onDurationChange={setDurationMinutes}
                    statusHelperText={STATUS_HELPER_EDIT}
                />
                <OneToOnePrepPanel />
                <OneToOneMemosPanel />
            </SimpleForm>
        </Edit>
    );
}
