# PHASE_173_imanishi_ilc_proposal_material PLAN

## Phase Type
docs

## Purpose
Phase 165〜172 の検証・費用感・ROI整理をもとに、今西さんへ共有しやすい AiLC 月次集計表作成 自動化提案資料を作成する。

## Background
相談メモ `docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md` には、検証結果・自動化可能性・費用感・ROI・AI駆動開発の価値を蓄積した。今西さんへ提示するには、内部検討ログではなく、結論・根拠・提案プラン・概算・次確認事項・返信案を1ファイルにまとめた提案資料が必要。

## Related SSOT
N/A（提案資料作成のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・正式見積書作成は行わない。

## Target Files
- docs/proposals/ilc_monthly_report_automation_proposal_imanishi.md
- docs/proposals/README.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_173_imanishi_ilc_proposal_material_PLAN.md
- docs/process/phases/PHASE_173_imanishi_ilc_proposal_material_WORKLOG.md
- docs/process/phases/PHASE_173_imanishi_ilc_proposal_material_REPORT.md

## Implementation Strategy
提案資料は相談メモよりも外部共有しやすい構成にする。冒頭で結論を示し、検証で分かったこと、削減効果、費用対効果、提案プラン、推奨ステップ、tugilo の AI駆動開発、確認事項、返信案の順に整理する。

## Tasks
- [x] 今西さん向け提案資料を `docs/proposals/` に作成する
- [x] proposals README / INDEX を更新する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- 今西さんへ共有しやすい提案資料になっている
- 検証結果・削減根拠・ROI・費用感が整理されている
- AI駆動Web MVP を中心とした段階提案になっている
- INDEX と proposals README から辿れる
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 173 が記録されている

