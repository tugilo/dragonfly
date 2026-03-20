# `/api/users/me` と BO 監査 actor の解決（BO-AUDIT-P3）

**実装:** `App\Services\Religo\ReligoActorContext`  
**利用者:** `UserController`（GET/PATCH `/api/users/me`）、`BoAssignmentAuditLogWriter`

---

## 1. 現在ユーザー（acting user）

| 順位 | 条件 |
|------|------|
| /1 | `auth()->user()` が `App\Models\User` のとき、そのインスタンス |
| /2 | 上記が無いとき、`users` を **id 昇順**で先頭の 1 行 |

**意図:** 認証導入後は必ず /1。現行の無認証 API では「単一管理者・最小 id の User がオペレータ」とみなす（旧 **user id 1 固定**の一般化）。

**404:** `users` が空のとき `/api/users/me` は 404。

---

## 2. workspace_id（chapter 文脈）

Religo / DragonFly では **1 `workspaces` 行 ≒ 1 BNI チャプター（会）** として扱う。複数 workspace はデータ上は存在しうるが、**Dashboard / owner の活動**はまず単一チャプター運用を前提とする。

**`/api/users/me` の `workspace_id`:** `owner_member_id` から推定（nullable）。

| 順位 | ソース |
|------|--------|
| /1 | `dragonfly_contact_flags` で `owner_member_id` が一致し `workspace_id` が非 null の先頭行 |
| /2 | `one_to_ones` 同上 |
| /3 | `contact_memos` 同上 |
| /4 | **workspaces** の id 昇順先頭（章の既定フォールバック） |

`owner_member_id` が null のときは /4 のみ。

---

## 3. BO 監査ログとの整合

- `actor_user_id` / `actor_owner_member_id`: **acting user** とその `owner_member_id`。
- `bo_assignment_audit_logs.workspace_id`: **同じ表**で `resolveWorkspaceIdForOwnerMember(owner_member_id)` を適用（audit 行ごとの actor に揃える）。

Dashboard Activity の `bo_assigned` は引き続き **`actor_owner_member_id` = ダッシュボード owner** でフィルタ。`workspace_id` 列は **Activity クエリでは未使用**（将来の絞り込み・レポート用）。

---

## 4. chapter という言葉

ドキュメント上の **chapter**（DragonFly チャプター名）と DB 上の **`workspaces`** は、このリポジトリの現段階では **1:1 対応を運用前提**としてよい。厳密な別エンティティは持たない。
