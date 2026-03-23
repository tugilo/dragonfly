import React from 'react';
import { SelectInput, TextInput, DateTimeInput, required } from 'react-admin';
import { useFormContext, useWatch } from 'react-hook-form';
import { Box, Typography } from '@mui/material';
import {
    MemberSearchAutocompleteInput,
    OwnerScopedTargetSelect,
    TargetMemberSummaryCard,
    OneToOneCreateScheduleFields,
    OneToOneMeetingReferenceInput,
} from './OneToOnesFormParts';

export const ONE_TO_ONE_STATUS_CHOICES = [
    { id: 'planned', name: '予定' },
    { id: 'completed', name: '実施済み' },
    { id: 'canceled', name: 'キャンセル' },
];

const NOTES_LABEL = 'メモ（この1to1の記録・目的・アジェンダ）';
const NOTES_HELPER_CREATE =
    '会話の時系列ログは contact_memos 側で将来拡張する想定。この欄は当該1to1レコードの要約メモとして使います。';
const NOTES_HELPER_EDIT =
    '一覧の「📝 メモ」と同じ要約です。下の「履歴メモ」で会話ログを追記できます。';

/**
 * Create / Edit 共通の 1to1 フォーム本体（ONETOONES_EDIT_UX_P2）。
 *
 * @param {'create'|'edit'} props.mode
 * @param {Array<object>} props.ownerMemberOptions
 * @param {number} props.durationMinutes
 * @param {(n: number) => void} props.onDurationChange
 * @param {string} [props.statusHelperText] — Edit 用（キャンセル方針など）
 */
export function OneToOneFormFields({ mode, ownerMemberOptions, durationMinutes, onDurationChange, statusHelperText }) {
    const { control } = useFormContext();
    const status = useWatch({ control, name: 'status' });

    return (
        <>
            {mode === 'create' && (
                <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                    Owner（自分）は Dashboard の設定が初期値です。別メンバーで記録する場合のみ変更してください。
                </Typography>
            )}
            <MemberSearchAutocompleteInput
                source="owner_member_id"
                label="Owner（自分）"
                options={ownerMemberOptions}
                validate={[required()]}
            />
            <OwnerScopedTargetSelect />
            <TargetMemberSummaryCard />
            <SelectInput
                source="status"
                choices={ONE_TO_ONE_STATUS_CHOICES}
                label="状態"
                helperText={statusHelperText}
            />
            <OneToOneCreateScheduleFields duration={durationMinutes} onDurationChange={onDurationChange} />
            {mode === 'edit' && status === 'completed' && (
                <Box sx={{ mt: 2 }}>
                    <Typography variant="subtitle2" gutterBottom sx={{ fontWeight: 700 }}>
                        実績
                    </Typography>
                    <DateTimeInput source="started_at" label="開始日時" />
                    <DateTimeInput source="ended_at" label="終了日時" />
                </Box>
            )}
            <OneToOneMeetingReferenceInput />
            <TextInput
                source="notes"
                label={NOTES_LABEL}
                multiline
                fullWidth
                minRows={mode === 'create' ? 3 : 4}
                helperText={mode === 'create' ? NOTES_HELPER_CREATE : NOTES_HELPER_EDIT}
            />
        </>
    );
}
