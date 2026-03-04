# PHASE_TEMPLATE_DOCKER_AUDIT_REPORT.md

## 監査表（最新4プロジェクト + tugilo-template）

### compose 構成比較

| 観点 | protectlab | tsuboi | muraconet | dandreez | tugilo-template |
|------|------------|--------|-----------|----------|-----------------|
| app | Apache+PHP | php-fpm | Apache+PHP | Apache+PHP | php-fpm |
| web | (app に内包) | nginx | (app に内包) | (app に内包) | nginx |
| db | mysql (build) | mariadb:11 | mysql:8.0 | mysql (build) | mariadb:11.2 |
| phpmyadmin | あり | あり | あり | あり | あり |
| mail | mailpit | なし | なし | mailhog | なし |
| healthcheck | app,mysql,pma,mailpit | nginx,app,mysql,pma | app,mysql,scheduler,queue | なし | なし |
| restart | unless-stopped | unless-stopped | unless-stopped | なし | なし |
| depends_on condition | service_healthy/started | service_healthy | あり | なし | なし |
| ports 管理 | APP_PORT,MYSQL_PORT,PMA_PORT env | PMA_PORT,PGADMIN_PORT env | 3307,8082 固定 | 固定 | 80,3307,8081 固定 |
| プロジェクト分離 | container_name なし | container_name tsuboi_* | container_name muraconet_* | なし | COMPOSE_PROJECT_NAME + ${PROJECT}-* |

### 標準の根拠（どのプロジェクトから何を採用するか）

| 取り込む標準 | 採用根拠プロジェクト | 備考 |
|-------------|---------------------|------|
| healthcheck（db 必須） | protectlab, tsuboi, muraconet | db の ready を待って app 起動するため |
| restart: unless-stopped | protectlab, tsuboi, muraconet | 開発時の安定性 |
| ports を project.env で管理（APP_PORT, DB_PORT, PMA_PORT） | protectlab, tsuboi, muraconet | 衝突回避 |
| COMPOSE_PROJECT_NAME / container_name 統一 | tugilo-template 既存 + tsuboi/muraconet | プロジェクト分離 |
| phpmyadmin の UPLOAD_LIMIT 等を env 連動 | protectlab, tsuboi | 大型インポート対応 |
| nginx の client_max_body_size を env 連動 | tugical（別調査） | アップロード制限の調整 |
| xdebug / phpmyadmin / mailhog は profile で任意ON | protectlab（xdebug）, dandreez（mailhog）の思想 | デフォルトは最小構成 |

## 動作確認

- make new-project test または make setup が成功すること
- docker ps で想定コンテナが起動すること
- http://localhost（または APP_PORT）で Laravel が表示されること
- php artisan migrate が成功すること

## 結論

上記「標準の根拠」に沿って tugilo-template の infra を拡張する。既存の make setup フローは維持し、追加は profile または project.env の変数で制御する。
