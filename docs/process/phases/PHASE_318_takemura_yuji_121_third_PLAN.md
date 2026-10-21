# Phase 318 PLAN — 竹村裕司 第3回121 Zoom要約反映

**作成:** 2026-10-12 10:53 JST  
**Phase Type:** docs  
**Branch:** 作業ツリー未分離（現在 `feature/phase315-okamoto-sorosoro-concept-prep` 上。commit 時に develop から切り直し可）  
**Related SSOT:** SPEC-012, SPEC-019, `docs/meetings/1to1/README.md`, `.cursor/rules/1to1-dedup.mdc`

---

## Purpose

2026-10-02（金）JST 19:00–20:00 の竹村裕司さんとの第3回121について、ユーザー提供の Zoom 文字起こし要約を校正し、既存の1相手1ファイルへ実施記録として残す。

---

## Scope

- `docs/meetings/1to1/1to1_takemura_yuji_onode.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_318_takemura_yuji_121_third_{PLAN,WORKLOG,REPORT}.md`
- ローカル `one_to_ones` に第3回の completed 行を1件追加し、当該セクションの notes を取り込む

提案書（2026-08-25 の AWS 概算）は金額を変えない。本番 DB へは出さない。

---

## DoD

- 要約を校正し、第3回本文・合意・保留・アクション・会後お礼（未送信）まで書く。
- Zoom 取込に同日・同相手の行が無いことを確認したうえで、新規 `one_to_ones` を1行だけ作る。
- `import-1to1-notes --only-ids=` で第3回の notes だけ更新する。第1回・第2回の notes は上書きしない。
- INDEX / 進捗 / PHASE_REGISTRY を同期する。

---

## Tasks

1. 同日重複が無いことを確認し、manual completed 行を作る。
2. 校正した第3回を既存ファイルへ追記する。
3. 当該 id の notes だけ取り込む。
