# Phase 308 PLAN — 竹内駿太 第2回121事前準備（インタビュー協力）

**作成:** 2026-09-14 10:24 JST  
**Phase Type:** docs  
**Branch:** `feature/phase308-takeuchi-shunta-121-second-prep`  
**Related SSOT:** SPEC-012, SPEC-013, SPEC-019, `docs/meetings/1to1/README.md`, `docs/PROJECT_NAMING.md`, `.cursor/rules/1to1-dedup.mdc`

---

## Purpose

BNI DragonFly メンバー・竹内駿太さんとの第2回121（2026-09-14 14:00–15:00 JST）に向けて、ユーザー提供のインタビュー項目を既存1to1ファイルへ追記し、次廣が答え役として話すメモを用意する。

---

## Scope

変更可能範囲は docs のみ。

- `docs/meetings/1to1/1to1_takeuchi_shunta_athlete_insurance.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_308_takeuchi_shunta_121_second_prep_PLAN.md`
- `docs/process/phases/PHASE_308_takeuchi_shunta_121_second_prep_WORKLOG.md`
- `docs/process/phases/PHASE_308_takeuchi_shunta_121_second_prep_REPORT.md`

---

## DoD

- 第2回を **2026-09-14（月）JST 14:00–15:00** として時刻付きで記録する（出典: ユーザー連絡。カレンダー／Zoom 未検出は明記）。
- 竹内さん提示のインタビュー項目に対する、次廣側の口語メモを既存1to1ファイルの【第2回】に置く。
- 次廣は事業継承者ではなく創業・個人事業主であることを冒頭確認事項にする。
- Religo は第1回 `one_to_ones.id=18` / `members.id=26` を正とし、第2回の新規行は prep 時点で作らない。
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md` を同期する。
- docsフェーズのため、Laravelテスト・Reactビルドは実行しない。

---

## Tasks

1. 既存1to1運用・SSOT・Phase番号・カレンダー・DBを確認する。
2. 竹内駿太さんの1to1ファイルに第2回インタビュー協力メモを追記する。
3. INDEX と進捗を同期する。
4. PHASE_REGISTRY と REPORT を更新する。
