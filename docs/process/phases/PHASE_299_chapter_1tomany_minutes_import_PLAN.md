# PHASE 299 PLAN — 1toMany 議事録の DB 取り込み

| 項目 | 内容 |
|------|------|
| **Phase ID** | 299 |
| **種別** | implement |
| **Related SSOT** | SPEC-014（CHAPTER_MINUTES_REQUIREMENTS） |
| **Scope** | `www/database/migrations/**`（meeting_types 追加）／`www/app/Support/MeetingDisplay.php`／`www/app/Console/Commands/ImportChapterMinutesCommand.php`／`www/tests/Feature/ImportChapterMinutesCommandTest.php`／`docs/SSOT/CHAPTER_MINUTES_REQUIREMENTS.md`／`docs/meetings/Dragonfly_chapter_1toMany_*`／INDEX・progress |
| **DoD** | `chapter_1tomany` 型で 2026-08-06 議事録をローカル import 済み／関連テスト緑／`make db-export`／ユーザー承認のもと `make db-push TARGET=prod` |

## 背景

チャプター横断 1toMany 実施議事録を Religo `meetings` / `meeting_minutes` に載せる。既存 import は定例会・BOD・モメンタムのみのため、`chapter_1tomany` を追加する。
