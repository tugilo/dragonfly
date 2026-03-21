# PHASE: MEMBERS-WORKSPACE-BACKFILL-P1 — REPORT

## 1. 実施内容サマリ

`members.workspace_id`（nullable FK → `workspaces`）を追加し、migration 内で `MemberWorkspaceBackfillService` により初期 backfill を実行した。`Member` に `workspace()` を追加。SSOT `MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md` 新設。DATA_MODEL・Dashboard 関連・WORKSPACE ポリシーを更新。**Dashboard stale の peer 絞り込みは未実施**（案A 維持）。

## 2. 変更ファイル一覧

- `www/database/migrations/2026_03_20_150000_add_workspace_id_to_members_table.php`
- `www/app/Services/Religo/MemberWorkspaceBackfillService.php`
- `www/app/Models/Member.php`
- `www/tests/Feature/Religo/MemberWorkspaceBackfillServiceTest.php`
- `docs/SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md`
- `docs/SSOT/DATA_MODEL.md`, `WORKSPACE_RESOLUTION_POLICY.md`, `DASHBOARD_DATA_SSOT.md`, `DASHBOARD_TASK_SOURCE_ANALYSIS.md`, `DASHBOARD_FIT_AND_GAP.md`
- `docs/process/phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`

## 3. members.workspace_id 設計判断

- **導入:** 採用（案A — 単一列で所属チャプターを表す）。
- **users との関係:** owner member は `default_workspace_id` を最優先でコピー。

## 4. backfill 方針

- 上記サービス 3 段階。複数 workspace では曖昧な一括埋めをしない。

## 5. 実装内容

- migration + service + Feature テスト 4 本。

## 6. テスト結果

- **php artisan test:** 325 passed（1296 assertions）
- **npm run build:** 成功

## 7. 未解決事項

- **PATCH me** 時の owner member `workspace_id` 自動同期は未実装。
- **Dashboard stale 案B** は `stalePeerMemberIds` + `getSummaryLiteBatch` の設計変更が別 Phase。

## 8. 次 Phase 提案

- **DASHBOARD-STALE-WORKSPACE-P3（仮）:** peer を `members.workspace_id` で絞り、解決済み workspace を stale に渡す可否を実装・SSOT 更新。

## 9. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff` |
| merged branch | `feature/phase-members-workspace-backfill-p1` |
| merge commit id | （記載） |
| feature last commit id | （記載） |
| pushed at | （記載） |
| test result | （記載） |
| notes | 列追加 + backfill。stale 未変更。 |
