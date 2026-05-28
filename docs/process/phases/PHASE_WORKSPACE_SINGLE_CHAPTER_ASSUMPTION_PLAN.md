# PLAN: WORKSPACE-SINGLE-CHAPTER-ASSUMPTION（BNI 1 user = 1 workspace の SSOT 固定）

| 項目 | 内容 |
|------|------|
| Phase ID | WORKSPACE-SINGLE-CHAPTER-ASSUMPTION |
| 種別 | docs（＋コードは docblock のみ） |
| Related SSOT | `DATA_MODEL.md`、`WORKSPACE_RESOLUTION_POLICY.md`、`USER_ME_AND_ACTOR_RESOLUTION.md`、`BO_AUDIT_LOG_DESIGN.md`、`DASHBOARD_DATA_SSOT.md` |
| ブランチ | `develop` 直コミット可（SSOT・軽微コメントのみ） |

---

## 1. 目的

- BNI 前提（**1 ユーザーは 1 チャプターのみ**）を SSOT に明文化する。
- **チャプター ≒ workspace** と **1 user = 1 workspace（原則）** を DATA_MODEL に固定する。
- `users.default_workspace_id` を **「デフォルト」ではなく所属 workspace** と再定義（カラム名は変更しない）。
- **user ⇄ workspace 多対多**は **スコープ外**と明記する。
- 実装の大変更は行わず、[WORKSPACE_RESOLUTION_POLICY.md](../../SSOT/WORKSPACE_RESOLUTION_POLICY.md) で解決順を **所属 / legacy 補完 / システムフォールバック**と意味づけする。

---

## 2. DoD

- [x] 上記 SSOT に追記・整合。
- [x] ReligoActorContext / UserController / BoAssignmentAuditLogWriter の docblock を SSOT と矛盾しないよう更新。
- [x] フィット＆ギャップを WORKLOG、サマリを REPORT に記載。
- [x] `PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` 更新。

---

## 3. 対象外企画

- `users` テーブルのリネーム（`primary_workspace_id` 等）・多対多中間テーブル。
