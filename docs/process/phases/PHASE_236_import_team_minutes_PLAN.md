# Phase 236 PLAN — import-team-minutes（SPEC-018 Phase B）

**作成:** 2026-06-23 22:10 JST  
**Phase Type:** implement  
**Branch:** feature/phase236-import-team-minutes  
**Related SSOT:** SPEC-018  
**Status:** completed

---

## Purpose

SPEC-018 Phase B: `dragonfly:import-team-minutes` で `docs/meetings/team/team_*.md` を `meetings` / `meeting_minutes` に idempotent 取込する。

---

## Scope

- `www/app/Console/Commands/ImportTeamMinutesCommand.php`（新規）
- `www/tests/Feature/ImportTeamMinutesCommandTest.php`（新規）
- `docs/process/phases/PHASE_236_*`
- `docs/process/PHASE_REGISTRY.md`
- `docs/dragonfly_progress.md`
- `docs/SSOT/TEAM_MEETING_MINUTES_REQUIREMENTS.md`（Phase B チェック）

変更しない:

- Meetings API/UI（Phase 237–238）
- `ImportChapterMinutesCommand` のリファクタ共通化（必要最小の独立実装）

---

## DoD

- [x] `dragonfly:import-team-minutes` 単一・一括・再取込
- [x] `team_id` / `session_date` 必須検証
- [x] 自然キー `(meeting_type_id=team_meeting, team_id, held_on)`
- [x] Feature test pass
- [x] 既存 `team_threebiz_*.md` 5 件 smoke import
- [x] php artisan test pass
- [ ] develop merge + push

---

## Tasks

1. ImportTeamMinutesCommand 実装
2. Feature test
3. smoke import（5 ファイル）
4. REPORT / PHASE_REGISTRY / progress
5. develop merge + push
