# Phase 235 WORKLOG — meeting_types DB

**tool:** cursor  
**開始:** 2026-06-23 21:55 JST

---

## 判断ログ

### FK は restrictOnDelete

- **判断:** `nullOnDelete()` は NOT NULL 列と矛盾するため `restrictOnDelete()` を採用。
- **理由:** MySQL 1830 エラー。部分適用後は FK を drop して再作成する idempotent migration にした。

### team_id 既定値は空文字

- **判断:** 非チーム集会は `team_id = ''`。
- **理由:** `(meeting_type_id, team_id, held_on)` UNIQUE を DB レベルで効かせる（NULL 複数行問題を回避）。

### Meeting::creating で meeting_type_id 自動設定

- **判断:** モデル boot で `session_type` から `meeting_type_id` を補完。
- **理由:** 既存テスト・ファクトリ大量の `Meeting::create` を一括で MySQL NOT NULL と整合。

### ImportChapterMinutes / MeetingController store

- **判断:** 明示的に `meeting_type_id` / `team_id` を渡すよう更新。
- **理由:** boot だけに頼らず import 経路を SSOT どおり明示。
