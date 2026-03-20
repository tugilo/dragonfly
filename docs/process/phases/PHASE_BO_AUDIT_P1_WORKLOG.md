# WORKLOG: BO-AUDIT-P1

## 判断ログ（いつ何をしたかではなく、何を判断したか）

### BO 保存処理の入口

- **主線:** `PUT /api/meetings/{meetingId}/breakouts`（`MeetingBreakoutController@update` → `MeetingBreakoutService::updateBreakouts`）。Board（`DragonFlyBoard.jsx`）が利用。
- **Round 版:** `PUT /api/meetings/{meetingId}/breakout-rounds`（`MeetingBreakoutRoundsController` → `MeetingBreakoutRoundsService`）。
- **レガシー:** `PUT /api/dragonfly/meetings/{number}/breakout-assignments` は P1 では監査未接続（利用状況を別タスクで確認してから拡張可能）。

### 既存ログの責務評価

- **`meeting_csv_apply_logs`:** participants / members / roles の CSV 反映成功時のみ。スキーマ・業務意味とも BO 割当保存とは異なる。**流用しない**（方針 B）。

### 採用した責務（Meetings / Connections / 専用）

- **Meetings ドメイン＋専用テーブル `bo_assignment_audit_logs`。** 「Connections」は React 画面の呼び名でありサーバドメインではない。イベントは **例会の breakout 状態が永続化された事実**なので `meeting_id` を FK に置くのが自然。汎用 activity テーブルは初回オーバーと判断。

### 保存項目の決め方

- Dashboard から逆算: `kind`, `occurred_at`, `title`（例会番号）, `meta`（BO1/BO2 または複数Round・割当人数）。
- **owner フィルタ:** `User::find(1)->owner_member_id` を保存時スナップショット（`actor_owner_member_id`）。既存 Dashboard と同じ「単一ユーザー」前提。本番認証時は `auth()->id()` への差し替えが後続。

### Dashboard Activity への接続方針

- `getActivity` 内で `BoAssignmentAuditLog` を `actor_owner_member_id = ownerMemberId` で取得し、memo / flag / 1to1 と同様に `rows` に足してから `occurred_at` で `usort`。**CSV apply ログと ID 空間・意味を混在させない**（`id` プレフィックス `bo-audit-`）。

### 実装したか / 見送ったか

- **実装した:** マイグレーション・Writer・Controller 2 箇所・`DashboardService`・`DashboardApiTest` 1 本。
- **見送り:** レガシー breakout-assignments の監査。

### merge 時の競合

- （Merge 実施後に WORKLOG 追記: なし / あり＋内容）
