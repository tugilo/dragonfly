# Phase 238 WORKLOG — MeetingsList UI 種別対応

**Phase:** 238  
**tool:** cursor

---

## 判断ログ

### supports フラグは API メタを優先

- **判断:** `meetingTypeUi.js` で `supports_*` 列を優先し、未設定時は `team_meeting` 以外を chapter 相当とみなす。
- **理由:** 一覧/show API が Phase 237 で種別メタを返すため、UI は API を正とする。

### チーム Select の選択肢

- **判断:** 種別=チームMTG 選択時に `/api/meetings?meeting_type=team_meeting` から `team_id` 一覧を動的取得。
- **理由:** team マスタ API が無いため、既存取込データから slug を列挙。

### モック比較

- **判断:** モック v2 に種別フィルタ無し → FIT_AND_GAP に Phase 238 追記（意図的拡張）。
- **理由:** SPEC-018 がモックより新しい要件。Members 以外は FIT_AND_GAP 列を正とする。
