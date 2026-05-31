# DB sync（Git 経由）

開発用 MariaDB を **固定ファイル名** で Git 同期する。

| ファイル | 役割 |
|----------|------|
| `dragonfly.sql` | 常に上書きする SQL ダンプ（**このファイルだけ**を commit） |

## 運用フロー

### データを送る側（export → push）

```bash
make db-export
git add www/database/sync/dragonfly.sql
git commit -m "chore: sync local DB dump"
git push origin develop
```

### データを受け取る側（pull → import）

```bash
git pull origin develop
make db-import
```

## コマンド（Git 経由・ローカル間）

| コマンド | 内容 |
|----------|------|
| `make db-export` | ローカル DB → `dragonfly.sql` に上書き出力 |
| `make db-import` | `dragonfly.sql` → ローカル DB に全置換 |

---

## 本番 / テスト ↔ ローカル 直接同期（SSH 経由）

GitHub Actions で develop→religo_dev / main→religo_app にデプロイした **稼働中の本番・テスト DB** と、ローカル docker DB を SSH で直接同期する。Git の `dragonfly.sql` を介さず、稼働 DB を mysqldump で相互コピーする。

| 対象 | サーバパス | DB | URL |
|------|-----------|----|-----|
| `prod` | `/var/www/laravel/religo_app` | `religo_app` | religo.tugilo.com |
| `dev` | `/var/www/laravel/religo_dev` | `religo_dev` | religo-dev.tugilo.com |

### 受け取る（本番/テスト → ローカル）

```bash
make db-pull TARGET=prod   # 本番をローカルへ（既定 prod）
make db-pull TARGET=dev    # テストをローカルへ
```

- ローカル `dragonfly` を **DROP→CREATE→流し込み**（完全置換）。
- 同時に `www/database/sync/dragonfly.sql` も更新（Git 同期用に揃える）。
- 確認プロンプトあり。CI 等で省略する場合は `RELIGO_DB_ASSUME_YES=1`。

### 送る（ローカル → 本番/テスト）※破壊的

```bash
make db-push TARGET=dev    # ローカルをテストへ（まずは dev で検証推奨）
make db-push TARGET=prod   # ローカルを本番へ（確認フレーズ必須）
```

- 実行前に **リモートを自動バックアップ**（`backups/<target>_<timestamp>.sql`・gitignore 済み）。
- `prod` は **`OVERWRITE religo_app` の入力**を要求。`dev` は y/N 確認。
- リモート DB を DROP→CREATE→流し込み（完全置換）。

### 仕組み・設定

- SSH ホストは既定 `tugilo.com`。変更は `RELIGO_REMOTE_SSH=<host> make db-pull ...`。
- リモート DB 資格情報は **リモートの `.env`** から都度読む（ハードコードしない）。
- スクリプト: `bin/db-pull.sh` / `bin/db-push.sh` / `bin/lib/remote.sh`。

## 注意

- **個人情報を含む**（メンバー名・1to1 メモ・プロフィール）。**private 前提**・取扱注意。
- import / pull / push は対象 DB を **DROP してから** 流し込む（完全同期）。
- `db-push` は**本番を上書きする破壊的操作**。必ずバックアップ確認・確認フレーズの上で実行する。
- スキーマ差がある場合、ソース側で `php artisan migrate` 後に同期する（本番は Actions が自動 migrate 済み）。
- 別 PC では先に `make setup` 済み・コンテナ起動済みであること。
