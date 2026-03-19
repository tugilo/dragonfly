import React, { useCallback, useEffect, useState } from 'react';
import {
    Edit,
    SimpleForm,
    SelectInput,
    DateTimeInput,
    NumberInput,
    TextInput,
    Toolbar,
    SaveButton,
    ListButton,
    required,
    useNotify,
    useRedirect,
    useRecordContext,
} from 'react-admin';
import { Box, Button, CircularProgress, Stack, TextField as MuiTextField, Typography } from '@mui/material';
import { OwnerScopedTargetSelect } from './OneToOnesFormParts';

const STATUS_CHOICES = [
    { id: 'planned', name: '予定' },
    { id: 'completed', name: '実施済み' },
    { id: 'canceled', name: 'キャンセル' },
];

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
                会話・フォローを時系列で残します。上欄は一覧用の要約（notes）です。
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

function EditContextHeader() {
    const record = useRecordContext();
    if (!record) return null;
    const when = record.started_at ?? record.scheduled_at;
    let whenShort = '';
    if (when) {
        try {
            whenShort = new Date(when).toLocaleString('ja-JP', { dateStyle: 'short', timeStyle: 'short' });
        } catch {
            whenShort = String(when);
        }
    }
    return (
        <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 2, fontWeight: 600 }}>
            {record.target_name ? `相手: ${record.target_name}` : '相手: —'}
            {whenShort ? ` ・ ${whenShort}` : ''}
        </Typography>
    );
}

export function OneToOnesEdit() {
    const notify = useNotify();
    const redirect = useRedirect();
    const [ownerChoices, setOwnerChoices] = useState([]);

    useEffect(() => {
        fetchJson('/api/dragonfly/members')
            .then((arr) =>
                setOwnerChoices(
                    Array.isArray(arr)
                        ? arr.map((m) => ({
                              id: m.id,
                              name: `${m.display_no != null ? `#${m.display_no} ` : ''}${m.name}`.trim() || `#${m.id}`,
                          }))
                        : []
                )
            )
            .catch(() => setOwnerChoices([]));
    }, []);

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
            <SimpleForm toolbar={<EditToolbar />}>
                <EditContextHeader />
                <SelectInput
                    source="owner_member_id"
                    choices={ownerChoices}
                    label="Owner（自分）"
                    validate={[required()]}
                />
                <OwnerScopedTargetSelect />
                <SelectInput source="status" choices={STATUS_CHOICES} label="状態" />
                <DateTimeInput source="scheduled_at" label="予定日時" />
                <DateTimeInput source="started_at" label="開始日時" />
                <DateTimeInput source="ended_at" label="終了日時" />
                <NumberInput source="meeting_id" label="Meeting ID（任意）" emptyText="—" />
                <TextInput
                    source="notes"
                    label="メモ（要約・一覧プレビュー）"
                    multiline
                    fullWidth
                    minRows={4}
                    helperText="一覧の「📝 メモ」と同じ要約です。下の「履歴メモ」で会話ログを追記できます。"
                />
                <OneToOneMemosPanel />
            </SimpleForm>
        </Edit>
    );
}
