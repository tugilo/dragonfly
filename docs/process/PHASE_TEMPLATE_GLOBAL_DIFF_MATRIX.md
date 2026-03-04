# 全案件標準 差分監査マトリクス（GLOBAL DIFF MATRIX）

template を最適解として、既存4プロジェクトとの差分を固定する。  
「採用」列は template が採用している仕様を指す。

## マトリクス

| 項目 | template | protectlab | tsuboi | muraconet | dandreez | 採用（template） |
|------|----------|------------|--------|-----------|----------|------------------|
| **app** | php-fpm | Apache+PHP | php-fpm | Apache+PHP | Apache+PHP | php-fpm（nginx と分離） |
| **web** | nginx | (app内包) | nginx | (app内包) | (app内包) | nginx 分離 |
| **db** | mariadb:11.2 | mysql build | mariadb:11 | mysql:8.0 | mysql build | mariadb 公式イメージ |
| **phpmyadmin** | あり | あり | あり | あり | あり | あり |
| **mail** | なし | mailpit | なし | なし | mailhog | なし（profile で任意追加可） |
| **healthcheck** | db,app,nginx,pma | app,mysql,pma,mailpit | nginx,app,mysql,pma | app,mysql,scheduler,queue | なし | 必須・起動順序保証 |
| **restart** | unless-stopped | unless-stopped | unless-stopped | unless-stopped | なし | unless-stopped |
| **depends_on** | condition: service_healthy | condition | condition | あり | なし | condition: service_healthy |
| **ports 管理** | project.env + PORT_GUARD | env | env | 固定 | 固定 | project.env + 自動スライド |
| **ポートレンジ** | 80-89 / 3307-3399 / 8081-8181 | 未定義 | 未定義 | 未定義 | 未定義 | APP 80-89（http://localhost）、DB/PMA は標準レンジで衝突回避 |
| **プロジェクト分離** | COMPOSE_PROJECT_NAME + ${PROJECT}-* | なし | tsuboi_* | muraconet_* | なし | プロジェクト名で一貫 |
| **文字セット** | utf8mb4_unicode_ci | utf8mb4_unicode_ci | utf8mb4_unicode_ci | utf8mb4_general_ci | 未明示 | utf8mb4_unicode_ci |
| **client_max_body_size** | 64m | 未記載 | 未記載 | 未記載 | 未記載 | 64m（アップロード） |
| **PMA UPLOAD_LIMIT** | env 連動 | env | env | 100M 固定 | なし | env（64M デフォルト） |

## template が最適解である理由（論理的根拠）

1. **一元管理**: 全案件が同一の infra 構造（nginx + php-fpm + mariadb + project.env）を持つため、手順・ドキュメント・AI（Cursor）の指示が一本化できる。
2. **起動の安定性**: healthcheck と depends_on condition により、db の ready を待ってから app を起動するため、migrate や接続エラーが起きにくい。
3. **ポート競合の解消**: PORT_GUARD とポートレンジ制限により、複数プロジェクト・他サービスとの共存が可能。
4. **例外の可視化**: 既存案件の「Apache 内包」「mysql build」「固定ポート」等は本マトリクスで差分として明示され、移行時や理由の説明に使える。
5. **将来の拡張**: 標準から外れる要件（mailpit / xdebug / 別 DB）は profile や docs で「例外」として管理し、テンプレート本体はシンプルに保つ。

## 既存4プロジェクトからの移行時の対応

| プロジェクト | 主な差分 | 移行時の対応 |
|-------------|----------|--------------|
| protectlab | Apache, mailpit, arm64 | 新規は template から。既存は Apache→nginx+php-fpm の移行は別 Phase で検討。 |
| tsuboi | pgadmin, ほぼ template に近い | template の infra を上書きコピーし、pgadmin のみ profile 等で追加。 |
| muraconet | scheduler, queue, certbot, 本番特化 | 本番用は別 compose として維持。開発環境は template に統一。 |
| dandreez | 固定ポート、healthcheck なし | template をコピーして make setup し、project.env でポートを合わせる。 |
