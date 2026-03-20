# REPORT: DASHBOARD-P7-2（Dashboard データ・導線改善）

| 項目 | 内容 |
|------|------|
| Phase ID | DASHBOARD-P7-2 |
| 種別 | implement |
| Related SSOT | `DASHBOARD_FIT_AND_GAP.md`、`DASHBOARD_DATA_SSOT.md`、`DATA_MODEL.md` |
| ブランチ | `feature/phase-dashboard-p7-2-data-actions` |

---

## 1. 実施内容サマリ

Dashboard API（`DashboardService`）と軽微な UI 定数で、**KPI 補足文の動的化**、**次回例会までの日数**、**Tasks のメモ deep link**、**Activity（紹介メモ種別・フラグ更新）**を実装した。P7-1 のレイアウトは維持。Feature テストを `DashboardApiTest` に追加。`develop` へ `--no-ff` merge・push、本 REPORT §10 Merge Evidence 追記コミットまで完了。

---

## 2. 変更ファイル一覧

| 種別 | パス |
|------|------|
| 更新 | `www/app/Services/Religo/DashboardService.php` |
| 更新 | `www/app/Models/DragonflyContactFlag.php`（`workspace_id` を fillable に） |
| 更新 | `www/resources/js/admin/pages/dashboard/dashboardConstants.js` |
| 更新 | `www/resources/js/admin/pages/dashboard/DashboardActivityPanel.jsx` |
| 更新 | `www/tests/Feature/Religo/DashboardApiTest.php` |
| 新規 | `docs/process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_PLAN.md` |
| 新規 | `docs/process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_WORKLOG.md` |
| 新規 | 本 REPORT |
| 更新 | `docs/process/PHASE_REGISTRY.md` |
| 更新 | `docs/INDEX.md` |
| 更新 | `docs/dragonfly_progress.md` |
| 更新 | `docs/SSOT/DASHBOARD_FIT_AND_GAP.md` |
| 更新 | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` |

---

## 3. KPI subtext 動的化

- 未接触：**人数・割合**の一行。
- 1to1 / 紹介メモ / 例会メモ：**先月件数**との差分（増減または変化なし）。
- 例会メモ：**直近登録の例会番号**を補足。

---

## 4. 次回例会表示

- 未来・当日の `held_on`：**本日開催** / **次回例会まであとN日**。
- 未来が無く過去のみ：**次回例会は未登録（直近 #N・終了済み）**。

---

## 5. Tasks 導線

- 2 件目 stale の「メモ追加」→ **`/members/{id}/show`**、`disabled: false`。

---

## 6. Activity 拡張

- `flag_changed`：`dragonfly_contact_flags.updated_at`。
- `memo_introduction`：`memo_type=introduction` のメモ。

---

## 7. テスト結果

| コマンド | 結果 |
|----------|------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | **302 passed**（merge 直後・本 Evidence 追記前の実行） |
| `docker compose ... exec node npm run build` | 成功 |

---

## 8. 残課題

- `bo_assigned` 活動：BO 保存の**単一イベント源**が無いため未対応。
- KPI 未接触の「前月比」は未実装（スナップショット無し）。

---

## 9. 次 Phase 提案

- **P7-3:** ローディング・空状態・`FIT_AND_GAP_MOCK_VS_UI` の細部更新、必要なら BO イベントの SSOT 化。

---

## 10. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff feature/phase-dashboard-p7-2-data-actions` |
| merged branch | `feature/phase-dashboard-p7-2-data-actions` |
| merge commit id | `519ace29dc8a1f72c33ecff3686cd1b24129a15a` |
| feature last commit id | `0a7c74b481624d45037a7a61ae5f4b3791b51d30` |
| first push develop (merge) | `2026-03-20T02:16:51Z`（UTC・merge push 直前タイムスタンプ） |
| test result | `302 passed`（1219 assertions・merge 直後ローカル） |
| build | `npm run build` 成功（merge 直後） |
| merge evidence docs commit | `ce5dfdba627807e2cb353a295bbc91211acea331`（`docs: add merge evidence for DASHBOARD P7-2`） |
| notes | 競合なし |
