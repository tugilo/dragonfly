# WORKLOG: BO-AUDIT-P4

## 判断

- **`default_workspace_id`:** 導入する。理由: 既存 `workspaces` との FK 整合・nullable で既存環境が壊れない・me / BO の説明を user 軸で固定できる。
- **解決順（旧 → 新）**
  - **旧（P3）:** flags → one_to_ones → contact_memos → 先頭 workspace（`owner_member_id` 起点で `resolveWorkspaceIdForOwnerMember` 相当）。
  - **新（P4）:** `users.default_workspace_id` → 同一 artifacts（owner = user の `owner_member_id`）→ 先頭 workspace → null。実装は `ReligoActorContext::resolveWorkspaceIdForUser` に一本化。
- **`/api/users/me`:** `default_workspace_id`（DB）と `workspace_id`（上記解決済み）を併記。PATCH は owner のみ必須をやめ、**どちらかのキーがあればよい**。
- **BO 監査:** `BoAssignmentAuditLogWriter` は引き続き context のみ参照。`resolveWorkspaceIdForAudit` は `resolveWorkspaceIdForUser(actor)` に差し替え。
- **Dashboard / フロント:** stats/tasks/activity への `workspace_id` クエリは付けない（データは従来どおり owner 軸）。**案B 軽量:** `DashboardHeader` に `GET /api/users/me` の解決済み `workspace_id` をキャプション表示し、「me と同じ式で解けている」を目視確認可能にした。
- **`DashboardController::resolveOwnerMemberId`:** `User::find(1)` をやめ **`ReligoActorContext::actingUser()`** に合わせる（P4 でフォールバック一貫）。
- **フォールバック:** 無認証時の最小 id User フォールバックは **維持**（認証全面化は別 Phase）。
- **merge 競合:** なし（`develop` への `--no-ff` merge）。
