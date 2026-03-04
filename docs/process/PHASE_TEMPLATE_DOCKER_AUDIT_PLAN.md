# PHASE_TEMPLATE_DOCKER_AUDIT_PLAN.md

## 目的

`/Users/tugi/docker` 以下の**最新プロジェクト（protectlab, tsuboi, muraconet, dandreez）**を対象に Docker 構成を横断調査し、tugilo-template に取り込む「標準」の根拠を明確にする。

## 対象プロジェクト（優先）

| プロジェクト | パス | 備考 |
|-------------|------|------|
| protectlab (protectlabo) | /Users/tugi/docker/protectlab | Apache+PHP, healthcheck, mailpit, ポートを env で管理 |
| tsuboi | /Users/tugi/docker/tuboi/tsuboi-docker | nginx+php-fpm, Laravel, healthcheck, restart, 命名規約 |
| muraconet | /Users/tugi/docker/muraco/files/muraconet-docker | 本番向け, healthcheck, 独自 network, 3307 で衝突回避 |
| dandreez | /Users/tugi/docker/dandreez | シンプル構成, mailhog, phpmyadmin |

## 比較観点

- **compose**: services 構成, volumes, ports（衝突回避）, env 管理, healthcheck, restart, networks
- **php**: ベースイメージ, 拡張, composer, xdebug の扱い
- **nginx**: root, try_files, php-fpm, client_max_body_size
- **開発UX**: make 体系, セットアップ, ログ・DB・バックアップ

## 成果物

- PHASE_TEMPLATE_DOCKER_AUDIT_WORKLOG.md … 調査実施ログ
- PHASE_TEMPLATE_DOCKER_AUDIT_REPORT.md … 監査表（Markdown テーブル）と「どのプロジェクトから何を採用したか」

## 制約

- tugilo-template の make setup フローを壊さない
- 変更は tugilo-template 内のみ（他プロジェクトは読み取りのみ）
