# Phase M7-M2: members 基本情報更新候補 — REPORT

**Phase ID:** M7-M2  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Services/Religo/MeetingCsvMemberDiffPreviewService.php（新規）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（memberDiffPreview）
- www/routes/api.php（GET member-diff-preview）
- www/resources/js/admin/pages/MeetingsList.jsx（member 差分プレビュー UI）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php（M7-M2 テスト 8 本）
- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md（実装メモ 1 段落）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_PLAN.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_REPORT.md（本ファイル）
- docs/process/PHASE_REGISTRY.md、docs/INDEX.md、docs/dragonfly_progress.md

---

## 実装要約

- 最新参加者 CSV と既存 members を比較し、基本情報（名前・よみがな）およびカテゴリー（大カテゴリー/カテゴリー列からマスタ照合）の**更新候補のみ**を JSON で返す API を追加。DB の members / categories は更新しない。Meetings Drawer の参加者 CSV ブロックに「member差分を確認」導線と summary・3 セクションのテーブルを追加。カテゴリー塊は MUI Alert warning と「マスタ未登録」Chip で強調。

## 追加した API / Service

- **GET /api/meetings/{meetingId}/csv-import/member-diff-preview**  
  レスポンス: `summary`（updated_member_basic_count, category_changed_count, unresolved_member_count, unchanged_member_count）, `updated_member_basic[]`, `category_changed[]`（`category_master_resolved` bool）, `unresolved_member[]`（csv_name, csv_category）。
- **MeetingCsvMemberDiffPreviewService::memberDiffPreview(Meeting, MeetingCsvImport)**

## members 差分プレビュー UI

- プレビュー取得済みかつ row_count > 0 のとき「member差分を確認」ボタン（outlined secondary）。
- 取得後: 情報 Alert、summary Chip×4、基本情報テーブル、カテゴリー変更テーブル（上に warning Alert）、未解決 member テーブル。

## テスト結果

- MeetingCsvImportControllerTest 計 38 件成功（+8）。全体 **194 passed** (794 assertions)。**npm run build** 成功。

## 既知の制約

- 名前完全一致での member 解決のみ（部分一致・表記ゆれは未対応）。
- CSV にカテゴリー列が空のときはカテゴリー差分を出さない（member の既存 category は「維持」扱い）。
- members の実更新・Role History・PDF フローは未対応。

## 次の改善候補

- 候補から members を確定更新する API / UI（別 Phase）。
- 表記ゆれ・別名照合。
- categories 新規作成のガード付きフロー（本 Phase では作成しない）。

---

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch:  
target branch: develop  
phase id: M7-M2  
phase type: implement  

test command: php artisan test  
test result: 194 passed  

scope check: OK  
ssot check: OK  
dod check: OK  
