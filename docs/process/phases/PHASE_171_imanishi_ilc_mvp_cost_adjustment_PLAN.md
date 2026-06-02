# PHASE_171_imanishi_ilc_mvp_cost_adjustment PLAN

## Phase Type
docs

## Purpose
今西さん向け AiLC Webアプリ提案の費用感が高く見えすぎないよう、AI駆動開発による MVP 段階提案を前面に出して調整する。

## Background
ユーザーより「高いかな」と指摘があった。Phase 168 では安全側に費用を上げたが、初回提案としては心理的ハードルが高くなりすぎる。tugilo の AI駆動開発では、ログイン・送信管理・高度な履歴を初期スコープから外した MVP を短期間で作り、ROI を確認しながら拡張する提案が現実的。

## Related SSOT
N/A（相談メモ・提案方針整理のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・正式見積書作成は行わない。

## Target Files
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_171_imanishi_ilc_mvp_cost_adjustment_PLAN.md
- docs/process/phases/PHASE_171_imanishi_ilc_mvp_cost_adjustment_WORKLOG.md
- docs/process/phases/PHASE_171_imanishi_ilc_mvp_cost_adjustment_REPORT.md

## Implementation Strategy
フル機能の価格帯は将来拡張として残しつつ、初回提案は `AI検証プラン` → `AI駆動Web MVP` → `AI駆動レポート生成版` の3段階を中心にする。MVP はログイン・送信管理・高度な履歴管理を外し、80〜90万円程度に調整する。

## Tasks
- [x] 費用感が高く見えすぎる点を相談メモに反映する
- [x] Web最小版を AI駆動Web MVP として再定義する
- [x] MVP 中心の費用レンジ・ROI を更新する
- [x] 今西さんへの返答案を MVP 中心に更新する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- 初回提案の心理的ハードルが下がっている
- AI駆動Web MVP の費用感が明記されている
- フル機能は将来拡張として整理されている
- ROI の回収期間が MVP 前提に更新されている
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 171 が記録されている

