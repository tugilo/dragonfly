# PHASE_172_imanishi_ilc_automation_reduction_basis PLAN

## Phase Type
docs

## Purpose
今西さん向け AiLC 自動化提案について、削減時間の根拠を明記し、TSV取得後の加工〜集計表作成に絞ればより大きく削減できる前提へ見直す。

## Background
ユーザーより「自動化がそこまで時間がかかりますか？」「根拠が欲しい。もっと削減できるはず」と指摘があった。既存の ROI 表は削減率が保守的で、TSV取得後の定型加工部分と、CMSからのTSV取得・送信確認まで含む月次運用全体が混ざっていた。手元データでは 51 TSV・約7.6万行が確認でき、列構造も共通のため、加工〜集計部分は 80〜95% 削減を見込めるように整理する。

## Related SSOT
N/A（相談メモ・ROI整理のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・正式見積書作成は行わない。

## Target Files
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_172_imanishi_ilc_automation_reduction_basis_PLAN.md
- docs/process/phases/PHASE_172_imanishi_ilc_automation_reduction_basis_WORKLOG.md
- docs/process/phases/PHASE_172_imanishi_ilc_automation_reduction_basis_REPORT.md

## Implementation Strategy
TSV数・行数・列構造・手順PDFの反復作業を根拠として追記する。ROI表は「TSV取得後の加工〜集計表作成」と「TSV取得・送付確認まで含めた月次運用全体」に分け、前者は 80〜95% 削減、後者は 60〜85% 削減のレンジにする。

## Tasks
- [x] TSV数・行数・列構造を根拠として追記する
- [x] 削減予測を加工部分と月次運用全体に分ける
- [x] ROI表と返答案を削減率高めの前提に更新する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- 削減予測に根拠がある
- 自動化対象の範囲が明確になっている
- TSV取得後の加工部分は大きく削減できる前提になっている
- 今西さんへの返答案に根拠と削減見込みが含まれている
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 172 が記録されている

