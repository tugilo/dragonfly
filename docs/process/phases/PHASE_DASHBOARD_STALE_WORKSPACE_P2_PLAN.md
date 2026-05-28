# PHASE: DASHBOARD-STALE-WORKSPACE-P2 — PLAN

## 種別

implement（SSOT + `DashboardService` 最小リファクタ）

## Related SSOT

- `docs/SSOT/DASHBOARD_DATA_SSOT.md`
- `docs/SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md`
- `docs/SSOT/WORKSPACE_RESOLUTION_POLICY.md`
- `docs/SSOT/DATA_MODEL.md` §7

## 目的

Dashboard **stale** の **peer 境界**と **`resolveWorkspaceIdForUser` を stale に渡す可否**を整理し、SSOT・実装の意味を揃える。

## 採用案

- **stale peer:** **案A**（owner 以外の全 `members`）— 現行実装と一致。
- **案B**（同一 workspace のみ）: **未採用** — `members.workspace_id` なし。
- **`getSummaryLiteBatch(..., null)`:** **維持** — peer が workspace 化されていないため、解決済み workspace を渡すと説明が割れる。

## 最小実装

- `DashboardService::stalePeerMemberIds()` で peer 取得を単一化し、docblock で SSOT 参照。

## DoD

- [x] SSOT に peer 定義・見送り理由
- [x] `stalePeerMemberIds` 追加
- [x] test / build 通過
- [x] develop merge + Merge Evidence + push
