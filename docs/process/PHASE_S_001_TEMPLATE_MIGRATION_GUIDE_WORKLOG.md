# PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_WORKLOG.md

## 実施内容

### Step0: PLAN 作成

- `PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_PLAN.md` を新規作成。
- 背景（全案件標準化後の移行手順の型の不在）、目的（公式移行ガイドの固定・事故防止）、対象プロジェクト例（protectlab / tsuboi / muraconet / dandreez）、非対象（本番専用のみ・外部由来構成）、絶対遵守（コード変更なし・ドキュメントのみ）、成果物・DoD を記載。

### Step1: 公式移行ガイド本体作成

- `PHASE_TEMPLATE_MIGRATION_GUIDE.md` を新規作成。
- **1. 移行パターン定義**: パターンA（最小移行・安全優先）、パターンB（標準移行・推奨）、パターンC（例外移行）の 3 パターンを定義。各パターンの対象・手順を明文化。
- **2. ポートの扱い**: 既存 APP_PORT=80 を維持する場合（PORT_GUARD=false）と標準 8000 系へ寄せる場合を表で整理。DB_PORT / PMA_PORT の扱いも記載。
- **3. 既存データベースの扱い**: dump 取得・volumes 確認・文字コード確認を記載。
- **4. doctor による確認**: `make doctor` の必須チェックと確認項目（Docker・project.env・ポート・healthcheck・Laravel 200）を記載。
- **5. 移行完了の定義（DoD）**: compose up 成功・doctor 全項目 OK・既存機能動作確認・進捗ファイル記録の 4 項目をチェックリスト化。
- **6. 禁止事項**: 既存 compose の独自改造禁止・標準を手書き再構築しないことを明記。

### Step2: WORKLOG 作成

- 本ファイルを作成。

### Step3: REPORT 作成

- `PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_REPORT.md` を作成。作成ファイル一覧・移行パターン整理結果・差分吸収方針・次フェーズ候補を記載。

### Step4: INDEX 更新

- `docs/INDEX.md` の process 一覧に、PLAN・MIGRATION_GUIDE・WORKLOG・REPORT の 4 エントリを追加。

## コード変更

- なし。docker-compose.yml / bin/ / Makefile は一切変更していない。
