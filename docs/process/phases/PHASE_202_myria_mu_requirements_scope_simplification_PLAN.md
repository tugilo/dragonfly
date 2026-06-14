# PHASE_202_myria_mu_requirements_scope_simplification PLAN

## Phase Type
docs

## Purpose
Myria-mu 外構紹介管理プラットフォーム要件定義書について、150〜180万円規模の初期提案・実装に合わせ、作り込み過ぎている箇所を整理する。

## Background
ユーザーから、現状の要件定義書は完成度が高い一方で、Myria-mu と運営者の分離、施工店評価指標テーブルの固定化など、初期開発としては作り込み過ぎの懸念があるとの指摘があった。提案時は必須範囲とできれば範囲を分ける方が受注しやすいという方針も共有された。

## Related SSOT
SPEC-013 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key）

補足: 本成果物は Religo 本体仕様ではなく、西浦雅さんとの相談記録を元にしたクライアント向け要件定義書である。

## Scope
docs のみ変更する。アプリ実装、DB変更、外部サービス連携調査、見積金額の契約確定は行わない。

## Target Files
- docs/requirements/myria_mu_exterior_referral_system_requirements.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_PLAN.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_WORKLOG.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_REPORT.md

## Implementation Strategy
ペルソナはMyria-mu担当者に統合し、権限は管理者 / Myria-mu担当者 / 施工店 / インフルエンサーの4権限を維持する。施工店評価は固定テーブルではなく、案件・契約・アンケートから集計可能な構造に留める。イラスト制作は初期は案件ステータスで管理し、将来的な独立テーブル化の確認事項を残す。

## Tasks
- [x] Myria-mu と運営者ペルソナを統合する
- [x] 施工店評価指標を固定テーブル前提から集計可能要件へ変更する
- [x] イラスト制作の将来的な独立テーブル化確認事項を追加する
- [x] インフルエンサー退会時の過去案件・報酬履歴の扱いを確認事項へ追加する
- [x] 提案時の必須/できればスコープ区分を追加する
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する

## DoD
- ペルソナ上、Myria-mu と運営者が分離されていない
- 権限要件は4権限で整理されている
- 施工店評価指標は固定テーブル前提ではなく、案件・契約・アンケートから集計可能な要件になっている
- イラスト制作の独立管理は確認事項として残っている
- インフルエンサー退会時の過去案件・報酬履歴の扱いが確認事項に追加されている
- 提案時の必須/できれば範囲が整理されている
