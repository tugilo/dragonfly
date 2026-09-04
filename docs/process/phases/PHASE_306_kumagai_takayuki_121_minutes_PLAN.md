# Phase 306 PLAN — 熊谷貴之 第1回121 Zoom要約反映

**作成:** 2026-09-04 13:58 JST  
**Phase Type:** docs  
**Branch:** `feature/phase305-kumagai-takayuki-121-prep`（Phase 305 未mergeのため同一ブランチ）  
**Related SSOT:** SPEC-012, SPEC-013, SPEC-019, `docs/meetings/1to1/README.md`, `.cursor/rules/1to1-dedup.mdc`

---

## Purpose

熊谷貴之さん（株式会社ENFUSIA）との第1回121 Zoom 文字起こし要約を校正し、既存の 1to1 ドキュメントへ実施後議事録として反映する。既存 Zoom 行 `#152` を更新し、新規行は作らない。

---

## Scope

変更可能範囲は docs と、既存 `one_to_ones.id=152` の notes／status 更新。

- `docs/meetings/1to1/1to1_kumagai_takayuki_enfusia.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_306_kumagai_takayuki_121_minutes_PLAN.md`
- `docs/process/phases/PHASE_306_kumagai_takayuki_121_minutes_WORKLOG.md`
- `docs/process/phases/PHASE_306_kumagai_takayuki_121_minutes_REPORT.md`

---

## DoD

- Zoom 要約を校正し、実施後サマリー・第1回本文・合意・アクション・会後お礼まで書く。
- 年号（2024→2026）、伴奏→伴走、小永→小中、羽賀→芳賀、堀切HP、DragonFly 表記を校正表に残す。
- `one_to_ones.id=152` を completed にし、`import-1to1-notes --only-ids=152` する。新規行なし。
- INDEX / 進捗 / PHASE_REGISTRY を同期する。
- docsフェーズだが、ユーザー指示でテスト・`db-export`・`db-push TARGET=prod` を実施する。

---

## Tasks

1. 要約を校正し、既存 1to1 ファイルを実施後議事録へ更新する。
2. `#152` を completed にし notes を取り込む。
3. INDEX と進捗を同期する。
