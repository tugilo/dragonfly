# PHASE11B Religo 1 to 1 独立一覧 — REPORT

**Phase:** 1 to 1 一覧・登録  
**完了日:** 2026-03-04

---

## 実施内容

- GET /api/one-to-ones を追加。クエリ: workspace_id, owner_member_id, target_member_id, status, from, to。返却は COALESCE(started_at, scheduled_at) desc, id desc。owner/target 名を含む。
- ReactAdmin Resource one-to-ones を List/Create に差し替え。List はフィルタ・列、Create は workspace 自動・Autocomplete・meeting_id 任意。
- OneToOneIndexTest で index と並び順・フィルタを担保。

## 変更ファイル一覧

- `www/app/Http/Requests/Religo/IndexOneToOnesRequest.php`（新規）
- `www/app/Services/Religo/OneToOneIndexService.php`（新規）
- `www/app/Http/Controllers/Religo/OneToOneController.php`（index 追加）
- `www/routes/api.php`（GET /api/one-to-ones 追加）
- `www/tests/Feature/Religo/OneToOneIndexTest.php`（新規）
- `www/resources/js/admin/dataProvider.js`（one-to-ones getList / create 追加）
- `www/resources/js/admin/pages/OneToOnesList.jsx`（新規：List + Create。OneToOnesPlaceholder は List/Create に差し替え）
- `www/resources/js/admin/app.jsx`（one-to-ones に create 追加）
- `docs/process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_PLAN.md`（新規）
- `docs/process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_WORKLOG.md`（新規）
- `docs/process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_REPORT.md`（新規）
- `docs/INDEX.md`（Phase11B ドキュメント追加）
- `docs/dragonfly_progress.md`（Phase11B 進捗追加）

## テスト結果

- `php artisan test` で 27 passed (125 assertions)。OneToOneIndexTest 4 件含む。

## DoD

- [x] GET /api/one-to-ones が動作
- [x] Resource から一覧・作成ができる
- [x] meeting_id は任意
- [x] docs 更新・Feature test green・1 コミット merge
- [x] REPORT に merge commit id を記録

## 取り込み証跡

| 項目 | 内容 |
|------|------|
| **merge commit id** | `9d2d467e23c00407f3d68459f63331797d4dc736` |
| **merge 元ブランチ** | feature/phase11b-one-to-one-list-v1 |
| **テスト結果** | 27 passed (125 assertions) |
