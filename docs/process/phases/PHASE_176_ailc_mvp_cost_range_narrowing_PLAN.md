# PHASE_176_ailc_mvp_cost_range_narrowing PLAN

## Phase Type
docs

## Purpose
AiLC 提案資料の AI駆動Web MVP 概算費用について、旧レンジでは判断に迷うため、`80〜90万円` に絞って提示する。

## Background
ユーザーより、AI駆動Web MVP の価格レンジが広すぎるため `80〜90万円` ぐらいにしておきたい、という指示があった。提案資料・Gensparkプロンプト・相談メモの価格レンジを狭め、ROI表も `80〜90万円` 前提に整合する必要がある。

## Related SSOT
N/A（提案資料・費用レンジ調整のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更は行わない。

## Target Files
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/proposals/ilc_monthly_report_automation_proposal_imanishi.md
- docs/proposals/ilc_monthly_report_automation_genspark_slide_prompt.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_176_ailc_mvp_cost_range_narrowing_PLAN.md
- docs/process/phases/PHASE_176_ailc_mvp_cost_range_narrowing_WORKLOG.md
- docs/process/phases/PHASE_176_ailc_mvp_cost_range_narrowing_REPORT.md

## Implementation Strategy
AI駆動Web MVP の費用を `80〜90万円` に統一する。MVPからレポート生成版への追加開発は `追加80〜90万円` とし、レポート生成版は `160〜180万円` に整合させる。投資回収表も `80〜90万円` / `160〜180万円` 前提に更新する。

## Tasks
- [x] AI駆動Web MVP の費用レンジを `80〜90万円` に統一する
- [x] レポート生成版の費用レンジを `160〜180万円` に整合する
- [x] ROI表を新レンジに合わせて更新する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [ ] 差分を確認する

## DoD
- 提案資料・相談メモ・Gensparkプロンプトに旧MVPレンジ表記が残っていない
- AI駆動Web MVP が `80〜90万円` として提示されている
- レポート生成版が `160〜180万円` として整合している
- ROI表が新価格レンジと矛盾していない
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 176 が記録されている

