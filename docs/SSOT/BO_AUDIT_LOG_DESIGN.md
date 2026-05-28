# BO 割当保存の監査ログ設計（BO-AUDIT-P1 / P2 / P3）

**Phase:** P1 基盤 · P2 レガシーAPI · **P3** `/api/users/me` と actor/workspace 一本化 · **P4** `users.default_workspace_id` と解決順の明示 · **WORKSPACE-SINGLE-CHAPTER-ASSUMPTION** BNI 前提の 1 user = 1 workspace SSOT 固定  
**目的:** Dashboard Activity の `bo_assigned` を **説明可能な永続イベント**として扱う。CSV 反映ログ（`meeting_csv_apply_logs`）とは **責務を分離**する。

**actor / workspace の単一情報源:** [USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md)（`ReligoActorContext`）。

---

## 1. イベント発生源（調査結果）

| 経路 | HTTP | Controller | Service | 備考 |
|------|------|------------|---------|------|
| **Connections（管理画面）** | `PUT /api/meetings/{meetingId}/breakouts` | `MeetingBreakoutController` | `MeetingBreakoutService::updateBreakouts` | `DragonFlyBoard.jsx` が利用。BO1/BO2 一括保存。 |
| **複数 Round** | `PUT /api/meetings/{meetingId}/breakout-rounds` | `MeetingBreakoutRoundsController` | `MeetingBreakoutRoundsService::updateBreakoutRounds` | Round 単位で BO1/BO2。 |
| **レガシー DragonFly MVP** | `PUT /api/dragonfly/meetings/{number}/breakout-assignments` | `DragonFlyBreakoutAssignmentController` | `BreakoutAssignmentService::saveAssignment` | **participant_id** ベース・セッション1/2。DELETE は **監査しない**。 |
| CSV apply | — | `MeetingCsvImportController` | `MeetingCsvApplyLogWriter` | **参加者・members・roles 反映**。BO 割当ではない。流用しない。 |

**レガシーと主線の意味:** 永続はいずれも例会あたりの **BO 状態**を更新する。`source` で API 所在を区別する。

**二重記録:** 別 API の連続呼び出しは別イベント。同一ハンドラ内で Writer を二重に呼ばない。

---

## 2. 採用案（責務）

- **Meetings ドメイン** — `meeting_id` 主外部キー、各 BO 保存成功直後に **1 行**。

---

## 3. テーブル `bo_assignment_audit_logs`

| カラム | 型 | 意味 |
|--------|-----|------|
| meeting_id | FK meetings | 必須 |
| actor_user_id | FK users nullable | **P3:** `ReligoActorContext::actingUser()` と `/api/users/me` の `id` と同一基準。 |
| actor_owner_member_id | FK members nullable | 上記 User の `owner_member_id`。**Activity はこれでフィルタ** |
| workspace_id | bigint nullable | **所属チャプター（workspace）。** `ReligoActorContext::resolveWorkspaceIdForUser(actor_user)`（**所属** `default_workspace_id` → legacy 補完 → システムフォールバック）。[WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)。 |
| source | string(40) | `connections_breakouts` \| `breakout_rounds` \| `dragonfly_breakout_assignments` |
| payload | json | 保存スナップショット |
| occurred_at | datetime | 保存完了時刻 |

---

## 4. Dashboard Activity 接続

| 項目 | 内容 |
|------|------|
| kind | `bo_assigned` |
| フィルタ | `actor_owner_member_id` = activity の owner。`workspace_id` は **クエリでは未使用**。 |
| meta | source 別（P2 まで通り） |

---

## 5. Writer API（`BoAssignmentAuditLogWriter`）

- 内部で `ReligoActorContext` と一致する actor / workspace を使用。
- `resolveActorUser()` / `resolveWorkspaceIdForAudit(?User)` — public（テスト・呼び出し互換）。

---

## 6. 既知の制限（将来）

- **users.me:** `UserController` は認証優先・無認証時フォールバック。**複数 User が無認証で共有運用される**場合は最小 id が「me」になる点に注意。
- **workspace:** `default_workspace_id` が無く、owner 由来の flags/o2o/memo にも workspace が無い場合は **先頭 workspace**。全体の順序は [WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)。
