---
name: import-religo
description: Import Markdown or CSV data into Religo DB in dragonfly. Use for chapter meeting minutes, team meeting minutes, 1to1 notes, or participant CSV sync after editing docs/meetings files.
---

# Religo データ取り込み（file → DB）

## 前提

- コンテナ起動済み
- パスは `docs/meetings/...` または `database/csv/...`（コンテナ内 `www/` 基準で解決）
- 詳細 SSOT: `docs/SSOT/CHAPTER_MINUTES_REQUIREMENTS.md`（SPEC-014）、チーム MTG は `docs/SSOT/TEAM_MEETING_MINUTES_REQUIREMENTS.md`（SPEC-018）

```bash
COMPOSE="docker compose -f infra/compose/docker-compose.yml --env-file project.env"
```

## 定例会議事録

```bash
# 単一ファイル
$COMPOSE exec app php artisan dragonfly:import-chapter-minutes docs/meetings/chapter/chapter_weekly_20260616.md

# ディレクトリ一括
$COMPOSE exec app php artisan dragonfly:import-chapter-minutes docs/meetings/chapter/

# front matter 上書き
$COMPOSE exec app php artisan dragonfly:import-chapter-minutes docs/meetings/chapter/file.md --meeting_number=212 --held_on=2026-06-23
```

- 定例会: `chapter_weekly_*.md`
- モメンタム/BOD: front matter の `doc_type` / `session_type` を確認（`meeting_number` なし可）

## チーム MTG 議事録（SPEC-018）

```bash
# 単一ファイル
$COMPOSE exec app php artisan dragonfly:import-team-minutes docs/meetings/team/team_threebiz_20260623.md

# ディレクトリ一括（team_*.md）
$COMPOSE exec app php artisan dragonfly:import-team-minutes docs/meetings/team/

# held_on 上書き
$COMPOSE exec app php artisan dragonfly:import-team-minutes docs/meetings/team/file.md --held_on=2026-06-23
```

- 対象: `team_*.md`（front matter `doc_type: team_meeting`）
- 必須: `team_id`, `session_date`
- 自然キー: `(team_meeting, team_id, held_on)` — 再取込は上書き
- 詳細: `docs/meetings/team/README.md`

## 1to1 議事録

```bash
# 単一
$COMPOSE exec app php artisan dragonfly:import-1to1-notes docs/meetings/1to1/1to1_example.md

# ディレクトリ一括
$COMPOSE exec app php artisan dragonfly:import-1to1-notes docs/meetings/1to1/

# ドライラン（突合のみ）
$COMPOSE exec app php artisan dragonfly:import-1to1-notes docs/meetings/1to1/file.md --dry-run

# 特定 ID のみ
$COMPOSE exec app php artisan dragonfly:import-1to1-notes docs/meetings/1to1/ --only-ids=68,69
```

- 突合: front matter の `one_to_ones.id` または notes 内 source path

## 参加者 CSV

```bash
# 定例会（回数指定）
$COMPOSE exec app php artisan dragonfly:import-participants-csv 212 database/csv/dragonfly_212_20260623_all_full.csv --held_on=2026-06-23

# モメンタム（回数なし・session-type 指定）
$COMPOSE exec app php artisan dragonfly:import-participants-csv - database/csv/dragonfly_momentum_20260616_members_only.csv --session-type=momentum_training --held_on=2026-06-16
```

## 取り込み後（本番反映が必要な場合）

1. ローカルで test 実行
2. `make db-export`
3. **`make db-push TARGET=prod` は破壊的操作** — 人間確認必須

## WORKLOG 記録

- 取り込み対象ファイル
- artisan コマンドと結果
- 更新された meeting / one_to_one ID
