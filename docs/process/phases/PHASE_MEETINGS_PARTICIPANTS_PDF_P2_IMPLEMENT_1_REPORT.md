# Phase M7-P2-IMPLEMENT-1: PDFテキスト抽出と解析結果保存 — REPORT

**Phase:** M7-P2-IMPLEMENT-1  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/database/migrations/2026_03_17_140000_add_extracted_fields_to_meeting_participant_imports.php（新規）
- www/composer.json, www/composer.lock（smalot/pdfparser 追加）
- www/app/Models/MeetingParticipantImport.php（fillable, casts）
- www/app/Services/Religo/PdfParticipantParseService.php（新規）
- www/app/Providers/AppServiceProvider.php（Parser バインド）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（parse アクション、store で parse 状態リセット）
- www/app/Http/Controllers/Religo/MeetingController.php（participant_import に candidate_count 追加）
- www/routes/api.php（POST .../participants/import/parse）
- www/resources/js/admin/pages/MeetingsList.jsx（postParticipantImportParse、Drawer の解析ボタン・候補数・onDetailRefresh）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（parse 関連 5 本追加）
- www/tests/Feature/Religo/MeetingControllerTest.php（participant_import に candidate_count 期待値追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_REPORT.md（本ファイル）
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md（追記）

---

## 実装要約

- meeting_participant_imports に extracted_text（longText nullable）, extracted_result（json nullable）を追加する migration を追加・適用。
- smalot/pdfparser で PDF からテキスト抽出。PdfParticipantParseService で行単位の候補を生成し、extracted_result に candidates + meta を保存。
- POST /api/meetings/{id}/participants/import/parse で解析実行。成功時は extracted_text / extracted_result / parse_status=success / parsed_at を保存し、candidate_count を返す。失敗時は parse_status=failed を保存し 422。
- GET /api/meetings/{id} の participant_import に candidate_count を追加。
- Drawer で PDF あり・未解析 or failed 時に「PDF解析」ボタン、成功時に「候補 N件」を表示。解析後に詳細を再取得して表示を更新。
- 新規 PDF アップロード時は parse_status を pending に戻し、parsed_at / extracted_* を null にリセット。

---

## 追加した API / DB 項目

- **API:** POST /api/meetings/{meetingId}/participants/import/parse（解析実行）。レスポンス: parse_status, parsed_at, candidate_count。
- **DB:** meeting_participant_imports に extracted_text（longText nullable）, extracted_result（json nullable）。
- **show API:** participant_import に candidate_count（success 時のみ数値、それ以外は null）を追加。

---

## テスト結果

- php artisan test: **111 passed**
- npm run build: **成功**

---

## 既知の制約

- テキスト埋め込み PDF のみ対象。スキャン PDF（OCR）は未対応。
- 候補抽出は行単位の簡易ルール。実際の BNI 参加者表レイアウトに合わせた調整は今後の Phase で行う。
- participants への反映・members 照合・候補確認 UI は未実装。

---

## 次の改善候補

- 候補一覧の確認・修正 UI（P3）。
- 既存 members との照合（P4）。
- 実際のサンプル PDF での type_hint ルール・行パースの調整。
