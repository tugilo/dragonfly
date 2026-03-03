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
    <button type="button" id="btn-show-roommates">同室者を表示</button>
</section>

<section>
    <h2>3. 同室者一覧・メモ</h2>
    <div id="roommates-area" style="display:none;">
        <p id="roommates-empty">同室者がいません。</p>
        <div id="roommates-list"></div>
    </div>
</section>

<section>
    <h2>4. 自分が書いたメモ一覧</h2>
    <button type="button" id="btn-load-memos">メモ一覧を更新</button>
    <ul id="memos-list" class="memos"></ul>
</section>

@push('scripts')
<script>
(function() {
    const number = {{ $number }};
    const baseUrl = '/api/dragonfly/meetings/' + number;
    let attendees = { meeting: null, attendees: { member: [], visitor: [], guest: [] } };
    let roommates = [];

    function getCsrfHeaders() {
        const token = document.querySelector('meta[name="csrf-token"]');
        return {
            'X-CSRF-TOKEN': token ? token.getAttribute('content') : '',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        };
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
})();
</script>
@endpush
@endsection
