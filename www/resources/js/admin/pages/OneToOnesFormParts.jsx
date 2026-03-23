import React, { useEffect, useState } from 'react';
import {
    SelectInput,
    FormDataConsumer,
    required,
    DateTimeInput,
    ReferenceInput,
    AutocompleteInput,
} from 'react-admin';
import { useFormContext, useWatch } from 'react-hook-form';
import { Card, CardContent, Chip, Stack, Typography, CircularProgress, Box } from '@mui/material';

async function fetchJson(url) {
    const res = await fetch(url, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

export function addMinutesToEndIso(scheduledAt, minutes) {
    if (!scheduledAt) {
        return null;
    }
    const d = new Date(scheduledAt);
    if (Number.isNaN(d.getTime())) {
        return null;
    }
    const end = new Date(d.getTime());
    end.setMinutes(end.getMinutes() + minutes);
    return end.toISOString();
}

/**
 * Owner（自分）に連動した相手メンバー一覧（GET /api/dragonfly/members?owner_member_id=）.
 */
function ScopedTargetSelect({ ownerMemberId }) {
    const [choices, setChoices] = useState([]);

    useEffect(() => {
        if (ownerMemberId == null || ownerMemberId === '') {
            setChoices([]);
            return;
        }
        let cancelled = false;
        fetchJson(`/api/dragonfly/members?owner_member_id=${encodeURIComponent(String(ownerMemberId))}`)
            .then((arr) => {
                if (cancelled || !Array.isArray(arr)) return;
                setChoices(
                    arr.map((m) => ({
                        id: m.id,
                        name: `${m.display_no != null ? `#${m.display_no} ` : ''}${m.name}`.trim() || `#${m.id}`,
                    }))
                );
            })
            .catch(() => {
                if (!cancelled) setChoices([]);
            });
        return () => {
            cancelled = true;
        };
    }, [ownerMemberId]);

    if (ownerMemberId == null || ownerMemberId === '') {
        return (
            <SelectInput
                source="target_member_id"
                label="相手"
                choices={[]}
                emptyText="先に Owner（自分）を選択してください"
                validate={[required()]}
            />
        );
    }

    return <SelectInput source="target_member_id" label="相手" choices={choices} validate={[required()]} />;
}

/** SimpleForm 内: owner_member_id の値に応じて相手候補を loaded */
export function OwnerScopedTargetSelect() {
    return (
        <FormDataConsumer>{({ formData }) => <ScopedTargetSelect ownerMemberId={formData?.owner_member_id} />}</FormDataConsumer>
    );
}

function formatCategoryLine(m) {
    const c = m?.category;
    if (!c) return '—';
    const g = c.group_name ? String(c.group_name).trim() : '';
    const n = c.name ? String(c.name).trim() : '';
    const line = [g, n].filter(Boolean).join(' / ');
    return line || '—';
}

function TargetMemberSummaryInner({ targetMemberId }) {
    const [member, setMember] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    useEffect(() => {
        if (targetMemberId == null || targetMemberId === '') {
            setMember(null);
            setError('');
            return;
        }
        const id = Number(targetMemberId);
        if (Number.isNaN(id)) {
            setMember(null);
            return;
        }
        let cancelled = false;
        setLoading(true);
        setError('');
        fetchJson(`/api/dragonfly/members/${id}`)
            .then((data) => {
                if (!cancelled) setMember(data);
            })
            .catch(() => {
                if (!cancelled) {
                    setMember(null);
                    setError('メンバー情報を取得できませんでした');
                }
            })
            .finally(() => {
                if (!cancelled) setLoading(false);
            });
        return () => {
            cancelled = true;
        };
    }, [targetMemberId]);

    if (targetMemberId == null || targetMemberId === '') {
        return null;
    }
    if (loading) {
        return (
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, py: 1 }}>
                <CircularProgress size={20} />
                <Typography variant="body2" color="text.secondary">
                    相手の情報を読込中…
                </Typography>
            </Box>
        );
    }
    if (error) {
        return (
            <Typography variant="body2" color="error" sx={{ py: 1 }}>
                {error}
            </Typography>
        );
    }
    if (!member) {
        return null;
    }

    const no = member.display_no != null ? `#${member.display_no}` : '';
    const title = [no, member.name].filter(Boolean).join(' ').trim() || `メンバー #${member.id}`;

    return (
        <Card variant="outlined" sx={{ mt: 1, mb: 1 }}>
            <CardContent sx={{ py: 1.5, '&:last-child': { pb: 1.5 } }}>
                <Typography variant="subtitle1" component="div">
                    {title}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                    {formatCategoryLine(member)}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                    役職: {member.current_role ?? '—'}
                </Typography>
            </CardContent>
        </Card>
    );
}

/** 相手（target_member_id）確定後に GET /api/dragonfly/members/{id} でサマリ表示（ONETOONES_CREATE_UX_P1） */
export function TargetMemberSummaryCard() {
    return (
        <FormDataConsumer>
            {({ formData }) => <TargetMemberSummaryInner targetMemberId={formData?.target_member_id} />}
        </FormDataConsumer>
    );
}

const DURATION_CHOICES = [30, 60, 90];

/**
 * 開始予定 + 所要時間（親 state）。ended_at は Create の transform で付与（ONETOONES_CREATE_UX_P1）。
 */
export function OneToOneCreateScheduleFields({ duration, onDurationChange }) {
    const { control } = useFormContext();
    const scheduledAt = useWatch({ control, name: 'scheduled_at' });

    const preview = addMinutesToEndIso(scheduledAt, duration);
    let previewText = '—';
    if (preview) {
        try {
            previewText = new Date(preview).toLocaleString('ja-JP', { dateStyle: 'short', timeStyle: 'short' });
        } catch {
            previewText = preview;
        }
    }

    return (
        <>
            <DateTimeInput source="scheduled_at" label="開始予定" />
            <Typography variant="caption" color="text.secondary" display="block" sx={{ mt: 0.5 }}>
                所要時間（終了予定を自動計算）
            </Typography>
            <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap sx={{ gap: 1, my: 1 }}>
                {DURATION_CHOICES.map((min) => (
                    <Chip
                        key={min}
                        label={`${min}分`}
                        color={duration === min ? 'primary' : 'default'}
                        variant={duration === min ? 'filled' : 'outlined'}
                        onClick={() => onDurationChange(min)}
                        size="small"
                    />
                ))}
            </Stack>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                終了予定（自動）: {previewText}
            </Typography>
        </>
    );
}

function meetingOptionLabel(record) {
    if (!record) return '';
    const num = record.number != null ? record.number : '—';
    const held = record.held_on ?? '—';
    const name = record.name ?? '';
    return `第${num}回 / ${held} / ${name}`;
}

/** GET /api/meetings を Autocomplete で選択（ONETOONES_CREATE_UX_P1） */
export function OneToOneMeetingReferenceInput() {
    return (
        <ReferenceInput source="meeting_id" reference="meetings" perPage={200}>
            <AutocompleteInput
                optionText={(record) => meetingOptionLabel(record)}
                label="関連例会（任意）"
                emptyText="未選択"
                sx={{ minWidth: 280 }}
            />
        </ReferenceInput>
    );
}
