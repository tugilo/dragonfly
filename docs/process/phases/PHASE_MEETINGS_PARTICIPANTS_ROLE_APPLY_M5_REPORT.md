# Phase M7-M5（M5）: Role History の確定反映 — REPORT

**Phase ID:** M7-M5  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Services/Religo/ApplyMeetingCsvRoleDiffService.php（新規）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（`roleApply`）
- www/routes/api.php（POST role-apply）
- www/resources/js/admin/pages/MeetingsList.jsx（API 呼び出し・ボタン・確認 Dialog・Alert 文言）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php（M7-M5 テスト 9 本）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_PLAN.md / WORKLOG.md / REPORT.md（本ファイル）
- docs/process/PHASE_REGISTRY.md、docs/INDEX.md、docs/dragonfly_progress.md
- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md（実装メモ）

---

## 実装要約

- M4 と同じ `roleDiffPreview` を apply 内で実行し、**マスタ解決済みの changed / csv_only** と **すべての current_role_only** をトランザクションで反映。open 行の特定は `Member::currentRole()` と同条件（`term_end` null、`term_start <= 基準日`、最大 `term_start`）。

## 追加した API / Service

- **POST /api/meetings/{meetingId}/csv-import/role-apply**  
  レスポンス: `changed_role_applied_count`, `csv_role_only_applied_count`, `current_role_only_closed_count`, `skipped_unresolved_role_count`, `message`。
- **ApplyMeetingCsvRoleDiffService::apply(Meeting, MeetingCsvImport)**

## Role History 反映 UI

- 役職差分プレビュー表示中、適用対象があるとき「Role History に反映」（warning contained）。確認ダイアログで終了・開始・CSV 無し時の終了・未登録役職スキップを説明。成功後 notify・詳細再取得・`role-diff-preview` 再取得。

## テスト結果

- `php artisan test`: **221 passed**（885 assertions）。  
- `php artisan test --filter=MeetingCsvImportControllerTest`: **65 passed**。  
- **npm run build**: 成功。

## 既知の制約

- 基準日は今日固定（ユーザー指定・例会日連動なし）。
- 同一メンバーに複数 open 行がある異常データは、現状は「最大 term_start の1行」だけを扱う（通常は1行想定）。
- 名前完全一致での member 解決は M4 に準拠。

## 次の改善候補

- 基準日の指定（例会日・手入力）。
- 役職名の表記ゆれ・別名マッピング。
- rollback / 監査ログ。
- roles マスタ整備向けの導線（別 UI）。

---

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch:  
target branch: develop  
phase id: M7-M5  
phase type: implement  

test command: php artisan test  
test result: 221 passed  

scope check: OK  
ssot check: OK  
dod check: OK  
