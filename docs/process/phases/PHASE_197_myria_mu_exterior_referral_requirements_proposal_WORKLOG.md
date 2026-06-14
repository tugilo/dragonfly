# PHASE_197_myria_mu_exterior_referral_requirements_proposal WORKLOG

## Task1 - 配置先の判断
- 状態: completed
- 判断: 文書名と用途を分け、要件定義書は `docs/requirements/`、提案書は `docs/proposals/` に配置する。
- 実施: `docs/requirements/` の既存運用を確認し、要件定義書の置き場として採用した。
- 確認: 後続の Phase 198 で、この要件定義書を元にした提案書を `docs/proposals/` に作成した。

## Task2 - 要件定義書本体の作成
- 状態: completed
- 判断: 経営者向けの前段資料として、機能一覧から始めず、事業背景・課題・目的・業務フローの順で構成する。
- 実施: `docs/requirements/myria_mu_exterior_referral_system_requirements.md` を新規作成した。
- 確認: プロジェクト概要、現在の課題、システム化の目的、As-Is / To-Be、ペルソナ、機能要件、画面一覧、権限設計、データ管理項目、将来拡張、スコープ外、概算見積対象範囲を含めた。

## Task3 - 業務フロー図と通知案の整理
- 状態: completed
- 判断: 非エンジニア読者でも業務の変化が分かるよう、As-Is / To-Be の業務フローを Mermaid で記載する。
- 実施: 現在の手作業フローと、導入後の専用URL・自動流入元記録・施工店候補表示・契約/報告/報酬管理の流れを図解した。
- 確認: 通知は案1「メール通知のみ」と案2「公式LINE通知」に分け、エルメ利用は前提にしないと明記した。

## Task4 - 概算予算とスコープ整理
- 状態: completed
- 判断: ユーザー指示の想定予算 150万円〜180万円に合わせ、初期構築は紹介・案件・契約・完了・報酬管理へ絞る。
- 実施: 公式LINE通知、売上分析ダッシュボード、ランキング、Googleマップ、電子契約はオプションまたは将来拡張として整理した。
- 確認: 初期構築に含める範囲と、スコープ外を分けて記載した。

## Task5 - ドキュメント管理同期
- 状態: completed
- 判断: 新規ドキュメント作成のため、INDEX、progress、PHASE_REGISTRY、Phase三点セットを同期する。
- 実施: `docs/INDEX.md` の requirements セクション、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` を更新した。
- 確認: コード・DB変更は行っていない。テストは docs only のため未実行。
