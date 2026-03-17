# Phase Meetings Participants PDF Upload — REPORT

**Phase:** M7-P1（参加者PDFアップロード）  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/database/migrations/2026_03_17_100001_create_meeting_participant_imports_table.php（新規）
- www/app/Models/MeetingParticipantImport.php（新規）
- www/app/Models/Meeting.php（participantImport HasOne 追加）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（新規）
- www/app/Http/Controllers/Religo/MeetingController.php（show に participant_import 追加）
- www/routes/api.php（participants/import 3 本追加）
- www/resources/js/admin/pages/MeetingsList.jsx（参加者PDFブロック・モーダル・API 呼び出し）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（新規）
- www/tests/Feature/Religo/MeetingControllerTest.php（participant_import テスト追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_REPORT.md（本ファイル）

---

## 実装内容

- **データ:** meeting_participant_imports テーブル（meeting_id unique）。PDF は storage/app/private の meeting_participant_imports/{meeting_id}/{uuid}.pdf に保存。1 Meeting = 1 PDF、再アップロードで上書き。
- **API:** GET /api/meetings/{id}/participants/import（メタ JSON）、POST /api/meetings/{id}/participants/import（multipart pdf、mimes:pdf, max:20MB）、GET /api/meetings/{id}/participants/import/download（PDF を attachment で返却）。GET /api/meetings/{id} に participant_import: { has_pdf, original_filename } を追加。
- **UI:** Meeting 詳細 Drawer に「参加者PDF」ブロックを追加。PDF あり時はファイル名＋ダウンロードリンク、PDF なし時は「未登録」＋「参加者PDF登録」ボタン。モーダルで PDF 選択→アップロード。成功時に Drawer 詳細を再取得して表示を更新。participants には一切触れない。

---

## テスト結果

- MeetingParticipantImportControllerTest: **7 passed**
- MeetingControllerTest: **13 passed**（participant_import 含む show テスト追加含む）
- php artisan test: **104 passed**（389 assertions）

---

## DoD チェック

- [x] PDF アップロードできる
- [x] DB に保存される
- [x] Drawer から確認できる
- [x] ダウンロードできる
- [x] 既存機能に影響なし
- [x] PLAN / WORKLOG / REPORT が揃っている

---

## 事象対応メモ（2026-03-17）

- **事象:** 参加者PDF登録モーダルで「PDFを選択」クリックしてもファイル選択ダイアログが開かない。
- **原因:** Button を component="label" で使用しており、MUI ButtonBase が role="button" を付与するため、label のネイティブな file input 起動が働かない。
- **対応:** ref + onClick で hidden の file input を programmatic に click する方式に変更（PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_* 参照）。

---

## 次 Phase への引き継ぎ

- **M7-P2（想定）:** PDF から参加者候補を抽出して画面に表示。テキスト抽出＋簡易パース。
- **M7-P3（想定）:** 抽出結果の確認・修正と participants への反映。
- ストレージを S3 等に変更する場合は config/filesystems と .env で disk を切り替え可能。

---

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に `git log -1 --format=%H develop` で取得） |
| **merge 元ブランチ名** | feature/phase-m7p1-meetings-participants-pdf-upload 等 |
| **変更ファイル一覧** | 上記「変更ファイル一覧」参照 |
| **テスト結果** | php artisan test — 104 passed |
| **scope check** | OK（participants 未変更、既存 Meetings 維持） |
