# PHASE: MEMBERS-WORKSPACE-BACKFILL-P1 — WORKLOG

## members.workspace_id の意味

- **所属チャプター**（BNI 1 member = 1 workspace）。`users.default_workspace_id` と **owner の member** では一致させることを backfill で優先。

## backfill 順序

1. `users.owner_member_id` + `default_workspace_id`
2. ReligoActorContext と同順の owner アーティファクト
3. `workspaces` が 1 件のときのみ残り null をその id に（複数 workspace ではスキップ）

## null

- 根拠が無い行は null のまま（複数 workspace 環境では単一フォールバックしない）。

## migration

- `2026_03_20_150000_add_workspace_id_to_members_table.php` が列追加後に `MemberWorkspaceBackfillService::run()` を実行。

## stale 案B

- 列により **peer を `workspace_id` で絞る条件はデータ上可能**になったが、**DashboardService は未変更**（案A のまま）。同席 last_contact の扱いは次 Phase。

## merge

- develop へ `--no-ff` merge。競合: **なし**。
