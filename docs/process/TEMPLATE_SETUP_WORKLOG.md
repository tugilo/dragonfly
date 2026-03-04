# テンプレートセットアップ作業ログ

## 実装ステップと内容

### Step 1: infra/docker/php/Dockerfile

- **ベース**: `php:${PHP_VERSION}-fpm`（ARG PHP_VERSION）
- **拡張**: pdo_mysql, mbstring, zip, bcmath, gd（gd は freetype/jpeg 対応）
- **Composer**: 公式イメージ `composer:latest` から `/usr/bin/composer` をコピー
- **WORKDIR**: `/var/www`

### Step 2: infra/docker/node/Dockerfile

- **ベース**: `node:${NODE_VERSION}-alpine`（ARG NODE_VERSION）
- **WORKDIR**: `/var/www`

### Step 3: infra/docker/nginx/default.conf

- **root**: `/var/www/public`
- **index**: `index.php index.html`
- **location /**: `try_files $uri $uri/ /index.php?$query_string`
- **PHP**: `fastcgi_pass app:9000`、`SCRIPT_FILENAME` に `$realpath_root$fastcgi_script_name` を使用

### Step 4: infra/compose/docker-compose.yml

- **app**: 上記 PHP Dockerfile からビルド、**`${PROJECT_DIR}`**（絶対パス）を `/var/www` にマウント、`db` に depends_on
- **node**: 上記 Node Dockerfile からビルド、同様に **`${PROJECT_DIR}`** をマウント
- **nginx**: `nginx:stable`、ポート `80:80`、**`${PROJECT_DIR}`** をマウント、`default.conf` をマウント、`app` に depends_on
- **db**: `mariadb:${MARIADB_VERSION}`、ルートパスワード `root`、DB名・ユーザ・パスワードは `${PROJECT}`、ボリューム `db_data`
- **PROJECT_DIR**: **そのプロジェクトのルート**（setup.sh を実行しているディレクトリ = infra を内包するディレクトリ）。`bin/setup.sh` で `project.env` に書き出し。

### Step 5: bin/setup.sh

1. **プロジェクト内で実行**する想定。`infra/compose` が存在しない場合はエラー。
2. **PROJECT**: 第1引数、または未指定時は **カレントディレクトリ名**（例: fluo）。
3. **PROJECT_DIR**: **REPO_ROOT**（= このスクリプトの親ディレクトリ = プロジェクトルート）。テンプレートの隣に作るのではなく、**今いるプロジェクト**がそのままプロジェクトルート。
4. `versions.env` を source で読み込み。
5. **project.env を生成**（COMPOSE_PROJECT_NAME, PROJECT, PROJECT_DIR, 各バージョン）。
6. **このプロジェクトの** `infra/compose/docker-compose.yml` と `project.env` で `docker compose up -d --build`。
7. 以降は従来どおり（Laravel create-project を /var/www にコピー、.env 書き換え、key:generate、migrate）。

### Step 6: Makefile

- **make new-project &lt;NAME&gt;**（テンプレート内で実行）: 隣に &lt;NAME&gt;/ を作成し、infra, bin, Makefile, versions.env, .gitignore, docs をコピー。続けて `cd &lt;NAME&gt; && make setup` でそのプロジェクトの infra でセットアップ。
- **make setup [PROJECT]**（プロジェクト内で実行）: `bin/setup.sh` に PROJECT（省略可）を渡す。PROJECT 省略時は setup.sh がディレクトリ名をプロジェクト名として使用。
- `MAKECMDGOALS` の第2単語を PROJECT に渡す仕組みは new-project / setup の両方で使用。

### ドキュメント

- `docs/process/TEMPLATE_SETUP_PLAN.md` … 目的・ゴール・手順・拡張余地
- `docs/process/TEMPLATE_SETUP_WORKLOG.md` … 本作業ログ（実装内容）
- `docs/process/TEMPLATE_SETUP_REPORT.md` … 変更ファイル一覧・実行手順・確認方法

## 注意事項

- `project.env` は `.gitignore` 済み。毎回 `make setup` で上書き生成される想定。
- 既存の `.env`（Laravel）がある場合は、DB_* が上書きされる。
- 初回は Laravel の create-project でネットワーク取得が発生するため、時間がかかることがある。
