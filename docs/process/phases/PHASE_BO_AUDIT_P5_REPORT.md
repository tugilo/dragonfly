# REPORT: BO-AUDIT-P5

| 項目 | 内容 |
|------|------|
| Phase ID | BO-AUDIT-P5 |
| 種別 | implement |
| Related SSOT | `DASHBOARD_DATA_SSOT.md`、`USER_ME_AND_ACTOR_RESOLUTION.md`、`WORKSPACE_RESOLUTION_POLICY.md` |
| ブランチ | `feature/phase-bo-audit-p5` |

---

## 1. 実施内容サマリ

所属チャプター（workspace）を **`/#/settings`** で選択し、**`PATCH /api/users/me`** の `default_workspace_id` に保存。一覧は既存 **`GET /api/workspaces`**。初期表示は **`GET /api/users/me` の `workspace_id`**（解決済み）。サイドメニュー・AppBar・Dashboard ヘッダに所属名を表示し、保存後はカスタムイベント **`religo-workspace-changed`** で AppBar / Dashboard が再取得する。

---

## 2. 変更ファイル一覧

| パス |
|------|
| `www/resources/js/admin/pages/ReligoSettings.jsx`（新規） |
| `www/resources/js/admin/app.jsx` |
| `www/resources/js/admin/ReligoMenu.jsx` |
| `www/resources/js/admin/CustomAppBar.jsx` |
| `www/resources/js/admin/pages/Dashboard.jsx` |
| `www/resources/js/admin/pages/dashboard/DashboardHeader.jsx` |
| `docs/SSOT/DASHBOARD_DATA_SSOT.md` |
| `docs/process/phases/PHASE_BO_AUDIT_P5_{PLAN,WORKLOG,REPORT}.md` |
| `docs/process/PHASE_REGISTRY.md` |
| `docs/INDEX.md` |
| `docs/dragonfly_progress.md` |

---

## 3. BNI前提の設計整理

- 変更なし（WORKSPACE-SINGLE-CHAPTER-ASSUMPTION 準拠）。UI は **所属 workspace** を編集するだけ。

---

## 4. SSOT更新内容

- `DASHBOARD_DATA_SSOT.md` に **所属チャプター UI** 節と実装紐づけ表の追記。

---

## 5. フィット＆ギャップ結果

- **ギャップなし。** actor / workspace 解決式は据え置き。

---

## 6. 実装への影響

- **バックエンド:** 変更なし。
- **フロント:** 新規ページ・イベント・表示のみ。

---

## 7. テスト結果

| コマンド | 結果 |
|----------|------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | **315 passed** |
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` | 成功 |

---

## 8. 未解決事項

- 認証必須化・ロール別の設定可否は **P6 以降**。

---

## 9. 次 Phase 提案

- **BO-AUDIT-P6:** 管理画面認証の本番運用と acting user の曖昧さ解消。

---

## 10. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff feature/phase-bo-audit-p5` |
| merged branch | `feature/phase-bo-audit-p5` |
| target branch | `develop` |
| merge commit id | `1129f7d9272d7e6c184a3acf19cac1d2e7bdacd9` |
| feature last commit id | `fde9071bfcec375d6f89a1cadc398e4cd36d10fe` |
| pushed at | `2026-03-20T08:50:02Z`（Evidence 追記コミット時点・UTC） |
| test result | 315 passed、`npm run build` 成功 |
| notes | `/settings`・PATCH `default_workspace_id`・AppBar/Dashboard・イベント同期。バックエンド変更なし。 |

| scope / ssot / dod | OK |
