# PLAN: BO-AUDIT-P5（所属チャプター設定 UI）

| 項目 | 内容 |
|------|------|
| Phase ID | BO-AUDIT-P5 |
| 種別 | implement |
| Related SSOT | `DASHBOARD_DATA_SSOT.md`、`USER_ME_AND_ACTOR_RESOLUTION.md`、`WORKSPACE_RESOLUTION_POLICY.md` |
| ブランチ | `feature/phase-bo-audit-p5` |

---

## 1. 目的

SSOT で **所属 workspace = `default_workspace_id`** とした前提を、管理画面から **選択・保存**できるようにする。`GET /api/users/me`・AppBar・Dashboard 表示を一致させる。

---

## 2. スコープ

- 既存 **`GET /api/workspaces`** を利用（新規 API なし）。
- **`/#/settings`**（`ReligoSettings`）に Select + 保存。初期値は **`me.workspace_id`**（解決済み）、保存は **`PATCH` with `default_workspace_id`**。
- **CustomAppBar** に所属名バッジ（`religo-workspace-changed` で更新）。
- **DashboardHeader** に所属チャプター名 + `/settings` リンク。

---

## 3. 対象外

リアルタイム workspace 切替、複数所属、権限、認証本格化（P6）、UI の過剰装飾。

---

## 4. DoD

- [x] workspace 一覧取得可能。
- [x] UI から所属変更・DB / me 反映。
- [x] Header / Dashboard と SSOT 意味一致。
- [x] `php artisan test`・`npm run build`・develop `--no-ff` merge・Merge Evidence・push。
