# PLAN: BO-AUDIT-P3（/api/users/me と BO actor 一本化）

| 項目 | 内容 |
|------|------|
| Phase ID | BO-AUDIT-P3 |
| 種別 | implement |
| Related SSOT | `USER_ME_AND_ACTOR_RESOLUTION.md`、`BO_AUDIT_LOG_DESIGN.md`、`DATA_MODEL.md`、`DASHBOARD_DATA_SSOT.md` |
| ブランチ | `feature/phase-bo-audit-p3` |

---

## 1. 目的

- `/api/users/me` の **user id 1 固定を廃止**し、`auth`＋**限定的フォールバック**に統一。
- **BO 監査の actor** を同一基準にする（**案B:** `ReligoActorContext` 共通 resolver）。
- **workspace_id:** owner 文脈で flags → 1to1 → memos → **先頭 workspace**（先頭のみの P2 から改善）。
- **chapter:** 運用上 **1 workspace ≒ 1 チャプター（DragonFly）** を SSOT 明文化。

---

## 2. DoD

- [x] `UserController` が `ReligoActorContext::actingUser()` を使用。
- [x] GET/PATCH `/api/users/me` に `workspace_id`（推定・nullable）を追加。
- [x] `BoAssignmentAuditLogWriter` が同一 resolver で workspace を決定。
- [x] テスト・build・merge・Evidence・push。

---

## 3. 対象外

認証全面再設計、RBAC、Dashboard UI 大改修、BO 以外の監査全面改修。
