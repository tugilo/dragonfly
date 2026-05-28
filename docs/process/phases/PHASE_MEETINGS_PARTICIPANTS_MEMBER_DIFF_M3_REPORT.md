# Phase M7-M3: members 基本情報の確定更新 — REPORT

**Phase ID:** M7-M3  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Services/Religo/ApplyMeetingCsvMemberDiffService.php（新規）
- www/app/Services/Religo/MeetingCsvMemberDiffPreviewService.php（`resolved_category_id` 追加）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（`memberApply`）
- www/routes/api.php（POST member-apply）
- www/resources/js/admin/pages/MeetingsList.jsx（反映ボタン・確認ダイアログ・再取得）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php（M7-M3 テスト 9 本）
- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md（実装メモ追記）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_PLAN.md / WORKLOG.md / REPORT.md（本ファイル）
- docs/process/PHASE_REGISTRY.md、docs/INDEX.md、docs/dragonfly_progress.md

---

## 実装要約

- M2 と同じ `memberDiffPreview` を実行し、その結果から **更新可能な差分だけ** を既存 `members` に書き込む。`updated_member_basic` は `new_name` / `new_name_kana` を更新。`category_changed` は `category_master_resolved` かつ `resolved_category_id` がある行のみ `category_id` を更新。新規 member・categories 作成なし。反映対象が 0 件のときは 422。

## 追加した API / Service

- **POST /api/meetings/{meetingId}/csv-import/member-apply**  
  レスポンス: `updated_member_basic_count`, `updated_category_count`, `skipped_unresolved_count`（unresolved_member 件数）, `skipped_unresolved_category_count`, `message`。
- **ApplyMeetingCsvMemberDiffService::apply(Meeting, MeetingCsvImport)**

## members 反映 UI

- member 差分プレビュー表示中、反映可能候補があるとき「members に反映」ボタン（contained secondary）。確認ダイアログでスコープ・スキップ条件を説明。成功後 `onDetailRefresh` と member-diff-preview の再取得。

## テスト結果

- MeetingCsvImportControllerTest 計 47 件（M7-M3 で 9 本追加）。全体 **203 passed** (813 assertions)。**npm run build** 成功。

## 既知の制約

- 名前完全一致での member 解決のみ（M2 と同じ）。
- 同一リクエストで basic と category の両方を更新する場合、別 UPDATE 文（順次実行）。
- 監査ログ・rollback なし。

## 次の改善候補

- 役職・Role History の慎重な反映フロー（別 Phase）。
- 新規 member 作成のガイド付きフロー。
- categories 新規登録の運用承認フロー。

---

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch:  
target branch: develop  
phase id: M7-M3  
phase type: implement  

test command: php artisan test  
test result: 203 passed  

scope check: OK  
ssot check: OK  
dod check: OK  
