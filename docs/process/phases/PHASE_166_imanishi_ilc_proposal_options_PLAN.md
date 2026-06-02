# PHASE_166_imanishi_ilc_proposal_options PLAN

## Phase Type
docs

## Purpose
Phase 165 の初期検証結果をもとに、今西さんへ提示できる具体的な対応プランと概算費用を相談メモに追記する。

## Background
今西さんからは、加盟店向け月次集計表を毎月手作業で加工しているため、簡単に処理できないか検証してほしいという相談があった。Phase 165 で TSV の共通列構造、店舗数、Excel / マクロ依存の現状を確認したため、次に「何をすると何ができるか」と費用感を説明できる形に整理する必要がある。

## Related SSOT
N/A（相談メモ・提案方針整理のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・正式見積書作成は行わない。

## Target Files
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_166_imanishi_ilc_proposal_options_PLAN.md
- docs/process/phases/PHASE_166_imanishi_ilc_proposal_options_WORKLOG.md
- docs/process/phases/PHASE_166_imanishi_ilc_proposal_options_REPORT.md

## Implementation Strategy
相談メモの既存「対応案」を、今西さんに提示しやすい具体プランへ拡張する。概算費用は税別・初期構築費のラフ見積として明記し、検証、小規模ツール化、加盟店向けレポート生成、既存 Excel 活用、送信管理までの段階に分ける。

## Tasks
- [x] 具体プランと概算費用を相談メモへ追記する
- [x] 今西さんへの返答案を追記する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- 今西さんへ提示できる複数プランが整理されている
- 各プランで「何をすると何ができるか」が分かる
- 概算費用と前提が明記されている
- 推奨する進め方と返答案が記載されている
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 166 が記録されている

