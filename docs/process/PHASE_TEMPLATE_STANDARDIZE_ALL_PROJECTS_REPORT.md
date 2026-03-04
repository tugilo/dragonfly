# PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS_REPORT.md

## 変更ファイル一覧

| ファイル | 変更内容 |
|----------|----------|
| docs/process/PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS_PLAN.md | 新規。目的・ゴール・絶対遵守・実装ステップ・DoD。 |
| docs/process/PHASE_TEMPLATE_GLOBAL_STANDARD_DECLARATION.md | 新規。宣言・適用範囲・標準仕様・禁止事項・例外承認フロー・将来バージョン管理方針。 |
| docs/process/PHASE_TEMPLATE_GLOBAL_DIFF_MATRIX.md | 新規。template と 4 プロジェクトの差分マトリクス・最適解の理由・移行時の対応。 |
| docs/process/PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS_WORKLOG.md | 新規。実施ログ。 |
| docs/process/PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS_REPORT.md | 本ファイル。 |
| bin/preflight.sh | get_docker_host_ports 追加。find_free_port START [MAX]。is_port_in_use で DOCKER_HOST_PORTS を考慮。 |
| bin/setup.sh | ポートレンジ（APP 8000-8999 等）・PORT_GUARD=true/false 対応・デフォルト 8000。 |
| bin/doctor.sh | 新規。Docker・ポート・project.env・healthcheck・Laravel 応答の自己診断。 |
| Makefile | make doctor 追加。 |
| infra/compose/docker-compose.yml | APP_PORT デフォルトを 8000 に変更。 |
| README.md | 標準仕様書へ昇格（v1.0・標準思想・適用ポリシー・例外承認フロー・将来バージョン方針・PORT_GUARD 強化・make doctor）。 |
| docs/INDEX.md | process 一覧に STANDARDIZE と GLOBAL 系を追加。 |

## 実装内容概要

- **全案件標準**: tugilo-template を唯一の Docker 基盤とし、標準宣言・差分マトリクスで思想と適用ポリシーを固定した。
- **PORT_GUARD 強化**: ポートレンジ制限・docker ps による既存バインド検出・PORT_GUARD フラグでスライドの ON/OFF を可能にした。APP デフォルトを 8000 に変更。
- **make doctor**: 基盤自己診断で Docker 起動・必須ファイル・project.env・ポート・healthcheck・Laravel 応答を一括確認できるようにした。
- **README**: 「tugilo Standard Docker Infrastructure v1.0」として標準思想・適用ポリシー・例外承認フロー・将来バージョン管理方針を明文化した。

## 差分監査結果要約

- template は php-fpm + nginx 分離・mariadb 公式イメージ・healthcheck 必須・restart: unless-stopped・project.env + PORT_GUARD・ポートレンジ・COMPOSE_PROJECT_NAME によるプロジェクト分離で、既存 4 プロジェクトの良い点を集約している。
- protectlab: Apache 内包・mailpit。tsuboi: ほぼ template に近い・pgadmin。muraconet: 本番特化・scheduler/queue/certbot。dandreez: 固定ポート・healthcheck なし。移行時は template をベースにし、差分はドキュメント化して例外として管理する方針をマトリクスに記載した。

## doctor 実行結果（例）

```
=== tugilo Standard Docker – doctor ===

[1] Docker
  ✅ Docker is running

[2] Required files
  ✅ Compose file exists
  ✅ project.env exists

[3] project.env
  ✅ COMPOSE_PROJECT_NAME=tugilo-template
  ...

[4] Ports (APP=8000, DB=3307, PMA=8081)
  ✅ Port 8000 is in use (expected if containers are running)
  ...

[5] Healthcheck (containers)
  ✅ Containers found: 5
  ✅ No unhealthy containers reported

[6] Laravel response (http://localhost:8000)
  ✅ Laravel responds with HTTP 200

=== doctor done ===
```

## DoD

- [x] GLOBAL_STANDARD_DECLARATION 作成済み
- [x] GLOBAL_DIFF_MATRIX 作成済み
- [x] PORT_GUARD 強化済み
- [x] make doctor 実装済み
- [x] README が標準仕様書になっている
- [x] INDEX 更新済み
- [x] commit 1回

## commit ID

`02877a9`
