# PHASE16B Religo 管理画面 UI モック同期 — PLAN

**Phase:** 管理画面を SSOT モック（religo-admin-mock.html）に合わせて統一し、全ページをメニューから辿れ、主要 UI・モーダルを動く形で揃える。  
**作成日:** 2026-03-05  
**SSOT:** www/public/mock/religo-admin-mock.html

---

## 1. 目的

- モック HTML を SSOT として、管理画面のメニュー・ページ・モーダルをモダンに統一する。
- 全ページを左メニューから遷移可能にし、未実装は「Placeholder」ではなくモック準拠の静的 UI で表示する。
- 既存 API・既存挙動は変えず、UI 側の調整のみ行う。

## 2. スコープ

| 対象 | 内容 |
|------|------|
| メニュー | Dashboard / Connections / Members / Meetings / 1 to 1 / Role History / Settings（Categories, Roles）の並び・ネスト |
| ルーティング | 全ページへの Resource または CustomRoutes |
| Dashboard | 新規。統計・今日やること・クイックショートカット（静的 UI） |
| Connections | 既存 DragonFlyBoard。タイトルを「Connections」に統一、ヘッダー・CTA をモック準拠 |
| Members | 一覧＋メモ追加・1to1予定・1to1メモのモーダル（既存 API 接続） |
| Meetings | 一覧。ヘッダー「Connectionsで編集」 |
| 1 to 1 | 一覧・追加。ヘッダーに Connections へ・1to1追加 |
| Role History | 新規。dataProvider スタブで一覧表示（UI のみ） |
| Settings / Categories, Roles | 新規。CustomRoutes で静的 UI ページ（API は次 Phase） |

## 3. 成果物

| 成果物 | 種別 |
|--------|------|
| www/resources/js/admin/ReligoMenu.jsx | 更新（モック通りの並び・Settings ネスト） |
| www/resources/js/admin/app.jsx | 更新（Dashboard, connections, role-history, CustomRoutes） |
| www/resources/js/admin/dataProvider.js | 更新（role-history getList スタブ） |
| www/resources/js/admin/pages/Dashboard.jsx | 新規 |
| www/resources/js/admin/pages/RoleHistoryList.jsx | 新規 |
| www/resources/js/admin/pages/CategoriesPage.jsx | 新規 |
| www/resources/js/admin/pages/RolesPage.jsx | 新規 |
| www/resources/js/admin/pages/DragonFlyBoard.jsx | 更新（Connections ヘッダー） |
| www/resources/js/admin/pages/MembersList.jsx | 更新（モーダル 3 種・Actions 列） |
| www/resources/js/admin/pages/MeetingsList.jsx | 更新（タイトル・Actions） |
| www/resources/js/admin/pages/OneToOnesList.jsx | 更新（タイトル・Actions） |
| docs/process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_PLAN.md | 本 PLAN |
| docs/process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_WORKLOG.md | WORKLOG |
| docs/process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_REPORT.md | REPORT |
| docs/INDEX.md | 更新（Phase16B リンク） |
| docs/dragonfly_progress.md | 更新（Phase16B 1 行） |

## 4. DoD

- [ ] 左メニューから Dashboard / Connections / Members / Meetings / 1 to 1 / Role History / Settings（Categories, Roles）に遷移できる。
- [ ] 各ページのヘッダー・CTA がモックの構成に沿っている。
- [ ] Members でメモ追加・1to1予定・1to1メモのモーダルが開き、保存可能なものは既存 API で保存できる。
- [ ] Connections（DragonFlyBoard）の見出しが「Connections」で、BO 保存・Meetings への導線がある。
- [ ] 既存 API・既存挙動を破壊していない。既存テストが通る。
- [ ] PLAN / WORKLOG / REPORT が揃い、INDEX と dragonfly_progress.md が更新されている。

## 5. リスク・ロールバック

- リスク: メニュー・ルート変更により既存ブックマークが変わる。dashboard を新設したため「/」が Dashboard になり、旧 Board は /connections に移動。
- ロールバック: feature ブランチを merge せず、develop をそのまま維持すればよい。

## 6. Git

- ブランチ: `feature/phase16b-admin-ui-mock-sync-v1`
- コミット: 1 コミット。メッセージ: `ui(phase16b): sync admin UI with mock (menu/pages/modals)`
- 取り込み: develop へ --no-ff merge、テスト実行、push。PR は使わない。
