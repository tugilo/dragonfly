# Git ブランチ運用ルール（SSOT）

DragonFly では tugilo 標準に従い、以下のブランチ運用を採用する。  
**取り込みは PR を介さず、ローカル merge で行う。** 詳細は [docs/git/PRLESS_MERGE_FLOW.md](git/PRLESS_MERGE_FLOW.md) を参照。

## ブランチ種別

| ブランチ | 役割 | 運用 |
|----------|------|------|
| **main** | リリース・安定 | 直接 push 禁止推奨。develop からの merge で更新（PR は使わない）。 |
| **develop** | 統合ブランチ | 作業は feature の **ローカル merge** でここに集約。日常開発の基点。 |
| **feature/*** | 作業用 | Phase 単位または目的単位。develop から分岐し、**ローカルで develop に merge**。 |
| **hotfix/*** | 緊急修正 | main から分岐し、main と develop へ取り込み。 |

## 原則

- **1push 原則** … 1 目的 = 1 コミットで push。細かく分けず、まとめて push。
- **スコープロック** … 1 ブランチでやることは 1 テーマに限定する。

## Phase 運用との関係

- Phase 開発ログは `docs/process/phases/` に PLAN / WORKLOG / REPORT を残す。
- feature ブランチ名は Phase や目的が分かるようにする（例: `feature/readme-and-branching`）。
- **develop へ取り込んだあと**、REPORT に「取り込み証跡」（merge commit id・変更ファイル一覧・テスト結果）を記録する。PR の代替。テンプレートは [docs/process/templates/PHASE_REPORT_TEMPLATE.md](process/templates/PHASE_REPORT_TEMPLATE.md)。

## 初期セットアップ（main しかない場合）

1. main を最新にする: `git checkout main && git pull`
2. develop を main から作成: `git checkout -b develop`
3. リモートへ push: `git push -u origin develop`
4. 以後、新規作業は `git checkout develop` してから `feature/***` を切る。

## 推奨フロー（PR を使わない）

1. **作業時:** `develop` から `feature/xxx` を切って作業 → 1 コミットで push。
2. **統合:** `feature/xxx` をローカルで `develop` に **merge（--no-ff）** し、テスト後に `git push origin develop`。REPORT に取り込み証跡を追記。
3. **リリース:** 安定したら `develop` を `main` に **merge** して push（PR は使わない）。

取り込みの詳細・禁止事項・証跡の残し方は [docs/git/PRLESS_MERGE_FLOW.md](git/PRLESS_MERGE_FLOW.md) を参照すること。
