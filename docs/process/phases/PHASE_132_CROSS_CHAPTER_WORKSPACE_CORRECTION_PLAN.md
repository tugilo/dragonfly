# Phase 132 PLAN: 他チャプター1to1相手の所属補正

## Phase

- **Phase ID:** 132
- **Name:** 他チャプター1to1相手の所属補正
- **Type:** implement
- **Started at:** 2026-05-21 16:18 JST

## Related SSOT

- **SPEC-006:** `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md` §1.2 / §4.9
- **MEMBERS_WORKSPACE_ASSIGNMENT_POLICY:** `docs/SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md`

## Scope

- **DB操作:** `workspaces`, `members`
- **Docs:** 木村秀継さん・藤本勇輝さんの1to1議事録、Phase 132 docs、`PHASE_REGISTRY.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md`
- **Out of scope:** `one_to_ones.workspace_id` の変更（記録コンテキストは DragonFly のまま）、UI/API実装変更

## DoD

- 木村秀継さんの所属を **BNI SPREAD** として `members.workspace_id` に反映する。
- 藤本勇輝さんの所属を **BNI トレスステラ** として `members.workspace_id` に反映する。
- 1to1議事録・INDEX・進捗・Phase記録を同期する。
- DB照合で対象2名の所属 workspace が更新されていることを確認する。
