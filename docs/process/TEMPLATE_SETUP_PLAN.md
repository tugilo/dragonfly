# テンプレートセットアップ計画

## 目的

- **プロジェクトごとに独立した infra** を持たせ、そのプロジェクト内で `docker compose` する構成にする。
- 環境を変えたいときは **そのプロジェクトの infra** を編集するだけでよく、テンプレートや他プロジェクトに影響しない。
- ホストに Composer を入れない（Composer は app コンテナ内）。Mac / WSL2 両対応。

## ゴール

**テンプレートから新規プロジェクトを作成する（例: fluo）**

```bash
cd tugilo-template
make new-project fluo
```

- テンプレートの隣に **fluo/** が作成される
- **fluo/** には fluo 用の **infra/**, **bin/**, **Makefile**, **versions.env**, **.gitignore** がコピーされる
- 続けて **fluo** 内で `make setup` が実行され、**fluo の infra** で Docker が起動し、Laravel が **fluo/www/** に構築される（infra/ と www/ は同階層）

**既存プロジェクトでセットアップする**

```bash
cd fluo
make setup
```

- そのプロジェクトの **infra/** で docker compose が動く
- プロジェクト名はディレクトリ名（省略時）または引数で指定

これにより:

1. 各プロジェクトが **同じ構成**（infra, bin, Makefile, versions.env）を持つ
2. **プロジェクトごとに独立したコンテナ**（fluo-app, fluo-db 等）がそのプロジェクトの infra で起動する
3. ポート・DB・PHP バージョンなどを変えたい場合は **そのプロジェクトの infra** を編集すればよい
4. テンプレート（tugilo-template）は「新規プロジェクトのひな形」としてのみ使い、実行時は **各プロジェクトの infra** で compose する

## 絶対遵守事項

- ホストに Composer を要求しない
- Mac / WSL2 両対応
- `sed` は使わない（Mac/Linux 差異回避）
- `.env` は PHP スクリプトで安全に書き換える
- 既存ファイルを壊さない

## 構成要素

| 要素 | 役割 |
|------|------|
| `versions.env` | PHP / Node / MariaDB / Laravel のバージョン定義（プロジェクトごとに編集可） |
| `project.env` | セットアップ時にそのプロジェクトルートに生成 |
| `infra/compose/docker-compose.yml` | **そのプロジェクト専用**。context はプロジェクトルート、volume は **PROJECT_DIR/www** を /var/www にマウント |
| `infra/docker/*` | PHP / Node / nginx の Dockerfile と設定 |
| `bin/setup.sh` | **プロジェクト内で**実行。そのプロジェクトの infra で compose し、Laravel をプロジェクトルートに構築 |
| `Makefile` | `make new-project <NAME>`（テンプレートから新規作成）、`make setup`（プロジェクト内でセットアップ） |

## 手順（利用者向け）

1. Docker Desktop を起動する
2. **新規プロジェクトを作る**: テンプレートで `make new-project fluo` → 隣に fluo ができ、その中で setup まで実行される
3. **既存プロジェクトでやり直す**: `cd fluo` のあと `make setup`
4. 完了後、`http://localhost` を開く（複数プロジェクトを同時に使う場合は、各プロジェクトの `infra/compose/docker-compose.yml` でポートを変更する）

## 今後の拡張余地

- 各プロジェクトの `versions.env` で PHP / Node / MariaDB / Laravel を個別に変更可能
- 複数プロジェクト同時起動時は、各プロジェクトの compose でポート（80, 8081, 3307 等）をずらす
- Node コンテナで `npm install` / `npm run dev` を実行する手順の追加
- テスト・CI 用の compose プロファイルの追加
