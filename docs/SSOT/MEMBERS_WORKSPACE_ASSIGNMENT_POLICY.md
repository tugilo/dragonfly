# Members の workspace 所属（MEMBERS-WORKSPACE-BACKFILL-P1）

**目的:** `members.workspace_id` の意味・backfill 順序・null の扱いを SSOT として固定する。  
**実装:** `members.workspace_id`（nullable FK）、`App\Services\Religo\MemberWorkspaceBackfillService`（初期 backfill）。

---

## 1. 列の意味

| 項目 | 定義 |
|------|------|
| **members.workspace_id** | 当該 member が所属する **BNI チャプター相当の workspace**（1 member = 1 チャプター前提）。 |
| **users.default_workspace_id** | ログインユーザーの **所属チャプター**（[WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)）。**owner の `users.owner_member_id` が指す member** については、運用上 **`members.workspace_id` と一致させる**ことを推奨（backfill では `default_workspace_id` を優先コピー）。 |
| **NULL** | 所属が未確定・レガシー・根拠不足。**無理に単一 workspace で埋めない**（複数 workspace 環境では `MemberWorkspaceBackfillService` の「先頭 1 件」フォールバックは使わない）。 |

---

## 2. Backfill 順序（説明可能な根拠のみ）

初期 migration 実行時に `MemberWorkspaceBackfillService::run()` が **1 回**呼ばれる。

| 順 | 処理 | 根拠 |
|----|------|------|
| 1 | `users` と `owner_member_id` で結び、`default_workspace_id` を `members.workspace_id` に写す | ユーザー設定が最も説明可能。 |
| 2 | まだ null の member について、**owner としての** `dragonfly_contact_flags` → `one_to_ones` → `contact_memos` の非 null `workspace_id` を **ReligoActorContext と同順**で採用 | 既存オーナー文脈のレガシー補完。 |
| 3 | **`workspaces` がちょうど 1 件**のときのみ、残り null をその id で埋める | 単一チャプター環境のみ曖昧さが小さい。複数 workspace では **実行しない**。 |

**やらないこと:** 推測のみによる全件埋め、他 member の target 側からの逆算（本フェーズでは対象外）。

---

## 3. 新規 member / 更新

- **本 Phase では** API や CSV が `members.workspace_id` を自動設定する改修は **必須としない**（列追加 + 初期 backfill が主成果）。
- 将来: `PATCH /api/users/me` で `default_workspace_id` 変更時に **対応する owner member の `workspace_id` を同期**するかは別 Phase で検討。

---

## 4. Dashboard stale（案B）との関係

- **列が存在しても**、`DashboardService::stalePeerMemberIds` を **所属で絞る改修は別 Phase**（[DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md) §0）。
- 案Bへ進めるには、peer を `members.workspace_id = 解決済み workspace` で限定し、**`getSummaryLiteBatch(..., $workspaceId)`** と説明を揃える必要がある（DASHBOARD-STALE-WORKSPACE-P2 の続き）。
