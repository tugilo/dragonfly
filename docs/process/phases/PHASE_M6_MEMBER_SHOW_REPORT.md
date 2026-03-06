# Phase M-6 Member Show / Drawer 履歴強化 — REPORT

**Phase:** M-6（M-6a / M-6b / M-6c）  
**完了日:** （各 Phase 完了時点で記入）

---

## M-6a 実施内容

- PHASE_M6_MEMBER_SHOW_PLAN.md を作成（目的・スコープ・非対象・DoD・成果物・Git）。
- PHASE_M6_MEMBER_SHOW_WORKLOG.md を作成（Step0 棚卸し〜Step5 モック差分）。
- PHASE_M6_MEMBER_SHOW_REPORT.md を作成（本ファイル）。
- docs/INDEX.md に M-6 の PLAN / WORKLOG / REPORT を追加。

---

## 変更ファイル一覧（M-6 全体）

**M-6a（Docs）**
- docs/process/phases/PHASE_M6_MEMBER_SHOW_PLAN.md
- docs/process/phases/PHASE_M6_MEMBER_SHOW_WORKLOG.md
- docs/process/phases/PHASE_M6_MEMBER_SHOW_REPORT.md
- docs/INDEX.md

**M-6b（Impl）**
- www/resources/js/admin/pages/MembersList.jsx（Drawer Overview に直近メモ等を追加）
- www/resources/js/admin/pages/MemberShow.jsx（Overview / Memos / 1to1 表示、Coming soon 除去）

**M-6c（Close）**
- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md
- docs/dragonfly_progress.md
- docs/process/phases/PHASE_M6_MEMBER_SHOW_REPORT.md

---

## テスト結果・ビルド結果

- **php artisan test:** 69 passed (262 assertions)
- **npm run build:** 成功（exit 0）

---

## まだ残る GAP（Members）

- カードグリッド未対応（一覧は表のまま）
- 大カテゴリ単独フィルタ未実装
- かな・関係ログ（最近）の一覧表示

---

## DoD チェック

| Phase | DoD | 結果 |
|-------|-----|------|
| M-6a | PLAN / WORKLOG / REPORT が揃う、INDEX から辿れる | ○ |
| M-6b | Drawer/Show でメモ・1to1履歴が見える、Overview 整理、「Coming soon」除去、既存 API、test/build 成功 | ○ |
| M-6c | FIT_AND_GAP 更新、progress 更新、REPORT に取り込み証跡 | ○ |

---

## 取り込み証跡（develop への merge 後）

| Phase | merge commit id | merge 元ブランチ | 変更ファイル |
|-------|-----------------|------------------|---------------|
| M-6a | （merge 後に記入） | feature/m6a-member-show-docs | （merge 後に記入） |
| M-6b | （merge 後に記入） | feature/m6b-member-show-impl | （merge 後に記入） |
| M-6c | （merge 後に記入） | feature/m6c-member-show-close | （merge 後に記入） |
