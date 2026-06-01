# PHASE_162_1TO1_HISTORY_DB_SYNC PLAN

## Phase Type
implement

## Purpose
原田里織さん・小中貴晃さんの第1回 1to1 履歴を、既存の Zoom 取り込み済み `one_to_ones` レコードへ実施済み履歴として反映し、本番DBにも同期する。

## Background
2026-06-01 に実施した原田里織さん・小中貴晃さんとの 1to1 は、Zoom 取り込みにより `planned` レコードとしてローカルDBに存在している。一方、議事録側には `one_to_ones.id` が TODO のまま残っているため、既存行を `completed` に更新し、議事録とDBの参照を揃える。

## Related SSOT
- SPEC-006: `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`
- DATA_MODEL: `docs/SSOT/DATA_MODEL.md` §4.9

## Scope
- DB操作: `one_to_ones`
- Docs: 対象 1to1 議事録、`docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md`、Phase 162 PLAN / WORKLOG / REPORT
- 本番同期: `make db-push TARGET=prod` によるローカルDB全体の本番DB上書き反映

## Out of Scope
- 新規UI/API実装
- 今回対象外の TODO 付き 1to1 履歴の一括整理
- メンバー名・所属チャプターの補正

## Target Records
| one_to_ones.id | target | started_at | ended_at |
|---:|---|---|---|
| 37 | 原田 里織 | 2026-06-01 14:00:00 | 2026-06-01 15:00:00 |
| 38 | 小中 貴晃 | 2026-06-01 15:00:00 | 2026-06-01 16:00:00 |

## DoD
- 対象2件の `one_to_ones.status` が `completed` になっている。
- 対象2件の `started_at` / `ended_at` / `notes` が議事録内容と整合している。
- 対象議事録に `one_to_ones.id` が追記されている。
- `make db-export` で `www/database/sync/dragonfly.sql` が更新されている。
- `php artisan test` が成功している。
- `make db-push TARGET=prod` で本番DBへ反映し、バックアップと確認結果を REPORT に記録している。
