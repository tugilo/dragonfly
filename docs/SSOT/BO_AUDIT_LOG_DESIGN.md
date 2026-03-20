# BO 割当保存の監査ログ設計（BO-AUDIT-P1）

**Phase:** BO-AUDIT-P1  
**目的:** Dashboard Activity の `bo_assigned` を **説明可能な永続イベント**として扱う。CSV 反映ログ（`meeting_csv_apply_logs`）とは **責務を分離**する。

---

## 1. イベント発生源（調査結果）

| 経路 | HTTP | Controller | Service | 備考 |
|------|------|------------|---------|------|
| **Connections（管理画面）** | `PUT /api/meetings/{meetingId}/breakouts` | `MeetingBreakoutController` | `MeetingBreakoutService::updateBreakouts` | `DragonFlyBoard.jsx` が利用。BO1/BO2 一括保存。 |
| **複数 Round** | `PUT /api/meetings/{meetingId}/breakout-rounds` | `MeetingBreakoutRoundsController` | `MeetingBreakoutRoundsService::updateBreakoutRounds` | Round 単位で BO1/BO2。 |
| レガシー DragonFly | `PUT /api/dragonfly/meetings/{number}/breakout-assignments` | `DragonFlyBreakoutAssignmentController` | `BreakoutAssignmentService` | Session / 同室者ベース。**P1 では監査未接続**（管理 UI の主線は上記2つ）。 |
| CSV apply | — | `MeetingCsvImportController` | `MeetingCsvApplyLogWriter` | **参加者・members・roles 反映**。BO 割当ではない。流用しない。 |

**結論:** 監査は **Meetings ドメイン**（breakout 保存 API）の成功コミット直後に **1 行追加**するのが自然。Connections はあくまでクライアント; 責務は **Meeting の breakout 更新**に紐づく。

---

## 2. 採用案（責務）

- **案A（Meetings ドメイン）✅ 採用** — `bo_assignment_audit_logs.meeting_id` を主外部キーとし、書き込みは breakout 用 Controller 成功後のみ。
- 案B（Connections 専用テーブル）— 不採用。サーバ上の「Connections」は存在せず、API は Meeting 単位。
- 案C（汎用アクティビティテーブルのみ）— 将来検討可。初回は **BO 専用の最小テーブル**で十分（クエリ・インデックスが明確）。

---

## 3. テーブル `bo_assignment_audit_logs`

| カラム | 型 | 意味 |
|--------|-----|------|
| id | bigint | PK |
| meeting_id | FK meetings | 必須 |
| actor_user_id | FK users nullable | 操作ユーザー（現行は `users.id = 1` 固定に相当） |
| actor_owner_member_id | FK members nullable | Dashboard の「自分」の文脈。`User::owner_member_id` スナップショット。**Activity はこれでフィルタ** |
| workspace_id | bigint nullable | 将来用（現状 null） |
| source | string(40) | `connections_breakouts` \| `breakout_rounds` |
| payload | json | 保存後スナップショット（rooms または rounds） |
| occurred_at | datetime | 保存完了時刻 |
| timestamps | | |

**before/after:** 初回は未保持。差分が必要になったら後続 Phase で `payload` 拡張または別列。

---

## 4. Dashboard Activity 接続

| 項目 | 内容 |
|------|------|
| kind | `bo_assigned` |
| フィルタ | `actor_owner_member_id = GET /api/dashboard/activity` の owner（E-4 と同じ） |
| occurred_at | `bo_assignment_audit_logs.occurred_at` |
| title | `例会 #{meeting.number} のBO割当を保存` |
| meta | `BO1/BO2・割当 n名` または `複数Round・割当 n名`（payload からユニーク member_id 数） |
| ソート | 既存と同様 `occurred_at` 降順でマージ後スライス |

**CSV apply:** 本テーブルに書かない。Dashboard の「BO 保存」と混同させない。

---

## 5. 既知の制限（将来）

- **DragonFly レガシー API** の保存は未ログ。利用が残るなら `source` 追加と Writer 呼び出しを別タスクで。
- **認証:** 現状 `User::find(1)` に相当（Dashboard と同じ）。本番認証導入時は `auth()->id()` に差し替え。
