# Phase 312 PLAN — 栗林千代子 第1回121 Zoom要約反映

**作成:** 2026-09-17 16:24 JST  
**Phase Type:** docs  
**Branch:** `feature/phase311-kuribayashi-chiyoko-121-prep`（Phase 311 未mergeのため同一作業ツリー。commit 時に develop から切り直し可）  
**Related SSOT:** SPEC-012, SPEC-013, SPEC-019, `docs/meetings/1to1/README.md`, `.cursor/rules/1to1-dedup.mdc`, `docs/PROJECT_NAMING.md`

---

## Purpose

栗林千代子さんとの第1回121 Zoom 文字起こし要約を校正し、既存 1to1 ファイルへ実施後議事録として反映する。`one_to_ones` 行は未作成のため新規行は作らず、Markdown のみを正とする。

---

## Scope

変更可能範囲は docs のみ。`one_to_ones` の INSERT はしない。

- `docs/meetings/1to1/1to1_kuribayashi_chiyoko_web_design.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_312_kuribayashi_chiyoko_121_minutes_PLAN.md`
- `docs/process/phases/PHASE_312_kuribayashi_chiyoko_121_minutes_WORKLOG.md`
- `docs/process/phases/PHASE_312_kuribayashi_chiyoko_121_minutes_REPORT.md`

---

## DoD

- Zoom 要約を校正し、実施後サマリー・第1回本文・合意・アクション・会後お礼まで書く。
- 校正表を残す（DragonFly／1to1／米澤／ファボローネ／木村杏那／ビジターでありメンバーではない、等）。
- `members.id=346` を正とし、`one_to_ones` 新規行なし。import は id 未採番のためスキップ。
- INDEX / 進捗 / PHASE_REGISTRY を同期する。
- docsフェーズのため Laravel テスト・React ビルド・`db-push` は実行しない。

---

## Tasks

1. 要約を校正し、既存 1to1 ファイルを実施後議事録へ更新する。
2. INDEX と進捗を同期する。
3. PHASE_REGISTRY と REPORT を更新する。
