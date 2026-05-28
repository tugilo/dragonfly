# Phase Meetings Toolbar Filters — PLAN

**Phase:** M5（Meetings 一覧ツールバー・フィルタ）  
**作成日:** 2026-03-17  
**SSOT:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[PHASE_MEETINGS_MEMO_MODAL_REPORT.md](PHASE_MEETINGS_MEMO_MODAL_REPORT.md)

---

## 1. 背景

- Phase M1〜M4 により一覧・行アクション・Drawer・例会メモ Dialog が実装済み。モックの「テーブルツールバー」（検索・メモあり/なし・件数表示）は未実装で、FIT_AND_GAP_MEETINGS の M06 が Gap のまま。
- M5 で一覧上部にツールバーを追加し、番号/日付検索・メモフィルタ・件数表示を実装する。

---

## 2. 目的

- 一覧上部にツールバーを追加する。
- 番号 / 日付で検索できるようにする（1 つの検索欄で両方にマッチ）。
- メモあり / メモなし / すべて のフィルタを追加する。
- 現在表示中の件数を表示する。
- M1〜M4 の既存 UX を壊さないこと。

---

## 3. スコープ

- **変更可能:** MeetingController::index、dataProvider（meetings の getList）、MeetingsList.jsx、必要ならテスト、docs/process/phases/PHASE_MEETINGS_TOOLBAR_FILTERS_*.md
- **変更しない:** 一覧列・Actions・Drawer・Dialog・GET /api/meetings/{id} 等の既存 API 形。

---

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/app/Http/Controllers/Religo/MeetingController.php | index() で Request を受け取り、q と has_memo でフィルタ適用 |
| www/resources/js/admin/dataProvider.js | meetings の getList で params.filter をクエリに乗せて GET /api/meetings を呼ぶ |
| www/resources/js/admin/pages/MeetingsList.jsx | ツールバー（検索・メモフィルタ・件数）を追加。List の toolbar に MeetingsToolbar を渡す |
| www/tests/Feature/Religo/MeetingControllerTest.php | フィルタ付き index のテストを追加（任意） |
| docs/process/phases/PHASE_MEETINGS_TOOLBAR_FILTERS_*.md | PLAN / WORKLOG / REPORT |

---

## 5. 実装方針

### 5.1 API

- **GET /api/meetings:** クエリパラメータを追加。
  - **q:** 任意。指定時は number の部分一致（LIKE %q%）または held_on の文字列プレフィックス一致（CAST(held_on AS CHAR) LIKE q%）で絞り込み。
  - **has_memo:** 任意。`1` のときは「メモあり」のみ、`0` のときは「メモなし」のみ。省略時はすべて。
- 既存の withCount / has_memo サブクエリは維持。has_memo フィルタは whereExists / whereDoesntExist で同じ条件を適用。

### 5.2 フロント

- **dataProvider:** meetings の getList で params.filter の q と has_memo を URL に付与して GET /api/meetings?q=...&has_memo=...
- **MeetingsToolbar:** useListContext() で filterValues, setFilters, total を取得。検索入力（番号/日付）、メモフィルタ（すべて/メモあり/メモなし）、件数表示を並べる。List の toolbar に渡す。
- 既存の Drawer / Dialog / Actions の state には触れない。

---

## 6. テスト観点

- 番号で検索できること（部分一致）。
- 日付で検索できること（プレフィックス一致）。
- メモあり / なし / すべて で絞り込めること。
- 件数表示がフィルタ後の件数と整合すること。
- Actions、Drawer、Dialog の既存挙動に影響がないこと。
- php artisan test の既存回帰がないこと。

---

## 7. DoD

- [x] GET /api/meetings が q と has_memo でフィルタ可能であること。
- [x] 一覧にツールバー（検索・メモフィルタ・件数）が表示されること。
- [x] 検索・メモフィルタで一覧が絞り込まれ、件数が更新されること。
- [x] M1〜M4 の既存機能が維持されていること。
- [x] PLAN / WORKLOG / REPORT が揃っていること。

---

## 8. 参照

- モック: http://localhost/mock/religo-admin-mock-v2.html#/meetings（テーブルツールバー）
- 実装: http://localhost/admin#/meetings
