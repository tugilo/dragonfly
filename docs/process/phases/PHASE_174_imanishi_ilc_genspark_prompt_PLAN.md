# PHASE_174_imanishi_ilc_genspark_prompt PLAN

## Phase Type
docs

## Purpose
今西さん向け AiLC 月次集計表作成 自動化提案メモをもとに、Gensparkで分かりやすい提案スライドを作成するためのプロンプトを作成する。

## Background
Phase 173 で外部共有向けの提案資料を作成した。次に、Gensparkでスライド化するため、目的・想定読者・トーン・デザイン方針・必須メッセージ・スライド構成・避けること・元資料を含めたコピペ用プロンプトが必要。

## Related SSOT
N/A（提案資料作成支援プロンプトのみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・実際のスライド生成は行わない。

## Target Files
- docs/proposals/ilc_monthly_report_automation_genspark_slide_prompt.md
- docs/proposals/README.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_174_imanishi_ilc_genspark_prompt_PLAN.md
- docs/process/phases/PHASE_174_imanishi_ilc_genspark_prompt_WORKLOG.md
- docs/process/phases/PHASE_174_imanishi_ilc_genspark_prompt_REPORT.md

## Implementation Strategy
Gensparkに貼り付けるだけで、経営者向けの分かりやすいスライドになるように、スライドの目的・対象者・トーン・デザイン方針・重要メッセージ・12枚構成・避けること・出力形式を指定する。提案メモの要点もプロンプト内に含める。

## Tasks
- [x] Genspark用スライド生成プロンプトを作成する
- [x] proposals README / INDEX を更新する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- Gensparkに貼り付けて使えるプロンプトになっている
- 経営者向けスライドとして、削減効果・ROI・段階提案が伝わる構成になっている
- 元提案資料の重要数字が含まれている
- INDEX と proposals README から辿れる
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 174 が記録されている

