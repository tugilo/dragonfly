/** SPEC-018: meeting type UI helpers (supports flags + import help). */

export const SESSION_TEAM_MEETING = 'team_meeting';

export function meetingTypeCode(record) {
    return record?.meeting_type_code ?? record?.session_type ?? 'chapter_weekly';
}

export function supportsParticipants(record) {
    if (record?.supports_participants != null) {
        return Boolean(record.supports_participants);
    }

    return meetingTypeCode(record) !== SESSION_TEAM_MEETING;
}

export function supportsBreakouts(record) {
    if (record?.supports_breakouts != null) {
        return Boolean(record.supports_breakouts);
    }

    return meetingTypeCode(record) !== SESSION_TEAM_MEETING;
}

export function supportsReferralSuggestions(record) {
    if (record?.supports_referral_suggestions != null) {
        return Boolean(record.supports_referral_suggestions);
    }

    return meetingTypeCode(record) !== SESSION_TEAM_MEETING;
}

export function visibleDrawerTabs(record) {
    const tabs = ['overview'];

    if (supportsParticipants(record)) {
        tabs.push('participants');
    }
    if (supportsBreakouts(record)) {
        tabs.push('bo');
    }
    tabs.push('memo');

    return tabs;
}

export function minutesImportHelp(record) {
    if (meetingTypeCode(record) === SESSION_TEAM_MEETING) {
        return '議事録は未取り込みです。`dragonfly:import-team-minutes` で Markdown から取り込んでください。';
    }

    return '議事録は未取り込みです。`dragonfly:import-chapter-minutes` で Markdown から取り込んでください。';
}

export function resolveDefaultDrawerTabForMeeting(meeting) {
    if (!supportsBreakouts(meeting)) {
        return 'overview';
    }
    if (!meeting?.held_on) {
        return 'overview';
    }
    const d = String(meeting.held_on).slice(0, 10);
    if (!/^\d{4}-\d{2}-\d{2}$/.test(d)) {
        return 'overview';
    }
    const today = new Date();
    const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;

    return d >= todayStr ? 'bo' : 'overview';
}
