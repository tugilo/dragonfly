# PHASE_204_myria_mu_initial_proposal PLAN

## Phase Type
docs

## Purpose
Myria-mu 向けに、既存の将来構想版提案書とは別に、150万・180万・200万円の機能差が分かる「初期導入版提案書」を作成する。

## Background
ユーザーから、現在の提案書は良いが理想形に寄りすぎており、西浦さんの初回相談フェーズでは「まず管理を楽にしたい」という現実案を前面に出す方が受注確率が高いとの指摘があった。さらに、150万・180万・200万円で機能差を明確にした提案書にすると、予算判断しやすいとの追加指示があった。

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
- docs/process/phases/PHASE_204_myria_mu_initial_proposal_PLAN.md
- docs/process/phases/PHASE_204_myria_mu_initial_proposal_WORKLOG.md
- docs/process/phases/PHASE_204_myria_mu_initial_proposal_REPORT.md

## Implementation Strategy
初期導入版は、A案（現実案）を中心に、150万円・180万円・200万円の3段階で機能差を整理する。B案（構想案）は最後に控えめに置き、施工事例資産化、施工店評価、顧客満足分析、SNS活用、ランキング、LINE連携などの将来拡張として扱う。

## Tasks
- [x] 初期導入版提案書を別ファイルで作成する
- [x] A案（現実案）を中心に構成する
- [x] 150万 / 180万 / 200万円の機能差を明確にする
- [x] B案（将来構想）を後半に控えめに記載する
- [x] 150〜180万円でできることを明確にする
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する

## DoD
- 初期導入版提案書が `docs/proposals/` に作成されている
- 既存の将来構想版提案書は残っている
- 150万 / 180万 / 200万円でできることが明確になっている
- A案（現実案）とB案（将来構想）が分かれている
- 西浦さんの初期相談内容に近い課題解決提案になっている
