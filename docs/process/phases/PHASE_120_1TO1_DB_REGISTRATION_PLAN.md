# Phase 120 PLAN: 1to1議事録のDB登録

## Phase

- **Phase ID:** 120
- **Name:** 1to1議事録のDB登録
- **Type:** implement
- **Started at:** 2026-05-17 22:24 JST

## Related SSOT

- **SPEC-006:** `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md` §1.2 / §4.9

## Scope

- **DB操作:** `members`, `one_to_ones`
- **Docs:** `docs/process/phases/PHASE_120_1TO1_DB_REGISTRATION_*`, `docs/process/PHASE_REGISTRY.md`, `docs/dragonfly_progress.md`, `docs/INDEX.md`
- **Out of scope:** UI/API実装変更、未実施の1to1予定の議事録化、既存登録済み1to1の二重登録

## DoD

- 作成済み1to1議事録のうち、実施済みと判断できるものを `one_to_ones` に登録する。
- 既存登録済みの1to1は重複登録しない。
- `members` に相手が存在しない場合は、最小の `visitor` レコードを作成してから1to1を登録する。
- 登録後に件数・対象者・重複スキップを確認する。
- WORKLOG / REPORT / PHASE_REGISTRY / 進捗を更新する。

## 対象判定

- 対象: 文書内で第1回が実施済みと確認できる1to1議事録。
- スキップ: 既存 `one_to_ones` に同一 owner / target / scheduled_at または同一 source 文書メモがあるもの。
- 保留: 事前台本・予定のみで、実施済み議事録になっていないもの。
