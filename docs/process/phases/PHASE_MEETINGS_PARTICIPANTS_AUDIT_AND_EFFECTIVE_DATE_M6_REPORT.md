# Phase M7-M6（M6）: 監査ログ / 基準日指定 — REPORT

**Phase ID:** M7-M6  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/database/migrations/2026_03_17_220000_create_meeting_csv_apply_logs_table.php
- www/app/Models/MeetingCsvApplyLog.php
- www/app/Services/Religo/MeetingCsvApplyLogWriter.php
- www/app/Services/Religo/ApplyMeetingCsvRoleDiffService.php（基準日解決・戻り値拡張）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（ログ記録・role-apply 入力・applyLogs）
- www/app/Http/Controllers/Religo/MeetingController.php（`csv_apply_logs_recent`）
- www/app/Models/Meeting.php、MeetingCsvImport.php（relation）
- www/routes/api.php
- www/resources/js/admin/pages/MeetingsList.jsx
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php
- www/tests/Feature/Religo/MeetingControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_*.md
- docs/process/PHASE_REGISTRY.md、docs/INDEX.md、docs/dragonfly_progress.md
- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md

---

## 実装要約

- 反映成功時のみ `meeting_csv_apply_logs` に追記。422/404 では書かない。
- Role 基準日: `effective_date`（任意）→ `held_on` → `today`。

## 追加したログ / API / UI

- **テーブル** `meeting_csv_apply_logs`（apply_type, applied_on, executed_at, 件数列, meta, executed_by_member_id nullable）
- **GET** `/api/meetings/{meetingId}/csv-import/apply-logs?limit=1..50` → `{ logs: [...] }`
- **GET meeting show** に `csv_apply_logs_recent`（新しい順最大 12 件、`summary` 付き）
- **POST role-apply** ボディ `effective_date` 任意。レスポンスに `effective_date`, `effective_date_source`
- **UI:** Role ダイアログに日付入力、CSV ブロックに直近履歴リスト

## 基準日指定の反映

- `MemberRole` の `term_end` / `term_start` は解決した日付文字列を使用。ログの `applied_on`（roles）も同一。

## テスト結果

- `php artisan test`: **227 passed**（922 assertions）
- `npm run build`: 成功

## 既知の制約

- `executed_by_member_id` は常に null（本格認証連携は未実施）。
- 履歴は一覧のみ（diff・rollback なし）。
- `held_on` が DB 上必須のため `today` フォールバックは稀。

## 次の改善候補

- 認証ユーザーと member の紐づけで `executed_by_member_id` を埋める。
- 履歴のフィルタ・エクスポート、詳細モーダル。

---

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch:  
target branch: develop  
phase id: M7-M6  
phase type: implement  

test command: php artisan test  
test result: 227 passed  

scope check: OK  
ssot check: OK  
dod check: OK  
