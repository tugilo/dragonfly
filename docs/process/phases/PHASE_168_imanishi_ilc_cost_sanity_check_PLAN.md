# PHASE_168_imanishi_ilc_cost_sanity_check PLAN

## Phase Type
docs

## Purpose
今西さん向け AiLC 月次集計表 Web アプリ提案の費用感が安すぎないか確認し、継続運用・例外処理・保守性を含めた安全側のレンジに見直す。

## Background
Phase 167 で Web アプリ前提の費用感を整理したが、ユーザーより「安すぎないかどうか確認」と指示があった。TSV 取込、文字コード、例外データ、PDF/Excel出力、ログイン、履歴、運用保守を考慮すると、前回の費用レンジは一部低めだったため、相談メモを上方修正する。

## Related SSOT
N/A（相談メモ・費用感整理のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・正式見積書作成は行わない。

## Target Files
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_168_imanishi_ilc_cost_sanity_check_PLAN.md
- docs/process/phases/PHASE_168_imanishi_ilc_cost_sanity_check_WORKLOG.md
- docs/process/phases/PHASE_168_imanishi_ilc_cost_sanity_check_REPORT.md

## Implementation Strategy
Web アプリ構築の実務リスクを含め、検証・最小版・レポート生成・管理画面・送信管理の各レンジを上方修正する。ランニング費用も、単なるサーバー代ではなく保守・軽微修正・月次運用見守りを含む前提に改める。

## Tasks
- [x] Web アプリ費用レンジが低すぎないか確認する
- [x] 相談メモの概算費用を安全側に上方修正する
- [x] 今西さんへの返答案の費用感を更新する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- 安すぎる可能性がある点が相談メモに明記されている
- Web アプリの費用レンジが安全側に見直されている
- ランニング費用が過小にならないよう更新されている
- 今西さんへ送れる返答案の金額が更新されている
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 168 が記録されている

