# WORKLOG: DASHBOARD-WEEKLY-P1

**Phase ID:** DASHBOARD-WEEKLY-P1  
**PLAN:** [PHASE_DASHBOARD_WEEKLY_P1_PLAN.md](./PHASE_DASHBOARD_WEEKLY_P1_PLAN.md)

---

## 判断ログ（実装の「なぜ」）

### API を `GET /api/dashboard/weekly-presentation` にした理由

- `DashboardController::resolveOwnerMemberId` と **422/404 の意味**を stats/tasks/activity と共有し、フロントは `owner_member_id` を付けるだけでよい。
- Member 汎用 API に `weekly_presentation_body` を載せると、一覧・Show のレスポンス設計・権限の議論が広がる。SPEC-004 の「最小・Dashboard 専用」に合わせ **読み取り専用の Dashboard 配下**に閉じた。

### UI を Shortcuts 直下・固定高スクロールにした理由

- SPEC-004 / PLAN の「Shortcuts の近傍」「長文は折りたたみまたは固定高」のうち、**実装コストが低く**プレビュー量が一定になる **固定高 + スクロール**を採用。

### 空文字と null を API でどちらも JSON `null` に正規化した理由

- UI の「未登録」分岐を **1 パス**にし、DB の空文字入力があっても表示を統一。

---

## 作業メモ

- **2026-04-07:** PLAN 完成 → migration・API・`Member::$fillable`・Dashboard 並列 fetch・カード UI・テスト・SSOT 更新 → 全テスト・ビルド通過。
- **並列取得:** `weekly-presentation` を `stats` / `tasks` / `activity` と同一 `Promise.all` に含め、SPEC-004 の非機能（体感速度）に沿った。
- **Owner 切替:** `loadDashboard` 先頭で `weeklyPresentation` をリセットし、前オーナーの本文が残らないようにした。

