# PHASE16C Religo Admin UI "Mock → Working" 接続 & 仕上げ — REPORT

**Phase:** Phase16C  
**完了日:** 2026-03-05

---

## 実施内容

- Settings（Categories / Roles）を実 API で CRUD 可能にした。CategoryController / RoleController に show, store, update, destroy を追加し、dataProvider で categories / roles の getList, getOne, create, update, delete を実装。
- Categories/Roles を ReactAdmin Resource の List / Create / Edit に分割。削除は Confirm 必須。メニューは Settings 配下で /categories, /roles にリンク。
- Role History のスタブを撤去し、GET /api/member-roles を利用。フィルタ（role_id, member_id, from, to）を追加。
- Members 一覧にカテゴリ・現在役職・最終接触を追加。メモ/1to1/1to1メモの保存後に refresh。1to1メモで「紐づける 1to1」を選択可能に。Member Show（詳細）を追加し、一覧から「詳細」で遷移。履歴は Coming soon 表示。
- Dashboard に「表示は静的です」を追記。
- CategoryApiTest / RoleApiTest を各 6 本追加。既存含め全テスト green（44 passed）。

## 変更ファイル一覧（feature ブランチ）

```
docs/INDEX.md
docs/dragonfly_progress.md
docs/process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_PLAN.md
docs/process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_WORKLOG.md
docs/process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_REPORT.md
www/app/Http/Controllers/Api/CategoryController.php
www/app/Http/Controllers/Api/RoleController.php
www/routes/api.php
www/resources/js/admin/ReligoMenu.jsx
www/resources/js/admin/app.jsx
www/resources/js/admin/dataProvider.js
www/resources/js/admin/pages/Dashboard.jsx
www/resources/js/admin/pages/MembersList.jsx
www/resources/js/admin/pages/MemberShow.jsx
www/resources/js/admin/pages/CategoriesList.jsx
www/resources/js/admin/pages/CategoriesCreate.jsx
www/resources/js/admin/pages/CategoriesEdit.jsx
www/resources/js/admin/pages/RolesList.jsx
www/resources/js/admin/pages/RolesCreate.jsx
www/resources/js/admin/pages/RolesEdit.jsx
www/resources/js/admin/pages/RoleHistoryList.jsx
www/tests/Feature/Api/CategoryApiTest.php
www/tests/Feature/Api/RoleApiTest.php
```

（CategoriesPage.jsx, RolesPage.jsx は削除）

## テスト結果

- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` — 44 passed (196 assertions)

## 手動スモーク

未実施（実施する場合は WORKLOG に結果を追記）

## DoD チェック

- [x] Task A: dataProvider で categories/roles/role-history が実 API に接続されている
- [x] Task B: Settings Categories/Roles が List/Create/Edit で CRUD でき、削除は Confirm 付き
- [x] Task C: Role History がスタブなしで GET /api/member-roles で表示、フィルタが効く
- [x] Task D: Members 一覧にカテゴリ・役職・最終接触・詳細ボタン、1to1メモで 1to1 紐付け選択、保存後 refresh、Member Show で履歴導線固定
- [x] 既存含め全テスト green
- [x] PLAN / WORKLOG / REPORT 作成、INDEX と dragonfly_progress 更新

---

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge commit id** | 69b12a153ea97c30437831c1c1e0312992dd16e2 |
| **merge 元ブランチ名** | feature/phase16c-settings-crud-and-member-actions-v1 |
| **変更ファイル一覧** | docs/INDEX.md, docs/dragonfly_progress.md, PHASE16C_* (PLAN/WORKLOG/REPORT), CategoryController.php, RoleController.php, api.php, ReligoMenu.jsx, app.jsx, dataProvider.js, Dashboard.jsx, MembersList.jsx, MemberShow.jsx, CategoriesList/Create/Edit.jsx, RolesList/Create/Edit.jsx, RoleHistoryList.jsx, CategoryApiTest.php, RoleApiTest.php（CategoriesPage.jsx, RolesPage.jsx 削除） |
| **テスト結果** | 44 passed (196 assertions) |
| **手動確認** | 未実施 |
