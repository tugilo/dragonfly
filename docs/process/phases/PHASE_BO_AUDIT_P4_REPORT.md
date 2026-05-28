# REPORT: BO-AUDIT-P4

| 項目 | 内容 |
|------|------|
| Phase ID | BO-AUDIT-P4 |
| 種別 | implement |
| Related SSOT | `USER_ME_AND_ACTOR_RESOLUTION.md`、`WORKSPACE_RESOLUTION_POLICY.md`、`BO_AUDIT_LOG_DESIGN.md`、`DATA_MODEL.md`、`DASHBOARD_DATA_SSOT.md` |
| ブランチ | `feature/phase-bo-audit-p4` |

---

## 1. 実施内容サマリ

- `users.default_workspace_id`（nullable FK → `workspaces`）を追加。
- `ReligoActorContext::resolveWorkspaceIdForUser` で **GET `/api/users/me` の `workspace_id` と BO 監査の `workspace_id`** を同一順に統一（default → owner artifacts → 先頭 workspace → null）。
- `PATCH /api/users/me` で `default_workspace_id` を更新可能（`owner_member_id` 単独必須を撤廃し、**どちらか一方以上**）。
- Dashboard は `workspace_id` を API に載せず、ヘッダに **解析用**として補助表示。`religoOwnerMemberId.js` に `fetchReligoMe()` を追加。
- SSOT 新規 `WORKSPACE_RESOLUTION_POLICY.md`、既存 SSOT 更新、Phase 文書・REGISTRY・INDEX・progress 更新。

---

## 2. 変更ファイル一覧

| 種別 | パス |
|------|------|
| 新規 | `www/database/migrations/2026_03_20_120000_add_default_workspace_id_to_users_table.php` |
| 更新 | `www/app/Models/User.php` |
| 更新 | `www/app/Services/Religo/ReligoActorContext.php` |
| 更新 | `www/app/Http/Controllers/Religo/UserController.php` |
| 更新 | `www/app/Http/Controllers/Religo/DashboardController.php` |
| 更新 | `www/app/Services/Religo/BoAssignmentAuditLogWriter.php` |
| 更新 | `www/tests/Feature/Religo/UserMeApiTest.php` |
| 更新 | `www/tests/Feature/Religo/MeetingBreakoutsTest.php` |
| 更新 | `www/resources/js/admin/pages/Dashboard.jsx` |
| 更新 | `www/resources/js/admin/pages/dashboard/DashboardHeader.jsx` |
| 更新 | `www/resources/js/admin/religoOwnerMemberId.js` |
| 新規 | `docs/SSOT/WORKSPACE_RESOLUTION_POLICY.md` |
| 更新 | `docs/SSOT/{USER_ME_AND_ACTOR_RESOLUTION,BO_AUDIT_LOG_DESIGN,DATA_MODEL,DASHBOARD_DATA_SSOT}.md` |
| 新規 | `docs/process/phases/PHASE_BO_AUDIT_P4_{PLAN,WORKLOG,REPORT}.md` |
| 更新 | `docs/{INDEX,dragonfly_progress}.md`、`docs/process/PHASE_REGISTRY.md` |

---

## 3. 調査結果

- users / workspaces / owner データの関係から **`default_workspace_id` 導入は安全**かつ説明コストが下がる。
- 複数 User・無認証共有運用では従来どおり **最小 id フォールバック**の限界は残る（SSOT に明記）。

---

## 4. `default_workspace_id` 設計判断

**採用。** nullable・既存行は null・`nullOnDelete`。User は **多対多で workspaces に所属**するのではなく、**「既定の 1 行」**を指すだけに留め、過度な一般化は避けた。

---

## 5. `/api/users/me` / actor / workspace 解決方針

**案C（併用）を採用:** `default_workspace_id` → owner の flags / 1to1 / memos → `workspaces` id 昇順先頭 → null。  
`BoAssignmentAuditLogWriter` と `UserController::mePayload` は **同じ `resolveWorkspaceIdForUser`** を参照。

---

## 6. 実装内容

- 上記のとおり。`DashboardController::resolveOwnerMemberId` は `actingUser()` の `owner_member_id` を使用。

---

## 7. テスト結果

| コマンド | 結果 |
|----------|------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | **315 passed**（feature 上・merge 前後で再実行可） |
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` | 成功 |

---

## 8. 未解決事項

- 管理画面から `default_workspace_id` を編集する **専用 UI** は未実装（API・PATCH のみ）。必要なら別 Phase。
- 認証必須化・workspace 切替 UI は未着手。

---

## 9. 次 Phase 提案

- 認証ミドルウェアの本導入と無認証フォールバック縮小。
- 既定 workspace を選ぶ **設定画面**（Select + PATCH）。

---

## 10. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff feature/phase-bo-audit-p4` |
| merged branch | `feature/phase-bo-audit-p4` |
| target branch | `develop` |
| merge commit id | `5cc3ca9df0777a62944386790224992ca2331ddc` |
| feature last commit id | `658d4e41399c6bb06b247d7f07d8d82155fd6289` |
| pushed at | `2026-03-20T04:51:58Z`（Evidence 追記コミット時点・UTC） |
| test result | `php artisan test` **315 passed**（merge 後 develop 上）。`npm run build` 成功。 |
| notes | `default_workspace_id` 導入。me / BO workspace は `resolveWorkspaceIdForUser` 一本化。Dashboard は workspace 補助表示のみ。競合なし。 |

| scope / ssot / dod | OK |
