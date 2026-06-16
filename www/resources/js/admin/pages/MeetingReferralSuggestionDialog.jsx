import React, { useCallback, useEffect, useState } from 'react';
import { useNotify } from 'react-admin';
import { religoFetch } from '../religoApiFetch';
import { meetingDisplayLabel } from '../meetingLabel';
import { ReferralSuggestionDialogCore } from '../components/ReferralSuggestionDialogCore';
import {
    fetchMeetingReferralSuggestions,
    generateMeetingReferralSuggestions,
} from '../referralSuggestionApi';

async function fetchMeetingMinutesMarkdown(meetingId) {
    const res = await religoFetch(`/api/meetings/${meetingId}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`議事録の取得に失敗しました (${res.status})`);
    const data = await res.json();
    return data?.minutes?.body_markdown ?? '';
}

export function MeetingReferralSuggestionDialog({ open, onClose, meeting, minutesMarkdown }) {
    const notify = useNotify();
    const meetingId = meeting?.id;
    const [markdown, setMarkdown] = useState(minutesMarkdown ?? '');
    const [markdownLoading, setMarkdownLoading] = useState(false);

    useEffect(() => {
        if (!open || !meetingId) {
            setMarkdown('');
            return;
        }
        if (minutesMarkdown?.trim()) {
            setMarkdown(minutesMarkdown);
            return;
        }
        let cancelled = false;
        setMarkdownLoading(true);
        fetchMeetingMinutesMarkdown(meetingId)
            .then((body) => { if (!cancelled) setMarkdown(body); })
            .catch(() => { if (!cancelled) setMarkdown(''); })
            .finally(() => { if (!cancelled) setMarkdownLoading(false); });
        return () => { cancelled = true; };
    }, [open, meetingId, minutesMarkdown]);

    const fetchSuggestions = useCallback(
        (runId) => {
            if (!meetingId) return Promise.reject(new Error('例会 ID がありません'));
            return fetchMeetingReferralSuggestions(meetingId, runId);
        },
        [meetingId],
    );

    const generateSuggestions = useCallback(() => {
        if (!meetingId) return Promise.reject(new Error('例会 ID がありません'));
        return generateMeetingReferralSuggestions(meetingId);
    }, [meetingId]);

    const title = meeting
        ? `リファーラル提案 — ${meeting.display_label ?? meetingDisplayLabel(meeting)}`
        : 'リファーラル提案（定例会）';

    let defaultIntroducedAt = '';
    if (meeting?.held_on) {
        try {
            const ho = meeting.held_on;
            defaultIntroducedAt = typeof ho === 'string' && ho.length >= 10 ? ho.slice(0, 10) : new Date(ho).toISOString().slice(0, 10);
        } catch {
            /* ignore */
        }
    }

    const subtitleParts = [];
    if (meeting?.name) subtitleParts.push(meeting.name);
    if (meeting?.held_on) {
        try {
            subtitleParts.push(new Date(meeting.held_on).toLocaleDateString('ja-JP'));
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
            sourceMarkdown={markdown}
            sourceLoading={markdownLoading}
            kind="meeting"
            fetchSuggestions={fetchSuggestions}
            generateSuggestions={generateSuggestions}
            notify={notify}
            defaultIntroducedAt={defaultIntroducedAt}
        />
    );
}
