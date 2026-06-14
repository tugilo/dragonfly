# PHASE_199_myria_mu_platform_proposal_rewrite PLAN

## Phase Type
docs

## Purpose
Myria-mu 向け提案書を、管理システム導入提案ではなく、外構紹介ビジネスを拡大するためのプラットフォーム構築提案として全面リライトする。

## Background
ユーザーから、現在の提案書は要件整理としてはまとまっているが「管理システム導入提案」に寄り過ぎているため、Myria-mu が本当に実現したい「外構紹介ビジネスを拡大するためのプラットフォーム」として書き直す指示があった。

## Related SSOT
SPEC-013 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key）

補足: 本成果物は Religo 本体仕様ではなく、西浦雅さんとの相談記録および Myria-mu 要件定義書を元にしたクライアント向け提案資料である。

## Scope
docs のみ変更する。アプリ実装、DB変更、外部サービス連携調査、見積金額の契約確定は行わない。

## Target Files
- docs/proposals/myria_mu_exterior_referral_system_proposal.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_199_myria_mu_platform_proposal_rewrite_PLAN.md
- docs/process/phases/PHASE_199_myria_mu_platform_proposal_rewrite_WORKLOG.md
- docs/process/phases/PHASE_199_myria_mu_platform_proposal_rewrite_REPORT.md

## Implementation Strategy
提案書のタイトルを「Myria-mu 外構紹介プラットフォーム構築提案」へ変更し、インフルエンサー、顧客、施工店、契約、施工、顧客満足、施工事例、データ蓄積が循環する紹介ネットワークとして再構成する。施工店は送客先ではなく地域パートナー、インフルエンサーは報酬管理対象ではなく成果パートナーとして位置づける。

## Tasks
- [x] タイトル・サブタイトルを変更する
- [x] 提案の要旨をプラットフォーム構築視点へ書き換える
- [x] 未来像の Mermaid 図を紹介ネットワーク循環として拡張する
- [x] 施工店・インフルエンサー・顧客満足度・施工事例の章を強化する
- [x] 「施工事例資産化」「なぜ専用システムなのか」を新規追加する
- [x] 予算説明を基盤構築費として書き換える
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する

## DoD
- 提案書タイトルが「Myria-mu 外構紹介プラットフォーム構築提案」になっている
- サブタイトルが追加されている
- 提案の主軸が管理負荷軽減ではなく、紹介ネットワーク・プラットフォーム・成長基盤になっている
- インフルエンサーが成果パートナーとして記載されている
- 施工店が地域パートナーとして記載されている
- 顧客満足度アンケートからオリジナルイラスト、SNS投稿、施工事例活用までの流れが記載されている
- 施工事例資産化の章がある
- スプレッドシートではなく専用システムが必要な理由が記載されている
- 150万〜180万円が外構紹介プラットフォームの基盤構築費として説明されている
- docs/INDEX.md と docs/dragonfly_progress.md と docs/process/PHASE_REGISTRY.md が更新されている
