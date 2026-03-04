# PHASE12V Religo Members / Meetings List — WORKLOG

**Phase:** Members / Meetings List 実装  
**作成日:** 2026-03-05

---

## Step 0: 前提確認

- GET /api/dragonfly/members（owner_member_id, with_summary=1）、GET /api/meetings の仕様を確認。

## Step 1: dataProvider 拡張

- getList に resource === 'members' と resource === 'meetings' を追加。members は owner_member_id を filter またはデフォルト 1 で付与。

## Step 2: MembersList / MeetingsList 作成

- MembersList.jsx: List + Datagrid（display_no, name, same_room_count, last_memo 等）。TopToolbar に「Board へ戻る」。
- MeetingsList.jsx: List + Datagrid（number, held_on）。TopToolbar に「Board へ戻る」。

## Step 3: app.jsx 差し替え

- MembersPlaceholder → MembersList、MeetingsPlaceholder → MeetingsList に変更。

## Step 4: テスト・docs

- php artisan test。REPORT・INDEX・progress 更新。
