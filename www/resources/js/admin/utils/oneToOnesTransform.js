/**
 * 1 to 1 Create/Edit の送信ペイロード正規化（ONETOONES_EDIT_UX_P2）。
 * Create を正とし、scheduled_at の ISO 化・meeting_id の正規化・所要時間からの ended_at を共通化。
 */

/**
 * @param {unknown} meetingId
 * @returns {number|null}
 */
export function normalizeMeetingId(meetingId) {
    let mid = meetingId;
    if (mid != null && typeof mid === 'object' && mid.id != null) {
        mid = mid.id;
    }
    if (mid === '' || mid === undefined || mid === null) {
        return null;
    }
    const n = Number(mid);
    return Number.isNaN(n) ? null : n;
}

/**
 * @param {unknown} v
 * @returns {string|null}
 */
function toIsoOrNull(v) {
    if (v == null || v === '') {
        return null;
    }
    const d = new Date(v);
    return Number.isNaN(d.getTime()) ? null : d.toISOString();
}

/**
 * 編集画面の所要時間チップ初期値（scheduled / ended から推定。completed は実績と混ざるため 60 固定）。
 *
 * @param {string|Date|undefined|null} scheduledAt
 * @param {string|Date|undefined|null} endedAt
 * @param {string|undefined|null} status
 * @returns {number}
 */
export function inferDurationMinutes(scheduledAt, endedAt, status) {
    if (status === 'completed') {
        return 60;
    }
    if (!scheduledAt || !endedAt) {
        return 60;
    }
    const s = new Date(scheduledAt).getTime();
    const e = new Date(endedAt).getTime();
    if (Number.isNaN(s) || Number.isNaN(e) || e <= s) {
        return 60;
    }
    const m = Math.round((e - s) / 60000);
    const choices = [30, 60, 90];
    if (choices.includes(m)) {
        return m;
    }
    return choices.reduce((a, b) => (Math.abs(b - m) < Math.abs(a - m) ? b : a));
}

/**
 * @param {object} data - react-admin フォーム値
 * @param {number} durationMinutes
 * @param {{ mode?: 'create'|'edit', workspaceId?: number|null }} options
 * @returns {object}
 */
export function buildOneToOnePayload(data, durationMinutes, options = {}) {
    const { mode = 'create', workspaceId } = options;
    const meeting_id = normalizeMeetingId(data.meeting_id);
    const status = data.status;
    const scheduledRaw = data.scheduled_at;

    let scheduled_at = null;
    let ended_at = null;
    let started_at = null;

    if (scheduledRaw) {
        const start = new Date(scheduledRaw);
        if (!Number.isNaN(start.getTime())) {
            scheduled_at = start.toISOString();
            if (mode === 'edit' && status === 'completed') {
                started_at = toIsoOrNull(data.started_at);
                ended_at = toIsoOrNull(data.ended_at);
            } else if (durationMinutes > 0) {
                const end = new Date(start.getTime());
                end.setMinutes(end.getMinutes() + durationMinutes);
                ended_at = end.toISOString();
            }
        }
    } else if (mode === 'edit' && status === 'completed') {
        started_at = toIsoOrNull(data.started_at);
        ended_at = toIsoOrNull(data.ended_at);
    }

    if (mode === 'create') {
        started_at = null;
    } else if (status !== 'completed') {
        started_at = null;
    }

    const notesRaw = data.notes;
    const notesTrimmed =
        notesRaw == null || notesRaw === ''
            ? null
            : String(notesRaw).trim() === ''
              ? null
              : String(notesRaw).trim();

    const payload = {
        owner_member_id: data.owner_member_id,
        target_member_id: data.target_member_id,
        meeting_id,
        status: data.status,
        scheduled_at,
        started_at,
        ended_at,
        notes: notesTrimmed,
    };

    if (mode === 'create') {
        return {
            ...payload,
            workspace_id: workspaceId ?? undefined,
        };
    }

    return payload;
}
