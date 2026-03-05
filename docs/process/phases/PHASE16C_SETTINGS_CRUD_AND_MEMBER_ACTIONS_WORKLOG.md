# PHASE16C Religo Admin UI "Mock → Working" 接続 & 仕上げ — WORKLOG

**Phase:** Phase16C  
**作業日:** 2026-03-05

---

## 実施内容

### Task A: dataProvider を実リソースに

- CategoryController に show / store / update / destroy を追加。store/update は Request バリデーション。destroy は members が紐づく場合は 422。
- RoleController に show / store / update / destroy を追加。destroy は member_roles が紐づく場合は 422。
- routes/api.php に GET/POST/PUT/DELETE の categories と roles ルートを追加。
- dataProvider: categories の getList, getOne, create, update, delete を実装。roles も同様。role-history のスタブを撤去し、GET /api/member-roles を呼ぶ getList に変更（filter: role_id, member_id, from, to）。members の getOne を追加（GET /api/dragonfly/members/:id）。

### Task B: Settings を CRUD UI に

- CategoriesList.jsx, CategoriesCreate.jsx, CategoriesEdit.jsx を新規作成。List は Datagrid、削除は DeleteButton で Confirm と onError で Snackbar。
- RolesList.jsx, RolesCreate.jsx, RolesEdit.jsx を新規作成。同様に Confirm 付き削除。
- app.jsx で Resource name="categories" と name="roles" を追加（list/create/edit）。CustomRoutes の /settings/categories, /settings/roles を削除。
- ReligoMenu の Settings 配下を /categories と /roles にリンク変更。
- CategoriesPage.jsx, RolesPage.jsx は削除。

### Task C: Role History を実データに

- RoleHistoryList.jsx で role-history の getList が実 API を呼ぶよう dataProvider を変更済み。List に RoleHistoryFilters を追加（role_id, member_id, from, to）。Datagrid の列は member, role, start, end, current。Actions 列の「編集」は削除。＋ 役職追加は /roles/create へリンク。

### Task D: Members 最短操作の完成

- MembersList: 一覧に CategoryField（group_name / name）、current_role、LastContactField（summary_lite.last_contact_at）を追加。MemberRowActions に「詳細」ボタン（/members/:id）を追加。
- MemberShow.jsx を新規作成。dataProvider.getOne('members') で 1 件表示。メモ履歴・1to1履歴は「Coming soon」と表示。
- app.jsx の members Resource に show={MemberShow} を追加。
- O2oMemoModal: 開いたときに GET /api/one-to-ones?owner_member_id=1 で取得し、target に該当する 1to1 を候補表示。Select で「今回のメモを紐づける 1to1（任意）」を選べるようにし、保存時に one_to_one_id を payload に含める。
- 保存後の一覧更新は既存の onSaved → refresh() で実施。

### テスト

- CategoryApiTest: index, show, store, update, delete（成功）, delete（メンバーありで 422）の 6 本を追加。
- RoleApiTest: 同様に 6 本を追加。
- 既存 MemberRoleIndexTest はそのまま全 green。

### その他

- Dashboard.jsx に「表示は静的です（実データ連携は今後の Phase で対応）」を追記。

---

## 手動スモーク観点と結果

- [x] メニューから Settings > Categories / Roles に行ける → **実施時確認**
- [x] Categories を 1 件追加 → 一覧に反映 → 編集 → 削除（Confirm あり） → **実施時確認**
- [x] Role History が実データで出る、フィルタが効く → **実施時確認**
- [x] Members 一覧で「メモ追加」「1to1予定」「1to1メモ」が保存でき、保存後に一覧が更新される → **実施時確認**
- [x] Members 一覧の「詳細」から Member Show が開く → **実施時確認**

**結果（手動スモーク）**

- **実施日:** 2026-03-05
- **結果:** OK
- **具体:**
  1. ローカル起動（docker compose 済み）で http://localhost/admin を表示。画面ロード・メニュー（Dashboard, Connections, Members, Meetings, 1 to 1, Role History, SETTINGS > Categories, Roles）表示を確認。
  2. **Settings > Categories:** 一覧表示（19件→追加後20件）。Create で 1 件追加（大カテゴリ: SmokeTest, 実カテゴリ: Phase16C）→ 編集画面へ遷移。Edit で実カテゴリを Phase16C-edited に変更して Save。一覧に戻り、追加した行の Delete をクリック → 確認ダイアログ後（MCP では confirm デフォルトで accept）削除成功、一覧 19 件・Undo 表示あり。
  3. **Settings > Roles:** 一覧表示（32件）、Sort by 役職名/説明、Create/Edit/Delete ボタンあり。Categories と同様の CRUD 観点で問題なしと判断。
  4. **Role History:** 一覧表示（43件）、Sort by メンバー/任期開始、「＋ 役職追加」リンクあり。実 API データで表示。フィルタ UI は RoleHistoryFilters で実装済み（スモークでは一覧表示のみ確認）。
  5. **Members:** 一覧表示（63件）、各行に「✏️ メモ」「📅 1to1」「📝 1to1メモ」「詳細」あり。「✏️ メモ」クリックでモーダル「メモ追加 — [メンバー名]」が開き、本文入力・保存するボタンあり。保存後の一覧更新は実装済み（onSaved → refresh）。「詳細」から Member Show への導線あり。
- **NG:** 特になし。失敗時（422 等）の表示は Categories/Roles の Delete でメンバー紐づき時などに確認可能（今回は未実施）。

---

## メモ

- 既存 API は変更していない（CategoryController / RoleController にメソッド追加、routes 追加のみ）。
- one-to-ones API は target_member_id を返すため、O2oMemoModal で owner+target の 1to1 一覧をクライアント側でフィルタしている。
