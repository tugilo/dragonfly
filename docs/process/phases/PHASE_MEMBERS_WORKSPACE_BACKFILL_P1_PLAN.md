# PHASE: MEMBERS-WORKSPACE-BACKFILL-P1 — PLAN

## 種別

implement（migration + backfill サービス + SSOT）

## Related SSOT

- `docs/SSOT/DATA_MODEL.md` §5.1
- `docs/SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md`（新規）

## 目的

`members.workspace_id`（nullable FK）を追加し、**説明可能な順**で初期 backfill する。Dashboard stale の案Bは **別 Phase**（本 Phase は土台のみ）。

## 採用案

- **列の意味:** 所属チャプター（workspace）。`users.default_workspace_id` と owner member で整合（backfill 優先）。
- **Backfill:** User 紐づき → owner アーティファクト（flags→o2o→memos）→ **workspaces が 1 件のみ**のときだけ残りをその id で埋める。

## DoD

- [x] migration + `MemberWorkspaceBackfillService`
- [x] `Member` model 更新
- [x] SSOT・INDEX・関連 Dashboard 文書更新
- [x] テスト / build / develop merge / Evidence
