# Phase 126 REPORT: SPEC-010 ユーザーログインと Owner 紐づけ（要件確定）

## Phase

- **Phase ID:** 126
- **Name:** SPEC-010 ログインと Owner 紐づけ要件の Registry / DATA_MODEL 同期
- **Type:** docs
- **Completed at:** 2026-05-18 10:09 JST
- **Status:** completed（ローカル文書のみ・merge は運用側で実施）

## Summary

SPEC-010（`AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md`）を **`active`** とし、`SSOT_REGISTRY`・`DATA_MODEL`（owner 定義への参照）・`REFERRAL_RECORDING`（§7 補足）・Phase 一覧（`INDEX` / `PHASE_REGISTRY`）を同期した。認証実装 Phase は別立てとする。

## Related SSOT

- SPEC-010（本 Phase の主対象）
- SPEC-003 `ADMIN_GLOBAL_OWNER_SELECTION.md`

## Deliverables

- `docs/SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md` — 状態 **active**
- `docs/02_specifications/SSOT_REGISTRY.md` — SPEC-010 **active**
- `docs/SSOT/DATA_MODEL.md` — SPEC-010 参照 1 行
- `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md`（§7 に SPEC-010 参照）
- `docs/process/phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_*`
- `docs/process/PHASE_REGISTRY.md` / `docs/INDEX.md` / `docs/dragonfly_progress.md`

## テスト

- **docs Phase のためテスト対象なし**（`php artisan test` スキップ）。

## Merge Evidence（docs）

| 項目 | 値 |
|------|-----|
| merge commit id | **N/A**（docs のみ・リポジトリ merge は人間運用で実施） |
| source branch | **N/A** または feature/phase126-auth-spec010-owner-binding（任意） |
| target branch | develop（推奨） |
| test command | スキップ |
| scope check | OK（docs/** のみ） |
| ssot check | OK（SPEC-010 active 化） |

## changed files（想定・`git diff --name-only` 相当）

```
docs/02_specifications/SSOT_REGISTRY.md
docs/INDEX.md
docs/SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md
docs/SSOT/DATA_MODEL.md
docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_PLAN.md
docs/process/phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_WORKLOG.md
docs/process/phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_REPORT.md
```
