# PHASE_167_imanishi_ilc_webapp_cost PLAN

## Phase Type
docs

## Purpose
今西さん向けの AiLC 月次集計表自動化プランを、デスクトップアプリではなく Web アプリ構築前提の費用感に更新する。

## Background
Phase 166 では自動化プランと概算費用を整理したが、ユーザーより「Webアプリとして実装するとするとの費用感のほうがいい。デスクトップアプリを構築するよりも」と方針指定があった。ブラウザで TSV をアップロードし、集計・レポート生成・履歴管理へ拡張できる前提で整理し直す。

## Related SSOT
N/A（相談メモ・提案方針整理のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・正式見積書作成は行わない。

## Target Files
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_167_imanishi_ilc_webapp_cost_PLAN.md
- docs/process/phases/PHASE_167_imanishi_ilc_webapp_cost_WORKLOG.md
- docs/process/phases/PHASE_167_imanishi_ilc_webapp_cost_REPORT.md

## Implementation Strategy
既存のプラン表を Web アプリ前提に置き換え、検証、Webアップロード最小版、加盟店向けWebレポート生成版、Web管理画面付き運用版、送信管理込みWeb運用版に整理する。初期費用に加え、サーバー・保守などのランニング費用も追記する。

## Tasks
- [x] 相談メモの費用表を Web アプリ前提へ更新する
- [x] Web アプリ前提のランニング費用を追記する
- [x] 今西さんへの返答案を Web アプリ前提へ更新する
- [x] progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- Web アプリとして実装する場合の複数プランが整理されている
- デスクトップアプリより Web アプリを推奨する理由が明記されている
- 初期費用とランニング費用の目安が分かる
- 今西さんへ送れる返答案が Web アプリ前提になっている
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 167 が記録されている

