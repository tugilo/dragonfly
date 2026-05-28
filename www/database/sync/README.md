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

## コマンド

| コマンド | 内容 |
|----------|------|
| `make db-export` | ローカル DB → `dragonfly.sql` に上書き出力 |
| `make db-import` | `dragonfly.sql` → ローカル DB に全置換 |

## 注意

- **開発データのみ** を想定。メンバー名・1to1 メモ等が含まれる。**private リポジトリ前提**。
- import は対象 DB を **DROP してから** 流し込む（完全同期）。
- 別 PC では先に `make setup` 済み・コンテナ起動済みであること。
- スキーマ差がある場合は export 側で `php artisan migrate` 後に export する。
