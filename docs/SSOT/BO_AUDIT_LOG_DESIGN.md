# BO 割当保存の監査ログ設計（BO-AUDIT-P1 / P2）

**Phase:** BO-AUDIT-P1（基盤）＋ **BO-AUDIT-P2**（レガシー・workspace・actor）  
**目的:** Dashboard Activity の `bo_assigned` を **説明可能な永続イベント**として扱う。CSV 反映ログ（`meeting_csv_apply_logs`）とは **責務を分離**する。

---

## 1. イベント発生源（調査結果）

| 経路 | HTTP | Controller | Service | 備考 |
|------|------|------------|---------|------|
| **Connections（管理画面）** | `PUT /api/meetings/{meetingId}/breakouts` | `MeetingBreakoutController` | `MeetingBreakoutService::updateBreakouts` | `DragonFlyBoard.jsx` が利用。BO1/BO2 一括保存。 |
| **複数 Round** | `PUT /api/meetings/{meetingId}/breakout-rounds` | `MeetingBreakoutRoundsController` | `MeetingBreakoutRoundsService::updateBreakoutRounds` | Round 単位で BO1/BO2。 |
| **レガシー DragonFly MVP** | `PUT /api/dragonfly/meetings/{number}/breakout-assignments` | `DragonFlyBreakoutAssignmentController` | `BreakoutAssignmentService::saveAssignment` | **participant_id** ベース・セッション1/2。`mvp.blade.php` が利用。**P2 で監査接続**（`source = dragonfly_breakout_assignments`）。DELETE は割当解除のため **監査しない**。 |
| CSV apply | — | `MeetingCsvImportController` | `MeetingCsvApplyLogWriter` | **参加者・members・roles 反映**。BO 割当ではない。流用しない。 |

**レガシーと主線の意味:** 永続はいずれも `breakout_rooms` / `participant_breakout` 上の **例会あたりの BO 状態**を更新する。ペイロード形状は異なるが「BO 割当の保存が完了した」という **同一の Dashboard 意味（`bo_assigned`）** で扱う。`source` で API 所在を区別する。

**二重記録:** API が別々に呼ばれたときは行が複数になるのみ（不具合ではない）。同一 HTTP ハンドラ内で Writer を二重に呼ばないこと。

---

## 2. 採用案（責務）

- **案A（Meetings ドメイン）✅ 採用** — `bo_assignment_audit_logs.meeting_id` を主外部キーとし、書き込みは各 BO 保存 API の成功直後に **1 行**。
- 案B（Connections 専用テーブル）— 不採用。
- 案C（汎用アクティビティテーブルのみ）— 初回はオーバー。

---

## 3. テーブル `bo_assignment_audit_logs`

| カラム | 型 | 意味 |
|--------|-----|------|
| id | bigint | PK |
| meeting_id | FK meetings | 必須 |
| actor_user_id | FK users nullable | **P2:** `auth()->user()` が `App\Models\User` ならその id。**無認証時は id 昇順の先頭 User** にフォールバック（暫定・従来 UserController の「me」固定と同趣旨）。 |
| actor_owner_member_id | FK members nullable | Dashboard の「自分」の文脈。上記 User の `owner_member_id` スナップショット。**Activity はこれでフィルタ** |
| workspace_id | bigint nullable | **P2:** **`workspaces` を id 昇順で最初の 1 件**（単一チャプター運用の既定）。行が無ければ null。Dashboard 活動フィルタには **現状未使用**（将来の絞り込み用）。 |
| source | string(40) | `connections_breakouts` \| `breakout_rounds` \| `dragonfly_breakout_assignments` |
| payload | json | 保存スナップショット（rooms / rounds / レガシーは session・participant_id 等） |
| occurred_at | datetime | 保存完了時刻 |
| timestamps | | |

**before/after:** 未保持（P1/P2）。差分は後続 Phase で検討。

---

## 4. Dashboard Activity 接続

| 項目 | 内容 |
|------|------|
| kind | `bo_assigned` |
| フィルタ | `actor_owner_member_id = GET /api/dashboard/activity` の owner（E-4 と同じ）。`workspace_id` の有無は **フィルタに使わない**（P2）。 |
| occurred_at | `bo_assignment_audit_logs.occurred_at` |
| title | `例会 #{meeting.number} のBO割当を保存` |
| meta | **source 別:** BO1/BO2・複数Round（member ユニーク数）／**レガシー:** `DragonFly MVP・セッションN・同席M名（participant）` |
| ソート | `occurred_at` 降順で他 kind とマージ後スライス |

**CSV apply:** 本テーブルに書かない。

---

## 5. Writer API（`BoAssignmentAuditLogWriter`）

- `logFromBreakoutsPayload` / `logFromBreakoutRoundsPayload` / `logFromDragonFlyBreakoutAssignment`
- `resolveActorUser()` / `resolveWorkspaceIdForAudit()` — テスト・将来の明示注入用に public。

---

## 6. 既知の制限（将来）

- **複数 workspace 本番運用時:** `workspace_id` を「ユーザ既定」や meeting 文脈で上書きする余地あり（現状は先頭 workspace のみ）。
- **認証:** Sanctum 等で API が常にログイン必須になったら、フォールバックがほぼ使われなくなる想定。
