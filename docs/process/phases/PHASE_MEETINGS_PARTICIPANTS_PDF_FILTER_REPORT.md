# Phase M7-P1-FILTER: 参加者PDFあり/なしフィルタ — REPORT

**Phase:** M7-P1-FILTER  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Http/Controllers/Religo/MeetingController.php（has_participant_pdf フィルタ追加）
- www/resources/js/admin/dataProvider.js（meetings の has_participant_pdf クエリ追加）
- www/resources/js/admin/pages/MeetingsList.jsx（MeetingsToolbar に参加者PDF Select 追加）
- www/tests/Feature/Religo/MeetingControllerTest.php（test_index_filters_by_has_participant_pdf 追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_REPORT.md（本ファイル）
- docs/INDEX.md、docs/process/PHASE_REGISTRY.md、docs/dragonfly_progress.md（追記）

---

## 実装要約

- **API:** GET /api/meetings にクエリ has_participant_pdf=1 / 0 を追加。1 のとき meeting_participant_imports が存在する Meeting のみ、0 のとき存在しない Meeting のみ返す。
- **dataProvider:** meetings の getList で filter.has_participant_pdf をクエリに載せた。
- **UI:** 一覧ツールバーに「参加者PDF」Select（すべて / PDFあり / PDFなし）を追加。メモフィルタと同じ設計。
- **テスト:** test_index_filters_by_has_participant_pdf でフィルタ結果を検証。

---

## テスト結果

- MeetingControllerTest: 14 passed（test_index_filters_by_has_participant_pdf 含む）。
- php artisan test: 106 passed。
- npm run build: 成功。

---

## 既知の制約

- 特になし。他フィルタ（q, has_memo）と併用可能。

---

## 次の改善候補

- Phase3（M7-P1-UX: PDF状態の視認性改善）に進む。
