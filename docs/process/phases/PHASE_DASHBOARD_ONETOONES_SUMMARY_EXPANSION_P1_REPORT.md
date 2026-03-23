# PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1 — REPORT

## 1. 実施内容サマリ

Dashboard の 1to1 KPI を、**今月実施（主）**と**登録全体の内訳（補助）**に分離。`GET /api/dashboard/stats` に `one_to_one_total_count` / `one_to_one_planned_count` / `one_to_one_canceled_count` と `subtexts.one_to_one_inventory` を追加。KPI カードで 2 行表示。検証コマンド・debug API 用サービスを拡張。

## 2. 変更ファイル一覧

- `www/app/Services/Religo/DashboardService.php`
- `www/app/Services/Religo/DashboardSummaryVerificationService.php`
- `www/app/Console/Commands/DashboardVerifySummaryCommand.php`
- `www/resources/js/admin/pages/dashboard/DashboardKpiGrid.jsx`
- `www/resources/js/admin/pages/dashboard/dashboardConstants.js`
- `www/tests/Feature/Religo/DashboardApiTest.php`
- `docs/SSOT/DASHBOARD_DATA_SSOT.md`
- `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_{PLAN,WORKLOG,REPORT}.md`

## 3. 件数定義の整理

| 項目 | 条件 |
|------|------|
| **monthly_one_to_one_count** | 従来どおり: `completed` かつ `started_at` が当月 |
| **one_to_one_total_count** | owner の 1to1 全行 |
| **one_to_one_planned_count** | `status=planned` |
| **one_to_one_canceled_count** | `status=canceled` |

## 4. 実装内容

- Service: 上記 3 カウントを `getStats` のトップレベルに追加。`subtexts.one_to_one_inventory` に「登録計 N（予定 x・キャンセル y）」。
- UI: `DashboardKpiGrid` の 1to1 カードに `sub2` 行を追加。
- 検証: `DashboardSummaryVerificationService` の `db_raw` / `service` / `diff` に新キー。

## 5. テスト結果

- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` — **329 passed**
- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` — **成功**

## 6. 未解決事項

- なし（本 Phase スコープ内）。

## 7. 次 Phase 提案

- **案B（workspace 内 peer）** への stale 絞り込みは、別 Phase（`members.workspace_id` と Dashboard の設計合意後）。

## 8. 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge method** | `git merge --no-ff` |
| **merged branch** | `feature/phase-dashboard-onetoones-summary-expansion-p1` |
| **merge commit id** | （merge 後に `git log -1 --format=%H develop` で追記） |
| **feature 最終コミット** | （merge 前に `git log -1 --format=%H feature/...` で追記） |
| **test result** | `php artisan test` — 329 passed |
| **notes** | 1to1 補助件数 3 つ + inventory subtext。verify-summary 7 行比較に拡張。UI は 1 カード 2 行目のみ。 |
