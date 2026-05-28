# Phase M7-P1-FILTER: 参加者PDFあり/なしフィルタ — WORKLOG

**Phase:** M7-P1-FILTER  
**作成日:** 2026-03-17

---

## 既存 API / UI の確認

- has_memo フィルタは MeetingController で has_memo クエリを受け、EXISTS / NOT EXISTS で where している。dataProvider は filter.has_memo を '1' / '0' でクエリに載せている。MeetingsToolbar は Select で has_memo を setFilters している。同じパターンで has_participant_pdf を追加した。

---

## 実装内容

1. **MeetingController@index:** has_participant_pdf クエリを読み、'1' なら meeting_participant_imports が存在する行のみ、'0' なら存在しない行のみに whereRaw。has_memo の直後に追加。
2. **dataProvider.js（meetings）:** f.has_participant_pdf が true または '1' なら q.set('has_participant_pdf','1')、false または '0' なら q.set('has_participant_pdf','0')。
3. **MeetingsToolbar:** hasParticipantPdf = filterValues?.has_participant_pdf ?? ''。FormControl + Select で「参加者PDF」ラベル、MenuItem は すべて / PDFあり / PDFなし。onChange で setFilters({ ...filterValues, has_participant_pdf: ... })。
4. **MeetingControllerTest:** test_index_filters_by_has_participant_pdf を追加。PDF あり 1 件・なし 1 件を用意し、has_participant_pdf=1 で PDF ありのみ、=0 で PDF なしのみ含まれることをアサート。

---

## テスト結果

- test_index_filters_by_has_participant_pdf: パス。
- php artisan test: 106 passed。
- npm run build: 成功。
