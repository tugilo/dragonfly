# REPORT: ONETOONES-P4

## 1. サマリ

- **統計:** `OneToOneIndexService::applyIndexFilters` を Index/Stats で共有。`GET /api/one-to-ones/stats` は `owner_member_id` 必須＋一覧と同じ任意 query（`target_member_id`,`status`,`from`,`to`,`q`,`workspace_id`）。want_1on1 は「filter 済み一覧のターゲット」のフラグ件数。
- **メモ:** `GET/POST /api/one-to-ones/{id}/memos`。`OneToOnesEdit` に履歴メモパネル。`notes` は要約のまま。
- **users/me:** `id`・`member_id`（= owner_member_id）・`owner_member_id` を返却。

## 2. 変更ファイル

| 種別 | パス |
|------|------|
| 更新 | `www/app/Services/Religo/OneToOneIndexService.php` |
| 更新 | `www/app/Services/Religo/OneToOneStatsService.php` |
| 更新 | `www/app/Http/Requests/Religo/OneToOneStatsRequest.php` |
| 更新 | `www/app/Http/Controllers/Religo/OneToOneController.php` |
| 新規 | `www/app/Http/Requests/Religo/StoreOneToOneMemoRequest.php` |
| 更新 | `www/app/Models/ContactMemo.php` |
| 更新 | `www/app/Http/Controllers/Religo/UserController.php` |
| 更新 | `www/routes/api.php` |
| 更新 | `www/tests/Feature/Religo/OneToOneStatsTest.php` |
| 新規 | `www/tests/Feature/Religo/OneToOneMemosApiTest.php` |
| 更新 | `www/tests/Feature/Religo/UserMeApiTest.php` |
| 更新 | `www/resources/js/admin/pages/OneToOnesList.jsx` |
| 更新 | `www/resources/js/admin/pages/OneToOnesEdit.jsx` |
| 新規/更新 | `docs/process/phases/PHASE_ONETOONES_P4_*`、REGISTRY・INDEX・progress・SSOT |

## 3. テスト

- `php artisan test`: **286 passed**（1171 assertions）
- `npm run build`: 通過

## 4. 残課題

- 一覧から履歴メモ直接編集、Members 連携、`/api/users/me` の認証本番化。

## 5. Merge Evidence（develop 取り込み済み）

| 項目 | 値 |
|------|-----|
| merge commit id | `d966e31dd110da5e2e31bd6022329ea6ab1f4948` |
| source branch | `develop`（作業ツリーが develop 上だったため **feature ブランチなし**で直接コミット） |
| target branch | `develop` |
| phase id | ONETOONES-P4 |
| test command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` / `exec node npm run build` |
| test result | **286 passed**（1171 assertions）/ **build OK** |
| pushed at | 2026-03-19T22:34Z（UTC） |

**補足:** 運用ルールどおり `merge --no-ff feature/...` を使う場合は、次回から P5 以降で feature ブランチを切り、取り込みマージコミットのハッシュをここに記録する。
