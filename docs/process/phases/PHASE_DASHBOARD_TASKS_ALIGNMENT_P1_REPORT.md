# PHASE: DASHBOARD-TASKS-ALIGNMENT-P1 — REPORT

## 1. 実施内容サマリ

Dashboard の**役割**を `DASHBOARD_DATA_SSOT.md` §0 で定義し、**Tasks** を「今日の ToDo」ではなく **優先して進める行動**として UI・SSOT・API kind を揃えた。`meeting_memo_pending` を **`meeting_follow_up`** に改名しタイトル・説明を実ロジック（次回/直近例会への Meetings 導線）に整合。stale 2 件目「メモ追加」の **SSOT を有効 deep link に統一**。1 to 1 予定行の meta 日付表現を修正。**Tasks は workspace 不使用**を SSOT・REPORT で固定。

## 2. 変更ファイル一覧

- `www/app/Services/Religo/DashboardService.php`
- `www/resources/js/admin/pages/dashboard/DashboardTasksPanel.jsx`
- `www/resources/js/admin/pages/dashboard/DashboardHeader.jsx`
- `www/resources/js/admin/pages/dashboard/dashboardConstants.js`
- `www/tests/Feature/Religo/DashboardApiTest.php`
- `docs/SSOT/DASHBOARD_DATA_SSOT.md`
- `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`
- `docs/SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md`
- `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`
- `docs/process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`

## 3. Dashboard 役割整理

- **一覧ではない:** 現状把握と次アクションの判断に使うホーム。  
- **KPI / Tasks / Activity / Leads** の分担は `DASHBOARD_DATA_SSOT.md` §0 の表を SSOT とする。

## 4. Tasks 再定義内容

- **見出し:** 優先アクション（Tasks）。  
- **kind:** `stale_follow` / `one_to_one_planned` / **`meeting_follow_up`**。  
- **「今日」案の不採用理由:** PLAN 参照。

## 5. 実装内容

- Service: `meeting_follow_up`、タイトル文言、予定 1to1 の `buildPlannedOneToOneTaskMeta`。  
- UI: `DashboardTasksPanel` 見出し・キャプション、`DashboardHeader` サブコピー、定数 TASKS_EMPTY / FALLBACK。  
- テスト: `meeting_follow_up` でアサート。

## 6. テスト結果

- **php artisan test（merge 後・develop）:** **315 passed**（1271 assertions）。`docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test`
- **npm run build（merge 後・develop）:** 成功（`exec node npm run build`、exit 0）

## 7. 未解決事項

- **例会行とメモ未整理の突合** — 未実装（将来 Phase）。  
- **Tasks に workspace スコープ** — 未使用（将来は API+SSOT 同時）。  
- **モック「今日やること」** — レイアウト・項目の SSOT はモック、**見出し文言**は役割優先で実装を正（`FIT_AND_GAP_MOCK_VS_UI` 記載）。

## 8. 次 Phase 提案

- **例会タスク:** `contact_memos`（meeting）と `meeting_id` を突合し、未記載時のみ表示する案（分析書 案B）。  
- **Tasks workspace:** `getSummaryLiteBatch` に解決済み `workspace_id` を渡すかの設計 Phase。  
- **DASHBOARD_REQUIREMENTS.md** — INDEX とギャップ（`DASHBOARD_FIT_AND_GAP` §8）の解消。

## 9. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff feature/phase-dashboard-tasks-alignment-p1` |
| target branch | `develop` |
| merged branch | `feature/phase-dashboard-tasks-alignment-p1` |
| merge commit id | `fe349925afe774332d661497dd3a20462c7820b1` |
| feature last commit id | `c37d12c7a6c4fa47ab0e2c25d2cf21f26c7a174c` |
| merge 競合 | なし（ort strategy） |
| test command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` |
| test result | **315 passed**（1271 assertions） |
| build command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` |
| build result | success（exit 0） |
| changed files（develop 取り込み範囲） | `docs/INDEX.md`, `docs/SSOT/DASHBOARD_DATA_SSOT.md`, `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`, `docs/SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md`, `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`, `docs/dragonfly_progress.md`, `docs/process/PHASE_REGISTRY.md`, `docs/process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_PLAN.md`, `docs/process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_REPORT.md`, `docs/process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_WORKLOG.md`, `www/app/Services/Religo/DashboardService.php`, `www/resources/js/admin/pages/dashboard/DashboardHeader.jsx`, `www/resources/js/admin/pages/dashboard/DashboardTasksPanel.jsx`, `www/resources/js/admin/pages/dashboard/dashboardConstants.js`, `www/tests/Feature/Religo/DashboardApiTest.php` |
| notes | **Dashboard 役割:** `DASHBOARD_DATA_SSOT` §0。**Tasks:** 見出し「優先アクション」、案A採用。**`meeting_follow_up`:** 次回/直近例会フォロー表現に改名。**workspace:** Tasks 生成は引き続き未使用（owner 軸）。 |

**運用上の注記:** §6・§9 の内容は merge 直後に `develop` へ `docs: add merge evidence for dashboard tasks alignment p1` としてコミットした（`git log develop --grep=merge evidence` で確認）。

### scope / ssot / dod

- scope check: OK  
- ssot check: OK  
- dod check: OK  
