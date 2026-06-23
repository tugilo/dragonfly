# Phase 235 PLAN — meeting_types DB（SPEC-018 Phase A）

**作成:** 2026-06-23 21:55 JST  
**Phase Type:** implement  
**Branch:** feature/phase235-meeting-types-db  
**Related SSOT:** SPEC-018  
**Status:** completed

---

## Purpose

SPEC-018 Phase A: `meeting_types` マスタと `meetings.meeting_type_id` / `team_id` を追加し、既存行を backfill する。

---

## Scope

- `www/database/migrations/*meeting_types*`
- `www/database/migrations/*meetings_meeting_type*`
- `www/app/Models/MeetingType.php`
- `www/app/Models/Meeting.php`
- `www/app/Support/MeetingDisplay.php`（team_meeting 定数・doc_type マップ）
- `www/tests/Feature/Religo/MeetingTypesMigrationTest.php`
- `docs/process/phases/PHASE_235_*`
- `docs/process/PHASE_REGISTRY.md`
- `docs/dragonfly_progress.md`（完了時）

変更しない:

- Import コマンド（Phase 236）
- Meetings API/UI（Phase 237–238）

---

## DoD

- [x] `meeting_types` テーブル + 5 種 seed
- [x] `meetings.meeting_type_id` / `team_id` + backfill + UNIQUE
- [x] MeetingType モデル + Meeting リレーション
- [x] Feature test pass
- [x] php artisan test pass

---

## Tasks

1. migration: create meeting_types + seed
2. migration: alter meetings + backfill + indexes
3. Models + MeetingDisplay 最小拡張
4. Feature test
5. REPORT / PHASE_REGISTRY
