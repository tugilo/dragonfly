# WORKLOG: WORKSPACE-SINGLE-CHAPTER-ASSUMPTION

## BNI ルールの整理

- BNI では会員は **1 チャプターにのみ所属**する前提で Religo を置く。
- Religo では **1 チャプター = 1 `workspaces` 行**。

## workspace = chapter

- ドキュメント・API の「chapter」「所属チャプター」は **解決済み `workspace_id` または所属 `default_workspace_id`** と読み替え可能、と SSOT で固定。

## `default_workspace_id` の再定義

- **Before（曖昧）:** 「デフォルト workspace」「将来 multi-tenant の足場」寄りの読み。
- **After（SSOT）:** **ユーザーの所属 workspace**（主たる値）。解決順 /1 は **fallback ではなく正式な所属**。
- **命名:** カラム名は **`default_workspace_id` 維持**（破壊的変更回避）。`workspace_id` / `primary_workspace_id` への users 列リネームは **保留**（REPORT に記載）。

## 実装とのズレ

| 箇所 | 評価 |
|------|------|
| `ReligoActorContext::resolveWorkspaceIdForUser` | **整合** — /1 が `default_workspace_id`。/2・/3 は「未設定時の補完」で SSOT の legacy / システムフォールバックに対応。 |
| `UserController` | **整合** — `mePayload` は同一 resolver。 |
| `BoAssignmentAuditLogWriter` | **整合** — `resolveWorkspaceIdForUser(actor)`。 |
| `Dashboard.jsx` / API | **整合** — workspace をクエリに載せず、me の **所属チャプター**表示のみ（DASHBOARD_DATA_SSOT と一致）。 |
| migration | **変更不要** — nullable は「未設定・移行途上」を許容するが、意味論は所属。 |

## fallback の意味整理

- **legacy 補完（/2）:** 所属未設定や古いデータから **推定**するだけ。運用では /1 を正とする。
- **システムフォールバック（/3）:** 単一チャプターDBで **最後の手段**。

## 多対多を採用しない理由

- BNI 会員ルールと矛盾する。
- 現プロダクトスコープ外。**将来必要なら SSOT から先に改訂**してから実装する。
