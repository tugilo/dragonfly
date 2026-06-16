# デプロイ（GitHub Actions）

Religo（dragonfly）の **develop / main** への push をトリガーに、**tugilo_site と同一 VPS** へデプロイする。

## 方針

| 場所 | 内容 |
|------|------|
| **Git（GitHub）** | リポジトリ全体（`www/`、`docs/`、`infra/` 等） |
| **サーバー** | **`www/` の中身だけ** を配置（`docs/` や `infra/` は載せない） |

サーバーに Docker・リポジトリ全体の `git clone` は不要。

## サーバー構成

| ブランチ | デプロイ先（Laravel ルート） | Web ルート | DB |
|----------|------------------------------|------------|-----|
| **develop** | `/var/www/laravel/religo_dev` | `.../religo_dev/public` | `religo_dev` |
| **main** | `/var/www/laravel/religo_app` | `.../religo_app/public` | `religo_app` |

旧構成（リポジトリ全体 + `www/` サブディレクトリ）はバックアップとして残す:

- `religo_dev_repo_20260528`
- `religo_app_repo_20260528`

## ワークフロー

- 定義: [`.github/workflows/deploy.yml`](../.github/workflows/deploy.yml)
- **手動実行:** Actions タブから `workflow_dispatch` も可

### Actions で行うこと

1. **rsync** で `www/` のソースのみ同期（`.env` / `storage/` / `vendor/` / `node_modules/` / `public/build/` は除外）
2. SSH でサーバー上 **`composer install`** → **`npm ci` → `npm run build`** → `migrate` → キャッシュ → 権限

ビルドは **VPS 上**（`/usr/bin/php8.4`、nvm Node 20）。Actions ランナーに PHP/Node は不要。

### rsync で上書きしないもの（サーバー側で保持）

- `.env`
- `storage/`（ログ・アップロード）
- `vendor/` / `node_modules/`（サーバーで install）
- `public/build/`（サーバーで `npm run build` 後に生成）

## GitHub Secrets（必須）

| Secret | 用途 |
|--------|------|
| `SSH_HOST` | VPS ホスト |
| `SSH_USER` | SSH ユーザー |
| `SSH_PRIVATE_KEY` | 秘密鍵 PEM |

## 環境ファイル（サーバー）

| 環境 | パス | テンプレート（リポジトリ） |
|------|------|---------------------------|
| 開発 | `/var/www/laravel/religo_dev/.env` | `www/.env.religo_dev.example` |
| 本番 | `/var/www/laravel/religo_app/.env` | `www/.env.religo_app.example` |

### 初回セットアップ（religo_dev 例）

```bash
cd /var/www/laravel/religo_dev
cp .env.religo_dev.example .env   # rsync 後に www からコピー可
# DB_PASSWORD を tugilo_dev の .env と同じ root パスワードに合わせる
/usr/bin/php8.4 artisan key:generate

mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS religo_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
/usr/bin/php8.4 artisan migrate --force
/usr/bin/php8.4 artisan storage:link
```

**開発データ:** `www/database/sync/dragonfly.sql` を手動インポート（[www/database/sync/README.md](../www/database/sync/README.md)）。

## Web サーバー（Apache）

VPS では **Apache + php-fpm**。Religo の SSL vhost は DocumentRoot は既に正しい:

| サイト | 設定ファイル | DocumentRoot |
|--------|--------------|--------------|
| 開発 | `religo-dev-le-ssl.conf` | `/var/www/laravel/religo_dev/public` |
| 本番 | `religo-le-ssl.conf` | `/var/www/laravel/religo_app/public` |

### PHP 8.4 を Web でも使う（必須）

デプロイ（CLI）は `php8.4` だが、**Apache は未指定だと php8.3 / mod_php になる**ため、画面に次のエラーが出る:

> Composer detected issues in your platform: require PHP ">= 8.4.0"

**手順（サーバーで sudo 実行）:**

```bash
# 1. FPM 8.4 をインストール・起動（未導入時）
sudo apt-get install -y php8.4-fpm
sudo systemctl enable --now php8.4-fpm
ls /run/php/php8.4-fpm.sock   # ソケット確認

# 2. SSL vhost に SetHandler を追加（dev.tugilo.com と同じ）
sudo nano /etc/apache2/sites-available/religo-dev-le-ssl.conf
sudo nano /etc/apache2/sites-available/religo-le-ssl.conf
```

各ファイルの `<IfModule mod_ssl.c>` 内、**`<VirtualHost>` の直前**に追加:

```apache
<FilesMatch \.php$>
    SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost/"
</FilesMatch>
```

スニペット例: [docs/apache/religo-dev-le-ssl.conf.snippet](apache/religo-dev-le-ssl.conf.snippet)、[religo-le-ssl.conf.snippet](apache/religo-le-ssl.conf.snippet)

```bash
# 3. 構文チェック・リロード
sudo apache2ctl configtest
sudo systemctl reload apache2
```

確認: `https://religo.dev-tugilo.com` / `https://religo.tugilo.com` で Laravel 画面（Composer エラーが消えること）。

## PHP バージョン

- `composer.lock` は **PHP >= 8.4**
- **CLI / デプロイ:** `/usr/bin/php8.4`
- **Web（Apache）:** `php8.4-fpm` のソケットを `SetHandler` で指定（上記）

## 注意

- **develop** → `religo_dev`、**main** → `religo_app` のみ
- デプロイ前にローカルで `php artisan test` と `npm run build` を推奨

## トラブルシュート

| 症状 | 確認 |
|------|------|
| Actions SSH / rsync 失敗 | Secrets・`authorized_keys` |
| 500 / 白画面 | `{religo_*}/.env`、`storage` 権限 |
| フロントが古い | サーバー上 `npm run build` の成否（Actions SSH ログ） |
| migrate 失敗 | DB 名・`.env` の `DB_DATABASE` |
| `npm ERR! ENOTEMPTY` … `node_modules` | サーバーで `cd $DEPLOY_PATH && rm -rf node_modules && npm ci --include=dev && npm run build`。以降は Actions が deploy 前に `rm -rf node_modules` する |
| `sh: 1: vite: not found`（build 127） | devDependencies 未インストール。`NODE_ENV=production` だと `npm ci` が vite を入れない。`rm -rf node_modules && NODE_ENV=development npm ci --include=dev && npm run build` |
| `npm warn tar TAR_ENTRY_ERROR` | キャッシュ破損のことが多い。`npm cache clean --force` のうえ `npm ci --include=dev`（`--prefer-offline` なし） |
| `database.sqlite` does not exist | `.env` 未作成または sqlite 設定のまま |
| `require PHP ">= 8.4.0"`（白画面） | Apache が 8.3 のまま → **php8.4-fpm + SetHandler** |
| `Failed to clear cache`（Actions） | php-fpm が `storage/framework/cache/data` を www-data 所有 → deploy.yml の data 再作成フォールバック |

---

**更新:** 2026-06-16 18:00 JST — deploy: `npm ci --include=dev`、vite 存在チェック  
**更新:** 2026-05-28 JST — Laravel 直置き、rsync + サーバー composer/npm build
