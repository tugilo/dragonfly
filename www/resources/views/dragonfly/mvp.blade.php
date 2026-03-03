@extends('layouts.dragonfly')

@section('title', 'DragonFly MVP (Meeting ' . $number . ')')

@section('content')
<h1>DragonFly MVP（Meeting {{ $number }}）</h1>

<section>
    <h2>1. 参加者一覧</h2>
    <button type="button" id="btn-load-attendees">参加者を読み込む</button>
    <div id="attendees-error" class="error" style="display:none;"></div>
    <div id="attendees-tables" style="display:none;">
        <h3>メンバー</h3>
        <table id="table-member"><thead><tr><th>No</th><th>氏名</th><th>カテゴリー</th><th>役職・備考</th><th>ルーム</th></tr></thead><tbody></tbody></table>
        <h3>ビジター</h3>
        <table id="table-visitor"><thead><tr><th>No</th><th>氏名</th><th>カテゴリー</th><th>ルーム</th></tr></thead><tbody></tbody></table>
        <h3>ゲスト</h3>
        <table id="table-guest"><thead><tr><th>No</th><th>氏名</th><th>カテゴリー</th><th>ルーム</th></tr></thead><tbody></tbody></table>
    </div>
</section>

<section>
    <h2>2. 自分を選択</h2>
    <select id="select-participant">
        <option value="">-- 参加者を読み込んでから選択 --</option>
    </select>
    <p id="participant-required-msg" class="hint" style="display:none;">ブレイクアウト記録・振り返りを使うには「自分」を選択してください。</p>
    <button type="button" id="btn-show-roommates">同室者を表示（従来）</button>
</section>

<section id="section-breakout-record">
    <h2>3. ブレイクアウト記録</h2>
    <div id="breakout-record-disabled" style="display:none;">
        <p class="hint">自分を選択すると Session1 / Session2 の記録ができます。</p>
    </div>
    <div id="breakout-record-body" style="display:none;">
        <div class="session-block" data-session="1">
            <h3>Session 1</h3>
            <p>
                <label>ルーム名 <input type="text" id="room-label-s1" placeholder="A" maxlength="20"></label>
            </p>
            <p>
                <label>同室者を検索 <input type="text" id="search-s1" placeholder="名前 or No で絞り込み"></label>
            </p>
            <div id="roommate-checkboxes-s1" class="roommate-checkboxes"></div>
            <button type="button" class="btn-save-assignment" data-session="1">保存</button>
            <span class="save-result" id="save-result-s1"></span>
            <div class="roommates-by-session" id="roommates-s1">
                <h4>このセッションの同室者一覧</h4>
                <div id="roommates-list-s1"></div>
            </div>
        </div>
        <div class="session-block" data-session="2">
            <h3>Session 2</h3>
            <p>
                <label>ルーム名 <input type="text" id="room-label-s2" placeholder="B" maxlength="20"></label>
            </p>
            <p>
                <label>同室者を検索 <input type="text" id="search-s2" placeholder="名前 or No で絞り込み"></label>
            </p>
            <div id="roommate-checkboxes-s2" class="roommate-checkboxes"></div>
            <button type="button" class="btn-save-assignment" data-session="2">保存</button>
            <span class="save-result" id="save-result-s2"></span>
            <div class="roommates-by-session" id="roommates-s2">
                <h4>このセッションの同室者一覧</h4>
                <div id="roommates-list-s2"></div>
            </div>
        </div>
    </div>
</section>

<section>
    <h2>4. 同室者一覧・メモ（従来）</h2>
    <div id="roommates-area" style="display:none;">
        <p id="roommates-empty">同室者がいません。</p>
        <div id="roommates-list"></div>
    </div>
</section>

<section>
    <h2>5. 振り返り</h2>
    <div id="review-disabled" style="display:none;">
        <p class="hint">自分を選択すると振り返りを表示します。</p>
    </div>
    <div id="review-body" style="display:none;">
        <div id="review-s1">
            <h3>Session 1 の同室者</h3>
            <div id="review-roommates-s1"></div>
        </div>
        <div id="review-s2">
            <h3>Session 2 の同室者</h3>
            <div id="review-roommates-s2"></div>
        </div>
        <p><button type="button" id="btn-refresh-review">振り返りを再取得</button></p>
    </div>
</section>

<section>
    <h2>6. 自分が書いたメモ一覧</h2>
    <button type="button" id="btn-load-memos">メモ一覧を更新</button>
    <ul id="memos-list" class="memos"></ul>
</section>

@push('scripts')
<script>
(function() {
    const number = {{ $number }};
    const initialParticipantId = {{ json_encode($participant_id_from_query ?? null) }};
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
        document.getElementById('breakout-record-disabled').style.display = hasParticipant ? 'none' : 'block';
        document.getElementById('breakout-record-body').style.display = hasParticipant ? 'block' : 'none';
        document.getElementById('review-disabled').style.display = hasParticipant ? 'none' : 'block';
        document.getElementById('review-body').style.display = hasParticipant ? 'block' : 'none';
        document.getElementById('participant-required-msg').style.display = hasParticipant ? 'none' : 'block';
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
            row.style.display = !q || text.toLowerCase().indexOf(q) !== -1 ? '' : 'none';
        });
    }

    function renderRoommateCheckboxes(session) {
        const container = document.getElementById('roommate-checkboxes-s' + session);
        container.innerHTML = '';
        allParticipantsForBreakout.forEach(function(a) {
            const row = document.createElement('label');
            row.className = 'roommate-row';
            row.dataset.displayNo = (a.member && a.member.display_no) ? String(a.member.display_no) : '';
            row.dataset.name = (a.member && a.member.name) ? String(a.member.name) : '';
            const id = 'cb-s' + session + '-' + a.participant_id;
            row.innerHTML = '<input type="checkbox" class="roommate-cb" data-session="' + session + '" value="' + a.participant_id + '" id="' + id + '"> ' +
                (a.member ? (a.member.display_no + ' ' + a.member.name) : '') + ' (' + (a.type || '') + ')';
            row.style.display = '';
            container.appendChild(row);
        });
    }

    async function saveBreakoutAssignment(session, roomLabel, roommateIds) {
        const participantId = getSelectedParticipantId();
        if (!participantId || !roomLabel.trim()) return;
        const resultEl = document.getElementById('save-result-s' + session);
        resultEl.textContent = '保存中...';
        resultEl.className = 'save-result';
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
            const data = await res.json();
            if (!res.ok) throw new Error(data.message || (data.errors ? JSON.stringify(data.errors) : 'Failed'));
            resultEl.textContent = '保存しました';
            resultEl.className = 'save-result ok';
            fetchRoommatesBySession(session);
            refreshReview();
        } catch (e) {
            resultEl.textContent = 'エラー: ' + (e.message || '');
            resultEl.className = 'save-result error';
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
                listEl.innerHTML = '<p class="hint">このセッションの同室者はいません。ルーム名と同室者を選んで保存してください。</p>';
            } else {
                roommatesList.forEach(function(r) {
                    const card = document.createElement('div');
                    card.className = 'card';
                    card.dataset.targetParticipantId = r.participant_id;
                    card.innerHTML = '<div><strong>' + (r.member ? r.member.display_no + ' ' + r.member.name : '') + '</strong></div>' +
                        '<textarea data-target-id="' + r.participant_id + '" placeholder="メモを入力"></textarea>' +
                        '<button type="button" class="btn-save-memo btn-save-memo-session" data-session="' + session + '" data-target-id="' + r.participant_id + '">保存</button>' +
                        '<span class="saved" style="display:none;"></span>';
                    listEl.appendChild(card);
                });
            }
        } catch (e) {
            listEl.innerHTML = '<p class="error">取得失敗: ' + (e.message || '') + '</p>';
        }
    }

    function refreshReview() {
        const participantId = getSelectedParticipantId();
        if (!participantId) return;
        [1, 2].forEach(function(session) {
            const container = document.getElementById('review-roommates-s' + session);
            container.innerHTML = '<p class="hint">読み込み中...</p>';
            fetch(baseUrl + '/breakout-roommates/' + participantId + '?session=' + session)
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    const list = data.data || [];
                    if (list.length === 0) {
                        container.innerHTML = '<p class="hint">同室者なし</p>';
                    } else {
                        container.innerHTML = '<ul class="review-list"></ul>';
                        const ul = container.querySelector('ul');
                        list.forEach(function(r) {
                            const li = document.createElement('li');
                            li.textContent = (r.member ? r.member.display_no + ' ' + r.member.name : '') || ('ID:' + r.participant_id);
                            ul.appendChild(li);
                        });
                    }
                })
                .catch(function(e) {
                    container.innerHTML = '<p class="error">取得失敗: ' + (e.message || '') + '</p>';
                });
        });
    }

    async function fetchAttendees() {
        const errEl = document.getElementById('attendees-error');
        errEl.style.display = 'none';
        try {
            const res = await fetch(baseUrl + '/attendees');
            const data = await res.json();
            if (!res.ok) throw new Error(data.message || 'Failed');
            attendees = data;
            renderAttendees(data);
            fillParticipantSelect(data);
            document.getElementById('attendees-tables').style.display = 'block';
            if (initialParticipantId && document.querySelector('#select-participant option[value="' + initialParticipantId + '"]')) {
                document.getElementById('select-participant').value = initialParticipantId;
                updateParticipantInUrl(initialParticipantId);
                setBreakoutAndReviewVisibility(true);
            }
        } catch (e) {
            errEl.textContent = e.message || '参加者の読み込みに失敗しました';
            errEl.style.display = 'block';
        }
    }

    function renderAttendees(data) {
        function rowMember(a) {
            return '<tr><td>' + (a.member.display_no || '') + '</td><td>' + (a.member.name || '') + '</td><td>' + (a.member.category || '') + '</td><td>' + (a.member.role_notes || '') + '</td><td>' + (a.breakout_room_labels && a.breakout_room_labels.length ? a.breakout_room_labels.join(',') : '') + '</td></tr>';
        }
        function rowShort(a) {
            return '<tr><td>' + (a.member.display_no || '') + '</td><td>' + (a.member.name || '') + '</td><td>' + (a.member.category || '') + '</td><td>' + (a.breakout_room_labels && a.breakout_room_labels.length ? a.breakout_room_labels.join(',') : '') + '</td></tr>';
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
        area.style.display = 'block';
        empty.style.display = 'block';
        try {
            const res = await fetch(baseUrl + '/breakout-roommates/' + participantId);
            const data = await res.json();
            if (!res.ok) throw new Error(data.message || 'Failed');
            roommates = data.data || [];
            empty.style.display = roommates.length ? 'none' : 'block';
            roommates.forEach(function(r) {
                const card = document.createElement('div');
                card.className = 'card';
                card.dataset.targetParticipantId = r.participant_id;
                card.innerHTML = '<div><strong>' + (r.member ? r.member.display_no + ' ' + r.member.name : '') + '</strong> ' + (r.member ? r.member.category || '' : '') + '</div>' +
                    '<textarea data-target-id="' + r.participant_id + '" placeholder="メモを入力"></textarea>' +
                    '<button type="button" class="btn-save-memo" data-target-id="' + r.participant_id + '">保存</button>' +
                    '<span class="saved" style="display:none;"></span>';
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
                li.innerHTML = '<strong>' + (m.target_member ? m.target_member.display_no + ' ' + m.target_member.name : '') + '</strong>: ' + (m.body || '(メモなし)') + ' <span style="color:#666;font-size:0.85rem">' + (m.updated_at || '') + '</span>';
                list.appendChild(li);
            });
        } catch (e) {
            const li = document.createElement('li');
            li.className = 'error';
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

    document.getElementById('btn-refresh-review').addEventListener('click', refreshReview);

    document.getElementById('search-s1').addEventListener('input', function() { filterBySearch(1); });
    document.getElementById('search-s2').addEventListener('input', function() { filterBySearch(2); });

    document.getElementById('roommates-list').addEventListener('click', function(ev) {
        if (!ev.target.classList.contains('btn-save-memo')) return;
        const participantId = document.getElementById('select-participant').value;
        if (!participantId) return;
        const targetId = ev.target.dataset.targetId;
        const card = ev.target.closest('.card');
        const textarea = card.querySelector('textarea');
        const savedSpan = card.querySelector('.saved');
        const body = textarea ? textarea.value.trim() : '';
        ev.target.disabled = true;
        savedSpan.style.display = 'none';
        upsertMemo(participantId, targetId, body || null).then(function() {
            savedSpan.className = 'saved';
            savedSpan.textContent = '保存しました';
            savedSpan.style.display = 'inline';
            ev.target.disabled = false;
        }).catch(function(e) {
            savedSpan.textContent = 'エラー: ' + (e.message || '');
            savedSpan.className = 'saved error';
            savedSpan.style.display = 'inline';
            ev.target.disabled = false;
        });
    });

    document.getElementById('section-breakout-record').addEventListener('click', function(ev) {
        if (!ev.target.classList.contains('btn-save-memo-session')) return;
        const participantId = getSelectedParticipantId();
        if (!participantId) return;
        const targetId = ev.target.dataset.targetId;
        const card = ev.target.closest('.card');
        const textarea = card ? card.querySelector('textarea') : null;
        const savedSpan = card ? card.querySelector('.saved') : null;
        const body = textarea ? textarea.value.trim() : '';
        ev.target.disabled = true;
        if (savedSpan) savedSpan.style.display = 'none';
        upsertMemo(participantId, targetId, body || null).then(function() {
            if (savedSpan) {
                savedSpan.className = 'saved';
                savedSpan.textContent = '保存しました';
                savedSpan.style.display = 'inline';
            }
            ev.target.disabled = false;
            fetchMemos();
        }).catch(function(e) {
            if (savedSpan) {
                savedSpan.textContent = 'エラー: ' + (e.message || '');
                savedSpan.className = 'saved error';
                savedSpan.style.display = 'inline';
            }
            ev.target.disabled = false;
        });
    });
})();
</script>
@endpush
@endsection
