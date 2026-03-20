# PHASE: DASHBOARD-TASKS-ALIGNMENT-P2 — REPORT

## 1. 実施内容サマリ

`meeting_follow_up` を **直近開催済み例会（`whereDate(held_on, <= today)`）** に限定し、**`contact_memos`（`memo_type = meeting`・本文あり）** が無い場合のみ表示するよう変更した。**Meeting 一覧 has_memo** と同型の会議単位判定。**`whereDate`** で暦日比較を固定。SSOT・分析書・Fit&Gap・テストを更新した。

## 2. 変更ファイル一覧

- `www/app/Services/Religo/DashboardService.php`
- `www/tests/Feature/Religo/DashboardApiTest.php`
- `www/resources/js/admin/pages/dashboard/dashboardConstants.js`
- `docs/SSOT/DASHBOARD_DATA_SSOT.md`
- `docs/SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md`
- `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`
- `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`
- `docs/process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`

## 3. meeting_follow_up 定義整理

**対象例会:** 今日以前の暦日で最も新しい `held_on` の例会 1 件。  
**表示:** 当該例会 id に **例会メモ（上記）が無い**ときのみ。  
**非表示:** 例会が無い／すべて未来日／メモあり。

## 4. 実装内容

- `hasMeetingMemoRecordedForMeeting` / `buildMeetingFollowUpTaskMeta` を追加。旧 `buildMeetingMemoTaskMeta` を削除。

## 5. テスト結果

- **php artisan test（feature）:** **318 passed**（1282 assertions）  
- **npm run build:** 成功

## 6. 未解決事項

- **`MeetingMemoController`** の **`owner_member_id` / `target_member_id` が先頭 member 固定** — ダッシュ突合は会議単位のため整合だが、**作成者紐付け**は別改善の余地あり。  
- **本文のみ「記録」** — 空白のみの行は DB に残らない想定（削除 API 準拠）。

## 7. 次 Phase 提案

- **Dashboard KPI `monthly_meeting_memo_count`（owner 軸）** と **Tasks（会議単位）** の意味差を README/SSOT で補足する。  
- **Stale の workspace スコープ**（別 Phase）。

## 8. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff feature/phase-dashboard-tasks-alignment-p2` |
| merged branch | `feature/phase-dashboard-tasks-alignment-p2` |
| merge commit id | *（要記載）* |
| feature last commit id | *（要記載）* |
| test result | *（要記載）* |
| notes | meeting memo = memo_type meeting + meeting_id + body。対象=直近開催済み。owner 突合なし。whereDate。workspace Tasks 未使用。 |
