# Phase 237 WORKLOG — Meetings API 種別フィルタ

**Phase:** 237  
**tool:** cursor

---

## 判断ログ

### 種別メタは meetingType リレーション + session_type フォールバック

- **判断:** `meetingTypeMetaPayload` で eager load 優先、legacy 行は `session_type` から MeetingType 解決。
- **理由:** 旧テストの raw insert 互換を維持しつつ、種別フラグを UI 出し分けに渡す。

### フィルタは whereHas + team_id 直指定

- **判断:** `meeting_type` は `meeting_types.code`、`team_id` は `meetings.team_id` 列。
- **理由:** SPEC-018 §7.1 の自然キー設計に一致。
