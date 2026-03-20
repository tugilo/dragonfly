# PHASE: MEMBER-SUMMARY-WORKSPACE-NULL-P1 — REPORT

## 1. 実施内容サマリ

`MemberSummaryQuery` の **`getSummaryLiteBatch(..., $workspaceId)`** で、`$workspaceId` が **非 null** のとき `contact_memos` / `one_to_ones` / `dragonfly_contact_flags` に **`(workspace_id = :id OR workspace_id IS NULL)`** を適用する private メソッドを追加し、**DATA_MODEL §5.1** と実装を一致させた。**Dashboard** の stale / KPI は **`getSummaryLiteBatch(..., null)` のまま**（変更なし）。Feature テスト 3 本追加。SSOT・分析書・Fit&Gap を更新。

## 2. 変更ファイル一覧

- `www/app/Queries/Religo/MemberSummaryQuery.php`
- `www/tests/Feature/Queries/MemberSummaryQueryWorkspaceScopeTest.php`
- `docs/SSOT/DATA_MODEL.md`
- `docs/SSOT/DASHBOARD_DATA_SSOT.md`
- `docs/SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md`
- `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`
- `docs/SSOT/WORKSPACE_RESOLUTION_POLICY.md`
- `docs/process/phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`

## 3. NULL 意味整理

- **単一チャプター運用:** `workspace_id IS NULL` は **legacy / 未設定データを現在の所属チャプターに含めてよい**（DATA_MODEL）。**他 workspace の非 NULL 行**は含めない。

## 4. Query 役割整理

- **チャプター文脈付き summary**（`workspaceId` 指定時）と **owner 全体 summary**（`null`）の両方を第 3 引数で切り替え。`null` 時は **workspace 列で絞らない**。

## 5. 実装内容

- `applyWorkspaceScopeForSummary` により 3 テーブルで条件統一。

## 6. テスト結果

- **php artisan test:** **321 passed**（1290 assertions）
- **npm run build:** 成功

## 7. 未解決事項

- **Dashboard stale** に解決済み `workspace_id` を渡すか、**peer をチャプター限定**するかは **別 Phase**（`members.workspace_id` 等のデータモデルと整合が必要）。

## 8. 次 Phase 提案

- **DASHBOARD-STALE-WORKSPACE-P2（仮）:** `ReligoActorContext::resolveWorkspaceIdForUser` と peer 境界の設計が揃ったうえで stale を検討。

## 9. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff` |
| merged branch | `feature/phase-member-summary-workspace-null-p1` |
| merge commit id | （merge 後に記載） |
| feature last commit id | （merge 後に記載） |
| pushed at | （merge 後に記載） |
| test command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` |
| test result | （記載） |
| build | `docker compose ... exec node npm run build` |
| notes | NULL = legacy 行を現在チャプターに含める OR 条件。Dashboard は `null` のまま。 |
