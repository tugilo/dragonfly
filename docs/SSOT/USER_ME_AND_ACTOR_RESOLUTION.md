# `/api/users/me` と BO 監査 actor の解決（BO-AUDIT-P3〜P4）

**実装:** `App\Services\Religo\ReligoActorContext`  
**利用者:** `UserController`（GET/PATCH `/api/users/me`）、`BoAssignmentAuditLogWriter`

**workspace 解決の詳細順序:** [WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)

---

## 1. 現在ユーザー（acting user）

| 順位 | 条件 |
|------|------|
| /1 | `auth()->user()` が `App\Models\User` のとき、そのインスタンス |
| /2 | 上記が無いとき、`users` を **id 昇順**で先頭の 1 行 |

**意図:** 認証導入後は必ず /1。現行の無認証 API では「単一管理者・最小 id の User がオペレータ」とみなす（旧 **user id 1 固定**の一般化）。

**404:** `users` が空のとき `/api/users/me` は 404。

---

## 2. `workspace_id`（chapter 文脈・解決済み）

Religo / DragonFly では **1 `workspaces` 行 ≒ 1 BNI チャプター（会）** として扱う。複数 workspace はデータ上は存在しうるが、**Dashboard / owner の活動**はまず単一チャプター運用を前提とする。

**`/api/users/me` の `workspace_id`:** 次を **この順で**適用した結果（nullable）。**`ReligoActorContext::resolveWorkspaceIdForUser($user)` と同一。**

1. `users.default_workspace_id`（BO-AUDIT-P4 で追加・nullable）
2. owner の既存データ — `dragonfly_contact_flags` → `one_to_ones` → `contact_memos` の `workspace_id`（`resolveWorkspaceIdFromOwnerMemberArtifacts`）
3. `workspaces` id 昇順先頭
4. 行が無ければ null

**応答フィールド `default_workspace_id`:** DB の生値。`workspace_id` は上記で解いた **運用上の章 ID**。

---

## 3. PATCH `/api/users/me`

- **`owner_member_id`** と **`default_workspace_id`** のいずれか一方以上を body に含めること（両方可）。どちらも無い場合は 422。
- `default_workspace_id` に `null` を送ると **クリア**（FK nullable）。

---

## 4. BO 監査ログとの整合

- `actor_user_id` / `actor_owner_member_id`: **acting user** とその `owner_member_id`。
- `bo_assignment_audit_logs.workspace_id`: **`resolveWorkspaceIdForUser(actingUser)`** と **GET `/api/users/me` の `workspace_id`** と同一基準。

Dashboard Activity の `bo_assigned` は引き続き **`actor_owner_member_id` = ダッシュボード owner** でフィルタ。`workspace_id` 列は **Activity クエリでは未使用**（将来の絞り込み・レポート用）。

---

## 5. chapter という言葉

ドキュメント上の **chapter**（DragonFly チャプター名）と DB 上の **`workspaces`** は、このリポジトリの現段階では **1:1 対応を運用前提**としてよい。厳密な別エンティティは持たない。
