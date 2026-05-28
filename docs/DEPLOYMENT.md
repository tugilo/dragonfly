# デプロイ（GitHub Actions）

Religo（dragonfly）の **develop / main** への push をトリガーに、**tugilo_site と同一 VPS** へ SSH デプロイする。

## サーバー構成（セットアップ済み）

| ブランチ | パス | 用途 |
|----------|------|------|
| **develop** | `/var/www/laravel/religo_dev` | 開発・検証 |
| **main** | `/var/www/laravel/religo_app` | 本番 |

同一 VPS 上の他アプリ例: `tugilo_dev` / `tugilo_app`（tugilo_site）

- **Laravel アプリ:** `{DEPLOY_PATH}/www`
- **Web ドキュメントルート:** `{DEPLOY_PATH}/www/public`
- **リポジトリ:** `git@github.com:tugilo/dragonfly.git`

## ワークフロー

- 定義: [`.github/workflows/deploy.yml`](../.github/workflows/deploy.yml)
- **手動実行:** Actions タブから `workflow_dispatch` も可

### デプロイで行うこと（サーバー上）

1. `git fetch` / `reset --hard origin/{branch}` / `clean -fd`
2. `www/` で `composer install --no-dev`
3. `www/` で `npm ci` → `npm run build`（Vite / React）
4. Laravel キャッシュ clear → cache
5. 未実行マイグレーションがあれば `php artisan migrate --force`
6. `php artisan storage:link`（未作成時）
7. `storage` / `bootstrap/cache` の権限調整（可能な場合）

## GitHub Secrets（必須）

リポジトリ `tugilo/dragonfly` → **Settings → Secrets and variables → Actions**

| Secret | 用途 |
|--------|------|
| `SSH_HOST` | VPS ホスト（tugilo_site と同じ値で可） |
| `SSH_USER` | SSH ユーザー（tugilo_site と同じ値で可） |
| `SSH_PRIVATE_KEY` | 秘密鍵 PEM 全文（tugilo_site と同じ値で可） |

tugilo_site 用 Secrets をそのまま流用できる（同一 VPS・同一デプロイ鍵の場合）。

## 環境ファイル（サーバー）

各環境で **`www/.env`** を個別管理する（Git に含めない）。

```bash
# 開発
cd /var/www/laravel/religo_dev/www
# .env を編集（APP_URL・DB 等）

# 本番
cd /var/www/laravel/religo_app/www
# .env を編集
```

## Web サーバー（Nginx 例）

```nginx
# 開発
root /var/www/laravel/religo_dev/www/public;

# 本番
root /var/www/laravel/religo_app/www/public;
```

## 初回セットアップ後の確認（参考）

```bash
cd /var/www/laravel/religo_dev/www
composer install --no-dev --optimize-autoloader
npm ci && npm run build
php artisan migrate --force
php artisan storage:link
```

## ローカル開発との対応

| ローカル | religo_dev | religo_app |
|----------|------------|------------|
| `docker compose`（`www/` マウント） | 開発サーバー | 本番サーバー |
| `project.env` Node 20 | デプロイ時 `nvm use 20` | 同左 |
| PHP 8.4（Docker） | デプロイは `/usr/bin/php8.4` | 同左 |

## PHP バージョン（必須）

- ローカル Docker は **PHP 8.4**（`versions.env`）。
- `composer.lock`（Symfony 8 等）は **PHP >= 8.4** が必要。
- VPS のデフォルト `php` は **8.3** のため、`deploy.yml` では **`/usr/bin/php8.4`** で `composer` / `artisan` を実行する。
- **Nginx の php-fpm** も Religo 用 vhost は **php8.4-fpm** を指定すること（CLI だけ 8.4 では不十分）。

## 注意

- **develop** push → `religo_dev`、**main** push → `religo_app` のみ。feature ブランチではデプロイしない。
- デプロイ前にローカルで `php artisan test` と `npm run build` を通す運用を推奨（[GIT_WORKFLOW.md](GIT_WORKFLOW.md)）。

## トラブルシュート

| 症状 | 確認 |
|------|------|
| Actions SSH 失敗 | Secrets が tugilo_site と同 VPS 向けか、authorized_keys |
| 500 / 白画面 | 該当環境の `www/.env`、`storage` 権限 |
| フロントが古い | `cd www && npm run build` の成否（Actions ログ） |
| migrate 失敗 | 環境別 DB 設定・バックアップ |
| composer「php >=8.4」 | サーバーで `php8.4` を使う（`deploy.yml` 修正済みか確認） |

---

**更新:** 2026-05-28 JST — パスを `religo_dev` / `religo_app`、Secrets を tugilo_site 同一 VPS 形式に合わせた
