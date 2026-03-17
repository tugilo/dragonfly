# Phase Meetings Stats Cards — PLAN

**Phase:** M6（Meetings 統計カード）  
**作成日:** 2026-03-17  
**Related SSOT:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[PHASE_MEETINGS_TOOLBAR_FILTERS_REPORT.md](PHASE_MEETINGS_TOOLBAR_FILTERS_REPORT.md)

---

## 1. 背景

- Phase M1〜M5 により一覧・行アクション・Drawer・例会メモ Dialog・ツールバーが実装済み。FIT_AND_GAP_MEETINGS の M04「統計カード 4 種」は未実装。
- モックでは画面上部に総例会数・総BO数・メモ有り例会・次回例会の 4 カードがあり、一覧を見る前に全体状況を把握できる。

---

## 2. 目的

- Meetings 画面上部に統計カードを追加する。
- 少なくとも次の 4 項目を表示する: 総例会数、総BO数、メモ有り例会数、次回例会。
- 一覧・Drawer・Dialog・Toolbar の既存挙動を壊さないこと。
- API 負荷が重すぎない形で実装する（専用の軽量 summary API を追加する）。

---

## 3. スコープ

- **変更可能:** MeetingController（または専用 controller）、routes/api.php、MeetingsList.jsx、tests、docs/process/phases/PHASE_MEETINGS_STATS_CARDS_*.md
- **変更しない:** 一覧列・Actions・Drawer・Dialog・ツールバー・既存 GET /api/meetings および GET /api/meetings/{id} のレスポンス形。

---

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/app/Http/Controllers/Religo/MeetingController.php | stats() メソッドを追加 |
| www/routes/api.php | GET /api/meetings/stats を追加（/meetings/{meetingId} より前に定義） |
| www/resources/js/admin/pages/MeetingsList.jsx | 統計カード表示コンポーネントと GET /api/meetings/stats の呼び出しを追加 |
| www/tests/Feature/Religo/MeetingControllerTest.php | stats のテストを追加 |
| docs/process/phases/PHASE_MEETINGS_STATS_CARDS_*.md | PLAN / WORKLOG / REPORT |

---

## 5. 実装方針

### 5.1 API

- **GET /api/meetings/stats** を新設。MeetingController::stats() で実装。
- レスポンス:
  - **total_meetings:** meetings の全件数。
  - **total_breakouts:** breakout_rooms の総数（または meetings の breakout_count 総和に相当）。
  - **meetings_with_memo:** contact_memos で meeting_id + memo_type='meeting' が存在する meeting のユニーク数。
  - **next_meeting:** held_on が今日以降で最も近い 1 件。`{ id, number, held_on }` または null。日付はアプリの timezone に合わせる（Carbon::today() で比較）。

- 集計は N+1 にならないよう、count クエリ・サブクエリで一括取得する。

### 5.2 フロント

- MeetingsList.jsx に統計用 state（stats, statsLoading, statsError）を追加。
- 画面上部（タイトル/サブ説明の下、ツールバーの上）に統計カードを配置。MUI Card / Paper / Box / Grid で 4 カードを横並び（レスポンシブ可）。
- マウント時または表示時に GET /api/meetings/stats を 1 回呼ぶ。取得中は loading 表示、失敗時はカードのみ簡易エラー表示または非表示とし、一覧はそのまま表示する。

---

## 6. テスト観点

- 統計カードが表示されること。
- 総例会数が正しいこと。
- 総BO数が正しいこと。
- メモ有り例会数が正しいこと。
- 次回例会が「今日以降で最も近い 1 件」であること（いなければ null）。
- 一覧・Drawer・Dialog・Toolbar の既存挙動に影響がないこと。
- php artisan test の既存回帰がないこと。

---

## 7. DoD

- [x] GET /api/meetings/stats が存在し、total_meetings / total_breakouts / meetings_with_memo / next_meeting を返すこと。
- [x] Meetings 画面上部に 4 つの統計カードが表示されること。
- [x] 統計の loading / エラー時も一覧・Drawer・Dialog・Toolbar が利用可能であること。
- [x] PLAN / WORKLOG / REPORT が揃っていること。
- [x] PHASE_REGISTRY を更新していること。
