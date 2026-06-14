# PHASE_202_myria_mu_requirements_scope_simplification REPORT

## Changed Files
- docs/requirements/myria_mu_exterior_referral_system_requirements.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_PLAN.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_WORKLOG.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_REPORT.md

## Summary
Myria-mu 外構紹介管理プラットフォーム要件定義書について、150〜180万円規模の初期提案・実装に合わせ、作り込み過ぎている箇所を整理した。

Myria-mu と運営者のペルソナを Myria-mu担当者へ統合し、権限は管理者 / Myria-mu担当者 / 施工店 / インフルエンサーの4権限に整理した。施工店評価指標は固定テーブル前提を外し、案件・契約・アンケートから集計可能な構造に留めた。

また、イラスト制作の将来的な独立データ化、インフルエンサー退会時の過去案件・報酬履歴・未払い報酬の扱いを確認事項に追加した。提案時のスコープは、必須範囲とできれば範囲に分けて整理した。

## DoD Check
- [x] ペルソナ上、Myria-mu と運営者が分離されていない
- [x] 権限要件は4権限で整理されている
- [x] 施工店評価指標は固定テーブル前提ではなく、案件・契約・アンケートから集計可能な要件になっている
- [x] イラスト制作の独立管理は確認事項として残っている
- [x] インフルエンサー退会時の過去案件・報酬履歴の扱いが確認事項に追加されている
- [x] 提案時の必須/できれば範囲が整理されている

## Scope Check
OK

## SSOT Check
OK

## Merge Evidence
merge commit id: 未実施（ユーザーから merge 指示なし）
source branch: develop
target branch: develop
phase id: 202
phase type: docs
related ssot: SPEC-013

test command: docs only / not run
test result: docs only

changed files:
- docs/requirements/myria_mu_exterior_referral_system_requirements.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_PLAN.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_WORKLOG.md
- docs/process/phases/PHASE_202_myria_mu_requirements_scope_simplification_REPORT.md

scope check: OK
ssot check: OK
dod check: OK
