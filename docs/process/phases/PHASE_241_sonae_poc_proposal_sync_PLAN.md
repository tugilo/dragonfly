# Phase 241 PLAN — SONAE PoC 提案同期

**作成:** 2026-06-24 12:55 JST  
**Phase Type:** docs  
**Branch:** develop（既存未コミット変更あり。ユーザーから commit / merge 指示なし）  
**Related SSOT:** SPEC-017（SONAE 要件定義）  
**Status:** in_progress

---

## Purpose

最新PDF `docs/proposals/sonae_proposal.pdf` の内容に合わせて、SONAE関連ドキュメントを「20万円開発費」や「共創MVP」ではなく、**DragonFlyをモデルチャプターにしたPoC開発（実証実験）** として整理し直す。

---

## Scope

変更可能範囲:

- `docs/SSOT/SONAE_REQUIREMENTS.md`
- `docs/proposals/sonae_bcp_proposal_iida_kaori.md`
- `docs/proposals/sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md`
- `docs/02_specifications/SSOT_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_241_sonae_poc_proposal_sync_*.md`

変更しない範囲:

- `www/**`
- `infra/**`
- DB dump
- 既存議事録本文

---

## DoD

- 最新PDF `sonae_proposal.pdf` を最新提案書としてINDEXに反映する。
- 関連Markdownから20万円開発費前提を削除し、PoC開発として整理する。
- DragonFlyへの開発費・利用料請求なしを明記する。
- GensparkプロンプトもPoC版スライド生成用に更新する。
- INDEX / progress / Phase Registry を同期する。
- コード変更を行わない。
