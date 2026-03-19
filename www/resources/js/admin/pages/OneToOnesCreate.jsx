import React, { useEffect, useState } from 'react';
import {
    Create,
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
} from 'react-admin';
import { Typography } from '@mui/material';
import { OwnerScopedTargetSelect } from './OneToOnesFormParts';
import { fetchReligoOwnerMemberId, ownerMemberIdFallback } from '../religoOwnerMemberId';

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

const CreateToolbar = () => (
    <Toolbar>
        <SaveButton />
        <ListButton label="一覧に戻る" />
    </Toolbar>
);

export function OneToOnesCreate() {
    const notify = useNotify();
    const redirect = useRedirect();
    const [workspaceId, setWorkspaceId] = useState(null);
    const [workspaceError, setWorkspaceError] = useState('');
    const [ownerChoices, setOwnerChoices] = useState([]);
    const [formReady, setFormReady] = useState(false);
    const [defaultValues, setDefaultValues] = useState({ status: 'planned' });

    useEffect(() => {
        let cancelled = false;
        Promise.all([fetchJson('/api/workspaces'), fetchReligoOwnerMemberId(), fetchJson('/api/dragonfly/members')])
            .then(([wsArr, meOwner, members]) => {
                if (cancelled) return;
                if (!Array.isArray(wsArr) || wsArr.length === 0) {
                    setWorkspaceError('ワークスペースがありません');
                    return;
                }
                setWorkspaceId(wsArr[0].id);
                setWorkspaceError('');
                const owners = Array.isArray(members)
                    ? members.map((m) => ({
                          id: m.id,
                          name: `${m.display_no != null ? `#${m.display_no} ` : ''}${m.name}`.trim() || `#${m.id}`,
                      }))
                    : [];
                setOwnerChoices(owners);
                setDefaultValues({
                    status: 'planned',
                    owner_member_id: ownerMemberIdFallback(meOwner),
                });
                setFormReady(true);
            })
            .catch(() => {
                if (!cancelled) setWorkspaceError('初期データの取得に失敗しました');
            });
        return () => {
            cancelled = true;
        };
    }, []);

    const transform = (data) => ({
        ...data,
        workspace_id: workspaceId ?? undefined,
    });

    const onSuccess = () => {
        notify('1 to 1 を登録しました');
        redirect('list', 'one-to-ones');
    };

    if (workspaceError) {
        return (
            <div style={{ padding: 16 }}>
                <p style={{ color: 'var(--ra-color-error)' }}>{workspaceError}</p>
            </div>
        );
    }

    if (!formReady || workspaceId == null) {
        return <div style={{ padding: 16 }}>Loading...</div>;
    }

    return (
        <Create transform={transform} mutationOptions={{ onSuccess }} title="1 to 1 を追加">
            <SimpleForm toolbar={<CreateToolbar />} defaultValues={defaultValues}>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                    Owner（自分）は Dashboard の設定が初期値です。別メンバーで記録する場合のみ変更してください。
                </Typography>
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
                <NumberInput source="meeting_id" label="Meeting ID（任意）" />
                <TextInput
                    source="notes"
                    label="メモ（この1to1の記録・目的・アジェンダ）"
                    multiline
                    fullWidth
                    minRows={3}
                    helperText="会話の時系列ログは contact_memos 側で将来拡張する想定。この欄は当該1to1レコードの要約メモとして使います。"
                />
            </SimpleForm>
        </Create>
    );
}
