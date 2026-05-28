# PHASE: DASHBOARD-TASKS-ALIGNMENT-P2 — PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | DASHBOARD-TASKS-ALIGNMENT-P2 |
| **種別** | implement |
| **Branch** | `feature/phase-dashboard-tasks-alignment-p2` |
| **Related SSOT** | `docs/SSOT/DASHBOARD_DATA_SSOT.md`、`DASHBOARD_TASK_SOURCE_ANALYSIS.md`、`DASHBOARD_FIT_AND_GAP.md`、`FIT_AND_GAP_MOCK_VS_UI.md` |

---

## 目的

`meeting_follow_up` を **contact_memos** と突合し、**例会メモ（`memo_type = meeting`）が未記録**のときだけ出す。**次回例会への単純導線**より **未記載検知**を優先（プロンプト方針）。

---

## スコープ

**対象:** `DashboardService::getTasks` の `meeting_follow_up`、Feature テスト、SSOT／分析／Fit&Gap、develop merge / Evidence。  
**対象外:** UI 再設計、Tasks 全体再定義、workspace 拡張、データモデル大改修。

---

## 定義（実装前に固定）

### 例会メモ「記録済み」

- `contact_memos` に **`meeting_id` = 対象例会の id**、**`memo_type` = `meeting`**、**`body` が null / 空でない**行が **1 件以上**。
- **Meeting 一覧 `has_memo` / `MeetingMemoController` と同型**（会議単位）。
- **`owner_member_id` は使わない**（現行例会メモ API が先頭 member を owner にする暫定があり、owner 絞りだと誤った「未記録」になる）。

### 対象例会

- **直近開催済み:** `held_on` の暦日が **今日以前**の例会のうち、`held_on` **最も新しい** 1 件（同値時は `id` DESC）。
- **クエリ:** `whereDate('held_on', '<=', now())` — **日付境界の取りこぼし防止**（`held_on` キャストとタイムゾーン由来のズレ対策）。
- **未来日のみ**（DB に過去・当日が無い）→ **タスクなし**。

### 比較案

| 案 | 結果 |
|----|------|
| A 直近開催済みでメモ無しのみ表示 | **採用** |
| B 次回例会は常に表示 | 不採用（未記載判定と混線） |
| C 直近未記録かつ次回接近 | 不採用（複雑） |

---

## DoD

1. SSOT・分析書に上記定義が書かれている。  
2. 実装が SSOT と一致。  
3. Feature テストで未記録/記録済み/紹介メモのみ/未来のみ/別例会メモをカバー。  
4. `php artisan test` / `npm run build` 通過。  
5. feature → develop `--no-ff` merge、REPORT Merge Evidence、`origin/develop` push。
