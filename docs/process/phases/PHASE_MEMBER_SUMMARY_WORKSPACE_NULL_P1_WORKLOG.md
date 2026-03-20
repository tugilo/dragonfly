# PHASE: MEMBER-SUMMARY-WORKSPACE-NULL-P1 — WORKLOG

## NULL の定義（採用）

- **DATA_MODEL §5.1 どおり:** 単一チャプター運用では `workspace_id IS NULL` は **legacy / 未 backfill の「デフォルト workspace」相当** とし、解決済み `:id` と **OR** で同一スコープに含める。

## Query 方針

- **厳密一致から変更:** 第 3 引数が非 null のとき、`contact_memos` / `one_to_ones` / `dragonfly_contact_flags` すべて `whereNull('workspace_id')->orWhere('workspace_id', $id)`。
- **未指定（null）:** 従来どおり workspace 列はフィルタに使わない（Dashboard stale 等）。

## MemberSummaryQuery の役割整理

- **owner→target** の summary-lite バッチ取得。`workspaceId` は **「そのチャプター文脈で見るときのスコープ」**（Members API の `workspace_id` クエリ）。**同席由来の last_contact** は引き続き workspace 非スコープ（`batchSameRoomCount` / 同席 meeting 日付は変更なし）。

## 利用箇所への影響

- **DragonFlyMemberController:** `workspace_id` 指定時、NULL 行のメモ・o2o・flags が **summary に含まれる**ようになる（意図どおり）。
- **DashboardService:** `null` のまま → **変更なし**。

## Dashboard stale 再導入への足場

- **条件 1（Query OR 化）** は **満たした**。peer 限定・Dashboard から解決済み workspace を渡すかは **未着手**（別 Phase）。

## merge

- develop への `--no-ff` merge 後に REPORT §9 を更新。競合: （merge 後に記載）
