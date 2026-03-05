# PHASE14 Religo DragonFly Member Model Refactor — WORKLOG

**Phase:** PHASE14 Member Model Refactor  
**作成日:** 2026-03-05

---

## 実施内容

### Step1 Category 正規化

- `2026_03_05_100001_create_categories_table.php` 作成（group_name, name）
- `2026_03_05_100002_add_category_id_to_members_table.php` 追加
- `2026_03_05_100003_migrate_members_category_to_categories.php` で既存 category 文字列 → categories 投入・category_id 設定
- `2026_03_05_100004_remove_category_from_members_table.php` で category カラム削除
- Model: `Category` 新規、`Member` に category_id / category() 追加
- DragonFlyMemberController / MeetingAttendeesService / BreakoutAssignmentService / DragonFlyBreakoutMemoController を category リレーション利用に変更
- DragonFlyMeeting199Seeder, BniDragonFly199ParticipantsSeeder を category_id 対応に変更

### Step2 Role 正規化

- `2026_03_05_100005_create_roles_table.php`, `2026_03_05_100006_create_member_roles_table.php` 作成
- `2026_03_05_100007_migrate_members_role_notes_to_member_roles.php` で role_notes → roles + member_roles 移行（term_start=today, term_end=null）
- `2026_03_05_100008_remove_role_notes_from_members_table.php` で role_notes 削除
- Model: `Role`, `MemberRole` 新規。Member に memberRoles(), roles(), currentRole() 追加
- MeetingAttendeesService: role_notes → currentRole()?->name
- DragonFlyMeeting199Seeder, BniDragonFly199ParticipantsSeeder: role_notes 廃止、syncCurrentRole() で member_roles 投入

### Step3 Backend API

- GET /api/dragonfly/members レスポンス: category をオブジェクト { id, group_name, name }、current_role 文字列で返却
- GET /api/dragonfly/members/{id}, PUT /api/dragonfly/members/{id} 追加
- GET /api/categories, GET /api/roles 追加（CategoryController, RoleController）

### Step4 Admin UI

- MembersList: カテゴリー（オブジェクト表示）、役職列追加。rowClick="edit"
- MemberEdit: SimpleForm で name, name_kana, display_no, category_id（SelectInput）, role_id（SelectInput）, type
- dataProvider: members の getOne / update、categories / roles の getList 追加

### Step5 テスト・docs

- 既存テスト 27 本すべて通過
- PLAN / WORKLOG / REPORT 作成、dragonfly_progress・INDEX 更新
