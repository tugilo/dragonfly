import React, { useCallback } from 'react';
import { useNotify } from 'react-admin';
import { ReferralSuggestionDialogCore } from '../components/ReferralSuggestionDialogCore';
import {
    fetchOneToOneReferralSuggestions,
    generateOneToOneReferralSuggestions,
} from '../referralSuggestionApi';

export function OneToOneReferralSuggestionDialog({ open, onClose, record }) {
    const notify = useNotify();
    const oneToOneId = record?.id;

    const fetchSuggestions = useCallback(
        (runId) => {
            if (!oneToOneId) return Promise.reject(new Error('1 to 1 ID がありません'));
            return fetchOneToOneReferralSuggestions(oneToOneId, runId);
        },
        [oneToOneId],
    );

    const generateSuggestions = useCallback(() => {
        if (!oneToOneId) return Promise.reject(new Error('1 to 1 ID がありません'));
        return generateOneToOneReferralSuggestions(oneToOneId);
    }, [oneToOneId]);

    const title = record?.target_name
        ? `リファーラル提案 — ${record.target_name}`
        : 'リファーラル提案（1 to 1）';

    const subtitleParts = [];
    if (record?.target_workspace_name) subtitleParts.push(`相手所属: ${record.target_workspace_name}`);
    if (record?.started_at || record?.completed_at) {
        const d = record.started_at || record.completed_at;
        try {
            subtitleParts.push(new Date(d).toLocaleDateString('ja-JP'));
        } catch {
            /* ignore */
        }
    }

    return (
        <ReferralSuggestionDialogCore
            open={open}
            onClose={onClose}
            title={title}
            subtitle={subtitleParts.join(' · ') || null}
            sourceMarkdown={record?.notes ?? ''}
            sourceLoading={false}
            kind="one_to_one"
            fetchSuggestions={fetchSuggestions}
            generateSuggestions={generateSuggestions}
            notify={notify}
        />
    );
}
