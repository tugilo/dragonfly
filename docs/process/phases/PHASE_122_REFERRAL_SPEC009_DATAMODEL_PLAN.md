# Phase 122 PLAN: SPEC-009 製品既定確定 + DATA_MODEL 反映（リファーラル）

## Phase

- **Phase ID:** 122
- **Name:** SPEC-009 製品既定確定と DATA_MODEL 反映（外部／内部リファーラル）
- **Type:** docs
- **Started at:** 2026-05-18 07:25 JST

## Related SSOT

- **SPEC-009:** `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md`
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md`
- **Registry:** `docs/02_specifications/SSOT_REGISTRY.md`（SPEC-009 状態）

## Scope（変更可）

- `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md`（§9 製品既定への置換・状態 active）
- `docs/SSOT/DATA_MODEL.md`（`introductions.referral_kind`、`internal_referrals` §4.14、Overview / Entities / §8 整合）
- `docs/process/phases/PHASE_122_REFERRAL_SPEC009_DATAMODEL_*.md`（本 Phase 記録）
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`（Phase 122 行の追加）
- `docs/dragonfly_progress.md`

## Out of scope

- Laravel マイグレーション・API・UI 実装（別 Phase）
- `DashboardService` / KPI の `introductions` 連動変更
- package.json / composer.json の変更

## DoD

- §9 の 4 問に対し、SSOT 上で **製品既定** が文章化されている。
- `DATA_MODEL.md` に **内部リファーラル表 `internal_referrals` の論理定義** と **`introductions.referral_kind`** が記載されている。
- SPEC-009 が Registry 上 **active** 相当（draft 解除）になっている。
- PLAN / WORKLOG / REPORT が揃い、`PHASE_REGISTRY` に 122 が登録されている。

## モック比較

- 本 Phase は SSOT・DATA_MODEL のみのため **対象外**。
