# Phase 225 PLAN — SONAE 飯田香さん向け提案書

**作成:** 2026-06-18 18:09 JST  
**Phase Type:** docs  
**Branch:** develop（既存未コミット変更あり。ユーザーから commit / merge 指示なし）  
**Related SSOT:** SPEC-017（SONAE 要件定義）  
**Status:** in_progress

---

## Purpose

`docs/SSOT/SONAE_REQUIREMENTS.md` をもとに、DragonFly BCP担当の飯田香さんへ共有しやすい **誰にでもわかる提案書** を作成する。

技術詳細よりも、BCP担当・役員・メンバーが理解しやすい言葉で、SONAE の目的、導入効果、20万円 MVP の範囲、導入後の訓練イメージを伝える。

---

## Scope

変更可能範囲:

- `docs/proposals/sonae_bcp_proposal_iida_kaori.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_225_sonae_iida_kaori_proposal_*.md`

参照:

- `docs/SSOT/SONAE_REQUIREMENTS.md`
- `docs/meetings/1to1/1to1_iida_kaori_libero.md`

変更しない範囲:

- `www/**`
- `infra/**`
- DB dump
- 既存議事録本文

---

## DoD

- 飯田香さん向けの提案書 Markdown が `docs/proposals/` に作成されている。
- SONAE の価値が非エンジニアにも分かる表現になっている。
- DragonFly 向け 20万円 MVP の範囲と含めない範囲が明記されている。
- BCP担当・役員が次に何を決めればよいかが分かる。
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` が同期されている。
- コード変更を行わない。

---

## Tasks

1. SONAE 要件定義と飯田香さんの 1to1 文脈を確認する。
2. 飯田香さん向け提案書を作成する。
3. INDEX / progress / Phase Registry を同期する。
4. WORKLOG / REPORT を作成する。
