# Phase 236 WORKLOG — import-team-minutes

**Phase:** 236  
**tool:** cursor

---

## 判断ログ

### upsert は whereDate + save

- **判断:** `updateOrCreate` の `held_on` 一致が SQLite テストで UNIQUE 違反になるため、`whereDate` で既存行を検索してから `save`。
- **理由:** date cast 列と文字列キーの SELECT 不一致。再取込 idempotent を保証。

### team_name_ja 未指定時の名称

- **判断:** `{team_id} チームMTG` をコマンド内で直接組み立て（SPEC-018 §6.1）。
- **理由:** `MeetingDisplay::defaultName` は team_id フォールバック未対応のため。
