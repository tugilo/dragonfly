# Workspace 解決ポリシー（BO-AUDIT-P4 / WORKSPACE-SINGLE-CHAPTER-ASSUMPTION）

**実装:** `App\Services\Religo\ReligoActorContext::resolveWorkspaceIdForUser()`  
**利用者:** `UserController`（GET/PATCH `/api/users/me` の `workspace_id`）、`BoAssignmentAuditLogWriter`（監査行の `workspace_id`）

---

## 前提

**BNI ルール**により、会員は **1 チャプターにのみ所属**できる、というプロダクト前提に立つ。

Religo では:

- **1 チャプター = 1 `workspaces` 行**

とするため、

**👉 ユーザー（`users`）は原則 1 workspace に所属する（1 user = 1 workspace）。**

`users.default_workspace_id` は **フォールバック用の「なんとなくのデフォルト」ではなく**、DB 上は nullable でも、**主たる所属 workspace（所属チャプター）を指す**ものとして **最優先**で使う。

---

## 解決順（共通・唯一）

論理チャプター相当の `workspace_id`（整数または null）は、**同一 User 文脈**で次の順のみ。

| 順位 | ソース | 意味論上の役割 |
|------|--------|----------------|
| /1 | `users.default_workspace_id`（非 null） | **所属 workspace**（BNI チャプター）。ここが設定されていれば **これを正**とする。 |
| /2 | owner 由来の既存データ — `dragonfly_contact_flags` → `one_to_ones` → `contact_memos` の各テーブルで `owner_member_id` が User の `owner_member_id` と一致し、`workspace_id` が非 null の **先頭行** | **legacy 補完**（移行・未設定・古いデータからの推定）。 |
| /3 | `workspaces` の **id 昇順先頭**（`defaultChapterWorkspaceId()`） | **システムフォールバック**（単一チャプター運用時の最後手段）。 |
| /4 | `workspaces` が空なら **null** | データ未整備。 |

`owner_member_id` が null のときは /1 のあと /2 はスキップされ、/3 → /4 となる。

**注意:** /2・/3 は「所属が未設定なとき」に workspace を **説明可能に埋める**ための列であり、**運用上は /1 を正として設定すること**を推奨する（SSOT: [DATA_MODEL.md](DATA_MODEL.md)「Workspace と User の関係」）。

---

## `GET /api/users/me` 応答

| キー | 意味 |
|------|------|
| `default_workspace_id` | DB 上の **所属 workspace**（nullable）。PATCH で更新可。カラム名は歴史的に `default_*`。 |
| `workspace_id` | 上表の **解決済み**値（`/1`〜`/4`）。**所属チャプター**としての workspace ID（監査・説明・将来フィルタの共通基準）。 |

---

## カラム命名（`default_workspace_id`）

| 選択肢 | 結論 |
|--------|------|
| 現状維持 `default_workspace_id` | **採用** — マイグレーション・API 互換のためリネームしない。 |
| 将来候補 `workspace_id` / `primary_workspace_id` on `users` | **保留** — 別 Phase で要件が固まったときにのみ検討。 |

**意味の正:** SSOT および実装コメント上は **「所属 workspace」= `default_workspace_id`** と読み替える。

---

## スコープ外（明示）

- **user ⇄ workspace 多対多**・複数チャプター所属を前提とした権限・UI は **本フェーズでは非対応**。

---

## 既知の制限

- **acting user** が無認証フォールバック（`users` id 最小）のとき、複数 User 環境では「誰の所属か」が運用依存になる。認証必須化で解消予定。
- 本ポリシーは **workspace 切替 UI 全画面**ではなく、**BNI 単一チャプター所属**を説明の軸に固定するもの。

詳細文脈: [USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md)

---

## MemberSummaryQuery と workspace（MEMBER-SUMMARY-WORKSPACE-NULL-P1）

`GET /api/dragonfly/members` の `with_summary=1` で任意の **`workspace_id` クエリ**を渡したとき、`MemberSummaryQuery::getSummaryLiteBatch` の第 3 引数にその ID が入る。単一チャプター運用の SSOT（[DATA_MODEL.md](DATA_MODEL.md) §5.1）に従い、`contact_memos` / `one_to_ones` / `dragonfly_contact_flags` には **`(workspace_id = :id OR workspace_id IS NULL)`** を適用する（legacy・未 backfill 行を現在所属チャプターに含める）。

**Dashboard** の stale / KPI は **第 3 引数 `null`**（owner 全体）のまま。解決済み workspace（本ポリシーの `/1`〜`/4`）を stale に渡すかは別 Phase。
