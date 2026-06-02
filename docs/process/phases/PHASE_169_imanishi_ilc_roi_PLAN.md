# PHASE_169_imanishi_ilc_roi PLAN

## Phase Type
docs

## Purpose
今西さん向け AiLC 月次集計表 Web アプリ提案に、経営者目線の費用対効果・作業削減予測・投資回収期間を追記する。

## Background
Phase 168 で Web アプリ費用感を安全側に見直したが、ユーザーより「経営者目線でいうと費用対効果が一番重要。手間がどれぐらい削減できるかの予測、ROIを説明しないと金額だけでは納得できない」と指摘があった。提案判断には、初期費用だけでなく、月次作業削減・属人化低減・回収期間を説明する必要がある。

## Related SSOT
N/A（相談メモ・ROI整理のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・正式見積書作成は行わない。

## Target Files
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_169_imanishi_ilc_roi_PLAN.md
- docs/process/phases/PHASE_169_imanishi_ilc_roi_WORKLOG.md
- docs/process/phases/PHASE_169_imanishi_ilc_roi_REPORT.md

## Implementation Strategy
現時点では実作業時間が未確認のため、20/40/60/80時間の仮説レンジで削減時間と月次削減額を示す。プラン別の投資回収期間を月次削減額 10/20/30万円のケースで整理し、今西さんへ確認すべき ROI 前提も明記する。

## Tasks
- [x] 月次作業削減予測を相談メモに追記する
- [x] プラン別の投資回収目安を追記する
- [x] ROI から見た推奨条件を追記する
- [x] 今西さんへの返答案に ROI 説明を追記する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- 金額だけでなく費用対効果の説明がある
- 月次作業時間削減の仮説レンジがある
- 投資回収期間の目安がある
- 今西さんに確認すべき ROI 前提が明記されている
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 169 が記録されている

