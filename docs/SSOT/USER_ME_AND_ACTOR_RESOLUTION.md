# `/api/users/me` と BO 監査 actor の解決（BO-AUDIT-P3〜P4 / WORKSPACE-SINGLE-CHAPTER-ASSUMPTION）

**実装:** `App\Services\Religo\ReligoActorContext`  
**利用者:** `UserController`（GET/PATCH `/api/users/me`）、`BoAssignmentAuditLogWriter`

**workspace 解決の詳細順序:** [WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)  
**BNI 前提（1 user = 1 workspace）:** [DATA_MODEL.md](DATA_MODEL.md)「Workspace と User の関係」

---

## `workspace_id` の意味（API・BO 共通）

GET `/api/users/me` の **`workspace_id`** および BO 監査ログの **`workspace_id`** は、どちらも **「その操作主体（acting user）に紐づく所属チャプター」**を示す workspace ID（nullable）である。

- **基準:** 通常は **`users.default_workspace_id`（所属 workspace）** があればそれがそのまま解決値となる（[WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md) /1）。
- **補足:** 未設定時のみ legacy 補完・システムフォールバックで埋める。意味の正は常に **所属 = `default_workspace_id`**。

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

Religo / DragonFly では **1 `workspaces` 行 ≒ 1 BNI チャプター（会）** として扱う。**ユーザーは原則 1 チャプター＝1 workspace に所属**（[DATA_MODEL.md](DATA_MODEL.md)）。

**`/api/users/me` の `workspace_id`:** 次を **この順で**適用した結果（nullable）。**`ReligoActorContext::resolveWorkspaceIdForUser($user)` と BO 監査と同一。**

1. **`users.default_workspace_id`** — **所属 workspace**（最優先・主たる値）
2. **legacy 補完** — owner の既存データ `dragonfly_contact_flags` → `one_to_ones` → `contact_memos` の `workspace_id`（`resolveWorkspaceIdFromOwnerMemberArtifacts`）
3. **システムフォールバック** — `workspaces` id 昇順先頭
4. 行が無ければ null

**応答フィールド `default_workspace_id`:** DB の生値（**所属 workspace**）。`workspace_id` は上記で解いた **所属チャプターとしての workspace ID**。

---

## 3. PATCH `/api/users/me`

- **`owner_member_id`** と **`default_workspace_id`** のいずれか一方以上を body に含めること（両方可）。どちらも無い場合は 422。
- `default_workspace_id` に `null` を送ると **所属 workspace をクリア**（FK nullable）。BNI 前提では運用上 **所属を未設定**に相当するため、速やかに再設定するか運用で扱う。

---

## 4. BO 監査ログとの整合

- `actor_user_id` / `actor_owner_member_id`: **acting user** とその `owner_member_id`。
- `bo_assignment_audit_logs.workspace_id`: **`resolveWorkspaceIdForUser(actingUser)`** と **GET `/api/users/me` の `workspace_id`** と同一基準。

Dashboard Activity の `bo_assigned` は引き続き **`actor_owner_member_id` = ダッシュボード owner** でフィルタ。`workspace_id` 列は **Activity クエリでは未使用**（将来の絞り込み・レポート用）。

---

## 5. chapter という言葉

ドキュメント上の **chapter**（DragonFly チャプター名）と DB 上の **`workspaces`** は、このリポジトリの現段階では **1:1 対応を運用前提**としてよい。厳密な別エンティティは持たない。
