# Phase 133 PLAN: 辻亮さん所属チャプター補正

## Phase

- **Phase ID:** 133
- **Name:** 辻亮さん所属チャプター補正
- **Type:** implement
- **Started at:** 2026-05-21 17:09 JST

## Related SSOT

- **SPEC-006:** `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md` §1.2 / §4.9
- **MEMBERS_WORKSPACE_ASSIGNMENT_POLICY:** `docs/SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md`

## Scope

- **DB操作:** `members`
- **Docs:** 辻亮さんの1to1議事録、Phase 133 docs、`PHASE_REGISTRY.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`
- **Out of scope:** `one_to_ones.workspace_id` の変更（記録コンテキストは DragonFly のまま）、UI/API実装変更

## DoD

- 辻亮さんの所属を **BNI TRES STELLAS（トレスステラ）** として `members.workspace_id` に反映する。
- 1to1議事録・INDEX・進捗・Phase記録を同期する。
- DB照合で対象1件の `is_cross_chapter = true` を確認する。
