# Phase Meetings Stats Cards — REPORT

**Phase:** M6（Meetings 統計カード）  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Http/Controllers/Religo/MeetingController.php（stats() 追加、BreakoutRoom use）
- www/routes/api.php（GET /api/meetings/stats 追加）
- www/resources/js/admin/pages/MeetingsList.jsx（fetchMeetingsStats、MeetingsStatsCards、state と useEffect、List 子の先頭に配置）
- www/tests/Feature/Religo/MeetingControllerTest.php（stats テスト 4 件追加）
- docs/SSOT/FIT_AND_GAP_MEETINGS.md（M04 Fit 化・実装セクション更新）
- docs/process/phases/PHASE_MEETINGS_STATS_CARDS_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_STATS_CARDS_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_STATS_CARDS_REPORT.md（本ファイル）

---

## 実装内容

- **API:** GET /api/meetings/stats を新設。MeetingController::stats() で total_meetings（meetings 件数）、total_breakouts（breakout_rooms 件数）、meetings_with_memo（contact_memos の memo_type='meeting' かつ meeting_id 非 null の DISTINCT meeting_id 件数）、next_meeting（held_on >= 今日で最も近い 1 件の { id, number, held_on }、該当なしなら null）を返す。
- **フロント:** MeetingsList に統計用 state（stats, statsLoading, statsError）を追加。マウント時に GET /api/meetings/stats を 1 回呼び、MeetingsStatsCards で 4 カード（総例会数・総BO数・メモ有り例会・次回例会）を MUI Card / Grid で表示。ツールバー上に配置。loading 時はスピナー、エラー時は簡易メッセージで一覧はそのまま表示。
- **テスト:** MeetingControllerTest に stats の 4 テスト（総数・BO数、メモ有り件数、次回例会あり、次回例会なし）を追加。

---

## テスト結果

- MeetingControllerTest: **11 passed**（stats 関連 4 件含む）。
- php artisan test: **96 passed**（366 assertions）。

---

## 既知の制約

- 統計は初回マウント時のみ取得。例会メモを保存しても「メモ有り例会」は再取得されない（画面をリロードすると更新される）。
- 次回例会の「今日」はサーバーの app timezone に依存する。

---

## 次 Phase への引き継ぎ事項

- 統計の自動更新が必要な場合は、メモ保存後や一覧 refresh 時に stats を再取得する導線を追加可能。
- FIT_AND_GAP_MEETINGS の M04（統計カード）は本 Phase で解消。モックの「今年度20回」「平均3.8/例会」「91%」などの副表示は未実装のため、必要に応じて別 Phase で対応可能。
