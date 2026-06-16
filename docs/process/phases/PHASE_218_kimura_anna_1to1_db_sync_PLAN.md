# PHASE_218_kimura_anna_1to1_db_sync PLAN

## Phase Type
implement

## Purpose
木村杏那さん第1回 1to1（2026-06-15 11:00 JST）履歴を、Zoom 取り込み済み `one_to_ones.id=68` へ実施済みとして反映し、本番DBと同期する。

## Related SSOT
- SPEC-006: `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`
- DATA_MODEL: `docs/SSOT/DATA_MODEL.md` §4.9

## Scope
- DB操作: `one_to_ones`（id=68）
- Docs: `docs/meetings/1to1/1to1_kimura_anna_andirich.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md`、Phase 218 PLAN / WORKLOG / REPORT
- 本番同期: `make db-push TARGET=prod`

## Target Record
| one_to_ones.id | target | member_id | started_at | ended_at |
|---:|---|---:|---|---|
| 68 | 木村 杏那 | 149 | 2026-06-15 11:00:00 | 2026-06-15 12:00:00（1時間枠想定・要確認） |

## DoD
- `one_to_ones.id=68` が `completed`、notes に source path 付き要約がある。
- 議事録に `one_to_ones.id=68` が追記されている。
- `make db-export` 済み、`php artisan test` 成功。
- 本番DBと比較し、差分があれば `make db-push TARGET=prod` で反映。
