# PHASE_TEMPLATE_DOCKER_AUDIT_WORKLOG.md

## 実施内容

- 対象: protectlab, tsuboi (tuboi/tsuboi-docker), muraconet (muraco/files/muraconet-docker), dandreez
- 各プロジェクトの docker-compose.yml / Dockerfile / nginx 設定を読み取り、比較観点でメモ

### protectlab

- **compose**: app, mysql, phpmyadmin, mailpit。APP_PORT / MYSQL_PORT / PMA_PORT を env で管理（デフォルト 80, 3306, 8080）。
- **healthcheck**: app (wget localhost), mysql (mariadb-admin ping), phpmyadmin (wget), mailpit (nc 1025)。
- **restart**: unless-stopped を全サービスに設定。
- **depends_on**: app は `mysql: condition: service_healthy`, `mailpit: condition: service_started`。
- **xdebug**: ボリュームで xdebug.ini をマウント。XDEBUG_MODE は env で指定可能。
- **mailpit**: axllent/mailpit。SMTP 1025, Web 8025。

### tsuboi

- **compose**: nginx, app (php-fpm), mysql, phpmyadmin, pgadmin。Laravel 向け。
- **healthcheck**: nginx (nginx -t), app (pgrep php-fpm), mysql (mariadb-admin ping), phpmyadmin (wget)。
- **restart**: unless-stopped。container_name: tsuboi_*。
- **depends_on**: app は `mysql: condition: service_healthy`。phpmyadmin も同様。
- **ports**: PMA_PORT, PGADMIN_PORT を env で指定可能（デフォルト 8080, 8081）。
- **volumes**: named volume (tsuboi_mysql_data, pgadmin_data)。

### muraconet

- **compose**: app, mysql, phpmyadmin, scheduler, queue, certbot。本番向け。
- **healthcheck**: app (curl health), mysql (mysqladmin ping), phpmyadmin なし, scheduler (pgrep schedule:run), queue (queue:monitor)。
- **restart**: unless-stopped。
- **ports**: mysql は 3307:3306（衝突回避）。phpmyadmin 8082。
- **networks**: 独自 bridge (muraconet_network), サブネット指定。

### dandreez

- **compose**: app, mysql, phpmyadmin, mailhog。シンプル。
- **ports**: 固定 80, 3306, 8080, 8025/1025。healthcheck なし、restart なし。
- **depends_on**: サービス名のみ（condition なし）。

### tugilo-template（現状）

- app (php-fpm), node, nginx, db (mariadb), phpmyadmin。ports は 80, 3307, 8081 固定。healthcheck なし。restart なし。COMPOSE_PROJECT_NAME でプロジェクト名を指定済み。

## 次のステップ

- REPORT に監査表をまとめ、標準採用項目と根拠プロジェクトを記載する。
