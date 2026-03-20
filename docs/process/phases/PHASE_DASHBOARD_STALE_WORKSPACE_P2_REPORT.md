# PHASE: DASHBOARD-STALE-WORKSPACE-P2 — REPORT

## 1. 実施内容サマリ

**stale peer** を **案A（owner 以外の全 members）** と SSOT に明記し、**案B** は `members.workspace_id` 未整備のため **不採用** とした。**`resolveWorkspaceIdForUser()` を stale の `getSummaryLiteBatch` に渡す**ことは **見送り**（peer 境界・同席スコープの説明が割れるため）。`DashboardService::stalePeerMemberIds()` を追加し、KPI・Tasks の peer 取得を単一化（挙動は変更なし）。関連 SSOT・分析書・Fit&Gap・DATA_MODEL Future・WORKSPACE ポリシーを更新。

## 2. 変更ファイル一覧

- `www/app/Services/Religo/DashboardService.php`
- `docs/SSOT/DASHBOARD_DATA_SSOT.md`
- `docs/SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md`
- `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`
- `docs/SSOT/WORKSPACE_RESOLUTION_POLICY.md`
- `docs/SSOT/DATA_MODEL.md` §7
- `docs/process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`

## 3. stale peer 定義整理

| 案 | 内容 | 結論 |
|----|------|------|
| A | 全 members − owner | **採用** |
| B | 同一 workspace の members のみ | **未採用**（スキーマなし） |
| C | 関与ネットワークのみ | **未採用**（重い） |

## 4. 調査結果

- `members` に **`workspace_id` なし**（モデル・マイグレーション確認）。
- `resolveWorkspaceIdForUser` は **User 文脈**の所属解決であり、**各 peer の所属** と **DB 上で比較する列**がない。

## 5. 実装内容

- `stalePeerMemberIds(int $ownerMemberId): array` + `getStats` / `getTasks` から利用。

## 6. テスト結果

- **php artisan test:** 321 passed（1290 assertions）
- **npm run build:** 成功

## 7. 未解決事項

- **`members.workspace_id`（または member↔workspace 正式所属）** が整うまで、stale の workspace 化は **保留**。
- 同席 `last_contact` をチャプターに寄せるかは **別合意**。

## 8. 次 Phase 提案

- **`members.workspace_id` migration + backfill 設計**（別 Phase）。
- その後 **stale peer を案B に変更**し、`getSummaryLiteBatch(..., $resolved)` を検討。

## 9. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff` |
| merged branch | `feature/phase-dashboard-stale-workspace-p2` |
| merge commit id | （記載） |
| feature last commit id | （記載） |
| pushed at | （記載） |
| test result | （記載） |
| notes | peer=案A、`resolveWorkspaceIdForUser` は stale 未使用。 |
