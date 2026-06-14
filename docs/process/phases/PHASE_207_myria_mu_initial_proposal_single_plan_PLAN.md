# PHASE_207_myria_mu_initial_proposal_single_plan PLAN

## Phase Type
docs

## Purpose
Myria-mu 初期導入版提案書を、180万円の本命プランのみを前面に出し、将来拡張は別途見積として扱う構成へ修正する。

## Background
ユーザーから、現在の西浦さんは「まず管理を楽にしたい」フェーズであり、商談では180万円の基本プランだけを本命として提示し、施工店評価・施工事例集・ランキング・LINE連携は将来拡張として口頭補足する方がよいとの指示があった。また、7章の確認事項に、既に確定済みのログインやアンケート/イラスト管理確認が残っていたため、契約書管理・完了報告・アンケート運用フロー、支払予定日の運用方法へ差し替える。

## Related SSOT
SPEC-013 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key）

補足: 本成果物は Religo 本体仕様ではなく、西浦雅さんとの相談記録および Myria-mu 要件定義書を元にしたクライアント向け提案資料である。

## Scope
docs のみ変更する。アプリ実装、DB変更、外部サービス連携調査、見積金額の契約確定は行わない。

## Target Files
- docs/proposals/myria_mu_exterior_referral_system_initial_proposal.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_207_myria_mu_initial_proposal_single_plan_PLAN.md
- docs/process/phases/PHASE_207_myria_mu_initial_proposal_single_plan_WORKLOG.md
- docs/process/phases/PHASE_207_myria_mu_initial_proposal_single_plan_REPORT.md

## Implementation Strategy
価格付きの200万円プランを削除し、180万円の初期導入プランを本命として提示する。将来拡張は、施工店評価、施工事例集、ランキング、LINE連携などを別途見積対象として後半に控えめに記載する。商談時確認事項は、未確定の運用確認に絞る。

## Tasks
- [x] 200万円プランを価格付きプランから削除する
- [x] 180万円プランを本命提案として整理する
- [x] 将来拡張を別途見積扱いにする
- [x] 7章の確認事項を修正する
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する

## DoD
- 初期導入版提案書で価格付きプランは180万円のみになっている
- 施工店評価、施工事例集、ランキング、LINE連携は将来拡張として記載されている
- 7章の確認事項から、施工店/インフルエンサーログイン確認とアンケート/イラスト初期含有確認が削除されている
- 7章に契約書管理・完了報告・アンケート運用フロー、支払予定日の運用方法が記載されている
