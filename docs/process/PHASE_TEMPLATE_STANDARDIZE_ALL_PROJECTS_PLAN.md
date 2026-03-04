# PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS_PLAN.md

## 目的

tugilo-template を **全案件共通標準基盤** として確定する。単なる改善ではなく、今後の全プロジェクトがこの構成を前提とする状態にする。

## 最終ゴール

1. tugilo-template が唯一の Docker 基盤となる
2. 既存4プロジェクト（protectlab / tsuboi / muraconet / dandreez）との差分が明確にドキュメント化される
3. 将来案件もこのテンプレートからしか開始しない運用になる
4. ポート競合・起動順序・healthcheck・文字コードが完全標準化される
5. 例外運用のルールが明文化される

## 絶対遵守

- 既存テンプレートを壊さない
- docker-compose.yml の思想を変えない
- 1 Phase = 1 commit
- PLAN / WORKLOG / REPORT 作成必須
- docs/INDEX.md 更新必須

## 実装ステップ

| Step | 内容 | 成果物 |
|------|------|--------|
| Step0 | 標準宣言ドキュメント | PHASE_TEMPLATE_GLOBAL_STANDARD_DECLARATION.md |
| Step1 | 差分監査の最終固定 | PHASE_TEMPLATE_GLOBAL_DIFF_MATRIX.md |
| Step2 | PORT_GUARD 強化 | レンジ制限・docker ps 検出・PORT_GUARD フラグ |
| Step3 | make doctor | Makefile + bin/doctor.sh（基盤自己診断） |
| Step4 | README を標準仕様書へ昇格 | 標準思想・適用ポリシー・例外承認フロー・バージョン方針 |
| Step5 | WORKLOG / REPORT / INDEX | 実施ログ・報告・INDEX 更新・1 commit |

## DoD

- GLOBAL_STANDARD_DECLARATION 作成済み
- GLOBAL_DIFF_MATRIX 作成済み
- PORT_GUARD 強化済み
- make doctor 実装済み
- README が標準仕様書になっている
- INDEX 更新済み
- commit 1回
