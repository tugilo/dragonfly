# PHASE: DASHBOARD-STALE-WORKSPACE-P2 — WORKLOG

## peer 定義

- **採用: 案A** — `members.id != owner` の全員。KPI 分母・`stale_follow` の対象集合がこれ。
- **不採用: 案B** — `members` に workspace / chapter の直接列がなく、peer を「所属チャプター一致」で絞れない。
- **不採用: 案C** — 関与ネットワークのみは定義・実装が重く、本 Phase スコープ外。

## owner / workspace / peer

- **Owner:** Dashboard 集計の軸（`owner_member_id`）。
- **解決済み workspace:** `ReligoActorContext::resolveWorkspaceIdForUser` — **ユーザー**の所属。stale では **未使用**（peer の行ごとの所属と突合できない）。
- **Peer:** 上記案A。将来 **案B** にするなら `members.workspace_id` 等が前提。

## stale に workspace を渡さない理由

- MEMBER-SUMMARY NULL P1 で Query は OR NULL 対応済みでも、**peer が全会員のまま** workspace を渡すと、memos/o2o/flags はチャプター文脈・**同席は全会議**の **last_contact** 説明が不一致になりうる。

## 実装

- `stalePeerMemberIds` のみ（挙動変更なし）。

## merge

- develop へ `--no-ff` merge。競合: **なし**。
