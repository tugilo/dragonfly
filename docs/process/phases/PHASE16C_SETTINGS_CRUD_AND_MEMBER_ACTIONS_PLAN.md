# PHASE16C Religo Admin UI "Mock → Working" 接続 & 仕上げ — PLAN

**Phase:** Phase16C  
**作成日:** 2026-03-05  
**前提:** Phase16B で UI モック同期完了。本 Phase でスタブを実 API に接続し CRUD と最短操作を完成させる。

---

## 1. 目的

- モックの「見た目」ではなく「迷わず速く目的を達成できる管理画面」を完成させる。
- Settings（Categories / Roles）を実 API で CRUD 可能にする。
- Role History をスタブから実 API（GET /api/member-roles）に接続する。
- Members 一覧の「一覧表示・メモ/1to1/1to1メモ・保存後更新・履歴導線」を仕上げる。
- PR レス運用（feature → 1 commit → develop no-ff merge → test → push → REPORT 証跡）で進める。

## 2. タスクと DoD

| Task | 内容 | DoD |
|------|------|-----|
| **A** | dataProvider を実リソースに | categories/roles: getList, getOne, create, update, delete。role-history: getList（GET /api/member-roles、フィルタ対応）。Settings > Categories / Roles が本物の API で一覧表示され、create/update/delete が動き、成功時 Snackbar・失敗時 Alert/Snackbar。 |
| **B** | Settings を CRUD UI に | Categories/Roles を Resource の List / Create / Edit に分割。一覧で検索・行アクション（編集/削除）。削除は Confirm 必須。メニュー導線は維持（/categories, /roles）。 |
| **C** | Role History を実データに | スタブ撤去。getList('role-history') で GET /api/member-roles を呼ぶ。フィルタ: role_id, member_id, from, to。既存 MemberRoleIndexTest を壊さない。 |
| **D** | Members 最短操作の完成 | 一覧に大カテゴリ/実カテゴリ・現在役職・summary_lite（同室/最終接触/直近メモ）。メモ追加・1to1予定・1to1メモの保存後に一覧再 fetch。1to1メモで「対象 1to1 を選んでメモ」を実装（直近 1to1 を候補表示）。履歴導線を固定（詳細ボタン → Member Show、メモ/1to1 履歴は Coming soon 表示）。 |
| **Test** | Feature Test | categories/roles CRUD のうち各 2 本以上。既存含め全テスト green。 |

## 3. 非目標

- メンバーの Create/Delete（現状維持）。
- 紹介（introductions）機能。
- Dashboard の実データ連携（静的表示で可、明示すればよい）。

## 4. 成果物

- **API:** CategoryController / RoleController の show, store, update, destroy。routes 追加。
- **dataProvider:** categories, roles の getList/getOne/create/update/delete。role-history のスタブ撤去・GET /api/member-roles 利用。
- **UI:** CategoriesList, CategoriesCreate, CategoriesEdit。RolesList, RolesCreate, RolesEdit。RoleHistoryList のフィルタ。MembersList の列・1to1メモ紐付け・MemberShow（詳細）・詳細ボタン。Dashboard に「表示は静的です」表記。
- **Tests:** CategoryApiTest, RoleApiTest（各 6 本）。
- **docs:** PHASE16C_PLAN / WORKLOG / REPORT。INDEX.md、dragonfly_progress.md 更新。

## 5. Git

- ブランチ: `feature/phase16c-settings-crud-and-member-actions-v1`
- コミット: 1 コミット。メッセージ: `feat(phase16c): connect Settings CRUD + RoleHistory + Members quick actions`
- 取り込み: develop へ --no-ff merge、テスト実行、push、REPORT に取り込み証跡追記。
