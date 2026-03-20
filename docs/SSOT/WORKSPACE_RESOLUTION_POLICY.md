# Workspace 解決ポリシー（BO-AUDIT-P4）

**実装:** `App\Services\Religo\ReligoActorContext::resolveWorkspaceIdForUser()`  
**利用者:** `UserController`（GET/PATCH `/api/users/me` の `workspace_id`）、`BoAssignmentAuditLogWriter`（監査行の `workspace_id`）

---

## 解決順（共通・唯一）

論理チャプター相当の `workspace_id`（整数または null）は、**同一 User 文脈**で次の順のみ。

| 順位 | ソース |
|------|--------|
| /1 | `users.default_workspace_id`（非 null） |
| /2 | owner 由来の既存データ — `dragonfly_contact_flags` → `one_to_ones` → `contact_memos` の各テーブルで `owner_member_id` が User の `owner_member_id` と一致し、`workspace_id` が非 null の **先頭行**（テーブル間はこの順で、先に当たった値を採用） |
| /3 | `workspaces` の **id 昇順先頭**（`defaultChapterWorkspaceId()`） |
| /4 | `workspaces` が空なら **null** |

`owner_member_id` が null のときは /1 のあと /2 はスキップされ、/3 → /4 となる。

---

## `GET /api/users/me` 応答

| キー | 意味 |
|------|------|
| `default_workspace_id` | DB 上のユーザー既定（nullable）。PATCH で更新可。 |
| `workspace_id` | 上表の **解決済み**値（`/1`〜`/4`）。説明・監査・将来フィルタの共通基準。 |

---

## 既知の制限

- **acting user** が無認証フォールバック（`users` id 最小）のとき、複数 User 環境では「誰の default / owner か」が運用依存になる。認証必須化で解消予定。
- 本ポリシーは **マルチテナント UI の workspace 切替**ではなく、単一〜少数 workspace 運用の **説明可能な基準**を固定するもの。

詳細文脈: [USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md)
