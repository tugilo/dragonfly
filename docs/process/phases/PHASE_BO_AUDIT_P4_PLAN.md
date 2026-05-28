# PLAN: BO-AUDIT-P4（`default_workspace_id`・workspace 解決一本化）

| 項目 | 内容 |
|------|------|
| Phase ID | BO-AUDIT-P4 |
| 種別 | implement |
| Related SSOT | `USER_ME_AND_ACTOR_RESOLUTION.md`、`WORKSPACE_RESOLUTION_POLICY.md`、`BO_AUDIT_LOG_DESIGN.md`、`DATA_MODEL.md`、`DASHBOARD_DATA_SSOT.md` |
| ブランチ | `feature/phase-bo-audit-p4` |

---

## 1. 目的

- `users.default_workspace_id` を **nullable FK** で導入し、**ユーザー既定チャプター**を DB に持てるようにする。
- **`/api/users/me` と `ReligoActorContext`（BO 監査）** で **同一の workspace 解決順**を固定する（案C: default → owner 由来 artifacts → 先頭 workspace → null）。
- Dashboard / フロントは **workspace を API に無理に載せず**、GET `me` の解決済み `workspace_id` を **補助表示**に留める（案B 軽量）。

---

## 2. 調査結論（導入可否）

| 項目 | 結論 |
|------|------|
| users と workspaces | 既存 `workspaces` テーブル・各種 `workspace_id` FK あり。**users に既定を足すのは整合的**。 |
| 複数 workspace 所属 | メンバー／データ行レベルでは複数を想定済み。User は **1 つの既定 workspace** で足りる（本格マルチテナントは別 Phase）。 |
| 単一チャプター運用 | `default_workspace_id` は **null のまま**運用可能。未設定時は従来どおり artifacts → 先頭 workspace。 |
| migration 安全性 | nullable・既存行は null。FK は `nullOnDelete`。 |
| me / 監査 / Dashboard | `resolveWorkspaceIdForUser` 共有で **説明一貫**。DashboardController は `actingUser()` に統一済み。 |

**採用:** マイグレーションで導入する。

---

## 3. PATCH `/api/users/me`

- body に **`owner_member_id` または `default_workspace_id` のどちらか以上**（従来「owner のみ必須」から緩和）。
- `default_workspace_id: null` でクリア可。

---

## 4. DoD

- [x] migration / Model / `ReligoActorContext` / `UserController` / `BoAssignmentAuditLogWriter` / `DashboardController` 整合。
- [x] Feature テスト（me・BO audit で default が flag より優先）。
- [x] Dashboard ヘッダに解決済み `workspace_id` 補助表示（任意表示・API 未送信）。
- [x] SSOT・PLAN/WORKLOG/REPORT・REGISTRY・INDEX・progress。
- [x] `php artisan test`・`npm run build`・`develop` `--no-ff` merge・Merge Evidence・push。

---

## 5. 対象外

認証全面再設計、RBAC、workspace 切替 UI 全画面、members の workspace 割当全面実装。
