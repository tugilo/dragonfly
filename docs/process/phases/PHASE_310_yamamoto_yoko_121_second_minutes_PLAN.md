# Phase 310 PLAN — 山本葉子 第2回121 Zoom要約反映

**作成:** 2026-09-16 15:38 JST  
**Phase Type:** docs  
**Branch:** `feature/phase309-yamamoto-yoko-121-second-prep`（Phase 309 未mergeのため同一作業ツリー）  
**Related SSOT:** SPEC-012, SPEC-013, SPEC-019, `docs/meetings/1to1/README.md`, `.cursor/rules/1to1-dedup.mdc`, `docs/PROJECT_NAMING.md`

---

## Purpose

山本葉子さんとの第2回121 Zoom 文字起こし要約を校正し、既存 1to1 ファイルへ実施後議事録として反映する。Zoom 取込済み `one_to_ones.id=159` を更新し、新規行は作らない。

---

## Scope

変更可能範囲は docs と、既存 `one_to_ones.id=159` の notes／status 更新。

- `docs/meetings/1to1/1to1_yamamoto_yoko_idemitsu_credit.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_310_yamamoto_yoko_121_second_minutes_PLAN.md`
- `docs/process/phases/PHASE_310_yamamoto_yoko_121_second_minutes_WORKLOG.md`
- `docs/process/phases/PHASE_310_yamamoto_yoko_121_second_minutes_REPORT.md`

---

## DoD

- Zoom 要約を校正し、実施後サマリー・第2回本文・合意・アクション・会後お礼まで書く。
- 氏名・章名の校正表を残す（船津／紀川／原田里織／松倉／山本洸太／木村杏那 等）。
- `one_to_ones.id=159` を completed にし、`import-1to1-notes --only-ids=159` する。新規行なし。
- INDEX / 進捗 / PHASE_REGISTRY を同期する。
- docsフェーズのため Laravel テスト・React ビルド・`db-push` は実行しない。ローカル import 後に `make db-export` する。

---

## Tasks

1. 要約を校正し、既存 1to1 ファイルを実施後議事録へ更新する。
2. `#159` を completed にし notes を取り込む。
3. INDEX と進捗を同期する。
