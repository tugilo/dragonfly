# Phase 316 PLAN — 木村杏那 建設業向け 機能選択の概算見積

**作成:** 2026-10-04 22:01 JST  
**Phase Type:** docs  
**Branch:** 作業ツリー未分離（commit 時に develop から切り直し可）  
**Related SSOT:** SPEC-013, `docs/meetings/1to1/1to1_kimura_anna_andirich_requirements_20260928.md`, `docs/PROJECT_NAMING.md`

---

## Purpose

第4回121の要件から、機能ごとに足し引きできる開発概算を作る。予算300万円と、ネイティブを見送る合意に対して、選択例で過不足が見えるようにする。

---

## Scope

- `docs/proposals/kimura_anna_construction_app_estimate_20261004.md`
- `docs/proposals/kimura_anna_construction_proposal_20261004.md`（22:20 JST 追加）
- `docs/proposals/kimura_anna_construction_proposal_slides_20261004.html` / `.pdf`（22:48 JST 追加）
- `docs/proposals/images/kimura_anna_mock_*_20261004.png`（23:01 JST 追加。スライド 9〜11 ページの画面イメージを PNG 化したもの）
- `docs/meetings/1to1/1to1_kimura_anna_andirich_requirements_20260928.md`
- `docs/meetings/1to1/1to1_kimura_anna_andirich.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_316_kimura_anna_construction_estimate_PLAN.md`
- `docs/process/phases/PHASE_316_kimura_anna_construction_estimate_WORKLOG.md`
- `docs/process/phases/PHASE_316_kimura_anna_construction_estimate_REPORT.md`

---

## DoD

- 機能ごとの税別金額、依存、300万円以内の選択例、30%手数料を乗せた場合の顧客提示を書く。
- ネイティブは機能ではなく1行（G）にする。→ 22:10 JST 以降、通知＋WebViewの入れ物300万円としてWeb合計に足す形へ変更（WORKLOG 参照）。
- 給与の法定計算、みつもろう、電子契約サービスは対象外と書く。
- INDEX と進捗を同期する。
- docsフェーズのため Laravel テスト・React ビルド・`db-push` は実行しない。

---

## Tasks

1. 概算見積を作成する。
2. 要件と第4回アクションから見積へリンクする。
3. INDEX / 進捗 / PHASE_REGISTRY を更新する。
