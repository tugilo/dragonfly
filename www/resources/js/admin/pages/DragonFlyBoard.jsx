import React, { useState, useEffect, useCallback, useRef, useMemo } from 'react';
import { Link } from 'react-router-dom';
import {
    Box,
    Stack,
    TextField,
    Autocomplete,
    Typography,
    FormControlLabel,
    Switch,
    Button,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    Menu,
    Chip,
    IconButton,
    Snackbar,
} from '@mui/material';
import EditNoteIcon from '@mui/icons-material/EditNote';

const API = '';
const TOGGLE_DEBOUNCE_MS = 300;
const MEMO_TYPES = [
    { value: 'other', label: 'その他' },
    { value: 'meeting', label: '例会' },
    { value: 'one_to_one', label: '1 to 1' },
    { value: 'introduction', label: '紹介' },
];
const O2O_STATUSES = [
    { value: 'planned', label: '予定' },
    { value: 'completed', label: '実施済み' },
    { value: 'canceled', label: 'キャンセル' },
];

async function fetchJson(url) {
    const res = await fetch(`${API}${url}`, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

async function putFlags(ownerMemberId, targetMemberId, data) {
    const res = await fetch(
        `${API}/api/dragonfly/flags/${targetMemberId}?owner_member_id=${ownerMemberId}`,
        {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
            body: JSON.stringify(data),
        }
    );
    if (!res.ok) throw new Error(`PUT flags ${res.status}`);
    return res.json();
}

async function postContactMemo(payload) {
    const res = await fetch(`${API}/api/contact-memos`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
    });
    if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.message || `POST contact-memos ${res.status}`);
    }
    return res.json();
}

async function postOneToOne(payload) {
    const res = await fetch(`${API}/api/one-to-ones`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
    });
    if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.message || `POST one-to-ones ${res.status}`);
    }
    return res.json();
}

async function getMeetingBreakouts(meetingId) {
    return fetchJson(`/api/meetings/${meetingId}/breakouts`);
}

/** C-7: Relationship Score 0..5 from ContactSummary (UI only) */
function calculateRelationshipScore(summary) {
    if (!summary) return 0;
    let s = 0;
    const same = summary.same_room_count ?? 0;
    if (same >= 10) s += 2;
    else if (same >= 5) s += 1;
    const memos = summary.latest_memos ?? [];
    if (memos.length > 0) s += 1;
    if (summary.flags?.interested) s += 1;
    if (summary.flags?.want_1on1) s += 1;
    return Math.min(5, Math.max(0, s));
}

const STARS = ['☆☆☆☆☆', '★☆☆☆☆', '★★☆☆☆', '★★★☆☆', '★★★★☆', '★★★★★'];

/** Build pseudo-summary from summary_lite for score calculation */
function summaryLiteToPseudoSummary(lite) {
    if (!lite) return null;
    const memos = lite.last_memo ? [{ updated_at: lite.last_memo.created_at, body: lite.last_memo.body }] : [];
    return {
        same_room_count: lite.same_room_count ?? 0,
        latest_memos: memos,
        flags: { interested: lite.interested ?? false, want_1on1: lite.want_1on1 ?? false },
    };
}

/** C-8: Introduction hints from members (summary_lite). Max 3 pairs. */
function calculateIntroductionHints(members, calculateRelationshipScoreFn) {
    if (!Array.isArray(members) || !calculateRelationshipScoreFn) return [];
    const withContact = members.filter((m) => {
        const lite = m.summary_lite;
        if (!lite) return false;
        if ((lite.same_room_count ?? 0) < 3) return false;
        if (lite.want_1on1 === true) return false;
        const pseudo = summaryLiteToPseudoSummary(lite);
        const score = calculateRelationshipScoreFn(pseudo);
        return score >= 2;
    });
    const categoryKey = (m) => (m.category?.name || m.category?.group_name || '').trim();
    const nameStr = (m) => formatMemberPrimaryLine(m) || m.name || `#${m.id}`;
    const pairs = [];
    for (let i = 0; i < withContact.length; i++) {
        for (let j = i + 1; j < withContact.length; j++) {
            const a = withContact[i];
            const b = withContact[j];
            if (categoryKey(a) === categoryKey(b)) continue;
            const scoreA = calculateRelationshipScoreFn(summaryLiteToPseudoSummary(a.summary_lite));
            const scoreB = calculateRelationshipScoreFn(summaryLiteToPseudoSummary(b.summary_lite));
            pairs.push({
                from: { member: a, category: categoryKey(a) || '—', name: nameStr(a), score: scoreA },
                to: { member: b, category: categoryKey(b) || '—', name: nameStr(b), score: scoreB },
                priority: (a.summary_lite?.same_room_count ?? 0) + (b.summary_lite?.same_room_count ?? 0) + scoreA + scoreB,
            });
        }
    }
    pairs.sort((x, y) => y.priority - x.priority);
    return pairs.slice(0, 3).map((p) => ({
        from: p.from,
        to: p.to,
    }));
}

async function getMeetings() {
    return fetchJson('/api/meetings');
}

async function putMeetingBreakouts(meetingId, payload) {
    const res = await fetch(`${API}/api/meetings/${meetingId}/breakouts`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
    });
    if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.message || `PUT breakouts ${res.status}`);
    }
    return res.json();
}

/**
 * Connections 共通: 1 行目（主表示）— display_no + name。空なら #id
 * SSOT: CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md §4
 */
function formatMemberPrimaryLine(member) {
    if (!member || member.id == null) return '';
    const line = `${member.display_no || ''} ${member.name || ''}`.trim();
    return line || `#${member.id}`;
}

/**
 * Connections 共通: 2 行目（副表示）— 大/実カテゴリ、なければ current_role。どちらも無ければ null（行を出さない）
 */
function formatMemberSecondaryLine(member) {
    if (!member) return null;
    const cat = [member.category?.group_name, member.category?.name].filter(Boolean).join(' / ');
    if (cat) return cat;
    const role = (member.current_role || '').trim();
    return role || null;
}

/** Autocomplete の filter / 入力補助用: 主＋副を 1 文字列に（副が無ければ主のみ） */
function formatMemberAutocompleteLabel(member) {
    if (!member) return '';
    const p = formatMemberPrimaryLine(member);
    const s = formatMemberSecondaryLine(member);
    return s ? `${p} ${s}` : p;
}

export default function DragonFlyBoard() {
    const [ownerMemberId, setOwnerMemberId] = useState(1);
    const [members, setMembers] = useState([]);
    const [targetMember, setTargetMember] = useState(null);
    const [summary, setSummary] = useState(null);
    const [loadingSummary, setLoadingSummary] = useState(false);
    const [pendingFlags, setPendingFlags] = useState(null);
    const debounceRef = useRef(null);

    // メモ追加モーダル
    const [memoOpen, setMemoOpen] = useState(false);
    const [memoBody, setMemoBody] = useState('');
    const [memoType, setMemoType] = useState('other');
    const [memoMeetingId, setMemoMeetingId] = useState('');
    const [memoOneToOneId, setMemoOneToOneId] = useState('');
    const [memoError, setMemoError] = useState('');
    const [memoSubmitting, setMemoSubmitting] = useState(false);

    // 1 to 1 登録モーダル
    const [o2oOpen, setO2oOpen] = useState(false);
    const [firstWorkspace, setFirstWorkspace] = useState(null);
    const [workspaceLoadError, setWorkspaceLoadError] = useState('');
    const [o2oStatus, setO2oStatus] = useState('planned');
    const [o2oDate, setO2oDate] = useState('');
    const [o2oStartTime, setO2oStartTime] = useState('');
    const [o2oEndTime, setO2oEndTime] = useState('');
    const [o2oNotes, setO2oNotes] = useState('');
    const [o2oMeetingId, setO2oMeetingId] = useState('');
    const [o2oError, setO2oError] = useState('');
    const [o2oSubmitting, setO2oSubmitting] = useState(false);

    // Meeting + BO（Round なし。BO はデフォルト 2）
    const [meetings, setMeetings] = useState([]);
    const [selectedMeetingId, setSelectedMeetingId] = useState('');
    const [selectedMeeting, setSelectedMeeting] = useState(null);
    const [roundsEdit, setRoundsEdit] = useState([]);
    const [roundsLoading, setRoundsLoading] = useState(false);
    const [roundsSaving, setRoundsSaving] = useState(false);
    const [roundsError, setRoundsError] = useState('');
    const [selectedRoundIndex, setSelectedRoundIndex] = useState(0);
    const [saveStatus, setSaveStatus] = useState('idle'); // 'idle' | 'loading' | 'saved' | 'unsaved'
    const [dirty, setDirty] = useState(false);
    const savedTimeoutRef = useRef(null);

    // C-2: Members pane search
    const [memberSearch, setMemberSearch] = useState('');
    const filteredMembers = useMemo(() => {
        if (!memberSearch.trim()) return members;
        const q = memberSearch.trim().toLowerCase();
        return members.filter((m) => {
            const name = `${m.display_no || ''} ${m.name}`.trim().toLowerCase();
            const cat = (m.category?.group_name || '') + (m.category?.name || '') + (m.current_role || '');
            return name.includes(q) || cat.toLowerCase().includes(q);
        });
    }, [members, memberSearch]);

    // メモモーダル（BO から開くときの文脈）
    const [memoContextTargetMemberId, setMemoContextTargetMemberId] = useState(null);
    const [memoContextMeetingId, setMemoContextMeetingId] = useState(null);
    const [memoContextRoundLabel, setMemoContextRoundLabel] = useState('');
    const [memoContextRoomLabel, setMemoContextRoomLabel] = useState('');
    const [snackbarMessage, setSnackbarMessage] = useState('');

    // 左ペイン：メンバー tap で BO 割当メニュー
    const [assignToBoAnchor, setAssignToBoAnchor] = useState(null);
    const [assignToBoMember, setAssignToBoMember] = useState(null);

    // BO メンバーチップタップで表示するメンバー詳細モーダル
    const [memberDetailModalMember, setMemberDetailModalMember] = useState(null);

    const refetchMembers = useCallback(() => {
        fetchJson(`/api/dragonfly/members?owner_member_id=${ownerMemberId}&with_summary=1`)
            .then(setMembers)
            .catch((e) => console.error('members load failed', e));
    }, [ownerMemberId]);

    useEffect(() => {
        refetchMembers();
    }, [refetchMembers]);

    useEffect(() => {
        fetchJson('/api/workspaces')
            .then((data) => {
                if (Array.isArray(data) && data.length > 0) {
                    setFirstWorkspace({ id: data[0].id, name: data[0].name || `ID: ${data[0].id}` });
                    setWorkspaceLoadError('');
                } else {
                    setFirstWorkspace(null);
                    setWorkspaceLoadError('workspace が未作成です。seed で 1 件作成してください。');
                }
            })
            .catch(() => {
                setFirstWorkspace(null);
                setWorkspaceLoadError('workspace の取得に失敗しました。');
            });
    }, []);

    useEffect(() => {
        getMeetings().then(setMeetings).catch(() => setMeetings([]));
    }, []);

    useEffect(() => {
        if (!selectedMeetingId) {
            setRoundsEdit([]);
            setSelectedMeeting(null);
            setSaveStatus('idle');
            setDirty(false);
            return;
        }
        setTargetMember(null);
        const meeting = meetings.find((m) => String(m.id) === String(selectedMeetingId));
        setSelectedMeeting(meeting || null);
        setRoundsLoading(true);
        setRoundsError('');
        setSaveStatus('loading');
        getMeetingBreakouts(selectedMeetingId)
            .then((data) => {
                const rooms = Array.isArray(data.rooms) ? data.rooms : [];
                setRoundsEdit([{
                    round_no: 1,
                    label: 'BO',
                    rooms: rooms.map((room) => ({
                        room_label: room.room_label,
                        notes: room.notes ?? '',
                        member_ids: Array.isArray(room.member_ids) ? [...room.member_ids] : [],
                    })),
                }]);
            })
            .catch((e) => {
                setRoundsError(e.message || 'BO 取得に失敗しました');
                setRoundsEdit([]);
            })
            .finally(() => {
                setRoundsLoading(false);
                setSaveStatus('idle');
                setDirty(false);
            });
    }, [selectedMeetingId, meetings]);

    const loadSummary = useCallback(() => {
        if (!targetMember?.id || !ownerMemberId) return;
        setLoadingSummary(true);
        fetchJson(
            `/api/dragonfly/contacts/${targetMember.id}/summary?owner_member_id=${ownerMemberId}`
        )
            .then((s) => {
                setSummary(s);
                setPendingFlags(null);
            })
            .catch((e) => {
                console.error('summary load failed', e);
                setSummary(null);
                setPendingFlags(null);
            })
            .finally(() => setLoadingSummary(false));
    }, [targetMember?.id, ownerMemberId]);

    useEffect(() => {
        loadSummary();
    }, [loadSummary]);

    // C-4: 1to1 history for selected member (Relationship Log)
    const [oneToOnes, setOneToOnes] = useState([]);
    const refetchOneToOnes = useCallback(() => {
        if (!targetMember?.id || !ownerMemberId) {
            setOneToOnes([]);
            return;
        }
        fetchJson(`/api/one-to-ones?owner_member_id=${ownerMemberId}&target_member_id=${targetMember.id}`)
            .then((data) => setOneToOnes(Array.isArray(data) ? data : []))
            .catch(() => setOneToOnes([]));
    }, [targetMember?.id, ownerMemberId]);
    useEffect(() => {
        refetchOneToOnes();
    }, [refetchOneToOnes]);

    const handleToggle = (field, value) => {
        if (!targetMember?.id || !summary?.flags) return;
        const next = { ...summary.flags, [field]: value };
        setPendingFlags(next);

        if (debounceRef.current) clearTimeout(debounceRef.current);
        debounceRef.current = setTimeout(async () => {
            debounceRef.current = null;
            try {
                await putFlags(ownerMemberId, targetMember.id, {
                    interested: next.interested,
                    want_1on1: next.want_1on1,
                });
                loadSummary();
            } catch (e) {
                console.error('PUT flags failed', e);
                setPendingFlags(null);
            }
        }, TOGGLE_DEBOUNCE_MS);
    };

    const displayFlags = pendingFlags ?? summary?.flags ?? { interested: false, want_1on1: false };
    const latestMemos = summary?.latest_memos ?? [];
    const interestedReason = summary?.latest_interested_reason;

    // C-6: Next Action rules (client-side, max 3)
    const nextActions = useMemo(() => {
        if (!summary) return [];
        const actions = [];
        const sameRoom = summary.same_room_count ?? 0;
        const o2oCount = summary.one_on_one_count ?? oneToOnes.length ?? 0;
        const memos = summary.latest_memos ?? [];
        const hasPlanned = (oneToOnes || []).some((o) => o.status === 'planned');
        const meetingMemosCount = (memos || []).filter((m) => m.meeting_id).length;

        if (sameRoom >= 3 && o2oCount === 0) {
            actions.push({ id: 'a', label: '1to1を提案', action: '1to1' });
        }
        if ((memos || []).length === 0) {
            actions.push({ id: 'b', label: 'メモを書く', action: 'memo' });
        }
        if (hasPlanned) {
            actions.push({ id: 'c', label: '実施後メモを残す', action: 'memo' });
        }
        if (meetingMemosCount >= 2) {
            actions.push({ id: 'd', label: '紹介メモ整理', action: 'memo' });
        }
        return actions.slice(0, 3);
    }, [summary, oneToOnes]);

    // C-8: Introduction hints from members (summary_lite)
    const introductionHints = useMemo(
        () => calculateIntroductionHints(members, calculateRelationshipScore),
        [members]
    );

    const canSubmitMemo =
        memoBody.trim() !== '' &&
        (memoType !== 'meeting' || memoContextMeetingId != null || memoMeetingId.trim() !== '') &&
        (memoType !== 'one_to_one' || memoOneToOneId.trim() !== '');

    const openMemoDialog = () => {
        setMemoBody('');
        setMemoType('other');
        setMemoMeetingId('');
        setMemoOneToOneId('');
        setMemoError('');
        setMemoContextTargetMemberId(null);
        setMemoContextMeetingId(null);
        if (!selectedMeetingId) {
            setSnackbarMessage('例会メモは中央で Meeting を選択してください');
        }
        setMemoOpen(true);
    };

    const openMemoDialogForMeetingMember = (meetingId, memberId, roundLabel, roomLabel) => {
        setMemoBody('');
        setMemoType('meeting');
        setMemoMeetingId(String(meetingId));
        setMemoOneToOneId('');
        setMemoError('');
        setMemoContextTargetMemberId(memberId);
        setMemoContextMeetingId(meetingId);
        setMemoContextRoundLabel(roundLabel ?? '');
        setMemoContextRoomLabel(roomLabel ?? '');
        setMemoOpen(true);
    };

    const closeMemoDialog = () => {
        setMemoOpen(false);
        setMemoError('');
        setMemoContextTargetMemberId(null);
        setMemoContextMeetingId(null);
        setMemoContextRoundLabel('');
        setMemoContextRoomLabel('');
    };

    const submitMemo = async () => {
        const targetId = memoContextTargetMemberId ?? targetMember?.id;
        if (!targetId || !ownerMemberId || !canSubmitMemo) return;
        if (memoType === 'meeting' && !(memoContextMeetingId ?? memoMeetingId.trim())) return;
        setMemoSubmitting(true);
        setMemoError('');
        const payload = {
            owner_member_id: ownerMemberId,
            target_member_id: targetId,
            memo_type: memoType,
            body: memoBody.trim(),
        };
        if (memoType === 'meeting') {
            payload.meeting_id = memoContextMeetingId ?? parseInt(memoMeetingId, 10);
        }
        if (memoType === 'one_to_one' && memoOneToOneId.trim() !== '') {
            payload.one_to_one_id = parseInt(memoOneToOneId, 10);
        }
        try {
            await postContactMemo(payload);
            refetchMembers();
            loadSummary();
            if (memoContextTargetMemberId != null) {
                setSnackbarMessage('保存しました');
                setMemoBody('');
                setMemoError('');
            } else {
                closeMemoDialog();
                setMemoContextTargetMemberId(null);
                setMemoContextMeetingId(null);
            }
        } catch (e) {
            setMemoError(e.message || '保存に失敗しました');
        } finally {
            setMemoSubmitting(false);
        }
    };

    const canSubmitO2o = firstWorkspace != null;

    const openO2oDialog = () => {
        setO2oStatus('planned');
        const today = new Date().toISOString().slice(0, 10);
        setO2oDate(today);
        setO2oStartTime('');
        setO2oEndTime('');
        setO2oNotes('');
        setO2oMeetingId('');
        setO2oError('');
        setO2oOpen(true);
    };

    const closeO2oDialog = () => {
        setO2oOpen(false);
        setO2oError('');
    };

    const toDateTimeLocal = (s) => {
        if (!s || s.trim() === '') return null;
        const t = s.trim().replace('T', ' ');
        return t.length <= 16 ? `${t}:00` : t;
    };

    const submitO2o = async () => {
        if (!targetMember?.id || !ownerMemberId || !canSubmitO2o) return;
        setO2oSubmitting(true);
        setO2oError('');
        const payload = {
            workspace_id: firstWorkspace.id,
            owner_member_id: ownerMemberId,
            target_member_id: targetMember.id,
            status: o2oStatus,
        };
        if (o2oDate.trim() && o2oStartTime.trim()) {
            payload.scheduled_at = `${o2oDate.trim()} ${o2oStartTime.trim()}:00`;
            payload.started_at = payload.scheduled_at;
        }
        if (o2oDate.trim() && o2oEndTime.trim()) {
            payload.ended_at = `${o2oDate.trim()} ${o2oEndTime.trim()}:00`;
        }
        if (o2oNotes.trim()) payload.notes = o2oNotes.trim();
        if (o2oMeetingId.trim()) payload.meeting_id = parseInt(o2oMeetingId, 10);
        try {
            await postOneToOne(payload);
            refetchMembers();
            loadSummary();
            refetchOneToOnes();
            closeO2oDialog();
        } catch (e) {
            setO2oError(e.message || '登録に失敗しました');
        } finally {
            setO2oSubmitting(false);
        }
    };

    const addBO = () => {
        setDirty(true);
        setRoundsEdit((prev) => {
            const first = prev[0];
            const rooms = first?.rooms ?? [];
            const nextNo = rooms.length + 1;
            const newRoom = { room_label: `BO${nextNo}`, notes: '', member_ids: [] };
            if (prev.length === 0) {
                return [{ round_no: 1, label: 'BO', rooms: [newRoom] }];
            }
            return [{
                ...first,
                rooms: [...rooms, newRoom],
            }];
        });
    };

    const toggleRoundMember = (roundIndex, roomLabel, memberId) => {
        setDirty(true);
        setRoundsEdit((prev) => {
            const next = prev.map((r, i) => {
                if (i !== roundIndex) return r;
                const rooms = r.rooms.map((room) => {
                    if (room.room_label !== roomLabel) return room;
                    const ids = room.member_ids.includes(memberId)
                        ? room.member_ids.filter((id) => id !== memberId)
                        : [...room.member_ids, memberId];
                    return { ...room, member_ids: ids };
                });
                return { ...r, rooms };
            });
            return next;
        });
    };

    const setRoundRoomNotes = (roundIndex, roomLabel, notes) => {
        setDirty(true);
        setRoundsEdit((prev) =>
            prev.map((r, i) => {
                if (i !== roundIndex) return r;
                const rooms = r.rooms.map((room) =>
                    room.room_label === roomLabel ? { ...room, notes } : room
                );
                return { ...r, rooms };
            })
        );
    };

    /** メンバーを指定 BO に割り当て（他 BO からは外す） */
    const assignMemberToRoom = (memberId, toRoomLabel) => {
        setDirty(true);
        setRoundsEdit((prev) => {
            if (prev.length === 0) return prev;
            const next = prev.map((r, i) => {
                if (i !== 0) return r;
                const rooms = (r.rooms ?? []).map((room) => {
                    const ids = room.member_ids ?? [];
                    const hasMember = ids.includes(memberId);
                    const isTarget = room.room_label === toRoomLabel;
                    if (isTarget && !hasMember) return { ...room, member_ids: [...ids, memberId] };
                    if (hasMember && !isTarget) return { ...room, member_ids: ids.filter((id) => id !== memberId) };
                    return room;
                });
                return { ...r, rooms };
            });
            return next;
        });
    };

    /** メンバーを指定 BO から外す */
    const removeMemberFromRoom = (memberId, roomLabel) => {
        setDirty(true);
        setRoundsEdit((prev) =>
            prev.map((r, i) => {
                if (i !== 0) return r;
                const rooms = (r.rooms ?? []).map((room) =>
                    room.room_label === roomLabel
                        ? { ...room, member_ids: (room.member_ids ?? []).filter((id) => id !== memberId) }
                        : room
                );
                return { ...r, rooms };
            })
        );
    };

    /** この例会の全 BO 割当をクリア（未保存の編集状態のみ） */
    const clearAllAssignments = () => {
        setDirty(true);
        setRoundsEdit((prev) =>
            prev.map((r, i) => {
                if (i !== 0) return r;
                return {
                    ...r,
                    rooms: (r.rooms ?? []).map((room) => ({ ...room, member_ids: [] })),
                };
            })
        );
    };

    const saveRounds = async () => {
        if (!selectedMeetingId) return;
        const rooms = roundsEdit[0]?.rooms ?? [];
        // G11: 同一 BO 内の重複のみ防ぐ。cross-BO は同一 member 可。
        const payloadRooms = rooms.map((room) => ({
            room_label: room.room_label,
            notes: room.notes || null,
            member_ids: [...new Set(room.member_ids ?? [])],
        }));
        setRoundsSaving(true);
        setRoundsError('');
        setSaveStatus('loading');
        try {
            const payload = {
                rooms: payloadRooms,
            };
            await putMeetingBreakouts(selectedMeetingId, payload);
            const data = await getMeetingBreakouts(selectedMeetingId);
            const nextRooms = Array.isArray(data.rooms) ? data.rooms : [];
            setRoundsEdit([{
                round_no: 1,
                label: 'BO',
                rooms: nextRooms.map((room) => ({
                    room_label: room.room_label,
                    notes: room.notes ?? '',
                    member_ids: Array.isArray(room.member_ids) ? [...room.member_ids] : [],
                })),
            }]);
            refetchMembers();
            setDirty(false);
            setSaveStatus('saved');
            setSnackbarMessage('BO割当を保存しました ✓');
            if (savedTimeoutRef.current) clearTimeout(savedTimeoutRef.current);
            savedTimeoutRef.current = setTimeout(() => {
                setSaveStatus('idle');
                savedTimeoutRef.current = null;
            }, 3000);
        } catch (e) {
            setRoundsError(e.message || '保存に失敗しました');
            setSaveStatus('idle');
        } finally {
            setRoundsSaving(false);
        }
    };

    const statusChipLabel =
        roundsLoading ? 'Loading' :
        roundsSaving ? '保存中...' :
        saveStatus === 'saved' ? 'Saved' :
        dirty ? 'Unsaved' : null;

    useEffect(() => {
        const onBeforeUnload = (e) => {
            if (dirty) e.preventDefault();
        };
        window.addEventListener('beforeunload', onBeforeUnload);
        return () => window.removeEventListener('beforeunload', onBeforeUnload);
    }, [dirty]);

    return (
        <Box sx={{ px: 2, py: 2 }}>
            {/* C-1: Page header — SSOT CONNECTIONS_REQUIREMENTS §3.1 */}
            <Box
                sx={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    justifyContent: 'space-between',
                    marginBottom: '18px',
                }}
            >
                <Box>
                    <Typography component="h1" sx={{ fontSize: 21, fontWeight: 700, letterSpacing: -0.3 }}>
                        Connections
                    </Typography>
                    <Typography sx={{ fontSize: 12, color: 'text.secondary', mt: 0.25 }}>
                        Meeting → BO割当 → 関係ログの中心
                    </Typography>
                </Box>
                <Stack direction="row" spacing={1} flexWrap="wrap">
                    <Button
                        variant={dirty ? 'contained' : 'outlined'}
                        size="small"
                        onClick={saveRounds}
                        disabled={roundsSaving || roundsLoading}
                    >
                        {roundsSaving ? '保存中...' : '💾 BO割当を保存'}
                    </Button>
                    <Button component={Link} to="/meetings" variant="outlined" size="small" color="inherit">
                        📋 Meetingsへ
                    </Button>
                </Stack>
            </Box>

            {/* C-1: 3-column grid — 220px | 1fr | 300px, gap 12px */}
            <Box
                sx={{
                    display: 'grid',
                    gridTemplateColumns: '220px 1fr 300px',
                    gap: '12px',
                    height: 'calc(100vh - 120px)',
                    minHeight: 500,
                }}
            >
                {/* Pane 1: Members */}
                <Box
                    sx={{
                        bgcolor: 'background.paper',
                        borderRadius: 2,
                        boxShadow: 1,
                        border: '1px solid',
                        borderColor: 'divider',
                        display: 'flex',
                        flexDirection: 'column',
                        overflow: 'hidden',
                    }}
                >
                    <Box
                        sx={{
                            p: '12px 14px',
                            borderBottom: '1px solid',
                            borderColor: 'divider',
                            bgcolor: '#fafbff',
                            flexShrink: 0,
                        }}
                    >
                        <Typography component="h3" sx={{ fontSize: 13, fontWeight: 700, mb: 1 }}>
                            👥 Members
                        </Typography>
                        <Box
                            sx={{
                                display: 'flex',
                                alignItems: 'center',
                                gap: 0.875,
                                bgcolor: '#f5f5f5',
                                border: '1px solid',
                                borderColor: 'divider',
                                borderRadius: 1,
                                px: 1.25,
                                py: 0.75,
                                minWidth: 180,
                            }}
                        >
                            <span style={{ color: '#999', fontSize: 12 }}>🔍</span>
                            <TextField
                                size="small"
                                placeholder="メンバー検索"
                                value={memberSearch}
                                onChange={(e) => setMemberSearch(e.target.value)}
                                variant="standard"
                                InputProps={{ disableUnderline: true, sx: { fontSize: 12 } }}
                                sx={{ flex: 1, minWidth: 0 }}
                            />
                        </Box>
                    </Box>
                    <Box sx={{ flex: 1, overflowY: 'auto', p: 1.25 }}>
                        {filteredMembers.map((m) => {
                            const name = formatMemberPrimaryLine(m);
                            const sub = formatMemberSecondaryLine(m);
                            const isSel = targetMember?.id === m.id;
                            const hasBoRooms = selectedMeetingId && roundsEdit[0]?.rooms?.length > 0;
                            const openAssignMenu = (e) => {
                                e.stopPropagation();
                                setAssignToBoMember(m);
                                setAssignToBoAnchor(e.currentTarget);
                            };
                            return (
                                <Box
                                    key={m.id}
                                    component="button"
                                    type="button"
                                    onClick={hasBoRooms ? openAssignMenu : () => setTargetMember(m)}
                                    sx={{
                                        display: 'flex',
                                        alignItems: 'center',
                                        gap: 1,
                                        p: '7px 10px',
                                        borderRadius: 1.75,
                                        cursor: 'pointer',
                                        border: 'none',
                                        background: isSel ? 'primary.light' : 'transparent',
                                        borderLeft: isSel ? '3px solid' : '3px solid transparent',
                                        borderColor: 'primary.main',
                                        width: '100%',
                                        textAlign: 'left',
                                        mb: 0.25,
                                        '&:hover': { bgcolor: isSel ? 'primary.light' : '#f5f6fa' },
                                    }}
                                >
                                    <Box
                                        sx={{
                                            width: 30,
                                            height: 30,
                                            borderRadius: '50%',
                                            bgcolor: 'primary.main',
                                            color: 'primary.contrastText',
                                            fontSize: 11,
                                            fontWeight: 700,
                                            display: 'flex',
                                            alignItems: 'center',
                                            justifyContent: 'center',
                                            flexShrink: 0,
                                        }}
                                    >
                                        {(m.name || '?').charAt(0)}
                                    </Box>
                                    <Box sx={{ minWidth: 0, flex: 1 }}>
                                        <Typography sx={{ fontSize: 12, fontWeight: 600 }}>{name}</Typography>
                                        {sub && (
                                            <Typography sx={{ fontSize: 10, color: 'text.secondary' }}>{sub}</Typography>
                                        )}
                                    </Box>
                                    {hasBoRooms && (
                                        <Typography sx={{ fontSize: 10, color: 'text.secondary' }}>＋</Typography>
                                    )}
                                </Box>
                            );
                        })}
                    </Box>
                    <Menu
                        anchorEl={assignToBoAnchor}
                        open={Boolean(assignToBoAnchor)}
                        onClose={() => { setAssignToBoAnchor(null); setAssignToBoMember(null); }}
                        anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}
                        transformOrigin={{ vertical: 'top', horizontal: 'left' }}
                        slotProps={{ paper: { sx: { minWidth: 200 } } }}
                    >
                        <MenuItem
                            onClick={() => {
                                if (assignToBoMember) setTargetMember(assignToBoMember);
                                setAssignToBoAnchor(null);
                                setAssignToBoMember(null);
                            }}
                        >
                            関係ログに表示
                        </MenuItem>
                        {assignToBoMember && roundsEdit[0]?.rooms?.map((room, roomIdx) => {
                            const roomLabel = room.room_label;
                            const boDisplayLabel = `BO${roomIdx + 1}`;
                            const isIn = (room.member_ids ?? []).includes(assignToBoMember.id);
                            return (
                                <MenuItem
                                    key={roomLabel}
                                    onClick={() => {
                                        const mid = assignToBoMember.id;
                                        if (isIn) {
                                            removeMemberFromRoom(mid, roomLabel);
                                        } else {
                                            assignMemberToRoom(mid, roomLabel);
                                        }
                                        setAssignToBoAnchor(null);
                                        setAssignToBoMember(null);
                                    }}
                                >
                                    {isIn ? `${boDisplayLabel} から外す` : `${boDisplayLabel} に追加`}
                                </MenuItem>
                            );
                        })}
                    </Menu>
                </Box>

                {/* Pane 2: Meeting + BO */}
                <Box
                    sx={{
                        bgcolor: 'background.paper',
                        borderRadius: 2,
                        boxShadow: 1,
                        border: '1px solid',
                        borderColor: 'divider',
                        display: 'flex',
                        flexDirection: 'column',
                        overflow: 'hidden',
                    }}
                >
                    <Box
                        sx={{
                            p: '12px 14px',
                            borderBottom: '1px solid',
                            borderColor: 'divider',
                            bgcolor: '#fafbff',
                            flexShrink: 0,
                        }}
                    >
                        <Typography component="h3" sx={{ fontSize: 13, fontWeight: 700, mb: 1 }}>
                            📋 Meeting + BO割当
                        </Typography>
                        <FormControl size="small" fullWidth sx={{ mt: 0 }}>
                            <Select
                                displayEmpty
                                value={selectedMeetingId || ''}
                                onChange={(e) => {
                                    setSelectedMeetingId(e.target.value ? String(e.target.value) : '');
                                    setSelectedRoundIndex(0);
                                }}
                                sx={{ fontSize: 12 }}
                            >
                                <MenuItem value="">例会を選択</MenuItem>
                                {meetings.map((m) => (
                                    <MenuItem key={m.id} value={String(m.id)}>
                                        #{m.number} — {m.held_on}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        <Typography sx={{ fontSize: 11, color: 'text.secondary', mt: 1 }}>
                            各同室枠（BO）にメンバーを割り当て、「BO割当を保存」で反映します。左のメンバーをタップ → 表示されるメニューで BO を選ぶと割り当てできます。
                        </Typography>
                    </Box>
                    <Box sx={{ flex: 1, overflowY: 'auto', p: 1.25 }}>
                        {roundsError && (
                            <Typography color="error" variant="body2" sx={{ mb: 1 }}>
                                {roundsError}
                            </Typography>
                        )}
                        {roundsLoading && <Typography color="text.secondary">Loading...</Typography>}
                        {!roundsLoading && selectedMeetingId && roundsEdit.length > 0 && (() => {
                            const round = roundsEdit[0];
                            const rooms = round.rooms ?? [];
                            return (
                                <>
                                    {rooms.map((room, roomIndex) => {
                                        const roomLabel = room.room_label;
                                        const boDisplayLabel = `BO${roomIndex + 1}`;
                                        // G11: この BO に未割当のメンバーのみ候補。他 BO には同じ member を入れてよい。
                                        const assignedInThisRoom = new Set(room.member_ids ?? []);
                                        return (
                                            <Box
                                                key={`${selectedMeetingId}-${roomLabel}`}
                                                sx={{
                                                    border: '1px solid',
                                                    borderColor: 'divider',
                                                    borderRadius: 1.5,
                                                    mb: 1.25,
                                                    overflow: 'hidden',
                                                }}
                                            >
                                                <Box
                                                    sx={{
                                                        py: 1.25,
                                                        px: 1.5,
                                                        background: 'linear-gradient(135deg, #f0f4ff, #fff)',
                                                        borderBottom: '1px solid',
                                                        borderColor: 'divider',
                                                        display: 'flex',
                                                        alignItems: 'center',
                                                        justifyContent: 'space-between',
                                                    }}
                                                >
                                                    <Typography sx={{ fontSize: 12, fontWeight: 700, color: 'primary.main' }}>
                                                        {boDisplayLabel}
                                                    </Typography>
                                                    <Stack direction="row" spacing={0.5} alignItems="center">
                                                        {roomLabel === 'BO2' && (() => {
                                                            const bo1 = rooms.find((r) => r.room_label === 'BO1');
                                                            return bo1 ? (
                                                                <Button
                                                                    size="small"
                                                                    variant="outlined"
                                                                    sx={{ fontSize: 11 }}
                                                                    onClick={() => {
                                                                        setDirty(true);
                                                                        setRoundsEdit((prev) => {
                                                                            const r0 = prev[0];
                                                                            const rs = r0?.rooms ?? [];
                                                                            const bo1Room = rs.find((r) => r.room_label === 'BO1');
                                                                            const bo2Copy = bo1Room
                                                                                ? { room_label: 'BO2', notes: bo1Room.notes ?? '', member_ids: [...(bo1Room.member_ids ?? [])] }
                                                                                : { room_label: 'BO2', notes: '', member_ids: [] };
                                                                            const nextRooms = rs.filter((r) => r.room_label !== 'BO2').concat(bo2Copy);
                                                                            return [{ ...r0, rooms: nextRooms }];
                                                                        });
                                                                    }}
                                                                >
                                                                    BO1→BO2 コピー
                                                                </Button>
                                                            ) : null;
                                                        })()}
                                                        <Chip label="同室枠" size="small" sx={{ fontSize: 10, height: 20 }} variant="outlined" />
                                                    </Stack>
                                                </Box>
                                                <Box sx={{ p: 1.5 }}>
                                                    <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 0.5 }}>
                                                        割り当てメンバー（左のメンバーをタップ→{boDisplayLabel}を選択）
                                                    </Typography>
                                                    <Autocomplete
                                                        key={`${selectedMeetingId}-${roomLabel}-add`}
                                                        size="small"
                                                        value={null}
                                                        sx={{ width: '100%', mb: 1 }}
                                                        options={members.filter((x) => !assignedInThisRoom.has(x.id))}
                                                        getOptionLabel={(m) => formatMemberAutocompleteLabel(m)}
                                                        onChange={(_, v) => v && toggleRoundMember(0, roomLabel, v.id)}
                                                        renderOption={(props, option) => {
                                                            const { key: optKey, ...optionProps } = props;
                                                            const sec = formatMemberSecondaryLine(option);
                                                            return (
                                                                <Box key={optKey ?? option.id} component="li" {...optionProps}>
                                                                    <Box sx={{ py: 0.25 }}>
                                                                        <Typography sx={{ fontSize: 13, fontWeight: 600 }}>
                                                                            {formatMemberPrimaryLine(option)}
                                                                        </Typography>
                                                                        {sec ? (
                                                                            <Typography sx={{ fontSize: 10, color: 'text.secondary' }}>
                                                                                {sec}
                                                                            </Typography>
                                                                        ) : null}
                                                                    </Box>
                                                                </Box>
                                                            );
                                                        }}
                                                        renderInput={(params) => (
                                                            <TextField
                                                                {...params}
                                                                size="small"
                                                                placeholder={`${boDisplayLabel} に追加するメンバーを検索`}
                                                            />
                                                        )}
                                                    />
                                                    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5, mb: 1 }}>
                                                        {(room.member_ids ?? []).map((id) => {
                                                            const mem = members.find((x) => x.id === id);
                                                            const primary = mem ? formatMemberPrimaryLine(mem) : `#${id}`;
                                                            const secondary = mem ? formatMemberSecondaryLine(mem) : null;
                                                            const ariaBase = primary;
                                                            return (
                                                                <Box
                                                                    key={id}
                                                                    sx={{
                                                                        display: 'flex',
                                                                        alignItems: 'flex-start',
                                                                        justifyContent: 'space-between',
                                                                        gap: 0.5,
                                                                        py: 0.75,
                                                                        px: 1,
                                                                        borderRadius: 1,
                                                                        bgcolor: 'grey.50',
                                                                        border: '1px solid',
                                                                        borderColor: 'divider',
                                                                        '&:hover': { bgcolor: 'grey.100' },
                                                                    }}
                                                                >
                                                                    <Box
                                                                        component="button"
                                                                        type="button"
                                                                        onClick={() => mem && setMemberDetailModalMember(mem)}
                                                                        sx={{
                                                                            flex: 1,
                                                                            minWidth: 0,
                                                                            textAlign: 'left',
                                                                            border: 'none',
                                                                            background: 'none',
                                                                            cursor: mem ? 'pointer' : 'default',
                                                                            py: 0.25,
                                                                            px: 0,
                                                                            color: 'text.primary',
                                                                            '&:hover': mem ? { color: 'primary.main' } : {},
                                                                        }}
                                                                    >
                                                                        <Typography sx={{ fontSize: 13, fontWeight: 600, display: 'block' }}>
                                                                            {primary}
                                                                        </Typography>
                                                                        {secondary ? (
                                                                            <Typography sx={{ fontSize: 10, color: 'text.secondary', display: 'block', mt: 0.125 }}>
                                                                                {secondary}
                                                                            </Typography>
                                                                        ) : null}
                                                                    </Box>
                                                                    <Box sx={{ display: 'flex', alignItems: 'center', flexShrink: 0 }}>
                                                                        <IconButton
                                                                            size="small"
                                                                            onClick={() => openMemoDialogForMeetingMember(selectedMeetingId, id, round.label, roomLabel)}
                                                                            aria-label={`${ariaBase}にメモ`}
                                                                            sx={{ p: 0.35 }}
                                                                        >
                                                                            <EditNoteIcon fontSize="small" />
                                                                        </IconButton>
                                                                        <IconButton
                                                                            size="small"
                                                                            onClick={() => toggleRoundMember(0, roomLabel, id)}
                                                                            aria-label={`${ariaBase}を削除`}
                                                                            sx={{ p: 0.35 }}
                                                                        >
                                                                            <Typography component="span" sx={{ fontSize: 16, lineHeight: 1, color: 'text.secondary' }}>×</Typography>
                                                                        </IconButton>
                                                                    </Box>
                                                                </Box>
                                                            );
                                                        })}
                                                    </Box>
                                                    <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 0.5 }}>
                                                        ルームメモ
                                                    </Typography>
                                                    <TextField
                                                        size="small"
                                                        placeholder="例: 今月のテーマ・共有事項"
                                                        multiline
                                                        minRows={1}
                                                        fullWidth
                                                        value={room.notes ?? ''}
                                                        onChange={(e) => setRoundRoomNotes(0, roomLabel, e.target.value)}
                                                        sx={{
                                                            '& .MuiInput-input': { fontSize: 11, fontStyle: 'italic' },
                                                            bgcolor: '#fffde7',
                                                        }}
                                                    />
                                                    <Button
                                                        variant={dirty ? 'contained' : 'outlined'}
                                                        size="small"
                                                        fullWidth
                                                        onClick={saveRounds}
                                                        disabled={roundsSaving || roundsLoading}
                                                        sx={{ mt: 1 }}
                                                    >
                                                        {roundsSaving ? '保存中...' : `${boDisplayLabel} を保存`}
                                                    </Button>
                                                </Box>
                                            </Box>
                                        );
                                    })}
                                    <Box sx={{ display: 'flex', gap: 1, mt: 1, flexWrap: 'wrap' }}>
                                        <Button variant="outlined" size="small" color="error" onClick={clearAllAssignments}>
                                            割当をクリア
                                        </Button>
                                        <Button variant="outlined" size="small" onClick={addBO}>
                                            ＋ 同室枠を追加
                                        </Button>
                                        <Button
                                            variant={dirty ? 'contained' : 'outlined'}
                                            size="small"
                                            fullWidth
                                            onClick={saveRounds}
                                            disabled={roundsSaving || roundsLoading}
                                        >
                                            {roundsSaving ? '保存中...' : '💾 BO割当を保存'}
                                        </Button>
                                    </Box>
                                </>
                            );
                        })()}
                        {!roundsLoading && selectedMeetingId && roundsEdit.length === 0 && (
                            <>
                                <Typography color="text.secondary" variant="body2" sx={{ mb: 1 }}>
                                    同室枠がありません。「＋ 同室枠を追加」で BO1 から作成できます。
                                </Typography>
                                <Button variant="outlined" size="small" onClick={addBO}>＋ 同室枠を追加</Button>
                            </>
                        )}
                    </Box>
                </Box>

                {/* Pane 3: Relationship Log */}
                <Box
                    sx={{
                        bgcolor: 'background.paper',
                        borderRadius: 2,
                        boxShadow: 1,
                        border: '1px solid',
                        borderColor: 'divider',
                        display: 'flex',
                        flexDirection: 'column',
                        overflow: 'hidden',
                    }}
                >
                    <Box
                        sx={{
                            p: '12px 14px',
                            borderBottom: '1px solid',
                            borderColor: 'divider',
                            bgcolor: '#fafbff',
                            flexShrink: 0,
                        }}
                    >
                        <Typography component="h3" sx={{ fontSize: 13, fontWeight: 700, mb: 1 }}>
                            🔗 Relationship Log
                        </Typography>
                        {targetMember ? (() => {
                            const rlSec = formatMemberSecondaryLine(targetMember);
                            return (
                                <Box>
                                    <Typography sx={{ fontSize: 12, fontWeight: 600, color: 'text.primary' }}>
                                        {formatMemberPrimaryLine(targetMember)}
                                    </Typography>
                                    {rlSec ? (
                                        <Typography sx={{ fontSize: 10, color: 'text.secondary', mt: 0.25 }}>
                                            {rlSec}
                                        </Typography>
                                    ) : null}
                                </Box>
                            );
                        })() : (
                            <Typography sx={{ fontSize: 11, color: 'text.secondary' }}>← メンバーを選択</Typography>
                        )}
                    </Box>
                    <Box sx={{ flex: 1, overflowY: 'auto', p: 1.25 }}>
                        {!targetMember && (
                            <Box sx={{ textAlign: 'center', py: 3 }}>
                                <Typography sx={{ fontSize: 24, mb: 1 }}>👈</Typography>
                                <Typography sx={{ fontSize: 12, color: 'text.secondary' }}>
                                    左リストからメンバーを選ぶと関係ログが表示されます
                                </Typography>
                            </Box>
                        )}
                        {targetMember && (
                            <>
                                {loadingSummary && <Typography color="text.secondary" variant="body2">Loading...</Typography>}
                                {targetMember && (summary || !loadingSummary) && (
                                    <>
                                        {/* C-6: Relationship Summary (above Relationship Log) */}
                                        <Box
                                            sx={{
                                                border: '1px solid',
                                                borderColor: 'divider',
                                                borderRadius: 1.5,
                                                p: 1.25,
                                                mb: 1.5,
                                                bgcolor: 'background.default',
                                            }}
                                        >
                                            <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 1 }}>
                                                🧠 Relationship Summary
                                            </Typography>
                                            {summary ? (
                                                <>
                                                    <Typography sx={{ fontSize: 11, color: 'text.secondary', mb: 0.5 }}>
                                                        同室回数: {typeof summary.same_room_count === 'number' ? summary.same_room_count : '—'}
                                                    </Typography>
                                                    <Typography sx={{ fontSize: 11, color: 'text.secondary', mb: 0.5 }}>
                                                        直近同室: {summary.last_same_room_meeting
                                                            ? `#${summary.last_same_room_meeting.number ?? ''} (${summary.last_same_room_meeting.held_on ?? ''})`
                                                            : '—'}
                                                    </Typography>
                                                    <Typography sx={{ fontSize: 11, color: 'text.secondary', mb: 0.5 }}>
                                                        1to1: 合計 {typeof summary.one_on_one_count === 'number' ? summary.one_on_one_count : oneToOnes?.length ?? 0}
                                                        {summary.last_one_on_one_at ? ` / 直近 ${new Date(summary.last_one_on_one_at).toLocaleDateString('ja-JP')}` : ''}
                                                    </Typography>
                                                    <Box sx={{ fontSize: 11, color: 'text.secondary', mb: 1 }}>
                                                        直近メモ: {(summary.latest_memos || []).length === 0
                                                            ? '—'
                                                            : (summary.latest_memos || []).slice(0, 3).map((m) => (
                                                                  <Box key={m.id} sx={{ fontSize: 10, display: 'block' }}>
                                                                      {m.updated_at ? new Date(m.updated_at).toLocaleDateString('ja-JP') : ''} {(m.body || '').slice(0, 40)}{(m.body && m.body.length > 40) ? '…' : ''}
                                                                  </Box>
                                                              ))}
                                                    </Box>
                                                    {nextActions.length > 0 && (
                                                        <>
                                                            <Typography sx={{ fontSize: 12, fontWeight: 700, color: 'text.secondary', mb: 0.75 }}>
                                                                💡 次の一手
                                                            </Typography>
                                                            <Stack spacing={0.5}>
                                                                {nextActions.map((a) => (
                                                                    <Stack key={a.id} direction="row" alignItems="center" flexWrap="wrap" gap={0.5}>
                                                                        <Typography sx={{ fontSize: 11 }}>{a.label}</Typography>
                                                                        {a.action === '1to1' && <Button size="small" variant="outlined" sx={{ fontSize: 10, minWidth: 0, py: 0.25 }} onClick={openO2oDialog}>📅 1to1登録</Button>}
                                                                        {a.action === 'memo' && <Button size="small" variant="outlined" sx={{ fontSize: 10, minWidth: 0, py: 0.25 }} onClick={openMemoDialog}>✏️ メモを書く</Button>}
                                                                    </Stack>
                                                                ))}
                                                            </Stack>
                                                        </>
                                                    )}
                                                </>
                                            ) : (
                                                <Typography sx={{ fontSize: 11, color: 'text.secondary' }}>—</Typography>
                                            )}
                                        </Box>
                                        {/* C-7: Relationship Score (below Summary) */}
                                        <Box
                                            sx={{
                                                border: '1px solid',
                                                borderColor: 'divider',
                                                borderRadius: 1.5,
                                                p: 1.25,
                                                mb: 1.5,
                                                bgcolor: 'background.default',
                                            }}
                                        >
                                            <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 0.5 }}>
                                                Relationship Score
                                            </Typography>
                                            <Typography sx={{ fontSize: 16, letterSpacing: 2 }}>
                                                {summary != null ? STARS[calculateRelationshipScore(summary)] : '—'}
                                            </Typography>
                                        </Box>
                                        {/* C-8: Introduction Hint (below Score, above Relationship Log) */}
                                        <Box
                                            sx={{
                                                border: '1px solid',
                                                borderColor: 'divider',
                                                borderRadius: 1.5,
                                                p: 1.25,
                                                mb: 1.5,
                                                bgcolor: 'background.default',
                                            }}
                                        >
                                            <Typography sx={{ fontSize: 13, fontWeight: 700, mb: 0.75 }}>
                                                💡 Introduction Hint
                                            </Typography>
                                            {introductionHints.length === 0 ? (
                                                <Typography sx={{ fontSize: 11, color: 'text.secondary' }}>紹介候補なし</Typography>
                                            ) : (
                                                <Stack spacing={0.75}>
                                                    {introductionHints.map((hint, idx) => (
                                                        <Typography key={idx} sx={{ fontSize: 11 }}>
                                                            {idx + 1}. {hint.from.category}（{hint.from.name}） → {hint.to.category}（{hint.to.name}）
                                                        </Typography>
                                                    ))}
                                                </Stack>
                                            )}
                                        </Box>
                                        {!loadingSummary && (
                                    <>
                                        <Stack direction="row" flexWrap="wrap" gap={0.5} sx={{ mb: 1.5 }}>
                                            <Button size="small" variant="contained" onClick={openMemoDialog}>✏️ メモ</Button>
                                            <Button size="small" variant="outlined" onClick={openO2oDialog}>📅 1to1</Button>
                                            <Button size="small" component={Link} to="/members" variant="outlined" color="inherit">👥 詳細</Button>
                                        </Stack>
                                        <Typography sx={{ fontSize: 12, fontWeight: 700, color: 'text.secondary', textTransform: 'uppercase', letterSpacing: 0.5, mb: 1.25 }}>
                                            関係ログ
                                        </Typography>
                                        {(latestMemos || []).length === 0 && (
                                            <Typography variant="body2" color="text.secondary" sx={{ fontSize: 12, pb: 1, borderBottom: '1px solid #f5f5f5' }}>
                                                メモはまだありません
                                            </Typography>
                                        )}
                                        {(latestMemos || []).map((m) => (
                                            <Box
                                                key={m.id}
                                                sx={{
                                                    display: 'flex',
                                                    gap: 0.875,
                                                    alignItems: 'flex-start',
                                                    py: 0.875,
                                                    borderBottom: '1px solid #f5f5f5',
                                                    fontSize: 12,
                                                }}
                                            >
                                                <Chip label="例会" size="small" sx={{ fontSize: 9, height: 18 }} variant="outlined" />
                                                <Typography component="span" sx={{ fontSize: 10, color: 'text.secondary', flexShrink: 0 }}>
                                                    {m.updated_at ? new Date(m.updated_at).toLocaleDateString('ja-JP') : ''}
                                                </Typography>
                                                <Typography component="span" sx={{ fontSize: 12 }}>{m.body || '(なし)'}</Typography>
                                            </Box>
                                        ))}
                                        <Typography sx={{ fontSize: 12, fontWeight: 700, color: 'text.secondary', textTransform: 'uppercase', letterSpacing: 0.5, mt: 1.5, mb: 1.25 }}>
                                            1to1履歴
                                        </Typography>
                                        {oneToOnes.length === 0 && (
                                            <Typography variant="body2" color="text.secondary" sx={{ fontSize: 11 }}>
                                                1to1はまだありません
                                            </Typography>
                                        )}
                                        {oneToOnes.map((o) => (
                                            <Box
                                                key={o.id}
                                                sx={{
                                                    border: '1px solid',
                                                    borderColor: 'divider',
                                                    borderRadius: 1.75,
                                                    p: '8px 10px',
                                                    mb: 0.75,
                                                }}
                                            >
                                                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 0.375 }}>
                                                    <Chip
                                                        label={o.status === 'completed' ? '実施済み' : o.status === 'planned' ? '予定' : o.status === 'canceled' ? 'キャンセル' : o.status}
                                                        size="small"
                                                        sx={{ fontSize: 9, height: 16 }}
                                                        color={o.status === 'completed' ? 'success' : o.status === 'planned' ? 'primary' : 'default'}
                                                        variant="outlined"
                                                    />
                                                    <Typography sx={{ fontSize: 10, color: 'text.secondary' }}>
                                                        {o.scheduled_at || o.started_at || o.ended_at
                                                            ? new Date(o.scheduled_at || o.started_at || o.ended_at).toLocaleDateString('ja-JP')
                                                            : ''}
                                                    </Typography>
                                                </Box>
                                                <Typography sx={{ fontSize: 11 }}>{o.notes || '(メモなし)'}</Typography>
                                            </Box>
                                        ))}
                                        <Box sx={{ mt: 1 }}>
                                            <FormControlLabel
                                                control={
                                                    <Switch
                                                        size="small"
                                                        checked={!!displayFlags.interested}
                                                        onChange={(_, v) => handleToggle('interested', v)}
                                                    />
                                                }
                                                label={<Typography variant="caption">気になる</Typography>}
                                            />
                                            <FormControlLabel
                                                control={
                                                    <Switch
                                                        size="small"
                                                        checked={!!displayFlags.want_1on1}
                                                        onChange={(_, v) => handleToggle('want_1on1', v)}
                                                    />
                                                }
                                                label={<Typography variant="caption">1on1 したい</Typography>}
                                            />
                                        </Box>
                                    </>
                                )}
                            </>
                                        )}
                                    </>
                                )}
                    </Box>
                </Box>
            </Box>
            {/* BO メンバーチップタップで開くメンバー詳細モーダル */}
            <Dialog open={Boolean(memberDetailModalMember)} onClose={() => setMemberDetailModalMember(null)} maxWidth="xs" fullWidth>
                <DialogTitle>メンバー情報</DialogTitle>
                <DialogContent>
                    {memberDetailModalMember && (
                        <Box sx={{ pt: 0.5 }}>
                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
                                <Box
                                    sx={{
                                        width: 48,
                                        height: 48,
                                        borderRadius: '50%',
                                        bgcolor: 'primary.main',
                                        color: 'primary.contrastText',
                                        fontSize: 18,
                                        fontWeight: 700,
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        flexShrink: 0,
                                    }}
                                >
                                    {(memberDetailModalMember.name || '?').charAt(0)}
                                </Box>
                                <Box sx={{ minWidth: 0 }}>
                                    <Typography variant="h6" sx={{ fontSize: 16 }}>
                                        {formatMemberPrimaryLine(memberDetailModalMember)}
                                    </Typography>
                                    <Typography variant="body2" color="text.secondary">
                                        {formatMemberSecondaryLine(memberDetailModalMember) ?? '—'}
                                    </Typography>
                                </Box>
                            </Box>
                            <Stack direction="row" spacing={1} sx={{ flexWrap: 'wrap' }}>
                                <Button
                                    size="small"
                                    variant="outlined"
                                    onClick={() => {
                                        setTargetMember(memberDetailModalMember);
                                        setMemberDetailModalMember(null);
                                    }}
                                >
                                    関係ログに表示
                                </Button>
                                <Button
                                    size="small"
                                    variant="outlined"
                                    startIcon={<EditNoteIcon />}
                                    onClick={() => {
                                        if (selectedMeetingId) {
                                            openMemoDialogForMeetingMember(selectedMeetingId, memberDetailModalMember.id, roundsEdit[0]?.label ?? '', '');
                                        }
                                        setMemberDetailModalMember(null);
                                    }}
                                    disabled={!selectedMeetingId}
                                >
                                    例会メモ
                                </Button>
                            </Stack>
                        </Box>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setMemberDetailModalMember(null)}>閉じる</Button>
                </DialogActions>
            </Dialog>
            <Dialog open={memoOpen} onClose={closeMemoDialog} maxWidth="sm" fullWidth>
                <DialogTitle>メモ追加</DialogTitle>
                <DialogContent>
                    {memoContextTargetMemberId != null && (
                        <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                            Meeting #{selectedMeeting?.number ?? memoContextMeetingId} / {memoContextRoundLabel || 'BO'} / {memoContextRoomLabel || 'Room'} / 相手: {members.find((m) => m.id === memoContextTargetMemberId)?.name ?? `#${memoContextTargetMemberId}`}（例会メモ）
                        </Typography>
                    )}
                    <FormControl fullWidth size="small" sx={{ mt: 1 }} disabled={memoContextTargetMemberId != null}>
                        <InputLabel>種別</InputLabel>
                        <Select
                            value={memoType}
                            label="種別"
                            onChange={(e) => setMemoType(e.target.value)}
                        >
                            {MEMO_TYPES.map((t) => (
                                <MenuItem key={t.value} value={t.value}>
                                    {t.label}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                    <TextField
                        label="本文"
                        multiline
                        minRows={3}
                        fullWidth
                        required
                        value={memoBody}
                        onChange={(e) => setMemoBody(e.target.value)}
                        sx={{ mt: 2 }}
                    />
                    {memoType === 'meeting' && memoContextMeetingId == null && (
                        <TextField
                            label="meeting_id（数値）"
                            type="number"
                            size="small"
                            fullWidth
                            value={memoMeetingId}
                            onChange={(e) => setMemoMeetingId(e.target.value)}
                            sx={{ mt: 2 }}
                        />
                    )}
                    {memoType === 'one_to_one' && (
                        <TextField
                            label="one_to_one_id（数値）"
                            type="number"
                            size="small"
                            fullWidth
                            value={memoOneToOneId}
                            onChange={(e) => setMemoOneToOneId(e.target.value)}
                            sx={{ mt: 2 }}
                        />
                    )}
                    {memoError && (
                        <Typography color="error" variant="body2" sx={{ mt: 2 }}>
                            {memoError}
                        </Typography>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={closeMemoDialog}>キャンセル</Button>
                    <Button
                        variant="contained"
                        onClick={submitMemo}
                        disabled={!canSubmitMemo || memoSubmitting}
                    >
                        {memoSubmitting ? '送信中...' : '保存'}
                    </Button>
                </DialogActions>
            </Dialog>
            <Dialog open={o2oOpen} onClose={closeO2oDialog} maxWidth="sm" fullWidth>
                <DialogTitle>1 to 1 登録</DialogTitle>
                <DialogContent>
                    {firstWorkspace ? (
                        <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                            ワークスペース: {firstWorkspace.name} (ID: {firstWorkspace.id})
                        </Typography>
                    ) : (
                        <Typography color="error" variant="body2" sx={{ mt: 1 }}>
                            {workspaceLoadError}
                        </Typography>
                    )}
                    <FormControl fullWidth size="small" sx={{ mt: 2 }}>
                        <InputLabel>状態</InputLabel>
                        <Select
                            value={o2oStatus}
                            label="状態"
                            onChange={(e) => setO2oStatus(e.target.value)}
                        >
                            {O2O_STATUSES.map((s) => (
                                <MenuItem key={s.value} value={s.value}>
                                    {s.label}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                    <Typography variant="subtitle2" color="text.secondary" sx={{ mt: 2, mb: 1 }}>
                        日時
                    </Typography>
                    <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, alignItems: 'flex-start' }}>
                        <TextField
                            label="日付"
                            type="date"
                            size="small"
                            value={o2oDate}
                            onChange={(e) => setO2oDate(e.target.value)}
                            InputLabelProps={{ shrink: true }}
                            sx={{ minWidth: 160 }}
                        />
                        <TextField
                            label="開始時刻"
                            type="time"
                            size="small"
                            value={o2oStartTime}
                            onChange={(e) => setO2oStartTime(e.target.value)}
                            InputLabelProps={{ shrink: true }}
                            inputProps={{ step: 300 }}
                            sx={{ minWidth: 120 }}
                        />
                        <TextField
                            label="終了時刻"
                            type="time"
                            size="small"
                            value={o2oEndTime}
                            onChange={(e) => setO2oEndTime(e.target.value)}
                            InputLabelProps={{ shrink: true }}
                            inputProps={{ step: 300 }}
                            sx={{ minWidth: 120 }}
                        />
                    </Box>
                    <TextField
                        label="meeting_id（任意）"
                        type="number"
                        size="small"
                        fullWidth
                        value={o2oMeetingId}
                        onChange={(e) => setO2oMeetingId(e.target.value)}
                        sx={{ mt: 2 }}
                    />
                    <TextField
                        label="メモ"
                        multiline
                        minRows={2}
                        fullWidth
                        value={o2oNotes}
                        onChange={(e) => setO2oNotes(e.target.value)}
                        sx={{ mt: 1 }}
                    />
                    {o2oError && (
                        <Typography color="error" variant="body2" sx={{ mt: 2 }}>
                            {o2oError}
                        </Typography>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={closeO2oDialog}>キャンセル</Button>
                    <Button
                        variant="contained"
                        onClick={submitO2o}
                        disabled={!canSubmitO2o || o2oSubmitting}
                    >
                        {o2oSubmitting ? '送信中...' : '登録'}
                    </Button>
                </DialogActions>
            </Dialog>
            <Snackbar
                open={!!snackbarMessage}
                autoHideDuration={3000}
                onClose={() => setSnackbarMessage('')}
                message={snackbarMessage}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
            />
        </Box>
    );
}
