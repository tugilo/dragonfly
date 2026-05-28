# PHASE CONN-LEFT-PANE-MEETING-P1 — PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | CONN-LEFT-PANE-MEETING-P1 |
| **種別** | implement |
| **Related SSOT** | SPEC-007 — [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) |
| **前提** | CONN-BO-PARTICIPANT-REQUIRED-P1（BO 保存は参加者必須） |
| **目的** | Connections 左ペインを **選択中例会の参加者のみ**表示。API で `meeting_id` 絞り込み、欠席除外、proxy は `bo_assignable: false`。 |
| **DoD** | `IndexDragonFlyMembersRequest`・`DragonFlyMemberController@index`・`DragonFlyBoard.jsx`・SSOT 5.2–5.4・テスト・build・REPORT・INDEX・進捗。 |

## Scope

- `meeting_id` クエリ（optional）で participants スコープ
- `DragonFlyBoard` の `refetchMembers` と UI（代理チップ・BO メニュー制限・Autocomplete）

## 非スコープ

- `GET /api/dragonfly/meetings/{n}/attendees` の `regular`/`proxy` バケット修正（別課題）
