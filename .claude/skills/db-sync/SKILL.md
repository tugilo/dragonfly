---
name: db-sync
description: Sync dragonfly local database with SQL dump or remote prod/dev. Use for db-export, db-import, db-pull, db-push, db-replicate-prod-to-dev via Makefile. db-push and db-replicate are destructive and require human approval.
---

# DB 同期（Makefile）

## 診断

```bash
make doctor
```

## ローカル ↔ sync SQL

```bash
# ローカル DB → www/database/sync/dragonfly.sql（固定名・上書き）
make db-export

# sync SQL → ローカル DB（全置換）
make db-import
```

## リモート ↔ ローカル（SSH）

```bash
# 本番/テスト → ローカル（全置換）
make db-pull TARGET=prod
make db-pull TARGET=dev

# ローカル → 本番/テスト（全置換・要確認・自動バックアップ）
make db-push TARGET=prod
make db-push TARGET=dev
```

## 本番 → テスト（SSH 直結・ローカル Docker 不要）

PoC 用に **prod データで dev を全置換**。dev バックアップ必須。

```bash
make db-replicate-prod-to-dev
# 確認フレーズ: REPLICATE prod to dev

# ロールバック
make db-restore-dev BACKUP=backups/dev_YYYYMMDD_HHMMSS.sql
```

- prod は dump のみ（本番 DB は変更しない）
- dev バックアップ → `backups/dev_<timestamp>.sql`
- 取り込み後: dev 上で workspace 名補正 + `migrate --force`

## 典型フロー（議事録取り込み → 本番）

1. Markdown 編集
2. `/import-religo` で artisan 取り込み
3. `php artisan test`
4. `make db-export`
5. **`make db-push TARGET=prod`** — 人間確認後のみ

## 安全

- `db-push` / `db-replicate-prod-to-dev` はリモート DB を **上書き** する。実行前にバックアップパスを確認
- `backups/` に自動バックアップが保存される
- `.env` / `project.env` は手動編集しない

## 禁止

- 確認なしの `make db-push` / `make db-replicate-prod-to-dev`
- 本番 DB への直接 SQL 実行（Makefile 経由を正とする）
