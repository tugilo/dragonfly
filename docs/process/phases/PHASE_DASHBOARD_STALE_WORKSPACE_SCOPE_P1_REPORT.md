# PHASE: DASHBOARD-STALE-WORKSPACE-SCOPE-P1 — REPORT

## 1. 実施内容サマリ

Dashboard の **stale**（`stale_contacts_count`・`stale_follow`）について、`MemberSummaryQuery::getSummaryLiteBatch` の **workspace 第 3 引数**と **DATA_MODEL / 現行スキーマ**を突き合わせ、**現状どおり `null` を渡す（案A）** を SSOT で確定した。**案B**（解決済み workspace で stale をチャプター文脈に寄せる）は、peer 限定と NULL 行扱い・同席スコープの **説明不能な中間状態**になりうるため **今回見送り**。**コード変更なし**。

## 2. 変更ファイル一覧

- `docs/SSOT/DASHBOARD_DATA_SSOT.md`
- `docs/SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md`
- `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`
- `docs/process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`

## 3. stale 定義整理

- **意味:** owner 以外の **全メンバー**を peer としたとき、`getSummaryLiteBatch(..., null)` の **last_contact_at** が 30 日超 / null。  
- **Workspace:** Dashboard stale には **渡さない**（`/api/users/me` の `workspace_id` は表示・他機能の解決済み値）。

## 4. 調査結果（`getSummaryLiteBatch`）

- `workspaceId != null` → memos / o2o / flags 系は **`workspace_id = X` のみ**、NULL 行除外。同席例会日は非フィルタ。  
- Members API（`DragonFlyMemberController`）はクエリで任意 `workspace_id` を渡し得るが、Dashboard は **別経路・本 Phase では変更しない**。

## 5. 実装内容（行った場合）

- **なし**（ドキュメントのみ）。

## 6. テスト結果

- **（merge 後記載）** `php artisan test` / `npm run build`

## 7. 未解決事項

- **`MemberSummaryQuery` が DATA_MODEL の NULL 許容 OR を実装するか**は本 Phase スコープ外。  
- **`members.workspace_id`（または同等）** で peer をチャプターに限定できるようになったら、案B を **別 Phase** で再評価。

## 8. 次 Phase 提案

- **Query 改修:** workspace 指定時 `(workspace_id = :id OR workspace_id IS NULL)`（単一チャプター前提の SSOT 整合）。  
- **データ:** members〜workspace 関連の付与と backfill 方針。  
- **Dashboard:** 上記後に `ReligoActorContext::resolveWorkspaceIdForUser` を stale 専用に渡すかレビュー。

## 9. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff feature/phase-dashboard-stale-workspace-scope-p1` |
| merged branch | `feature/phase-dashboard-stale-workspace-scope-p1` |
| merge commit id | *（要記載）* |
| feature last commit id | *（要記載）* |
| notes | stale=案A維持、`getSummaryLiteBatch(..., null)`、案B見送り理由・再検討条件を SSOT 化 |
