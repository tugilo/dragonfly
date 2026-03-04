# PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_PLAN.md

## 背景

- **全案件標準化**（PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS）により、tugilo-template が唯一の Docker 基盤として確定した。
- 既存案件（protectlab / tsuboi / muraconet / dandreez）を template 標準へ移行する際、**事故を防ぐための手順の型**が存在しないと、人や AI が迷い、独自改造や手書き再構築が発生する。

## 目的

- 既存案件を tugilo-template 標準基盤へ **安全に移行するための「公式移行ガイド」** を 1 枚に固定する。
- 移行パターン（最小／標準／例外）を明文化し、PORT_GUARD・ポート変更・doctor による確認を整理する。
- **実装フェーズではない**。コードは変更せず、ドキュメントのみで「標準を守らせるための道」を作る。

## 対象プロジェクト例

| プロジェクト | パス | 移行の想定 |
|-------------|------|------------|
| protectlab | /Users/tugi/docker/protectlab | Apache 内包・mailpit。標準移行または例外（arm64 等） |
| tsuboi | /Users/tugi/docker/tuboi/tsuboi-docker | ほぼ template に近い。最小移行で吸収可能 |
| muraconet | /Users/tugi/docker/muraco/files/muraconet-docker | 本番専用・scheduler/queue/certbot。例外移行 |
| dandreez | /Users/tugi/docker/dandreez | 固定ポート・healthcheck なし。標準移行で吸収可能 |

## 非対象

- **本番専用 compose**（HTTPS・certbot・scheduler・queue のみで開発用 compose を持たない）は、本ガイドの「パターンC：例外移行」の対象。template をベースにせず、既存本番 compose を維持しつつ差分を GLOBAL_DIFF_MATRIX に追記する運用も可。
- 他社・外部から受け取った Docker 構成で tugilo 標準外のものは、本ガイドの対象外。必要に応じて template から新規作成することを推奨。

## 絶対遵守

- docker-compose.yml を変更しない。
- bin/ のコードは変更しない。
- Makefile も変更しない。
- **ドキュメントのみ作成**。
- 既存ルール（PLAN / WORKLOG / REPORT）必須。
- 1 Phase = 1 commit。

## 成果物

| 成果物 | 内容 |
|--------|------|
| PHASE_TEMPLATE_MIGRATION_GUIDE.md | 公式移行ガイド本体（1 枚）。移行パターン・ポート・DB・doctor・DoD・禁止事項。 |
| PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_WORKLOG.md | 実施ログ。 |
| PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_REPORT.md | 作成ファイル一覧・移行パターン整理結果・差分吸収方針・次フェーズ候補。 |
| docs/INDEX.md | 上記 4 ファイルを process 一覧に追加。 |

## DoD

- MIGRATION_GUIDE 作成済み。
- 3 パターン（A 最小 / B 標準 / C 例外）定義済み。
- doctor による確認手順を記載済み。
- INDEX 更新済み。
- 1 commit。
