# Phase M7-P1-FILTER: 参加者PDFあり/なしフィルタ — PLAN

**Phase:** M7-P1-FILTER（参加者PDFフィルタ）  
**Phase ID:** M7-P1-FILTER  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_REPORT.md)

---

## 1. 背景

- M7-P1-LIST で一覧に参加者PDF有無列を追加済み。PDF登録済み Meeting を一覧で絞り込むフィルタが要望されている。

---

## 2. 目的

- GET /api/meetings に has_participant_pdf クエリを追加し、PDFあり/なしで一覧を絞り込めるようにする。
- 一覧ツールバーに「参加者PDF」フィルタ（すべて / PDFあり / PDFなし）を追加する。既存の has_memo フィルタと同じ設計とする。

---

## 3. スコープ

- **変更対象:** MeetingController@index、dataProvider（meetings の getList）、MeetingsList.jsx（MeetingsToolbar）、MeetingControllerTest。
- **変更しない:** Drawer、アップロード、ダウンロード、一覧列表示。他リソースのフィルタ。

---

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/app/Http/Controllers/Religo/MeetingController.php | index で has_participant_pdf クエリを受け取り、EXISTS/NOT EXISTS でフィルタ |
| www/resources/js/admin/dataProvider.js | meetings getList で filter.has_participant_pdf をクエリに追加 |
| www/resources/js/admin/pages/MeetingsList.jsx | MeetingsToolbar に「参加者PDF」Select（すべて/PDFあり/PDFなし）追加 |
| www/tests/Feature/Religo/MeetingControllerTest.php | test_index_filters_by_has_participant_pdf 追加 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_*.md | PLAN / WORKLOG / REPORT |

---

## 5. 実装方針

- **API:** has_participant_pdf=1 のとき meeting_participant_imports が存在する Meeting のみ。=0 のとき存在しない Meeting のみ。未指定は従来どおり全件。
- **UI:** メモフィルタの右隣に「参加者PDF」Select を追加。value は '' / '1' / '0'。setFilters で has_participant_pdf を更新。
- **他フィルタとの併用:** q / has_memo と組み合わせても正しく絞り込まれること。

---

## 6. テスト観点

- has_participant_pdf=1 で PDF ありの Meeting のみ返ること。
- has_participant_pdf=0 で PDF なしの Meeting のみ返ること。
- フィルタ未指定時は従来どおり全件（既存テストで担保）。
- php artisan test / npm run build が通ること。

---

## 7. DoD（Definition of Done）

- [x] GET /api/meetings に has_participant_pdf フィルタが効く。
- [x] 一覧ツールバーに「参加者PDF」フィルタが表示され、切り替えで一覧が変わる。
- [x] 他フィルタ（q, has_memo）に影響しない。
- [x] Feature テストでフィルタを検証している。
- [x] PLAN / WORKLOG / REPORT が揃っている。
