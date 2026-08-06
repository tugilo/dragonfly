# PHASE 299 WORKLOG

## 判断

- 1toMany を BOD/モメンタムに誤分類せず、専用 `meeting_types.code=chapter_1tomany` を追加。
- `doc_type: chapter_1tomany`（旧メモの `chapter_1tomany_minutes` も MeetingDisplay でマップ）を採用。
- 表示名は `speaker` front matter があれば `1toMany — {氏名}`。

## 実装

- migration `2026_08_07_071300_add_chapter_1tomany_meeting_type`
- MeetingDisplay / ImportChapterMinutesCommand / Feature test
- 議事録 front matter 整備後 `dragonfly:import-chapter-minutes`
