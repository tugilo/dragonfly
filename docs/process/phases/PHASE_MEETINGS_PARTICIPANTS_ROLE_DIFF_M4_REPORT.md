# Phase M7-M4: Role History 差分検知（表示のみ）— REPORT

**Phase ID:** M7-M4  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Services/Religo/MeetingCsvRoleDiffPreviewService.php（新規）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（`roleDiffPreview`）
- www/routes/api.php（GET role-diff-preview）
- www/resources/js/admin/pages/MeetingsList.jsx（fetch・state・「role差分を確認」・表）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php（M7-M4 テスト 9 本）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_PLAN.md / WORKLOG.md / REPORT.md（本ファイル）
- docs/process/PHASE_REGISTRY.md、docs/INDEX.md、docs/dragonfly_progress.md
- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md（実装メモ追記）

---

## 実装要約

- 保存済み CSV を `MeetingCsvPreviewService` で読み、名前解決済み行について CSV 役職と `Member::currentRole()?->name` を比較。`changed_role` / `csv_role_only` / `current_role_only` / `unchanged_role_count` / `unresolved_member` と summary カウントを返す。
- **DB 更新なし**（GET のみ）。`roles` の自動作成なし。

## API

- **GET /api/meetings/{meetingId}/csv-import/role-diff-preview**  
  レスポンス: `summary`（各 count）、`changed_role`, `csv_role_only`, `current_role_only`, `unresolved_member`。各差分行に `role_master_resolved`（該当時）。

## UI

- CSV プレビュー行数あり時、「role差分を確認」で取得。Alert・Chips・セクション別テーブル。Drawer 閉鎖でリセット。

## テスト結果

- MeetingCsvImportControllerTest に M7-M4 用 9 本追加。当該ファイル **56 passed**。  
- 実施コマンド: `php artisan test`（全体 **212 passed**）  
- **npm run build** 成功（本 REPORT 作成時）。

## 既知の制約

- 名前完全一致での member 解決のみ（member 差分と同じ）。
- 役職の「意味的同一・表記ゆれ」は未対応（文字列一致）。

## 次の改善候補

- Role History 確定反映（term_end / 新規 member_role）の別 Phase・承認 UI。
- 役職名の表記ゆれ・別名マッピング。

---

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch:  
target branch: develop  
phase id: M7-M4  
phase type: implement  

test command: php artisan test --filter=MeetingCsvImportControllerTest  
test result: 212 passed（全体） / MeetingCsvImportControllerTest 56 passed  

scope check: OK  
ssot check: OK  
dod check: OK  
