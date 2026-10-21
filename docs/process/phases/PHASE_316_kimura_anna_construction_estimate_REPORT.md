# Phase 316 REPORT — 木村杏那 建設業向け 機能選択の概算見積

**完了日:** 2026-10-04 22:01 JST（金額改定 22:33 JST）  
**Phase Type:** docs  
**Status:** in_progress（develop merge 未実施）

---

## 実施内容

- [`docs/proposals/kimura_anna_construction_app_estimate_20261004.md`](../../proposals/kimura_anna_construction_app_estimate_20261004.md) を作成し、経営者向けの [`kimura_anna_construction_proposal_20261004.md`](../../proposals/kimura_anna_construction_proposal_20261004.md) を追加した。
- 作る前に要件定義・設計50万円。土台100万円（当初56万円を市場比較で改定）。本体とオプションは機能ごとに足す。おすすめの初期は例2の304万円（日報・給与・予定表）。現場の記録まで含める例3は352万円。
- LINE級の現場トークは48万円の「現場の記録」と分け、下限300万円（5L）。ストア用アプリは機能行ではなく、通知＋WebViewの入れ物300万円を選んだWeb合計に足す。
- 第1回の手数料30%は未適用で、乗せた場合の顧客提示だけ別表にした。
- 杏那さん向けのプレゼン用スライド（HTML 21枚）を作成し、Chrome headless で PDF を生成した。「30%の手数料」の定義ページと、画面イメージ 3 ページ（職人スマホ: 日報・予定/工事情報、事務所 PC: 給与集計・利用者登録）を含む。画面イメージは CSS で描き、PNG 化して提案書 §4.1 にも埋め込んだ。

---

## 変更ファイル一覧

- `docs/proposals/kimura_anna_construction_app_estimate_20261004.md`
- `docs/proposals/kimura_anna_construction_proposal_20261004.md`
- `docs/proposals/kimura_anna_construction_proposal_slides_20261004.html`
- `docs/proposals/kimura_anna_construction_proposal_slides_20261004.pdf`
- `docs/proposals/images/kimura_anna_mock_worker_report_20261004.png`
- `docs/proposals/images/kimura_anna_mock_worker_schedule_20261004.png`
- `docs/proposals/images/kimura_anna_mock_office_pc_20261004.png`
- `docs/meetings/1to1/1to1_kimura_anna_andirich_requirements_20260928.md`
- `docs/meetings/1to1/1to1_kimura_anna_andirich.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_316_kimura_anna_construction_estimate_PLAN.md`
- `docs/process/phases/PHASE_316_kimura_anna_construction_estimate_WORKLOG.md`
- `docs/process/phases/PHASE_316_kimura_anna_construction_estimate_REPORT.md`

---

## テスト結果

docs フェーズのため `php artisan test` はスキップ。

---

## DoD チェック

- [x] 機能ごとの税別、依存、選択例、30%を乗せた顧客提示
- [x] ネイティブは機能行にせず、通知＋WebViewの入れ物300万円として分離（PLAN の「G 1行」から変更。理由は WORKLOG）
- [x] 要件定義・設計を土台の前に置き、土台は市場比較で100万円
- [x] 法定給与・みつもろう・電子契約は対象外
- [x] INDEX / 進捗 / PHASE_REGISTRY
- [x] テスト・ビルド・db-push なし

---

## Merge Evidence

merge commit id: TODO（develop 取り込み後）  
source branch: TODO  
target branch: develop  
phase id: 316  
phase type: docs  
related ssot: SPEC-013

test command: スキップ（docsフェーズ）  
test result: スキップ

changed files: 上記一覧

scope check: OK  
ssot check: OK  
dod check: OK
