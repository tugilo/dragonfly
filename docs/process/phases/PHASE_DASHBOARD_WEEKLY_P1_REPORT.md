# REPORT: DASHBOARD-WEEKLY-P1

**Phase ID:** DASHBOARD-WEEKLY-P1  
**種別:** implement  
**Related SSOT:** SPEC-004 — [DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md](../../SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md)  
**ステータス:** completed（ローカル実装・テスト完了。**develop への merge は別手順**）

---

## 1. 実施内容サマリ

- `members` に **`weekly_presentation_body`（text, nullable）** を追加。
- **`GET /api/dashboard/weekly-presentation`** を追加（`DashboardController::resolveOwnerMemberId` により stats/tasks/activity と **同一 Owner 解決**）。
- Dashboard 左列 **Shortcuts と Activity の間**に **「ウィークリープレゼン原稿」**カードを追加（改行保持・最大高 240px スクロール・全文コピー・Owner 未設定時は非表示）。
- **DATA_MODEL**・**FIT_AND_GAP_MOCK_VS_UI §2**・**SSOT_REGISTRY（SPEC-004）**・要件書 DoD を更新。
- Feature テスト 4 件追加（`DashboardApiTest`）。

---

## 2. 変更ファイル一覧

```
docs/02_specifications/SSOT_REGISTRY.md
docs/INDEX.md
docs/SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md
docs/SSOT/DATA_MODEL.md
docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_DASHBOARD_WEEKLY_P1_PLAN.md
docs/process/phases/PHASE_DASHBOARD_WEEKLY_P1_WORKLOG.md
docs/process/phases/PHASE_DASHBOARD_WEEKLY_P1_REPORT.md
www/app/Http/Controllers/Religo/DashboardController.php
www/app/Models/Member.php
www/database/migrations/2026_04_07_110000_add_weekly_presentation_body_to_members_table.php
www/resources/js/admin/pages/Dashboard.jsx
www/resources/js/admin/pages/dashboard/DashboardWeeklyPresentationPanel.jsx
www/routes/api.php
www/tests/Feature/Religo/DashboardApiTest.php
docs/dragonfly_progress.md
```

---

## 3. データ変更

**あり。** `members.weekly_presentation_body`（nullable text）。マイグレーション: `2026_04_07_110000_add_weekly_presentation_body_to_members_table.php`

---

## 4. API 変更

**追加:** `GET /api/dashboard/weekly-presentation`  
**レスポンス:** `{ "weekly_presentation_body": string | null }`（DB が null または空文字のときは `null`）

---

## 5. UI 変更

**あり。** `Dashboard.jsx` に補助カード `DashboardWeeklyPresentationPanel.jsx` を追加。

---

## 6. テスト結果

| コマンド | 結果 |
|----------|------|
| `php artisan test --filter=DashboardApiTest` | **24 passed**（79 assertions） |
| `php artisan test`（全件） | **336 passed**（1339 assertions） |
| `npm run build` | **成功**（Vite build 完了） |

---

## 7. 未対応事項（本 Phase スコープ外）

- 原稿の **編集 UI**（Members 等）
- **標準稿 / 別稿**の複数カラム
- **リッチテキスト**・履歴・権限ロールの細分化

---

## 8. 次 Phase で扱うべき事項

- Members 編集（または専用画面）から **`weekly_presentation_body` を保存**するフローとバリデーション。
- 必要なら **一覧・CSV エクスポート**への列露出の要否。

---

## 9. Merge Evidence（develop 取り込み時に追記）

| 項目 | 値 |
|------|-----|
| merge commit id | （`git merge --no-ff` 後に記載） |
| source branch | feature/phase-dashboard-weekly-p1 |
| target branch | develop |
| test command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` |
| test result | 336 passed（取り込み時に再実行して記載） |

---

## 10. チェックリスト

| 項目 | 結果 |
|------|------|
| scope check | OK（PLAN のスコープどおり） |
| ssot check | OK（SPEC-004・DATA_MODEL・FIT_AND_GAP 更新） |
| dod check | OK |
