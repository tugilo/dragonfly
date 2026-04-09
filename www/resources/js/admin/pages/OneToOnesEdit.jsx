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
import { OneToOneFormFields } from './OneToOneFormFields';
import { buildOneToOnePayload, inferDurationMinutes } from '../utils/oneToOnesTransform';

async function fetchJson(url) {
    const res = await fetch(url, { headers: { Accept: 'application/json' } });
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
        fetch(`/api/one-to-ones/${id}/memos`, { headers: { Accept: 'application/json' } })
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
        fetch(`/api/one-to-ones/${id}/memos`, {
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
                                <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
                                    {m.body}
                                </Typography>
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
                <OneToOneMemosPanel />
            </SimpleForm>
        </Edit>
    );
}
