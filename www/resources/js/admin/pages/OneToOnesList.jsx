import React, { useState, useEffect } from 'react';
import {
    List,
    Datagrid,
    TextField,
    NumberField,
    FunctionField,
    Create,
    SimpleForm,
    TextInput,
    NumberInput,
    SelectInput,
    DateTimeInput,
    Filter,
    required,
    useNotify,
    useRedirect,
    TopToolbar,
    Button,
} from 'react-admin';
import { Link } from 'react-router-dom';

const STATUS_CHOICES = [
    { id: 'planned', name: '予定' },
    { id: 'completed', name: '実施済み' },
    { id: 'canceled', name: 'キャンセル' },
];

function EffectiveDateField({ record, ...props }) {
    const v = record?.started_at ?? record?.scheduled_at;
    if (!v) return <span>—</span>;
    try {
        return <span>{new Date(v).toLocaleString('ja-JP', { dateStyle: 'short', timeStyle: 'short' })}</span>;
    } catch {
        return <span>{String(v)}</span>;
    }
}

export function OneToOnesListFilters() {
    return (
        <Filter>
            <NumberInput source="owner_member_id" label="Owner member ID" alwaysOn />
            <SelectInput source="status" choices={STATUS_CHOICES} label="状態" />
            <TextInput source="from" label="From (date)" />
            <TextInput source="to" label="To (date)" />
        </Filter>
    );
}

function OneToOnesListActions() {
    return (
        <TopToolbar>
            <Button component={Link} to="/one-to-ones/create" variant="contained" size="small">＋ 1to1を追加</Button>
            <Button component={Link} to="/connections" variant="outlined" size="small">🗺 Connectionsへ</Button>
        </TopToolbar>
    );
}

export function OneToOnesList() {
    return (
        <List filters={[<OneToOnesListFilters key="filters" />]} title="1 to 1" actions={<OneToOnesListActions />}>
            <Datagrid rowClick={false}>
                <FunctionField label="予定/実施日" render={(record) => <EffectiveDateField record={record} />} />
                <TextField source="target_name" label="相手" />
                <TextField source="status" label="状態" />
                <TextField source="notes" label="メモ" ellipsis />
                <NumberField source="meeting_id" label="Meeting ID" emptyText="—" />
            </Datagrid>
        </List>
    );
}

const API = '';

async function fetchJson(url) {
    const res = await fetch(`${API}${url}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

export function OneToOnesCreate() {
    const notify = useNotify();
    const redirect = useRedirect();
    const [workspaceId, setWorkspaceId] = useState(null);
    const [workspaceError, setWorkspaceError] = useState('');
    const [members, setMembers] = useState([]);

    useEffect(() => {
        fetchJson('/api/workspaces')
            .then((arr) => {
                if (Array.isArray(arr) && arr.length > 0) {
                    setWorkspaceId(arr[0].id);
                    setWorkspaceError('');
                } else {
                    setWorkspaceError('ワークスペースがありません');
                }
            })
            .catch(() => setWorkspaceError('ワークスペースの取得に失敗しました'));
    }, []);

    useEffect(() => {
        fetchJson('/api/dragonfly/members')
            .then((arr) => setMembers(Array.isArray(arr) ? arr : []))
            .catch(() => setMembers([]));
    }, []);

    const memberChoices = members.map((m) => ({ id: m.id, name: `${m.display_no || ''} ${m.name}`.trim() || `#${m.id}` }));

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

    if (workspaceId == null) {
        return <div style={{ padding: 16 }}>Loading...</div>;
    }

    return (
        <Create transform={transform} mutationOptions={{ onSuccess }} title="1 to 1 登録">
            <SimpleForm defaultValues={{ status: 'planned' }}>
                <SelectInput source="owner_member_id" choices={memberChoices} label="Owner（自分）" validate={[required()]} />
                <SelectInput source="target_member_id" choices={memberChoices} label="相手" validate={[required()]} />
                <SelectInput source="status" choices={STATUS_CHOICES} label="状態" />
                <DateTimeInput source="scheduled_at" label="予定日時" />
                <DateTimeInput source="started_at" label="開始日時" />
                <DateTimeInput source="ended_at" label="終了日時" />
                <NumberInput source="meeting_id" label="Meeting ID（任意）" />
                <TextInput source="notes" label="メモ" multiline fullWidth />
            </SimpleForm>
        </Create>
    );
}
