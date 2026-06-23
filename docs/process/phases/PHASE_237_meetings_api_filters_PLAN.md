# Phase 237 PLAN — Meetings API 種別フィルタ（SPEC-018 Phase C）

**作成:** 2026-06-23 22:06 JST  
**Phase Type:** implement  
**Branch:** feature/phase237-meetings-api-filters  
**Related SSOT:** SPEC-018  
**Status:** completed

---

## Purpose

SPEC-018 Phase C: `GET /api/meeting-types` と `GET /api/meetings` の種別/チームフィルタ・種別メタ列を追加する。

---

## Scope

- `www/app/Http/Controllers/Religo/MeetingTypeController.php`（新規）
- `www/app/Http/Controllers/Religo/MeetingController.php`（index/show 拡張）
- `www/routes/api.php`
- `www/tests/Feature/Religo/MeetingTypeApiTest.php`（新規）
- `www/tests/Feature/Religo/MeetingControllerTest.php`（種別メタ・フィルタ追記）
- Phase 237 docs / PHASE_REGISTRY / progress / SPEC-018 Phase C チェック

変更しない:

- MeetingsList UI（Phase 238）
- React build

---

## DoD

- [x] `GET /api/meeting-types`
- [x] `GET /api/meetings?meeting_type=&team_id=`
- [x] 一覧/詳細に種別メタ列
- [x] Feature test pass
- [x] php artisan test pass
- [ ] develop merge + push
