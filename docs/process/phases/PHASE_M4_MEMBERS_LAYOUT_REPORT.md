# Phase M-4 Members パッと見レイアウト — REPORT

**Phase:** M-4（M-4a / M-4b / M-4c）  
**完了日:** （各 Phase 完了時点で記入）

---

## M-4a 実施内容

- PHASE_M4_MEMBERS_LAYOUT_WORKLOG.md を作成（Step0 現状確認、Step1 統計方針、Step2 フィルタバー方針、Step3 Datagrid 維持理由、Step4 モック比較）。
- PHASE_M4_MEMBERS_LAYOUT_REPORT.md を作成（本ファイル）。
- docs/INDEX.md に M-4 WORKLOG / REPORT を追加。

---

## 変更ファイル一覧（M-4 全体）

**M-4a（Docs）**
- docs/process/phases/PHASE_M4_MEMBERS_LAYOUT_WORKLOG.md
- docs/process/phases/PHASE_M4_MEMBERS_LAYOUT_REPORT.md
- docs/INDEX.md

**M-4b（Impl）**
- www/resources/js/admin/pages/MembersList.jsx

**M-4c（Close）**
- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md
- docs/dragonfly_progress.md
- docs/process/phases/PHASE_M4_MEMBERS_LAYOUT_REPORT.md

---

## テスト結果・ビルド結果

- **php artisan test:** 69 passed (262 assertions)
- **npm run build:** 成功（exit 0）

---

## 判断・改善点（M-4b / M-4c）

- **統計カード常時表示:** クライアント集計で 4 種を表示。総メンバー数は `total`、1to1未実施(30日)/interested ON/want_1on1 ON は現在の `data` から算出。ページング時は「表示中 N 件中」の値になる制約を WORKLOG に記載。
- **フィルタバー常時表示:** List の子として `MembersFilterBar` を配置し、検索・カテゴリ・役職・Interested/Want 1on1・並び順・件数を 1 行（wrap 可）で常時表示。大カテゴリは既存 API/UI にないため今回は未追加（GAP）。
- **Datagrid 維持:** ブロック順の一致を優先し、一覧は表のまま。カードグリッドは後続 Phase で対応。
- **モック比較:** ヘッダー→統計→フィルタバー→一覧の流れでパッと見がモックと揃った。

---

## まだ残る GAP（Members）

- カードグリッド未対応（一覧は表のまま）
- 大カテゴリ単独フィルタ未実装
- かな・関係ログ（最近）の一覧表示
- Members 画面からのフラグ編集モーダル
- Member Show ページ（/members/:id）のメモ・1to1履歴（Coming soon）

---

## DoD チェック

| Phase | DoD | 結果 |
|-------|-----|------|
| M-4a | PLAN / WORKLOG / REPORT が揃う、INDEX から辿れる | ○ |
| M-4b | ヘッダー→統計カード→フィルタバー→一覧の順、統計4種・フィルタ常時表示、Datagrid 維持、test/build 成功 | ○ |
| M-4c | FIT_AND_GAP 更新、progress 更新、REPORT に取り込み証跡 | ○ |

---

## 取り込み証跡（develop への merge 後）

| Phase | merge commit id | merge 元ブランチ | 変更ファイル |
|-------|-----------------|------------------|---------------|
| M-4a | `1db0084fa34152dd08e8d44a8ebf465cc45f68d1` | feature/m4a-members-layout-docs | docs/INDEX.md, docs/process/phases/PHASE_M4_MEMBERS_LAYOUT_REPORT.md, docs/process/phases/PHASE_M4_MEMBERS_LAYOUT_WORKLOG.md |
| M-4b | `702f1afc3c95d12cbe33ee858bee7b14a96b1a13` | feature/m4b-members-layout-impl | www/resources/js/admin/pages/MembersList.jsx |
| M-4c | `3e6188bc048fca991df159b8042e82fd94e5c86a` | feature/m4c-members-layout-close | docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md, docs/dragonfly_progress.md, docs/process/phases/PHASE_M4_MEMBERS_LAYOUT_REPORT.md |
