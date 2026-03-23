import React, { useCallback, useEffect, useState } from 'react';
import {
    Create,
    SimpleForm,
    Toolbar,
    SaveButton,
    ListButton,
    useNotify,
    useRedirect,
} from 'react-admin';
import { useSearchParams } from 'react-router-dom';
import { OneToOneFormFields } from './OneToOneFormFields';
import { fetchReligoOwnerMemberId, ownerMemberIdFallback } from '../religoOwnerMemberId';
import { buildOneToOnePayload } from '../utils/oneToOnesTransform';

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
    const [searchParams] = useSearchParams();
    const [workspaceId, setWorkspaceId] = useState(null);
    const [workspaceError, setWorkspaceError] = useState('');
    const [ownerMemberOptions, setOwnerMemberOptions] = useState([]);
    const [formReady, setFormReady] = useState(false);
    const [defaultValues, setDefaultValues] = useState({ status: 'planned' });
    const [durationMinutes, setDurationMinutes] = useState(60);

    useEffect(() => {
        let cancelled = false;
        (async () => {
            try {
                const [wsArr, meOwner, allMembers] = await Promise.all([
                    fetchJson('/api/workspaces'),
                    fetchReligoOwnerMemberId(),
                    fetchJson('/api/dragonfly/members'),
                ]);
                if (cancelled) {
                    return;
                }
                if (!Array.isArray(wsArr) || wsArr.length === 0) {
                    setWorkspaceError('ワークスペースがありません');
                    return;
                }
                setWorkspaceId(wsArr[0].id);
                setWorkspaceError('');
                const owners = Array.isArray(allMembers) ? allMembers : [];
                setOwnerMemberOptions(owners);
                const ownerId = ownerMemberIdFallback(meOwner);
                const scoped = await fetchJson(
                    `/api/dragonfly/members?owner_member_id=${encodeURIComponent(String(ownerId))}`
                );
                if (cancelled) {
                    return;
                }
                const scopedList = Array.isArray(scoped) ? scoped : [];
                const qTarget = searchParams.get('target_member_id');
                const qNum = qTarget != null && /^\d+$/.test(String(qTarget)) ? Number(qTarget) : null;
                const targetOk =
                    qNum != null &&
                    qNum !== ownerId &&
                    scopedList.some((m) => Number(m.id) === qNum);
                setDefaultValues({
                    status: 'planned',
                    owner_member_id: ownerId,
                    ...(targetOk ? { target_member_id: qNum } : {}),
                });
                setFormReady(true);
            } catch {
                if (!cancelled) {
                    setWorkspaceError('初期データの取得に失敗しました');
                }
            }
        })();
        return () => {
            cancelled = true;
        };
    }, [searchParams]);

    const transform = useCallback(
        (data) => buildOneToOnePayload(data, durationMinutes, { mode: 'create', workspaceId }),
        [workspaceId, durationMinutes]
    );

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
                <OneToOneFormFields
                    mode="create"
                    ownerMemberOptions={ownerMemberOptions}
                    durationMinutes={durationMinutes}
                    onDurationChange={setDurationMinutes}
                />
            </SimpleForm>
        </Create>
    );
}
