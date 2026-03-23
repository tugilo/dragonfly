import React, { useCallback, useEffect, useState } from 'react';
import {
    Create,
    SimpleForm,
    SelectInput,
    TextInput,
    Toolbar,
    SaveButton,
    ListButton,
    required,
    useNotify,
    useRedirect,
} from 'react-admin';
import { Typography } from '@mui/material';
import { useSearchParams } from 'react-router-dom';
import {
    MemberSearchAutocompleteInput,
    OwnerScopedTargetSelect,
    TargetMemberSummaryCard,
    OneToOneCreateScheduleFields,
    OneToOneMeetingReferenceInput,
} from './OneToOnesFormParts';
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
    const [searchParams] = useSearchParams();
    const [workspaceId, setWorkspaceId] = useState(null);
    const [workspaceError, setWorkspaceError] = useState('');
    const [ownerMemberOptions, setOwnerMemberOptions] = useState([]);
    const [formReady, setFormReady] = useState(false);
    const [defaultValues, setDefaultValues] = useState({ status: 'planned' });
    const [durationMinutes, setDurationMinutes] = useState(60);

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
                const owners = Array.isArray(members) ? members : [];
                setOwnerMemberOptions(owners);
                const ownerId = ownerMemberIdFallback(meOwner);
                const qTarget = searchParams.get('target_member_id');
                const qNum = qTarget != null && /^\d+$/.test(String(qTarget)) ? Number(qTarget) : null;
                const targetOk = qNum != null && qNum !== ownerId && members.some((m) => Number(m.id) === qNum);
                setDefaultValues({
                    status: 'planned',
                    owner_member_id: ownerId,
                    ...(targetOk ? { target_member_id: qNum } : {}),
                });
                setFormReady(true);
            })
            .catch(() => {
                if (!cancelled) setWorkspaceError('初期データの取得に失敗しました');
            });
        return () => {
            cancelled = true;
        };
    }, [searchParams]);

    const transform = useCallback(
        (data) => {
            let meetingId = data.meeting_id;
            if (meetingId != null && typeof meetingId === 'object' && meetingId.id != null) {
                meetingId = meetingId.id;
            }
            let meeting_id =
                meetingId === '' || meetingId === undefined || meetingId === null
                    ? null
                    : Number(meetingId);
            if (meeting_id !== null && Number.isNaN(meeting_id)) {
                meeting_id = null;
            }

            // scheduled_at と ended_at を同一の Date から toISOString し、PHP strtotime の解釈ずれを防ぐ
            let scheduled_at = data.scheduled_at;
            let ended_at = null;
            if (data.scheduled_at) {
                const start = new Date(data.scheduled_at);
                if (!Number.isNaN(start.getTime())) {
                    scheduled_at = start.toISOString();
                    if (durationMinutes > 0) {
                        const end = new Date(start.getTime());
                        end.setMinutes(end.getMinutes() + durationMinutes);
                        ended_at = end.toISOString();
                    }
                }
            }

            return {
                ...data,
                workspace_id: workspaceId ?? undefined,
                started_at: null,
                scheduled_at,
                ended_at,
                meeting_id,
            };
        },
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
                <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                    Owner（自分）は Dashboard の設定が初期値です。別メンバーで記録する場合のみ変更してください。
                </Typography>
                <MemberSearchAutocompleteInput
                    source="owner_member_id"
                    label="Owner（自分）"
                    options={ownerMemberOptions}
                    validate={[required()]}
                />
                <OwnerScopedTargetSelect />
                <TargetMemberSummaryCard />
                <SelectInput source="status" choices={STATUS_CHOICES} label="状態" />
                <OneToOneCreateScheduleFields duration={durationMinutes} onDurationChange={setDurationMinutes} />
                <OneToOneMeetingReferenceInput />
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
