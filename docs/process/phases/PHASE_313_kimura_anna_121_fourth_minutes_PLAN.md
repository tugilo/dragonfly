# Phase 313 PLAN — 木村杏那 第4回121 Zoom要約反映

**作成:** 2026-09-28 09:46 JST  
**Phase Type:** docs  
**Branch:** `feature/phase308-takeuchi-shunta-121-second-prep`（作業ツリー未分離。commit 時に develop から切り直し可）  
**Related SSOT:** SPEC-012, SPEC-013, SPEC-019, `docs/meetings/1to1/README.md`, `.cursor/rules/1to1-dedup.mdc`, `docs/PROJECT_NAMING.md`

---

## Purpose

木村杏那さんとの第4回121（2026-09-28 JST 09:00–09:45・**Google Meet**）の文字起こし要約を校正し、既存 1to1 ファイルへ実施後議事録として反映する。`one_to_ones` の同日行はないため新規行は作らず、Markdown のみを正とする。

---

## Scope

変更可能範囲は docs のみ。`one_to_ones` の INSERT はしない。

- `docs/meetings/1to1/1to1_kimura_anna_andirich.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_313_kimura_anna_121_fourth_minutes_PLAN.md`
- `docs/process/phases/PHASE_313_kimura_anna_121_fourth_minutes_WORKLOG.md`
- `docs/process/phases/PHASE_313_kimura_anna_121_fourth_minutes_REPORT.md`

---

## DoD

- Zoom 要約を校正し、実施後サマリー・第4回本文・合意・アクション・会後お礼まで書く。
- 校正表を残す（Webアプリ、Excel、ANDPAD、300万円は制約、定例会リハーサルの対象日は未確定）。
- `members.id=149` を正とし、`one_to_ones` 新規行なし。import は id 未採番のためスキップ。
- INDEX / 進捗 / PHASE_REGISTRY を同期する。
- docsフェーズのため Laravel テスト・React ビルド・`db-push` は実行しない。

---

## Tasks

1. 要約を校正し、既存 1to1 ファイルへ第4回を追記する。
2. INDEX と進捗を同期する。
3. PHASE_REGISTRY と REPORT を更新する。
