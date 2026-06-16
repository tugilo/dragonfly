---
name: docker-artisan
description: Run dragonfly Docker and Laravel commands inside containers. Use for migrate, test, composer, npm build, or any artisan command. Never run composer on the host.
---

# Docker / Artisan 定型（dragonfly）

## 前提

- リポジトリルートで実行
- **Composer はコンテナ内のみ**（ホスト禁止）
- 詳細: `docs/AI_TOOLING.md` §5

## 環境変数

```bash
COMPOSE="docker compose -f infra/compose/docker-compose.yml --env-file project.env"
```

## よく使うコマンド

```bash
# 起動
$COMPOSE up -d

# テスト
$COMPOSE exec app php artisan test

# マイグレーション
$COMPOSE exec app php artisan migrate

# 特定 Artisan
$COMPOSE exec app php artisan <command>

# Composer（コンテナ内）
$COMPOSE exec app composer require <package>

# React ビルド（resources/js 変更後は必須）
$COMPOSE exec node npm run build
```

## Makefile

```bash
make doctor
make db-export
make db-import
make db-pull TARGET=prod
make db-push TARGET=prod   # 要確認・破壊的操作
```

## 禁止

- ホスト側 `composer`
- `sed`
- `.env` 手動編集
