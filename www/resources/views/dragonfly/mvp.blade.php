@extends('layouts.dragonfly')

@section('title', 'DragonFly MVP (Meeting ' . $number . ')')

@section('content')
<div id="mvp-config" data-participant-id="{{ $participant_id_from_query ?? '' }}" class="hidden" aria-hidden="true"></div>

<header class="mb-8">
    <h1 class="text-2xl font-semibold text-slate-900">DragonFly MVP（Meeting {{ $number }}）</h1>
</header>

<section class="mb-8 rounded-xl bg-white p-6 shadow-sm ring-1 ring-slate-200/60">
    <h2 class="mb-4 text-lg font-medium text-slate-700">1. 参加者一覧</h2>
    <button type="button" id="btn-load-attendees" class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">参加者を読み込む</button>
    <div id="attendees-error" class="mt-2 text-sm text-red-600 hidden"></div>
    <div id="attendees-tables" class="mt-4 hidden space-y-4">
        <div>
            <h3 class="mb-2 text-sm font-medium text-slate-500">メンバー</h3>
            <div class="overflow-x-auto rounded-lg border border-slate-200">
                <table id="table-member" class="min-w-full divide-y divide-slate-200 text-sm"><thead class="bg-slate-50"><tr><th class="px-4 py-2 text-left font-medium text-slate-600">No</th><th class="px-4 py-2 text-left font-medium text-slate-600">氏名</th><th class="px-4 py-2 text-left font-medium text-slate-600">カテゴリー</th><th class="px-4 py-2 text-left font-medium text-slate-600">役職・備考</th><th class="px-4 py-2 text-left font-medium text-slate-600">ルーム</th></tr></thead><tbody class="divide-y divide-slate-200 bg-white"></tbody></table>
            </div>
        </div>
        <div>
            <h3 class="mb-2 text-sm font-medium text-slate-500">ビジター</h3>
            <div class="overflow-x-auto rounded-lg border border-slate-200">
                <table id="table-visitor" class="min-w-full divide-y divide-slate-200 text-sm"><thead class="bg-slate-50"><tr><th class="px-4 py-2 text-left font-medium text-slate-600">No</th><th class="px-4 py-2 text-left font-medium text-slate-600">氏名</th><th class="px-4 py-2 text-left font-medium text-slate-600">カテゴリー</th><th class="px-4 py-2 text-left font-medium text-slate-600">ルーム</th></tr></thead><tbody class="divide-y divide-slate-200 bg-white"></tbody></table>
            </div>
        </div>
        <div>
            <h3 class="mb-2 text-sm font-medium text-slate-500">ゲスト</h3>
            <div class="overflow-x-auto rounded-lg border border-slate-200">
                <table id="table-guest" class="min-w-full divide-y divide-slate-200 text-sm"><thead class="bg-slate-50"><tr><th class="px-4 py-2 text-left font-medium text-slate-600">No</th><th class="px-4 py-2 text-left font-medium text-slate-600">氏名</th><th class="px-4 py-2 text-left font-medium text-slate-600">カテゴリー</th><th class="px-4 py-2 text-left font-medium text-slate-600">ルーム</th></tr></thead><tbody class="divide-y divide-slate-200 bg-white"></tbody></table>
            </div>
        </div>
    </div>
</section>

<section class="mb-8 rounded-xl bg-white p-6 shadow-sm ring-1 ring-slate-200/60">
    <h2 class="mb-4 text-lg font-medium text-slate-700">2. 自分を選択</h2>
    <div class="flex flex-wrap items-center gap-3">
        <select id="select-participant" class="rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 min-w-[220px]">
            <option value="">-- 参加者を読み込んでから選択 --</option>
        </select>
        <button type="button" id="btn-show-roommates" class="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">同室者を表示（従来）</button>
    </div>
    <p id="participant-required-msg" class="mt-2 text-sm text-slate-500 hidden">ブレイクアウト記録・振り返りを使うには「自分」を選択してください。</p>
</section>

<section id="section-breakout-record" class="mb-8 rounded-xl bg-white p-6 shadow-sm ring-1 ring-slate-200/60">
    <h2 class="mb-4 text-lg font-medium text-slate-700">3. ブレイクアウト記録</h2>
    <div id="breakout-record-disabled" class="hidden">
        <p class="text-sm text-slate-500">自分を選択すると Session1 / Session2 の記録ができます。</p>
    </div>
    <div id="breakout-record-body" class="hidden space-y-6">
        <div class="session-block rounded-lg border border-slate-200 bg-slate-50/50 p-4" data-session="1">
            <h3 class="mb-3 font-medium text-slate-700">Session 1</h3>
            <div class="space-y-3">
                <label class="block text-sm text-slate-600">ルーム名 <input type="text" id="room-label-s1" placeholder="A" maxlength="20" class="mt-1 rounded border border-slate-300 px-3 py-1.5 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 w-24"></label>
                <label class="block text-sm text-slate-600">同室者を検索 <input type="text" id="search-s1" placeholder="名前 or No で絞り込み" class="mt-1 rounded border border-slate-300 px-3 py-1.5 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 w-full max-w-xs"></label>
            </div>
            <div id="roommate-checkboxes-s1" class="roommate-checkboxes my-3 max-h-48 overflow-y-auto rounded border border-slate-200 bg-white p-2 text-sm"></div>
            <div class="flex flex-wrap items-center gap-2">
                <button type="button" class="btn-save-assignment rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-500" data-session="1">保存</button>
                <button type="button" class="btn-delete-assignment rounded-lg border border-red-200 bg-white px-4 py-2 text-sm font-medium text-red-600 hover:bg-red-50" data-session="1">このセッションの記録を削除</button>
                <span class="save-result text-sm" id="save-result-s1"></span>
            </div>
            <div class="roommates-by-session mt-4">
                <h4 class="mb-2 text-sm font-medium text-slate-600">このセッションの同室者一覧</h4>
                <div id="roommates-list-s1" class="space-y-3"></div>
            </div>
        </div>
        <div class="session-block rounded-lg border border-slate-200 bg-slate-50/50 p-4" data-session="2">
            <h3 class="mb-3 font-medium text-slate-700">Session 2</h3>
            <div class="space-y-3">
                <label class="block text-sm text-slate-600">ルーム名 <input type="text" id="room-label-s2" placeholder="B" maxlength="20" class="mt-1 rounded border border-slate-300 px-3 py-1.5 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 w-24"></label>
                <label class="block text-sm text-slate-600">同室者を検索 <input type="text" id="search-s2" placeholder="名前 or No で絞り込み" class="mt-1 rounded border border-slate-300 px-3 py-1.5 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 w-full max-w-xs"></label>
            </div>
            <div id="roommate-checkboxes-s2" class="roommate-checkboxes my-3 max-h-48 overflow-y-auto rounded border border-slate-200 bg-white p-2 text-sm"></div>
            <div class="flex flex-wrap items-center gap-2">
                <button type="button" class="btn-save-assignment rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-500" data-session="2">保存</button>
                <button type="button" class="btn-delete-assignment rounded-lg border border-red-200 bg-white px-4 py-2 text-sm font-medium text-red-600 hover:bg-red-50" data-session="2">このセッションの記録を削除</button>
                <span class="save-result text-sm" id="save-result-s2"></span>
            </div>
            <div class="roommates-by-session mt-4">
                <h4 class="mb-2 text-sm font-medium text-slate-600">このセッションの同室者一覧</h4>
                <div id="roommates-list-s2" class="space-y-3"></div>
            </div>
        </div>
    </div>
</section>

<section class="mb-8 rounded-xl bg-white p-6 shadow-sm ring-1 ring-slate-200/60">
    <h2 class="mb-4 text-lg font-medium text-slate-700">4. 同室者一覧・メモ（従来）</h2>
    <div id="roommates-area" class="hidden">
        <p id="roommates-empty" class="text-sm text-slate-500">同室者がいません。</p>
        <div id="roommates-list" class="mt-3 space-y-3"></div>
    </div>
</section>

<section class="mb-8 rounded-xl bg-white p-6 shadow-sm ring-1 ring-slate-200/60">
    <h2 class="mb-4 text-lg font-medium text-slate-700">5. 振り返り</h2>
    <div id="review-disabled" class="hidden">
        <p class="text-sm text-slate-500">自分を選択すると振り返りを表示します。</p>
    </div>
    <div id="review-body" class="hidden space-y-4">
        <div id="review-s1">
            <h3 class="mb-2 text-sm font-medium text-slate-600">Session 1 の同室者</h3>
            <div id="review-roommates-s1"></div>
        </div>
        <div id="review-s2">
            <h3 class="mb-2 text-sm font-medium text-slate-600">Session 2 の同室者</h3>
            <div id="review-roommates-s2"></div>
        </div>
        <button type="button" id="btn-refresh-review" class="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-50">振り返りを再取得</button>
    </div>
</section>

<section class="mb-8 rounded-xl bg-white p-6 shadow-sm ring-1 ring-slate-200/60">
    <h2 class="mb-4 text-lg font-medium text-slate-700">6. 自分が書いたメモ一覧</h2>
    <button type="button" id="btn-load-memos" class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-500">メモ一覧を更新</button>
    <ul id="memos-list" class="mt-4 list-none divide-y divide-slate-200 p-0"></ul>
</section>

@push('scripts')
<script>
(function() {
    const number = {{ $number }};
    const initialParticipantId = (function() {
        const el = document.getElementById('mvp-config');
        const raw = el ? (el.getAttribute('data-participant-id') || '') : '';
        return raw && /^\d+$/.test(raw) ? raw : null;
    })();
    const baseUrl = '/api/dragonfly/meetings/' + number;
    let attendees = { meeting: null, attendees: { member: [], visitor: [], guest: [] } };
    let roommates = [];
    let allParticipantsForBreakout = [];

    function getCsrfHeaders() {
        const token = document.querySelector('meta[name="csrf-token"]');
        return {
            'X-CSRF-TOKEN': token ? token.getAttribute('content') : '',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        };
    }

    function getSelectedParticipantId() {
        return document.getElementById('select-participant').value || null;
    }

    function updateParticipantInUrl(participantId) {
        const url = new URL(window.location.href);
        if (participantId) {
            url.searchParams.set('participant_id', participantId);
        } else {
            url.searchParams.delete('participant_id');
        }
        window.history.replaceState({}, '', url.toString());
    }

    function setBreakoutAndReviewVisibility(hasParticipant) {
        document.getElementById('breakout-record-disabled').classList.toggle('hidden', !!hasParticipant);
        document.getElementById('breakout-record-body').classList.toggle('hidden', !hasParticipant);
        document.getElementById('review-disabled').classList.toggle('hidden', !!hasParticipant);
        document.getElementById('review-body').classList.toggle('hidden', !hasParticipant);
        document.getElementById('participant-required-msg').classList.toggle('hidden', !!hasParticipant);
        if (hasParticipant) {
            allParticipantsForBreakout = buildParticipantOptions();
            renderRoommateCheckboxes(1);
            renderRoommateCheckboxes(2);
            fetchRoommatesBySession(1);
            fetchRoommatesBySession(2);
            refreshReview();
        }
    }

    function buildParticipantOptions() {
        const selfId = getSelectedParticipantId();
        if (!selfId) return [];
        const list = [].concat(
            (attendees.attendees.member || []),
            (attendees.attendees.visitor || []),
            (attendees.attendees.guest || [])
        );
        return list.filter(function(a) { return String(a.participant_id) !== String(selfId); });
    }

    function filterBySearch(session) {
        const q = (document.getElementById('search-s' + session).value || '').toLowerCase().trim();
        const list = document.querySelectorAll('#roommate-checkboxes-s' + session + ' .roommate-row');
        list.forEach(function(row) {
            const text = (row.dataset.displayNo || '') + ' ' + (row.dataset.name || '');
            row.style.display = !q || text.toLowerCase().indexOf(q) !== -1 ? 'flex' : 'none';
        });
    }

    function renderRoommateCheckboxes(session) {
        const container = document.getElementById('roommate-checkboxes-s' + session);
        container.innerHTML = '';
        allParticipantsForBreakout.forEach(function(a) {
            const row = document.createElement('label');
            row.className = 'roommate-row flex cursor-pointer items-center gap-2 py-1.5 text-sm text-slate-700 hover:bg-slate-100 rounded px-2';
            row.dataset.displayNo = (a.member && a.member.display_no) ? String(a.member.display_no) : '';
            row.dataset.name = (a.member && a.member.name) ? String(a.member.name) : '';
            const id = 'cb-s' + session + '-' + a.participant_id;
            row.innerHTML = '<input type="checkbox" class="roommate-cb h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500" data-session="' + session + '" value="' + a.participant_id + '" id="' + id + '"> ' +
                '<span>' + (a.member ? (a.member.display_no + ' ' + a.member.name) : '') + ' <span class="text-slate-400">(' + (a.type || '') + ')</span></span>';
            row.style.display = 'flex';
            container.appendChild(row);
        });
    }

    function formatValidationErrors(data) {
        if (data.errors && typeof data.errors === 'object') {
            const parts = [];
            for (const key in data.errors) {
                if (Array.isArray(data.errors[key]) && data.errors[key].length) {
                    parts.push(key + ': ' + data.errors[key][0]);
                }
            }
            if (parts.length) return parts.join(' / ');
        }
        return null;
    }

    async function saveBreakoutAssignment(session, roomLabel, roommateIds) {
        const participantId = getSelectedParticipantId();
        const resultEl = document.getElementById('save-result-s' + session);
        resultEl.className = 'save-result';
        if (!participantId) {
            resultEl.textContent = '自分を選択してください';
            resultEl.className = 'save-result text-sm text-red-600';
            resultEl.classList.remove('hidden');
            return;
        }
        if (!roomLabel.trim()) {
            resultEl.textContent = 'ルーム名を入力してください';
            resultEl.className = 'save-result text-sm text-red-600';
            resultEl.classList.remove('hidden');
            return;
        }
        resultEl.textContent = '保存中...';
        resultEl.className = 'save-result text-sm text-slate-600';
        resultEl.classList.remove('hidden');
        try {
            const res = await fetch(baseUrl + '/breakout-assignments', {
                method: 'PUT',
                headers: getCsrfHeaders(),
                body: JSON.stringify({
                    session: session,
                    participant_id: parseInt(participantId, 10),
                    room_label: roomLabel.trim(),
                    roommate_participant_ids: roommateIds.map(function(id) { return parseInt(id, 10); })
                })
            });
            const data = await res.json().catch(function() { return {}; });
            if (!res.ok) {
                const msg = formatValidationErrors(data) || data.message || (data.errors ? JSON.stringify(data.errors) : '保存に失敗しました');
                throw new Error(msg);
            }
            resultEl.textContent = '保存しました';
            resultEl.className = 'save-result text-sm text-green-600';
            fetchRoommatesBySession(session);
            refreshReview();
        } catch (e) {
            resultEl.textContent = 'エラー: ' + (e.message || '');
            resultEl.className = 'save-result text-sm text-red-600';
        }
    }

    async function deleteBreakoutAssignment(session) {
        const participantId = getSelectedParticipantId();
        const resultEl = document.getElementById('save-result-s' + session);
        resultEl.className = 'save-result';
        if (!participantId) {
            resultEl.textContent = '自分を選択してください';
            resultEl.className = 'save-result text-sm text-red-600';
            resultEl.classList.remove('hidden');
            return;
        }
        resultEl.textContent = '削除中...';
        resultEl.className = 'save-result text-sm text-slate-600';
        resultEl.classList.remove('hidden');
        try {
            const res = await fetch(baseUrl + '/breakout-assignments', {
                method: 'DELETE',
                headers: getCsrfHeaders(),
                body: JSON.stringify({ session: session, participant_id: parseInt(participantId, 10) })
            });
            const data = await res.json().catch(function() { return {}; });
            if (!res.ok) {
                const msg = formatValidationErrors(data) || data.message || '削除に失敗しました';
                throw new Error(msg);
            }
            resultEl.textContent = '削除しました';
            resultEl.className = 'save-result text-sm text-green-600';
            fetchRoommatesBySession(session);
            refreshReview();
        } catch (e) {
            resultEl.textContent = 'エラー: ' + (e.message || '');
            resultEl.className = 'save-result text-sm text-red-600';
        }
    }

    async function fetchRoommatesBySession(session) {
        const participantId = getSelectedParticipantId();
        if (!participantId) return;
        const listEl = document.getElementById('roommates-list-s' + session);
        listEl.innerHTML = '';
        try {
            const res = await fetch(baseUrl + '/breakout-roommates/' + participantId + '?session=' + session);
            const data = await res.json();
            if (!res.ok) throw new Error(data.message || 'Failed');
            const roommatesList = data.data || [];
            if (roommatesList.length === 0) {
                listEl.innerHTML = '<p class="text-sm text-slate-500">このセッションの同室者はいません。ルーム名と同室者を選んで保存してください。</p>';
            } else {
                roommatesList.forEach(function(r) {
                    const card = document.createElement('div');
                    card.className = 'rounded-lg border border-slate-200 bg-white p-4 shadow-sm';
                    card.dataset.targetParticipantId = r.participant_id;
                    card.innerHTML = '<div class="font-medium text-slate-800">' + (r.member ? r.member.display_no + ' ' + r.member.name : '') + '</div>' +
                        '<textarea data-target-id="' + r.participant_id + '" placeholder="メモを入力" class="mt-2 w-full rounded border border-slate-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 min-h-[80px]"></textarea>' +
                        '<div class="mt-2 flex items-center gap-2"><button type="button" class="btn-save-memo btn-save-memo-session rounded-lg bg-indigo-600 px-3 py-1.5 text-sm text-white hover:bg-indigo-500" data-session="' + session + '" data-target-id="' + r.participant_id + '">保存</button><span class="saved text-sm hidden"></span></div>';
                    listEl.appendChild(card);
                });
            }
        } catch (e) {
            listEl.innerHTML = '<p class="text-sm text-red-600">取得失敗: ' + (e.message || '') + '</p>';
        }
    }

    function refreshReview() {
        const participantId = getSelectedParticipantId();
        if (!participantId) return;
        [1, 2].forEach(function(session) {
            const container = document.getElementById('review-roommates-s' + session);
            container.innerHTML = '<p class="text-sm text-slate-500">読み込み中...</p>';
            fetch(baseUrl + '/breakout-roommates/' + participantId + '?session=' + session)
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    const list = data.data || [];
                    if (list.length === 0) {
                        container.innerHTML = '<p class="text-sm text-slate-500">同室者なし</p>';
                    } else {
                        container.innerHTML = '<ul class="list-disc space-y-1 pl-5 text-sm text-slate-700"></ul>';
                        const ul = container.querySelector('ul');
                        list.forEach(function(r) {
                            const li = document.createElement('li');
                            li.textContent = (r.member ? r.member.display_no + ' ' + r.member.name : '') || ('ID:' + r.participant_id);
                            ul.appendChild(li);
                        });
                    }
                })
                .catch(function(e) {
                    container.innerHTML = '<p class="text-sm text-red-600">取得失敗: ' + (e.message || '') + '</p>';
                });
        });
    }

    async function fetchAttendees() {
        const errEl = document.getElementById('attendees-error');
        errEl.classList.add('hidden');
        try {
            const res = await fetch(baseUrl + '/attendees');
            const data = await res.json();
            if (!res.ok) throw new Error(data.message || 'Failed');
            attendees = data;
            renderAttendees(data);
            fillParticipantSelect(data);
            document.getElementById('attendees-tables').classList.remove('hidden');
            if (initialParticipantId && document.querySelector('#select-participant option[value="' + initialParticipantId + '"]')) {
                document.getElementById('select-participant').value = initialParticipantId;
                updateParticipantInUrl(initialParticipantId);
                setBreakoutAndReviewVisibility(true);
            }
        } catch (e) {
            errEl.textContent = e.message || '参加者の読み込みに失敗しました';
            errEl.classList.remove('hidden');
        }
    }

    function renderAttendees(data) {
        var cell = ' class="px-4 py-2 text-slate-700"';
        function rowMember(a) {
            return '<tr class="hover:bg-slate-50"><td' + cell + '>' + (a.member.display_no || '') + '</td><td' + cell + '>' + (a.member.name || '') + '</td><td' + cell + '>' + (a.member.category || '') + '</td><td' + cell + '>' + (a.member.role_notes || '') + '</td><td' + cell + '>' + (a.breakout_room_labels && a.breakout_room_labels.length ? a.breakout_room_labels.join(',') : '') + '</td></tr>';
        }
        function rowShort(a) {
            return '<tr class="hover:bg-slate-50"><td' + cell + '>' + (a.member.display_no || '') + '</td><td' + cell + '>' + (a.member.name || '') + '</td><td' + cell + '>' + (a.member.category || '') + '</td><td' + cell + '>' + (a.breakout_room_labels && a.breakout_room_labels.length ? a.breakout_room_labels.join(',') : '') + '</td></tr>';
        }
        document.querySelector('#table-member tbody').innerHTML = (data.attendees.member || []).map(rowMember).join('');
        document.querySelector('#table-visitor tbody').innerHTML = (data.attendees.visitor || []).map(rowShort).join('');
        document.querySelector('#table-guest tbody').innerHTML = (data.attendees.guest || []).map(rowShort).join('');
    }

    function fillParticipantSelect(data) {
        const select = document.getElementById('select-participant');
        select.innerHTML = '<option value="">-- 自分を選択 --</option>';
        [].concat(data.attendees.member || [], data.attendees.visitor || [], data.attendees.guest || []).forEach(function(a) {
            const opt = document.createElement('option');
            opt.value = a.participant_id;
            opt.textContent = (a.member.display_no || '') + ' ' + (a.member.name || '') + ' (' + (a.type || '') + ')';
            select.appendChild(opt);
        });
    }

    async function fetchRoommates() {
        const participantId = document.getElementById('select-participant').value;
        if (!participantId) return;
        const area = document.getElementById('roommates-area');
        const list = document.getElementById('roommates-list');
        const empty = document.getElementById('roommates-empty');
        list.innerHTML = '';
        area.classList.remove('hidden');
        empty.classList.remove('hidden');
        try {
            const res = await fetch(baseUrl + '/breakout-roommates/' + participantId);
            const data = await res.json();
            if (!res.ok) throw new Error(data.message || 'Failed');
            roommates = data.data || [];
            empty.classList.toggle('hidden', roommates.length > 0);
            roommates.forEach(function(r) {
                const card = document.createElement('div');
                card.className = 'rounded-lg border border-slate-200 bg-white p-4 shadow-sm';
                card.dataset.targetParticipantId = r.participant_id;
                card.innerHTML = '<div class="font-medium text-slate-800">' + (r.member ? r.member.display_no + ' ' + r.member.name : '') + ' ' + (r.member ? r.member.category || '' : '') + '</div>' +
                    '<textarea data-target-id="' + r.participant_id + '" placeholder="メモを入力" class="mt-2 w-full rounded border border-slate-300 px-3 py-2 text-sm min-h-[80px] focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500"></textarea>' +
                    '<div class="mt-2 flex items-center gap-2"><button type="button" class="btn-save-memo rounded-lg bg-indigo-600 px-3 py-1.5 text-sm text-white hover:bg-indigo-500" data-target-id="' + r.participant_id + '">保存</button><span class="saved text-sm hidden"></span></div>';
                list.appendChild(card);
            });
        } catch (e) {
            empty.textContent = '同室者の取得に失敗: ' + (e.message || '');
        }
    }

    async function upsertMemo(participantId, targetParticipantId, body) {
        const headers = getCsrfHeaders();
        const res = await fetch(baseUrl + '/breakout-memos', {
            method: 'PUT',
            headers: headers,
            body: JSON.stringify({
                participant_id: parseInt(participantId, 10),
                target_participant_id: parseInt(targetParticipantId, 10),
                body: body || null,
                breakout_room_id: null
            })
        });
        const data = await res.json();
        if (!res.ok) throw new Error(data.message || (data.errors ? JSON.stringify(data.errors) : 'Failed'));
        return data;
    }

    async function fetchMemos() {
        const participantId = document.getElementById('select-participant').value;
        if (!participantId) return;
        const list = document.getElementById('memos-list');
        list.innerHTML = '';
        try {
            const res = await fetch(baseUrl + '/breakout-memos?participant_id=' + participantId);
            const data = await res.json();
            if (!res.ok) throw new Error(data.message || 'Failed');
            const items = data.data || [];
            items.forEach(function(m) {
                const li = document.createElement('li');
                li.className = 'py-3 text-sm';
                li.innerHTML = '<span class="font-medium text-slate-800">' + (m.target_member ? m.target_member.display_no + ' ' + m.target_member.name : '') + '</span>: ' + (m.body || '(メモなし)') + ' <span class="text-slate-500 text-xs">' + (m.updated_at || '') + '</span>';
                list.appendChild(li);
            });
        } catch (e) {
            const li = document.createElement('li');
            li.className = 'py-3 text-sm text-red-600';
            li.textContent = 'メモ一覧の取得に失敗: ' + (e.message || '');
            list.appendChild(li);
        }
    }

    document.getElementById('btn-load-attendees').addEventListener('click', fetchAttendees);
    document.getElementById('btn-show-roommates').addEventListener('click', fetchRoommates);
    document.getElementById('btn-load-memos').addEventListener('click', fetchMemos);

    document.getElementById('select-participant').addEventListener('change', function() {
        const val = this.value;
        updateParticipantInUrl(val || null);
        setBreakoutAndReviewVisibility(!!val);
    });

    document.querySelectorAll('.btn-save-assignment').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const session = parseInt(this.dataset.session, 10);
            const roomLabelEl = document.getElementById('room-label-s' + session);
            const roomLabel = roomLabelEl ? roomLabelEl.value : '';
            const checkboxes = document.querySelectorAll('#roommate-checkboxes-s' + session + ' .roommate-cb:checked');
            const roommateIds = [].map.call(checkboxes, function(cb) { return cb.value; });
            saveBreakoutAssignment(session, roomLabel, roommateIds);
        });
    });

    document.querySelectorAll('.btn-delete-assignment').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const session = parseInt(this.dataset.session, 10);
            deleteBreakoutAssignment(session);
        });
    });

    document.getElementById('btn-refresh-review').addEventListener('click', refreshReview);

    document.getElementById('search-s1').addEventListener('input', function() { filterBySearch(1); });
    document.getElementById('search-s2').addEventListener('input', function() { filterBySearch(2); });

    document.getElementById('roommates-list').addEventListener('click', function(ev) {
        if (!ev.target.classList.contains('btn-save-memo')) return;
        const participantId = document.getElementById('select-participant').value;
        if (!participantId) return;
        const targetId = ev.target.dataset.targetId;
        const card = ev.target.closest('[data-target-participant-id]');
        const textarea = card ? card.querySelector('textarea') : null;
        const savedSpan = card ? card.querySelector('.saved') : null;
        const body = textarea ? textarea.value.trim() : '';
        ev.target.disabled = true;
        if (savedSpan) savedSpan.classList.add('hidden');
        upsertMemo(participantId, targetId, body || null).then(function() {
            if (savedSpan) { savedSpan.className = 'saved text-sm text-green-600'; savedSpan.textContent = '保存しました'; savedSpan.classList.remove('hidden'); }
            ev.target.disabled = false;
        }).catch(function(e) {
            if (savedSpan) { savedSpan.className = 'saved text-sm text-red-600'; savedSpan.textContent = 'エラー: ' + (e.message || ''); savedSpan.classList.remove('hidden'); }
            ev.target.disabled = false;
        });
    });

    document.getElementById('section-breakout-record').addEventListener('click', function(ev) {
        if (!ev.target.classList.contains('btn-save-memo-session')) return;
        const participantId = getSelectedParticipantId();
        if (!participantId) return;
        const targetId = ev.target.dataset.targetId;
        const card = ev.target.closest('[data-target-participant-id]');
        const textarea = card ? card.querySelector('textarea') : null;
        const savedSpan = card ? card.querySelector('.saved') : null;
        const body = textarea ? textarea.value.trim() : '';
        ev.target.disabled = true;
        if (savedSpan) savedSpan.classList.add('hidden');
        upsertMemo(participantId, targetId, body || null).then(function() {
            if (savedSpan) { savedSpan.className = 'saved text-sm text-green-600'; savedSpan.textContent = '保存しました'; savedSpan.classList.remove('hidden'); }
            ev.target.disabled = false;
            fetchMemos();
        }).catch(function(e) {
            if (savedSpan) { savedSpan.className = 'saved text-sm text-red-600'; savedSpan.textContent = 'エラー: ' + (e.message || ''); savedSpan.classList.remove('hidden'); }
            ev.target.disabled = false;
        });
    });
})();
</script>
@endpush
@endsection
