# PHASE_175_ailc_naming_correction PLAN

## Phase Type
docs

## Purpose
今西さん向け提案資料・相談メモ・索引・Phase記録における表示名を、`ILC` から正しい表記 `AiLC` に修正する。

## Background
ユーザーより「ILCではなくAiLCです」と指摘があった。提案資料・Gensparkプロンプト・相談メモ・INDEX・progress・PHASE_REGISTRY に人間向け表示名として `ILC` が残っていたため、表示名を `AiLC` に統一する必要がある。

## Related SSOT
N/A（名称表記修正のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更は行わない。既存の `docs/consultations/ILC/` パスはリンク切れ防止のため維持する。

## Target Files
- docs/proposals/ilc_monthly_report_automation_proposal_imanishi.md
- docs/proposals/ilc_monthly_report_automation_genspark_slide_prompt.md
- docs/proposals/README.md
- docs/consultations/ILC/README.md
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_*_imanishi_ilc_*.md
- docs/process/phases/PHASE_175_ailc_naming_correction_PLAN.md
- docs/process/phases/PHASE_175_ailc_naming_correction_WORKLOG.md
- docs/process/phases/PHASE_175_ailc_naming_correction_REPORT.md

## Implementation Strategy
表示名・見出し・説明文・Phase名の `ILC` を `AiLC` に置換する。ファイル名や既存フォルダ名に含まれる `ilc` / `ILC` は、既存リンク・配置維持のため変更しない。

## Tasks
- [x] 提案資料・Gensparkプロンプトの表示名を `AiLC` に修正する
- [x] INDEX / progress / PHASE_REGISTRY の表示名を修正する
- [x] 相談メモ・Phase文書の表示名を修正する
- [x] リンク用パスが壊れていないことを確認する
- [x] WORKLOG / REPORT を作成する
- [ ] 差分を確認する

## DoD
- 人間向け表示名が `AiLC` になっている
- 提案資料とGensparkプロンプトに `ILC` 表記が残っていない
- 既存リンクパス `consultations/ILC/` は維持されている
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 175 が記録されている

