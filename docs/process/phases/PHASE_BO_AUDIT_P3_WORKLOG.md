# WORKLOG: BO-AUDIT-P3

## 判断

### /api/users/me の旧実装と差分

- **旧:** `User::find(1)` のみ。**新:** `ReligoActorContext::actingUser()`＝`auth()->user()` が `User` なら採用、無ければ `User::orderBy('id')->first()`。PATCH も **acting user の行のみ**更新。

### actor をどう統一したか

- `BoAssignmentAuditLogWriter::resolveActorUser()` は `ReligoActorContext::actingUser()` に委譲。`createLog` の `workspace_id` は `resolveWorkspaceIdForOwnerMember($user?->owner_member_id)`。

### workspace をどう決めたか

- `owner_member_id` について **dragonfly_contact_flags → one_to_ones → contact_memos** の既存 `workspace_id` を順に探索。無ければ **workspaces 先頭**。

### chapter をどう解釈したか

- **DragonFly チャプター ≒ `workspaces` の 1 行** と文書化（厳密な別エンティティは持たない）。

### fallback

- **残す:** 無認証時の「先頭 User」。複数 User・無認証共有運用では最小 id が me になる点を SSOT に明記。

### Dashboard

- Activity フィルタは `actor_owner_member_id` のみ継続。`workspace_id` 列は未使用。

### merge 時の競合

- **なし**（`develop` に `feature/phase-bo-audit-p3` を `--no-ff` merge）。
