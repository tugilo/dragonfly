# REPORT: BO-AUDIT-P1（BO保存の監査ログ設計・Dashboard `bo_assigned`）

| 項目 | 内容 |
|------|------|
| Phase ID | BO-AUDIT-P1 |
| 種別 | implement |
| Related SSOT | `BO_AUDIT_LOG_DESIGN.md`、`DATA_MODEL.md`、`DASHBOARD_FIT_AND_GAP.md`、`DASHBOARD_DATA_SSOT.md`、`FIT_AND_GAP_MOCK_VS_UI.md` |
| ブランチ | `feature/phase-bo-audit-p1` |

---

## 1. 実施内容サマリ

BO（breakout）保存の **説明可能な監査**として `bo_assignment_audit_logs` を新設し、`PUT .../breakouts` と `PUT .../breakout-rounds` 成功直後に 1 行記録。`meeting_csv_apply_logs` は流用しない。Dashboard `GET /api/dashboard/activity` に **`kind=bo_assigned`** を統合（owner = `actor_owner_member_id`）。

---

## 2. 変更ファイル一覧

| 種別 | パス |
|------|------|
| 新規 | `www/database/migrations/2026_03_20_100000_create_bo_assignment_audit_logs_table.php` |
| 新規 | `www/app/Models/BoAssignmentAuditLog.php` |
| 新規 | `www/app/Services/Religo/BoAssignmentAuditLogWriter.php` |
| 更新基礎 | `www/app/Http/Controllers/Religo/MeetingBreakoutController.php` |
| 更新基礎 | `www/app/Http/Controllers/Religo/MeetingBreakoutRoundsController.php` |
| 更新基礎 | `www/app/Services/Religo/DashboardService.php` |
| 更新 | `www/tests/Feature/Religo/DashboardApiTest.php` |
| 新規 | `docs/SSOT/BO_AUDIT_LOG_DESIGN.md` |
| 新規 | `docs/process/phases/PHASE_BO_AUDIT_P1_PLAN.md` |
| 新規 | `docs/process/phases/PHASE_BO_AUDIT_P1_WORKLOG.md` |
| 新規 | 本 REPORT |
| 更新 | `docs/process/PHASE_REGISTRY.md` |
| 更新 | `docs/INDEX.md` |
| 更新 | `docs/dragonfly_progress.md` |
| 更新 | `docs/SSOT/DATA_MODEL.md` |
| 更新 | `docs/SSOT/DASHBOARD_FIT_AND_GAP.md` |
| 更新 | `docs/SSOT/DASHBOARD_DATA_SSOT.md` |
| 更新 | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` |

---

## 3. 調査結果

- **イベント源:** `MeetingBreakoutController` / `MeetingBreakoutRoundsController` が保存 API の入口。個別保存（ペイロード単位の PUT）。CSV apply は別系統。
- **既存ログ:** `MeetingCsvApplyLog` は CSV 反映専用。BO 監査の源として不適切。
- **レガシー API:** 未接続（ REPORT 時点で P1 スコープ外）。

---

## 4. 設計判断

- **責務:** Meetings（`meeting_id`）＋専用監査テーブル。
- **Activity:** `bo_assigned`、title は `例会 #{number} のBO割当を保存`、meta は payload からユニーク `member_id` 数とラベル（BO1/BO2 vs 複数Round）。
- **actor:** 現行は `User::find(1)` と `owner_member_id` スナップショット（Dashboard と同様の制約）。

---

## 5. 実装内容

- 上記マイグレーション・Writer・Controller 追記・`DashboardService::getActivity` 拡張・テスト `test_activity_includes_bo_assigned_after_breakout_save`。

---

## 6. テスト結果

| コマンド | 結果 |
|----------|------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | （merge 完了後に記載） |
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` | （merge 完了後に記載） |

---

## 7. 未解決事項

- レガシー `breakout-assignments` の監査接続。
- 認証を user id 1 固定から移行する際の `actor_user_id` 取得。

---

## 8. 次 Phase 提案

- **BO-AUDIT-P2（案）:** レガシー API の監査、`workspace_id` の埋め方、本番認証との整合。

---

## 9. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff feature/phase-bo-audit-p1` |
| merged branch | `feature/phase-bo-audit-p1` |
| target branch | `develop` |
| merge commit id | （merge 後に `git log -1 --format=%H develop`） |
| feature last commit id | （merge 直前の feature `HEAD`） |
| pushed at | （`git push` 完了後に記載・ISO8601 推奨） |
| test command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` |
| test result | （passed 数） |
| build | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` |
| notes | 最小監査＋Dashboard 表示まで実装。 |

**証跡追記コミット:** merge 直後に本表を埋めたうえで、必要なら `docs: add merge evidence for BO-AUDIT-P1` を別コミットで push。

---

## scope / ssot / dod セルフチェック

| チェック | 結果 |
|----------|------|
| scope | OK（ Meetings / Dashboard 周辺のみ） |
| ssot | `BO_AUDIT_LOG_DESIGN.md` 追加・既存 SSOT 更新済み |
| dod | PLAN の DoD すべて満たす（merge・Evidence 追記後に完了） |
