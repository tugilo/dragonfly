# Phase M7-M6（ユーザー表記: M6）: 監査ログ / 基準日指定 — PLAN

**Phase ID:** M7-M6  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md, PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_REPORT.md, PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_REPORT.md, PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_REPORT.md

**モック比較:** Meetings Drawer の CSV ブロック拡張のみ。個別 MOCK_UI_VERIFICATION 対象外。

---

## 背景

- participants / members / roles の CSV 反映は実装済みだが、**誰が・いつ・何件**を一元的に追うテーブルがなかった（import の `imported_at` / `applied_count` のみ）。
- Role apply の基準日が **今日固定** であり、**例会日や任意日**に合わせた履歴更新ができなかった。

## 目的

- 3 種の反映成功時に **追記型の監査ログ** を残す。
- **POST role-apply** で `effective_date` を受け取り、未指定時は **meeting.held_on → today** の優先順で member_roles の term に使用する。
- Drawer で基準日入力と **直近履歴の簡易表示** を行う。

## スコープ

**やること**

1. `meeting_csv_apply_logs` テーブルと `MeetingCsvApplyLog` モデル。
2. `MeetingCsvApplyLogWriter` で participants / members / roles 成功時に 1 行追記。
3. `ApplyMeetingCsvRoleDiffService` の基準日解決ロジック変更・レスポンスに `effective_date` / `effective_date_source`。
4. `GET .../csv-import/apply-logs` と `GET meeting show` の `csv_apply_logs_recent`（最大 12 件）。
5. `MeetingsList.jsx`: Role 確認ダイアログに `type="date"`、反映履歴ブロック。

**やらないこと**

- rollback、本格認証の `executed_by`、PDF 全面、履歴 diff UI、ログ編集削除、categories/roles 自動作成。

## 変更対象ファイル

- www/database/migrations/*meeting_csv_apply_logs*
- www/app/Models/MeetingCsvApplyLog.php
- www/app/Services/Religo/MeetingCsvApplyLogWriter.php
- www/app/Services/Religo/ApplyMeetingCsvRoleDiffService.php
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php
- www/app/Http/Controllers/Religo/MeetingController.php
- www/app/Models/Meeting.php / MeetingCsvImport.php（relation）
- www/routes/api.php
- www/resources/js/admin/pages/MeetingsList.jsx
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php
- www/tests/Feature/Religo/MeetingControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_*.md
- docs/process/PHASE_REGISTRY.md、docs/INDEX.md、docs/dragonfly_progress.md
- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md

## 監査ログ方針

- `apply_type`: `participants` | `members` | `roles`
- `applied_on`: roles は **effective_date**（履歴上の基準日）。participants / members は **実行日の日付**（`now()->toDateString()`）。
- `executed_at`: 常に `now()`
- 件数列 + `meta`（delete_missing、skipped 内訳、effective_date_source 等）
- 失敗（422/404）では **ログを書かない**

## 基準日方針（Role apply）

1. リクエスト `effective_date` があれば **最優先**（`source: request`）
2. なければ **`meeting.held_on`**（`source: held_on`）
3. `held_on` が null の場合のみ **`today`**（`source: today`）— 現行スキーマでは `held_on` NOT NULL のためフォールバックは防御的

## UI 方針

- Role History 確認ダイアログに日付欄。空欄で POST 時は `effective_date` キー省略 → サーバが held_on を使用。
- Drawer 内 CSV エリア下部に「CSV反映履歴（直近）」を `csv_apply_logs_recent` で表示。

## テスト観点

- effective_date 指定で term がその日付になること・ログ `applied_on` が一致すること。
- 未指定時は **held_on** が使われること（既存 role apply テストの期待値を held_on に合わせる）。
- 各 apply 成功でログ 1 行、422 でログ増えないこと。
- apply-logs GET、show に `csv_apply_logs_recent` があること。

## DoD

- [x] 上記実装・テスト・ビルド・ドキュメント更新。
