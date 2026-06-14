# PHASE_200_myria_mu_requirements_platform_rewrite PLAN

## Phase Type
docs

## Purpose
Myria-mu 外構紹介管理プラットフォーム要件定義書を、顧客管理システム寄りの整理から、インフルエンサー・顧客・Myria-mu・施工店の4者を扱う外構紹介管理プラットフォームの要件定義へ修正する。

## Background
ユーザーから、現在の要件定義書は概ね正しいが、一部が顧客管理システムのような整理になっているため、営業表現を避け、機能・業務・データ・権限を客観的かつ具体的に整理するよう指示があった。

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
- docs/process/phases/PHASE_200_myria_mu_requirements_platform_rewrite_PLAN.md
- docs/process/phases/PHASE_200_myria_mu_requirements_platform_rewrite_WORKLOG.md
- docs/process/phases/PHASE_200_myria_mu_requirements_platform_rewrite_REPORT.md

## Implementation Strategy
提案書的な表現を削り、要件定義書として、概要・ペルソナ・業務フロー・機能要件・データ要件・権限要件・非機能要件・スコープ・スコープ外に再構成する。システム名は外構紹介管理プラットフォームとして扱い、4者を同格の関係者として整理する。

## Tasks
- [x] 概要を外構紹介管理プラットフォームとして修正する
- [x] ペルソナを4者同格で整理する
- [x] 指定業務フローを Mermaid で追加する
- [x] 契約管理・完了報告・アンケート・施工店・インフルエンサー要件を強化する
- [x] インフルエンサーマイページを追加する
- [x] 権限要件・非機能要件・スコープ・スコープ外を明確化する
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する

## DoD
- 要件定義書が「外構紹介管理プラットフォーム」として整理されている
- Myria-mu、運営者、インフルエンサー、施工店、顧客の役割が定義されている
- 指定の Mermaid 業務フローが記載されている
- 契約管理に契約日、契約金額、契約書PDF、支払予定日、登録者が含まれている
- 完了報告に完了日、複数完成写真、報告内容が含まれている
- 顧客アンケートに満足度、コメント、公開可否が含まれている
- 施工店に対応都道府県、対応市区町村、対応郵便番号が含まれている
- インフルエンサーに区分、報酬率、マイページ閲覧項目が含まれている
- 4権限が定義されている
- 非機能要件、スコープ、スコープ外が記載されている
