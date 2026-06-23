# Phase 236 REPORT — import-team-minutes

**完了:** 2026-06-23 22:02 JST  
**Phase Type:** implement  
**Related SSOT:** SPEC-018 Phase B

---

## 実施内容

- `ImportTeamMinutesCommand`（`dragonfly:import-team-minutes`）新規
- 自然キー `(meeting_type_id=team_meeting, team_id, held_on)` で idempotent upsert
- `team_id` / `session_date` / `doc_type: team_meeting` 検証
- `ImportTeamMinutesCommandTest` 6 件
- `docs/meetings/team/team_threebiz_*.md` 5 件 smoke import 成功

---

## 変更ファイル

```
www/app/Console/Commands/ImportTeamMinutesCommand.php
www/tests/Feature/ImportTeamMinutesCommandTest.php
docs/SSOT/TEAM_MEETING_MINUTES_REQUIREMENTS.md
docs/process/phases/PHASE_236_import_team_minutes_PLAN.md
docs/process/phases/PHASE_236_import_team_minutes_WORKLOG.md
docs/process/phases/PHASE_236_import_team_minutes_REPORT.md
docs/process/PHASE_REGISTRY.md
docs/dragonfly_progress.md
docs/INDEX.md
docs/meetings/team/team_threebiz_20260623.md
```

---

## テスト

```
php artisan test --filter=ImportTeamMinutesCommandTest  → 6 passed
php artisan test                                      → 494 passed (1837 assertions)
```

Smoke:

```
php artisan dragonfly:import-team-minutes docs/meetings/team/  → Imported 5 file(s).
```

---

## DoD チェック

| 項目 | 結果 |
|------|------|
| ImportTeamMinutesCommand | OK |
| Feature test | OK |
| smoke import 5 件 | OK |
| php artisan test | OK |

---

## 次 Phase

- **Phase 237 (C):** API 種別フィルタ + `GET /api/meeting-types`

---

## Merge Evidence

| 項目 | 内容 |
|------|------|
| merge commit id | be1ae4882ca73e1b53f2754d695dd27333312786 |
| source branch | feature/phase236-import-team-minutes |
| target branch | develop |
| phase id | 236 |
| phase type | implement |
| related ssot | SPEC-018 |
| test command | php artisan test |
| test result | 494 passed |
| scope check | OK |
| ssot check | OK |
| dod check | OK |
