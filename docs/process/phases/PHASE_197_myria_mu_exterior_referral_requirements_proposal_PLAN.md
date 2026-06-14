# PHASE_197_myria_mu_exterior_referral_requirements_proposal PLAN

## Phase Type
docs

## Purpose
株式会社Myria-mu の外構工事紹介・施工店送客・インフルエンサー報酬管理システムについて、クライアント提案書の前段として使える要件定義書を `docs/requirements/` に作成する。

## Background
2026-06-14 JST 20:00 から実施した西浦雅さんとの第2回121で、Myria-mu の外構SNS集客・施工店送客・契約/完了報告・インフルエンサー報酬管理をシステム化する相談があった。ユーザーから、経営者向けに、単なる機能一覧ではなくプロジェクト概要、課題、As-Is / To-Be、ペルソナ、機能要件、画面、権限、データ、将来拡張、スコープ外、概算見積対象範囲まで整理したMarkdown作成依頼があった。

## Related SSOT
SPEC-013 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key）

補足: 本成果物は Religo 本体仕様ではなく、1to1/相談記録を元にしたクライアント提案用ドキュメントである。

## Scope
docs のみ変更する。アプリ実装、DB変更、外部サービス連携調査、見積金額の契約確定は行わない。

## Target Files
- docs/requirements/myria_mu_exterior_referral_system_requirements.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_197_myria_mu_exterior_referral_requirements_proposal_PLAN.md
- docs/process/phases/PHASE_197_myria_mu_exterior_referral_requirements_proposal_WORKLOG.md
- docs/process/phases/PHASE_197_myria_mu_exterior_referral_requirements_proposal_REPORT.md

## Implementation Strategy
ユーザー提供要件を元に、経営者が読みやすい順序で業務課題と導入効果を整理する。配置先は文書種別に合わせて `docs/requirements/` とし、提案書は別途 `docs/proposals/` に作成する。

## Tasks
- [x] 配置先を `docs/requirements/` に決定する
- [x] 要件定義書本体を作成する
- [x] Mermaid の As-Is / To-Be 業務フロー図を含める
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する

## DoD
- `docs/requirements/myria_mu_exterior_referral_system_requirements.md` が作成されている
- プロジェクト概要、現在の課題、システム化の目的が整理されている
- As-Is / To-Be 業務フローが Mermaid で記載されている
- ペルソナ、機能要件、画面一覧、権限設計、データ管理項目が記載されている
- 通知2案（メール通知、公式LINE通知）が整理されている
- 将来拡張、スコープ外、概算見積対象範囲が記載されている
- 概算予算 150万円〜180万円に見合う初期スコープとして整理されている
- docs/INDEX.md と docs/dragonfly_progress.md と docs/process/PHASE_REGISTRY.md が更新されている
