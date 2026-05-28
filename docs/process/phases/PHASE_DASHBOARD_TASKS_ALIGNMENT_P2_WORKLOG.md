# PHASE: DASHBOARD-TASKS-ALIGNMENT-P2 — WORKLOG

## 判断

### meeting memo の定義

- **`memo_type = meeting`** かつ **`meeting_id`** が対象例会に一致し、**本文あり**。**紹介メモ等はカウントしない**。

### owner 軸か

- **突合では owner を使わない**。**理由:** 一覧 has_memo と同一の「会議にメモがあるか」であり、`MeetingMemoController` の作成行は **`owner_member_id` が先頭 member になる実装**のため、owner 絞りは偽陽性を増やす。

### 直近 vs 次回

- **直近開催済み（held_on ≤ 今日の暦日）のみ**を対象。**次回例会だけ**の導線はやめる（プロンプト推奨案A）。

### title / meta

- **title:** `例会 #N のメモを記録`  
- **meta:** `開催日 本日|n/j — 例会メモが未記録です（Meetings で入力）`

### `whereDate` を使った理由

- 単体テストで **`held_on <= toDateString()` が 0 件**になる事象があり、**日付カラムの比較を暦日ベースに統一**した（`DashboardService::getTasks`）。

### workspace

- **Tasks 生成は引き続き workspace 非使用**（P1 と同様）。

### merge 競合

- **なし。** merge commit `3d9134f6f61834ec5a980834a140bf639407b5cc`。
