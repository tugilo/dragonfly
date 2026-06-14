# PHASE_205_myria_mu_initial_proposal_two_plan PLAN

## Phase Type
docs

## Purpose
Myria-mu 初期導入版提案書を、150万円案を削除し、180万円基本プランと200万円推奨プランの2段階に再構成する。

## Background
ユーザーから、確定要件上、施工店ログイン・インフルエンサーログイン・契約登録・完了報告・契約書PDF管理・報酬計算は必須であり、ログインなしの150万円案は要件を満たさないとの指摘があった。また、顧客アンケートと完成写真管理は業務フローの中核であるため、基本プランに含める方針が示された。

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
- docs/process/phases/PHASE_205_myria_mu_initial_proposal_two_plan_PLAN.md
- docs/process/phases/PHASE_205_myria_mu_initial_proposal_two_plan_WORKLOG.md
- docs/process/phases/PHASE_205_myria_mu_initial_proposal_two_plan_REPORT.md

## Implementation Strategy
150万円案を削除し、180万円基本プランに顧客管理、施工店管理、契約管理、完了報告、アンケート、写真管理、報酬管理、施工店/インフルエンサーログインを含める。200万円推奨プランは基本プラン +20万円のオプションとして、イラスト制作管理、NPS、将来の施工店評価基盤を含める。

## Tasks
- [x] 150万円案を削除する
- [x] 180万円基本プランを定義する
- [x] 200万円推奨プランを定義する
- [x] 機能差一覧を2段階に更新する
- [x] 推奨案と進め方を更新する
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する

## DoD
- 150万円案が削除されている
- 180万円基本プランにアンケートと写真管理が含まれている
- 200万円推奨プランにイラスト制作管理、NPS、施工店評価基盤が含まれている
- 機能差一覧が2段階になっている
- 提案書が西浦さんの初期相談に合う現実的な構成になっている
